import os
import re
import json
import logging
from pathlib import Path

from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required
from werkzeug.utils import secure_filename

from models.jamu_models import db, Jamu

jamu_bp = Blueprint("jamu", __name__)
logger = logging.getLogger(__name__)

# ============================================================
# 0. PATH KONFIGURASI
# Asumsi struktur:
# project/
# ├── backend/
# │   ├── routes/<file_blueprint_ini.py>
# │   └── static/uploads/
# └── NLP/nlp5/
#     ├── model_mlp.keras
#     ├── tfidf.pkl
#     ├── preprocessor.pkl
#     ├── label_encoder.pkl
#     └── scaler.pkl (opsional)
# ============================================================

BASE_DIR = Path(__file__).resolve().parent
# File ini diasumsikan berada di backend/routes/
BACKEND_ROOT = BASE_DIR.parent
PROJECT_ROOT = BACKEND_ROOT.parent

MODEL_DIR = PROJECT_ROOT / "NLP" / "nlp5"
MODEL_PATH = MODEL_DIR / "model_mlp.keras"
TFIDF_PATH = MODEL_DIR / "tfidf.pkl"
PREPROCESSOR_PATH = MODEL_DIR / "preprocessor.pkl"
SCALER_PATH = MODEL_DIR / "scaler.pkl"
LABEL_ENCODER_PATH = MODEL_DIR / "label_encoder.pkl"

KAMUS_PATH = BACKEND_ROOT / "kamus_typo.json"
UPLOAD_FOLDER = BACKEND_ROOT / "static" / "uploads"

# False secara default. Ubah True hanya jika scaler memang digunakan
# pada fitur yang masuk ke model ketika training.
USE_SCALER_FOR_CLASSIFIER = False

# ============================================================
# 1. CUSTOM PREPROCESSOR
# Penting: class/module harus cocok dengan saat pickle dibuat.
# ============================================================

class TextPreprocessor:
    def __init__(self):
        self.stop_words = set()
        self._load_stopwords()

    def _load_stopwords(self):
        try:
            import nltk

            nltk_data_dir = "/tmp/nltk_data"
            os.makedirs(nltk_data_dir, exist_ok=True)
            if nltk_data_dir not in nltk.data.path:
                nltk.data.path.append(nltk_data_dir)

            from nltk.corpus import stopwords

            try:
                words = stopwords.words("indonesian")
            except LookupError:
                downloaded = nltk.download(
                    "stopwords",
                    download_dir=nltk_data_dir,
                    quiet=True,
                )
                if not downloaded:
                    raise RuntimeError("Unduhan NLTK stopwords gagal.")
                words = stopwords.words("indonesian")

            self.stop_words = set(words)
            important_medical_words = {
                "sakit", "nyeri", "kurang", "tidak",
                "turun", "naik", "jamu",
            }
            self.stop_words -= important_medical_words
            self.stop_words.add("melalui")

        except Exception:
            logger.exception("Gagal menyiapkan stopwords NLTK.")
            raise

    def fit(self, X, y=None):
        return self

    def transform(self, X):
        return [self.clean_text(text) for text in X]

    def clean_text(self, text):
        import string

        text = str(text or "").lower()
        text = re.sub(r"http\S+|www\S+", "", text)
        text = re.sub(r"\d+", "", text)
        text = text.translate(str.maketrans("", "", string.punctuation))
        text = re.sub(r"\s+", " ", text).strip()
        tokens = text.split()
        tokens = [word for word in tokens if word not in self.stop_words]
        return " ".join(tokens)


# Membantu unpickle hanya bila pickle merujuk ke __main__.TextPreprocessor.
# Jika pickle dibuat dari modul lain, modul/kelas asli tetap harus tersedia.
import __main__
__main__.TextPreprocessor = TextPreprocessor
# Alias untuk pickle lama yang menyimpan nama kelas TeksPrepocessor.
TeksPrepocessor = TextPreprocessor
__main__.TeksPrepocessor = TextPreprocessor

# ============================================================
# 2. LOAD MODEL DAN ARTEFAK SECARA LAZY
# ============================================================

model_ml = None
tfidf_vectorizer = None
preprocessor = None
scaler = None
label_encoder = None
ml_load_error = None
kamus_dict = {}

