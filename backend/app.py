import os
os.environ["CUDA_VISIBLE_DEVICES"] = "-1"
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "2"
import logging
from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager 
from dotenv import load_dotenv

load_dotenv()

# --- 1. IMPORT DB (Pusat) ---
# Pastikan semua file model ambil 'db' dari file yang sama
from models.kabupaten_models import db 

# --- 2. IMPORT SEMUA MODEL CLASS (PENTING!) ---
# Ini buat ngenalin semua class ke SQLAlchemy Registry sebelum db.create_all()
from models.kabupaten_models import Kabupaten
from models.jenis_models import JenisJamu
from models.produsen_models import Produsen
from models.lokasi_produksi_models import LokasiProduksi
from models.lokasi_pemasaran_models import LokasiPemasaran
from models.jamu_models import Jamu 
from models.perizinan_models import Perizinan # Buka kalau sudah ada

# --- 3. IMPORT SEMUA BLUEPRINT ---
from routes.login_routes import auth_bp 
from routes.jenis_routes import jenis_bp
from routes.kabupaten_routes import kabupaten_bp
from routes.lokasi_produksi_routes import lokasi_produksi_bp
from routes.lokasi_pemasaran_routes import lokasi_pemasaran_bp
from routes.produsen_routes import produsen_bp
from routes.jamu_routes import jamu_bp
from routes.perizinan_routes import perizinan_bp



app = Flask(__name__)
logger = logging.getLogger(__name__)

basedir = os.path.abspath(os.path.dirname(__file__))

# Database Config
database_url = os.environ.get("DATABASE_URL", "").strip()
if database_url.startswith("postgres://"):
    database_url = "postgresql://" + database_url[len("postgres://"):]
if not database_url:
    database_path = "/tmp/jamu.db" if os.environ.get("VERCEL") == "1" else os.path.join(basedir, "database.db")
    database_url = "sqlite:///" + database_path
app.config['SQLALCHEMY_DATABASE_URI'] = database_url

# with db postgree + Sqlite3
# app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL', "sqlite:///" + os.path.join(os.path.abspath(os.path.dirname(__file__)), 'database.db'))
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = 'rahasia-jamu-madura-123' 

CORS(app)
jwt = JWTManager(app)
db.init_app(app)

# --- 4. DAFTARKAN SEMUA BLUEPRINT ---
app.register_blueprint(auth_bp, url_prefix='/api')
app.register_blueprint(jenis_bp, url_prefix='/api')
app.register_blueprint(kabupaten_bp, url_prefix='/api')
app.register_blueprint(lokasi_produksi_bp, url_prefix='/api')
app.register_blueprint(lokasi_pemasaran_bp, url_prefix='/api')
app.register_blueprint(produsen_bp, url_prefix='/api')
app.register_blueprint(jamu_bp, url_prefix='/api')
app.register_blueprint(perizinan_bp, url_prefix='/api')
# --- 5. BUAT TABEL OTOMATIS ---
# Vercel menjalankan modul saat cold start dan filesystem deployment-nya read-only.
# Database production harus sudah memiliki schema, jadi jangan jalankan DDL di sana.
if os.environ.get("VERCEL") != "1":
    with app.app_context():
        db.create_all()

if __name__ == '__main__':
    app.run(debug=True)