import os
import re
import joblib  
import json
from flask import Blueprint, jsonify, request
from models.jamu_models import db, Jamu
from flask_jwt_extended import jwt_required
from werkzeug.utils import secure_filename
from sklearn.base import BaseEstimator, TransformerMixin  
from sklearn.metrics.pairwise import cosine_similarity  

jamu_bp = Blueprint('jamu', __name__)

# Folder tempat berkas gambar fisik disimpan di backend
UPLOAD_FOLDER = os.path.join('static', 'uploads')


# ====================================================================
# 🧠 0A. DEFINISI CUSTOM CLASS TEXT PREPROCESSOR (SUNTIK NAMESPACE)
# ====================================================================
class TextPreprocessor(BaseEstimator, TransformerMixin):
    def __init__(self):
        import nltk
        import os
        # Paksa NLTK mengunduh data ke folder /tmp yang diizinkan oleh Vercel
        nltk_data_dir = os.path.join('/tmp', 'nltk_data')
        if not os.path.exists(nltk_data_dir):
            os.makedirs(nltk_data_dir)
        nltk.data.path.append(nltk_data_dir)
        
        try:
            from nltk.corpus import stopwords
            self.stop_words = set(stopwords.words('indonesian'))
        except LookupError:
            # Unduh otomatis jika belum ada di serverless Vercel
            nltk.download('stopwords', download_dir=nltk_data_dir)
            from nltk.corpus import stopwords
            self.stop_words = set(stopwords.words('indonesian'))
            
        # Amankan kata kunci medis agar tidak dibuang sebagai sampah teks oleh NLTK
        kata_medis_penting = {'sakit', 'nyeri', 'kurang', 'tidak', 'turun', 'naik', 'jamu'}
        self.stop_words = self.stop_words - kata_medis_penting
        self.stop_words.add('melalui')
        
    def fit(self, X, y=None):
        return self
        
    def transform(self, X):
        return [self.clean_text(text) for text in X]

    def clean_text(self, text):
        import re
        import string
        text = str(text).lower()
        text = re.sub(r'http\S+|www\S+', '', text)
        text = re.sub(r'\d+', '', text)
        text = text.translate(str.maketrans('', '', string.punctuation))
        text = re.sub(r'\s+', ' ', text).strip()
        tokens = text.split()
        tokens = [w for w in tokens if w not in self.stop_words]
        return " ".join(tokens)

# Trik sakti menyuntikkan kelas ke module __main__ Flask agar unpickling lancar
import __main__
__main__.TextPreprocessor = TextPreprocessor


# ====================================================================
# 🤖 0B. LOAD MODEL MACHINE LEARNING & KAMUS EXTERNAL JSON (SINKRON ROOT)
# ====================================================================
BASE_DIR = os.path.abspath(os.path.dirname(__file__))  # Target: /backend/routes
BACKEND_ROOT = os.path.dirname(BASE_DIR)              # Naik satu tingkat ke: /backend

# Mengarah langsung ke file pkl dan json yang berada di root folder backend
MODEL_PATH = os.path.join(BACKEND_ROOT, "model_pipeline.pkl")
KAMUS_PATH = os.path.join(BACKEND_ROOT, "kamus_typo.json")

print("\n==============================================")
print(f"🔬 Melacak Model ML ke: {MODEL_PATH}")
print(f"🔬 Melacak Kamus Typo ke: {KAMUS_PATH}")
print("==============================================\n")

try:
    model_ml = joblib.load(MODEL_PATH)
    print("✅ Model Machine Learning Berhasil Dimuat!")
except Exception as e:
    print(f"⚠️ GAGAL MEMUAT MODEL ML: {e}")
    model_ml = None

try:
    with open(KAMUS_PATH, 'r') as f:
        kamus_dict = json.load(f)
    print("✅ Kamus Typo Berhasil Dimuat dari JSON!")
except Exception as e:
    print(f"⚠️ GAGAL MEMUAT KAMUS TYPO: {e}")
    kamus_dict = {}


# ====================================================================
# 🛠️ 0C. FUNGSI ANTI-TYPO (Mendukung Casing & Tanda Baca via JSON)
# ====================================================================
def typo_correction(text):
    if not kamus_dict:
        return text
    tokens = text.split()
    corrected_tokens = []
    
    for token in tokens:
        match = re.match(r'^([^\w]*)([\w\-\']+)([^\w]*)$', token)
        if match:
            prefix, word, suffix = match.groups()
            word_lower = word.lower()
            if word_lower in kamus_dict:
                corrected_word = kamus_dict[word_lower]
                if word.istitle():
                    corrected_word = corrected_word.title()
                elif word.isupper():
                    corrected_word = corrected_word.upper()
                corrected_tokens.append(f"{prefix}{corrected_word}{suffix}")
            else:
                corrected_tokens.append(token)
        else:
            corrected_tokens.append(token)
            
    return " ".join(corrected_tokens)