def load_ml_artifacts():
    """Muat dependency dan artefak ML hanya saat fitur rekomendasi dipakai."""
    global model_ml, tfidf_vectorizer, preprocessor, scaler, label_encoder
    global ml_load_error

    if ml_load_error is not None:
        raise RuntimeError("Fitur rekomendasi ML tidak tersedia.") from ml_load_error
    if model_ml is not None:
        return

    try:
        import joblib

        required_files = [
            MODEL_PATH,
            TFIDF_PATH,
            PREPROCESSOR_PATH,
            LABEL_ENCODER_PATH,
        ]
        missing_files = [str(path) for path in required_files if not path.is_file()]
        if missing_files:
            raise FileNotFoundError(
                "Artefak wajib tidak ditemukan: " + ", ".join(missing_files)
            )

        preprocessor = joblib.load(PREPROCESSOR_PATH)
        tfidf_vectorizer = joblib.load(TFIDF_PATH)
        label_encoder = joblib.load(LABEL_ENCODER_PATH)

        if SCALER_PATH.is_file():
            scaler = joblib.load(SCALER_PATH)

        from tensorflow import keras

        model_ml = keras.models.load_model(MODEL_PATH, compile=False)
        logger.info("Model Keras dan artefak NLP berhasil dimuat dari %s", MODEL_DIR)
    except Exception as exc:
        ml_load_error = exc
        logger.exception("Gagal memuat model atau artefak NLP.")
        raise RuntimeError("Fitur rekomendasi ML tidak tersedia.") from exc

try:
    if KAMUS_PATH.is_file():
        with KAMUS_PATH.open("r", encoding="utf-8") as file:
            kamus_dict = json.load(file)
    else:
        logger.warning("Kamus typo tidak ditemukan: %s", KAMUS_PATH)
except Exception:
    logger.exception("Gagal memuat kamus typo.")
    kamus_dict = {}

# ============================================================
# 3. HELPER: TYPO, TRANSFORM, PREDIKSI
# ============================================================

def typo_correction(text):
    if not kamus_dict:
        return text

    corrected_tokens = []
    for token in str(text).split():
        match = re.match(r"^([^\w]*)([\w\-']+)([^\w]*)$", token)
        if not match:
            corrected_tokens.append(token)
            continue

        prefix, word, suffix = match.groups()
        replacement = kamus_dict.get(word.lower())

        if replacement is None:
            corrected_tokens.append(token)
            continue

        replacement = str(replacement)
        if word.istitle():
            replacement = replacement.title()
        elif word.isupper():
            replacement = replacement.upper()

        corrected_tokens.append(f"{prefix}{replacement}{suffix}")

    return " ".join(corrected_tokens)


def transform_text(texts):
    """Mengubah daftar teks menjadi matriks fitur TF-IDF."""
    load_ml_artifacts()
    if preprocessor is None or tfidf_vectorizer is None:
        raise RuntimeError("Preprocessor/TF-IDF belum berhasil dimuat.")

    cleaned_texts = preprocessor.transform(texts)
    return tfidf_vectorizer.transform(cleaned_texts)


def predict_class(text):
    """Prediksi kategori dengan model Keras."""
    load_ml_artifacts()
    if model_ml is None or label_encoder is None:
        raise RuntimeError("Model Keras atau label encoder belum tersedia.")

    import numpy as np

    features = transform_text([text])

    if USE_SCALER_FOR_CLASSIFIER:
        if scaler is None:
            raise RuntimeError(
                "USE_SCALER_FOR_CLASSIFIER aktif, tetapi scaler.pkl tidak tersedia."
            )
        features = scaler.transform(features)

    if hasattr(features, "toarray"):
        features = features.toarray()

    probabilities = np.asarray(
        model_ml.predict(np.asarray(features), verbose=0)
    )

    if probabilities.ndim != 2 or probabilities.shape[0] == 0:
        raise ValueError("Bentuk keluaran model tidak sesuai ekspektasi.")

    predicted_index = int(np.argmax(probabilities[0]))
    predicted_label = label_encoder.inverse_transform([predicted_index])[0]
    confidence = float(np.max(probabilities[0]))

    return str(predicted_label), confidence


def rank_jamu_by_similarity(query_text, jamu_items, limit=None):
    """Urutkan jamu berdasarkan cosine similarity TF-IDF."""
    load_ml_artifacts()
    if not jamu_items or tfidf_vectorizer is None or preprocessor is None:
        return []

    query_vector = transform_text([query_text])
    jamu_texts = [
        f"{item.nama_jamu or ''} {item.khasiat or ''}"
        for item in jamu_items
    ]
    jamu_vectors = transform_text(jamu_texts)
    import numpy as np

    query_array = query_vector.toarray()
    jamu_array = jamu_vectors.toarray()
    query_norm = np.linalg.norm(query_array, axis=1, keepdims=True)
    jamu_norm = np.linalg.norm(jamu_array, axis=1, keepdims=True)
    denominator = query_norm * jamu_norm.T
    scores = np.divide(
        query_array @ jamu_array.T,
        denominator,
        out=np.zeros((query_array.shape[0], jamu_array.shape[0])),
        where=denominator != 0,
    ).flatten()

    results = []
    for index, item in enumerate(jamu_items):
        score = float(scores[index])
        if score <= 0:
            continue

        item_dict = item.to_dict()
        item_dict["relevansi"] = round(score * 100, 1)
        item_dict["skor_matching"] = score
        results.append(item_dict)

    results.sort(key=lambda item: item["skor_matching"], reverse=True)
    return results[:limit] if limit is not None else results