# ====================================================================
# 🎯 1. GET ALL JAMU (Dashboard Admin)
# ====================================================================
@jamu_bp.route('/jamu', methods=['GET'])
@jwt_required()
def get_all_jamu():
    try:
        data_jamu = Jamu.query.all()
        hasil_json = [item.to_dict() for item in data_jamu] 
        return jsonify({
            "status": "success",
            "message": "Seluruh data Jamu berhasil diambil",
            "data": hasil_json
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ====================================================================
# 🎯 2. GET SINGLE JAMU BY ID + REKOMENDASI TERKAIT (COSINE SIMILARITY)
# ====================================================================
@jamu_bp.route('/jamu/<int:id_jamu>', methods=['GET'])
def get_jamu_by_id(id_jamu):
    try:
        target = Jamu.query.get(id_jamu)
        if not target:
            return jsonify({"status": "error", "message": "Jamu tidak ditemukan"}), 404
            
        jamu_utama_dict = target.to_dict()
        all_jamu = Jamu.query.all()
        saran_jamu_lainnya = []
        
        if model_ml is not None and len(all_jamu) > 1:
            try:
                transformer_prep = model_ml.named_steps['prep']
                transformer_tfidf = model_ml.named_steps['tfidf']

                khasiat_utama = str(target.khasiat or "")
                query_clean = transformer_prep.transform([khasiat_utama])
                matrix_query = transformer_tfidf.transform(query_clean)

                khasiat_semua = [str(item.khasiat or "") for item in all_jamu]
                dataset_clean = transformer_prep.transform(khasiat_semua)
                matrix_dataset = transformer_tfidf.transform(dataset_clean)

                skor_similarity = cosine_similarity(matrix_query, matrix_dataset).flatten()

                for idx, item in enumerate(all_jamu):
                    if int(item.id_jamu or 0) == int(target.id_jamu or 0):
                        continue
                        
                    item_dict = item.to_dict()
                    item_dict['skor_matching'] = float(skor_similarity[idx])
                    saran_jamu_lainnya.append(item_dict)

                saran_jamu_lainnya.sort(key=lambda x: x['skor_matching'], reverse=True)
                saran_jamu_lainnya = saran_jamu_lainnya[:5]
                
            except Exception as nlp_err:
                print(f"⚠️ GAGAL MENGHITUNG COSINE SIMILARITY DI DETAIL: {nlp_err}")
                saran_jamu_lainnya = []

        return jsonify({
            "status": "success",
            "message": "Detail data Jamu berhasil diambil",
            "data": jamu_utama_dict,
            "jamu_terkait": saran_jamu_lainnya
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ====================================================================
# 🎯 3. INSERT (Tambah Jamu)
# ====================================================================
@jamu_bp.route('/jamu', methods=['POST'])
@jwt_required()
def tambah_jamu():
    try:
        nama_jamu = request.form.get('nama_jamu')
        if not nama_jamu:
            return jsonify({"status": "error", "message": "Nama jamu tidak boleh kosong!"}), 400
        
        nama_file_gambar = None
        if 'image' in request.files:
            file = request.files['image']
            if file and file.filename != '':
                filename = secure_filename(file.filename)
                if not os.path.exists(UPLOAD_FOLDER):
                    os.makedirs(UPLOAD_FOLDER)
                file.save(os.path.join(UPLOAD_FOLDER, filename))
                nama_file_gambar = filename

        jamu_baru = Jamu(
            nama_jamu=nama_jamu,
            khasiat=request.form.get('khasiat'),
            kandungan=request.form.get('kandungan'),
            aturan_minum=request.form.get('aturan_minum'),
            efek_samping=request.form.get('efek_samping'),
            image=nama_file_gambar,
            id_jenis=request.form.get('id_jenis'),
            id_produsen=request.form.get('id_produsen'),
            id_lokasi_produksi=request.form.get('id_lokasi_produksi'),
            id_kabupaten=request.form.get('id_kabupaten'),
            id_perizinan=request.form.get('id_perizinan'),
            id_lokasi_pemasaran=request.form.get('id_lokasi_pemasaran')
        )
        db.session.add(jamu_baru)
        db.session.commit()
        return jsonify({"status": "success", "message": f"Jamu {jamu_baru.nama_jamu} berhasil didaftarkan!"}), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"status": "error", "message": str(e)}), 500


# ====================================================================
# 🎯 4. UPDATE (Edit Jamu)
# ====================================================================
@jamu_bp.route('/jamu/<int:id_edit>', methods=['PUT'])
@jwt_required()
def edit_jamu(id_edit):
    try:
        target = Jamu.query.get(id_edit)
        if not target:
            return jsonify({"status": "error", "message": "Jamu tidak ditemukan"}), 404
        
        target.nama_jamu = request.form.get('nama_jamu', target.nama_jamu)
        target.khasiat = request.form.get('khasiat', target.khasiat)
        target.kandungan = request.form.get('kandungan', target.kandungan)
        target.aturan_minum = request.form.get('aturan_minum', target.aturan_minum)
        target.efek_samping = request.form.get('efek_samping', target.efek_samping)
        target.id_jenis = request.form.get('id_jenis', target.id_jenis)
        target.id_produsen = request.form.get('id_produsen', target.id_produsen)
        target.id_lokasi_produksi = request.form.get('id_lokasi_produksi', target.id_lokasi_produksi)
        target.id_kabupaten = request.form.get('id_kabupaten', target.id_kabupaten)
        target.id_perizinan = request.form.get('id_perizinan', target.id_perizinan)
        target.id_lokasi_pemasaran = request.form.get('id_lokasi_pemasaran', target.id_lokasi_pemasaran)

        if 'image' in request.files:
            file = request.files['image']
            if file and file.filename != '':
                if target.image:
                    path_gambar_lama = os.path.join(UPLOAD_FOLDER, target.image)
                    if os.path.exists(path_gambar_lama):
                        os.remove(path_gambar_lama)
                filename = secure_filename(file.filename)
                file.save(os.path.join(UPLOAD_FOLDER, filename))
                target.image = filename 

        db.session.commit()
        return jsonify({"status": "success", "message": "Data Jamu berhasil diupdate"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"status": "error", "message": str(e)}), 500


# ====================================================================
# 🎯 5. DELETE (Hapus Jamu)
# ====================================================================
@jamu_bp.route('/jamu/<int:id_hapus>', methods=['DELETE'])
@jwt_required()
def hapus_jamu(id_hapus):
    try:
        target = Jamu.query.get(id_hapus)
        if not target:
            return jsonify({"status": "error", "message": "Data tidak ditemukan"}), 404
        if target.image:
            path_file_fisik = os.path.join(UPLOAD_FOLDER, target.image)
            if os.path.exists(path_file_fisik):
                os.remove(path_file_fisik) 
        db.session.delete(target)
        db.session.commit()
        return jsonify({"status": "success", "message": "Jamu beserta file gambarnya berhasil dihapus"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"status": "error", "message": str(e)}), 500


# ====================================================================
# 🎯 6. GET ALL JAMU FOR PUBLIC
# ====================================================================
@jamu_bp.route('/jamu/public', methods=['GET'])
def get_public_jamu():
    try:
        data_jamu = Jamu.query.all()
        hasil_json = [item.to_dict() for item in data_jamu] 
        return jsonify({
            "status": "success",
            "message": "Data katalog jamu publik berhasil diambil",
            "data": hasil_json
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ====================================================================
# 🎯 7. GET UNIQUE FILTERS FOR PUBLIC
# ====================================================================
@jamu_bp.route('/jamu/public-filters', methods=['GET'])
def get_public_filters():
    try:
        all_jamu = Jamu.query.all()
        all_jamu_dict = [item.to_dict() for item in all_jamu]
        jenis_unik = sorted(list(set([item.get('nama_jenis') for item in all_jamu_dict if item.get('nama_jenis')])))
        kabupaten_unik = sorted(list(set([item.get('nama_kabupaten') for item in all_jamu_dict if item.get('nama_kabupaten')])))
        perizinan_unik = sorted(list(set([item.get('nama_perizinan') for item in all_jamu_dict if item.get('nama_perizinan')])))
        return jsonify({
            "status": "success",
            "message": "Data pilihan filter berhasil diekstrak",
            "data": {
                "jenis": jenis_unik,
                "kabupaten": kabupaten_unik,
                "perizinan": perizinan_unik
            }
        }), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500


# ====================================================================
# 🌐 SUNTIKAN HEADER CORS GLOBAL UNTUK BLUEPRINT JAMU
# ====================================================================
@jamu_bp.after_request
def add_cors_headers(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type,Authorization')
    response.headers.add('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    return response


# ====================================================================
# 🎯 8. POST RECOMMENDATION VIA ML PIPELINE (ANTI CRASH & ANTI CORS ERROR)
# ====================================================================
@jamu_bp.route('/jamu/recommend', methods=['POST', 'OPTIONS'])
def dapatkan_rekomendasi_ml():
    if request.method == 'OPTIONS':
        return jsonify({"status": "success"}), 200

    try:
        data = request.get_json(silent=True) or {}
        teks_input = data.get('keluhan', '') or data.get('teks', '') or data.get('query', '')
        skip_correction = data.get('skip_correction', False)

        if not teks_input or not teks_input.strip():
            return jsonify({"status": "error", "message": "Teks keluhan tidak boleh kosong!"}), 400

        teks_terkoreksi_calculated = typo_correction(teks_input)
        teks_terkoreksi = teks_input if skip_correction else teks_terkoreksi_calculated
        
        label_prediksi = "Umum"
        probabilitas = 1.0

        if model_ml is not None:
            try:
                label_prediksi = model_ml.predict([teks_terkoreksi])[0]
                probabilitas = model_ml.predict_proba([teks_terkoreksi]).max()
            except Exception as ml_err:
                print(f"⚠️ Gagal prediksi model: {ml_err}")
                label_prediksi = "Keluhan Terdeteksi"

        print("\n================== 🧠 AI PREDICTION LOG ==================")
        print(f"Input User      : {teks_input}")
        print(f"Koreksi Typo    : {teks_terkoreksi}")
        print(f"Hasil Prediksi  : {label_prediksi}")
        print("==========================================================\n")

        semua_jamu = Jamu.query.all()
        hasil_sementara = []
        
        if semua_jamu and model_ml is not None:
            try:
                prep_transformer = model_ml.named_steps['prep']
                tfidf_vectorizer = model_ml.named_steps['tfidf']
                
                query_clean = prep_transformer.transform([teks_terkoreksi])
                query_vector = tfidf_vectorizer.transform(query_clean)
                
                jamu_texts = [f"{item.nama_jamu or ''} {item.khasiat or ''}" for item in semua_jamu]
                jamu_clean = prep_transformer.transform(jamu_texts)
                jamu_vectors = tfidf_vectorizer.transform(jamu_clean)
                
                similarities = cosine_similarity(query_vector, jamu_vectors)[0]
                
                for idx, item in enumerate(semua_jamu):
                    skor_persen = round(float(similarities[idx]) * 100, 1)
                    if skor_persen > 0:
                        item_dict = item.to_dict()
                        item_dict['relevansi'] = skor_persen
                        item_dict['skor_matching'] = float(similarities[idx])
                        hasil_sementara.append(item_dict)
            except Exception as tfidf_err:
                print(f"⚠️ Gagal kalkulasi TF-IDF: {tfidf_err}")

        if not hasil_sementara or model_ml is None:
            print("🚨 Menjalankan Fallback String Matching Manual (Model .pkl Tidak Aktif)...")
            for item in semua_jamu:
                khasiat_str = (item.khasiat or '').lower()
                nama_str = (item.nama_jamu or '').lower()
                
                words = teks_terkoreksi.lower().split()
                match_count = sum(1 for kata in words if kata in khasiat_str or kata in nama_str)
                
                if match_count > 0:
                    item_dict = item.to_dict()
                    item_dict['relevansi'] = min(round((match_count / len(words)) * 100, 1), 95.0)
                    item_dict['skor_matching'] = float(item_dict['relevansi'] / 100)
                    hasil_sementara.append(item_dict)

        hasil_sementara = sorted(hasil_sementara, key=lambda x: x['relevansi'], reverse=True)
        hasil_json = hasil_sementara[:10]

        return jsonify({
            "status": "success",
            "message": "Rekomendasi berhasil diramu",
            "prediksi_label": str(label_prediksi),
            "confidence": float(probabilitas),
            "teks_asli": teks_input,
            "teks_terkoreksi": teks_terkoreksi,
            "data": hasil_json
        }), 200

    except Exception as e:
        print(f"❌ CRITICAL ERROR: {e}")
        return jsonify({"status": "error", "message": str(e), "data": []}), 500