def manual_jamu_fallback(query_text, jamu_items, limit=10):
    """Fallback sederhana jika TF-IDF tidak tersedia/tidak menemukan hasil."""
    words = [
        word for word in re.findall(r"\w+", query_text.lower())
        if len(word) > 1
    ]
    if not words:
        return []

    results = []
    for item in jamu_items:
        text = f"{item.nama_jamu or ''} {item.khasiat or ''}".lower()
        matches = sum(1 for word in words if word in text)
        if matches == 0:
            continue

        relevance = min(round((matches / len(words)) * 100, 1), 95.0)
        item_dict = item.to_dict()
        item_dict["relevansi"] = relevance
        item_dict["skor_matching"] = relevance / 100
        results.append(item_dict)

    results.sort(key=lambda item: item["relevansi"], reverse=True)
    return results[:limit]


# ============================================================
# 4. GET ALL JAMU (ADMIN)
# ============================================================

@jamu_bp.route("/jamu", methods=["GET"])
@jwt_required()
def get_all_jamu():
    try:
        hasil_json = [item.to_dict() for item in Jamu.query.all()]
        return jsonify({
            "status": "success",
            "message": "Seluruh data Jamu berhasil diambil",
            "data": hasil_json,
        }), 200
    except Exception:
        logger.exception("Gagal mengambil seluruh data jamu.")
        return jsonify({"status": "error", "message": "Gagal mengambil data jamu."}), 500


# ============================================================
# 5. GET DETAIL JAMU + JAMU TERKAIT
# ============================================================

@jamu_bp.route("/jamu/<int:id_jamu>", methods=["GET"])
def get_jamu_by_id(id_jamu):
    try:
        target = db.session.get(Jamu, id_jamu)
        if target is None:
            return jsonify({"status": "error", "message": "Jamu tidak ditemukan"}), 404

        all_jamu = Jamu.query.all()
        jamu_utama_dict = target.to_dict()
        saran_jamu_lainnya = []

        if len(all_jamu) > 1 and preprocessor is not None and tfidf_vectorizer is not None:
            try:
                matrix_query = transform_text([str(target.khasiat or "")])
                matrix_dataset = transform_text([
                    str(item.khasiat or "") for item in all_jamu
                ])
                import numpy as np

                query_array = matrix_query.toarray()
                dataset_array = matrix_dataset.toarray()
                query_norm = np.linalg.norm(query_array, axis=1, keepdims=True)
                dataset_norm = np.linalg.norm(dataset_array, axis=1, keepdims=True)
                denominator = query_norm * dataset_norm.T
                scores = np.divide(
                    query_array @ dataset_array.T,
                    denominator,
                    out=np.zeros((query_array.shape[0], dataset_array.shape[0])),
                    where=denominator != 0,
                ).flatten()

                for index, item in enumerate(all_jamu):
                    if item.id_jamu == target.id_jamu:
                        continue

                    score = float(scores[index])
                    if score == 0 and item.id_jenis == target.id_jenis:
                        score = 0.25
                    elif score == 0 and item.id_kabupaten == target.id_kabupaten:
                        score = 0.15

                    if score > 0:
                        item_dict = item.to_dict()
                        item_dict["skor_matching"] = score
                        saran_jamu_lainnya.append(item_dict)

                saran_jamu_lainnya.sort(
                    key=lambda item: item["skor_matching"],
                    reverse=True,
                )
                saran_jamu_lainnya = saran_jamu_lainnya[:5]

            except Exception:
                logger.exception("Gagal menghitung jamu terkait.")

        # Fallback tampilan jika tidak ada skor kemiripan
        if not saran_jamu_lainnya and len(all_jamu) > 1:
            for item in all_jamu:
                if item.id_jamu == target.id_jamu:
                    continue
                item_dict = item.to_dict()
                item_dict["skor_matching"] = 0.05
                saran_jamu_lainnya.append(item_dict)
                if len(saran_jamu_lainnya) >= 5:
                    break

        return jsonify({
            "status": "success",
            "message": "Detail data Jamu berhasil diambil",
            "data": jamu_utama_dict,
            "jamu_terkait": saran_jamu_lainnya,
        }), 200

    except Exception:
        logger.exception("Gagal mengambil detail jamu.")
        return jsonify({"status": "error", "message": "Gagal mengambil detail jamu."}), 500


# ============================================================
# 6. INSERT JAMU (ADMIN)
# ============================================================

@jamu_bp.route("/jamu", methods=["POST"])
@jwt_required()
def tambah_jamu():
    try:
        nama_jamu = request.form.get("nama_jamu", "").strip()
        if not nama_jamu:
            return jsonify({
                "status": "error",
                "message": "Nama jamu tidak boleh kosong!",
            }), 400

        nama_file_gambar = None
        file = request.files.get("image")
        if file and file.filename:
            filename = secure_filename(file.filename)
            if not filename:
                return jsonify({
                    "status": "error",
                    "message": "Nama file gambar tidak valid.",
                }), 400

            os.makedirs(UPLOAD_FOLDER, exist_ok=True)
            file.save(str(UPLOAD_FOLDER / filename))
            nama_file_gambar = filename

        jamu_baru = Jamu(
            nama_jamu=nama_jamu,
            khasiat=request.form.get("khasiat"),
            kandungan=request.form.get("kandungan"),
            aturan_minum=request.form.get("aturan_minum"),
            efek_samping=request.form.get("efek_samping"),
            image=nama_file_gambar,
            id_jenis=request.form.get("id_jenis"),
            id_produsen=request.form.get("id_produsen"),
            id_lokasi_produksi=request.form.get("id_lokasi_produksi"),
            id_kabupaten=request.form.get("id_kabupaten"),
            id_perizinan=request.form.get("id_perizinan"),
            id_lokasi_pemasaran=request.form.get("id_lokasi_pemasaran"),
        )

        db.session.add(jamu_baru)
        db.session.commit()
        return jsonify({
            "status": "success",
            "message": f"Jamu {jamu_baru.nama_jamu} berhasil didaftarkan!",
        }), 201

    except Exception:
        db.session.rollback()
        logger.exception("Gagal menambahkan jamu.")
        return jsonify({"status": "error", "message": "Gagal menambahkan jamu."}), 500


# ============================================================
# 7. UPDATE JAMU (ADMIN)
# ============================================================

@jamu_bp.route("/jamu/<int:id_edit>", methods=["PUT"])
@jwt_required()
def edit_jamu(id_edit):
    try:
        target = db.session.get(Jamu, id_edit)
        if target is None:
            return jsonify({"status": "error", "message": "Jamu tidak ditemukan"}), 404

        fields = [
            "nama_jamu", "khasiat", "kandungan", "aturan_minum",
            "efek_samping", "id_jenis", "id_produsen",
            "id_lokasi_produksi", "id_kabupaten", "id_perizinan",
            "id_lokasi_pemasaran",
        ]
        for field in fields:
            value = request.form.get(field)
            if value is not None:
                setattr(target, field, value)

        file = request.files.get("image")
        if file and file.filename:
            filename = secure_filename(file.filename)
            if not filename:
                return jsonify({
                    "status": "error",
                    "message": "Nama file gambar tidak valid.",
                }), 400

            os.makedirs(UPLOAD_FOLDER, exist_ok=True)
            file.save(str(UPLOAD_FOLDER / filename))

            if target.image:
                old_path = UPLOAD_FOLDER / target.image
                try:
                    if old_path.is_file():
                        old_path.unlink()
                except OSError:
                    logger.exception("Gagal menghapus gambar lama: %s", old_path)

            target.image = filename

        db.session.commit()
        return jsonify({
            "status": "success",
            "message": "Data Jamu berhasil diupdate",
        }), 200

    except Exception:
        db.session.rollback()
        logger.exception("Gagal mengubah jamu.")
        return jsonify({"status": "error", "message": "Gagal mengubah data jamu."}), 500


# ============================================================
# 8. DELETE JAMU (ADMIN)
# ============================================================

@jamu_bp.route("/jamu/<int:id_hapus>", methods=["DELETE"])
@jwt_required()
def hapus_jamu(id_hapus):
    try:
        target = db.session.get(Jamu, id_hapus)
        if target is None:
            return jsonify({"status": "error", "message": "Data tidak ditemukan"}), 404

        image_path = UPLOAD_FOLDER / target.image if target.image else None
        db.session.delete(target)
        db.session.commit()

        if image_path and image_path.is_file():
            try:
                image_path.unlink()
            except OSError:
                logger.exception("Gagal menghapus file gambar: %s", image_path)

        return jsonify({
            "status": "success",
            "message": "Data jamu berhasil dihapus",
        }), 200

    except Exception:
        db.session.rollback()
        logger.exception("Gagal menghapus jamu.")
        return jsonify({"status": "error", "message": "Gagal menghapus jamu."}), 500


# ============================================================
# 9. GET ALL JAMU PUBLIC
# ============================================================

@jamu_bp.route("/jamu/public", methods=["GET"])
def get_public_jamu():
    try:
        hasil_json = [item.to_dict() for item in Jamu.query.all()]
        return jsonify({
            "status": "success",
            "message": "Data katalog jamu publik berhasil diambil",
            "data": hasil_json,
        }), 200
    except Exception:
        logger.exception("Gagal mengambil katalog publik.")
        return jsonify({"status": "error", "message": "Gagal mengambil katalog jamu."}), 500


# ============================================================
# 10. FILTER PUBLIK
# ============================================================

@jamu_bp.route("/jamu/public-filters", methods=["GET"])
def get_public_filters():
    try:
        data = [item.to_dict() for item in Jamu.query.all()]

        jenis = sorted({
            item.get("nama_jenis")
            for item in data
            if item.get("nama_jenis")
        })
        kabupaten = sorted({
            item.get("nama_kabupaten")
            for item in data
            if item.get("nama_kabupaten")
        })
        perizinan = sorted({
            item.get("nama_perizinan")
            for item in data
            if item.get("nama_perizinan")
        })

        return jsonify({
            "status": "success",
            "message": "Data pilihan filter berhasil diekstrak",
            "data": {
                "jenis": jenis,
                "kabupaten": kabupaten,
                "perizinan": perizinan,
            },
        }), 200

    except Exception:
        logger.exception("Gagal mengambil filter publik.")
        return jsonify({"status": "error", "message": "Gagal mengambil filter."}), 500


# ============================================================
# 11. CORS
# Catatan: wildcard origin tidak cocok bila frontend memakai
# cookie/credential. Sesuaikan origin dengan konfigurasi aplikasi.
# ============================================================

@jamu_bp.after_request
def add_cors_headers(response):
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type,Authorization"
    response.headers["Access-Control-Allow-Methods"] = "GET,PUT,POST,DELETE,OPTIONS"
    return response


# ============================================================
# 12. REKOMENDASI ML
# ============================================================

@jamu_bp.route("/jamu/recommend", methods=["POST", "OPTIONS"])
def dapatkan_rekomendasi_ml():
    if request.method == "OPTIONS":
        return jsonify({"status": "success"}), 200

    try:
        data = request.get_json(silent=True) or {}
        teks_input = (
            data.get("keluhan")
            or data.get("teks")
            or data.get("query")
            or ""
        )

        if not isinstance(teks_input, str) or not teks_input.strip():
            return jsonify({
                "status": "error",
                "message": "Teks keluhan tidak boleh kosong!",
            }), 400

        teks_input = teks_input.strip()
        skip_correction = bool(data.get("skip_correction", False))
        corrected = typo_correction(teks_input)
        teks_terkoreksi = teks_input if skip_correction else corrected

        label_prediksi = "Tidak tersedia"
        confidence = 0.0

        if model_ml is not None:
            try:
                label_prediksi, confidence = predict_class(teks_terkoreksi)
            except Exception:
                logger.exception("Prediksi kategori gagal.")
                label_prediksi = "Prediksi tidak tersedia"

        semua_jamu = Jamu.query.all()
        hasil = []

        if semua_jamu and preprocessor is not None and tfidf_vectorizer is not None:
            try:
                hasil = rank_jamu_by_similarity(
                    teks_terkoreksi,
                    semua_jamu,
                    limit=10,
                )
            except Exception:
                logger.exception("Pencarian similarity TF-IDF gagal.")

        if not hasil:
            hasil = manual_jamu_fallback(
                teks_terkoreksi,
                semua_jamu,
                limit=10,
            )

        return jsonify({
            "status": "success",
            "message": "Rekomendasi berhasil diproses",
            "prediksi_label": str(label_prediksi),
            "confidence": float(confidence),
            "teks_asli": teks_input,
            "teks_terkoreksi": teks_terkoreksi,
            "data": hasil,
        }), 200

    except Exception:
        logger.exception("Kesalahan kritis pada endpoint rekomendasi.")
        return jsonify({
            "status": "error",
            "message": "Terjadi kesalahan saat memproses rekomendasi.",
            "data": [],
        }), 500