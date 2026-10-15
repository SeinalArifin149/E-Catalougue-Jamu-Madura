import os

from models.kabupaten_models import db
from models.jenis_models import JenisJamu  
from models.kategori_models import Kategori

class Jamu(db.Model):
    __tablename__ = "jamu"

    id_jamu = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nama_jamu = db.Column(db.String(150), nullable=False)
    khasiat = db.Column(db.Text, nullable=True)
    kandungan = db.Column(db.Text, nullable=True)
    aturan_minum = db.Column(db.Text, nullable=True)
    efek_samping = db.Column(db.Text, nullable=True)
    image = db.Column(db.Text, nullable=True)

    id_jenis = db.Column(db.Integer, db.ForeignKey("jenis.id_jenis"), nullable=True)
    id_produsen = db.Column(db.Integer, db.ForeignKey("produsen.id_produsen"), nullable=True)
    id_lokasi_produksi = db.Column(db.Integer, db.ForeignKey("lokasi_produksi.id_lokasi_produksi"), nullable=True)
    id_kabupaten = db.Column(db.Integer, db.ForeignKey("kabupaten.id_kabupaten"), nullable=True)
    id_perizinan = db.Column(db.Integer, db.ForeignKey("perizinan.id_perizinan"), nullable=True)
    id_lokasi_pemasaran = db.Column(db.Integer, db.ForeignKey("lokasi_pemasaran.id_lokasi_pemasaran"), nullable=True)
    id_kategori = db.Column(db.Integer, db.ForeignKey("kategori.id_kategori"), nullable=True)

    # ====================================================================
    # 🔗 DEFINISI RELATIONSHIP (Penghubung Antar Tabel)
    # ====================================================================
    jenis_rel = db.relationship('JenisJamu', backref='jamu_list', lazy=True)
    kabupaten_rel = db.relationship('Kabupaten', backref='jamu_list', lazy=True)
    perizinan = db.relationship('Perizinan', backref='jamu_list', lazy=True)
    kategori_rel = db.relationship('Kategori', backref='jamu_list', lazy=True)
    
    def to_dict(self):
        image = self.image
        if image and image.startswith("file://"):
            image = os.path.basename(image.replace("\\", "/"))

        return {
            "id_jamu": self.id_jamu,
            "nama_jamu": self.nama_jamu,
            "khasiat": self.khasiat,
            "kandungan": self.kandungan,
            "aturan_minum": self.aturan_minum,
            "efek_samping": self.efek_samping,
            "image": image,
            "id_jenis": self.id_jenis,
            "id_produsen": self.id_produsen,
            "id_lokasi_produksi": self.id_lokasi_produksi,
            "id_kabupaten": self.id_kabupaten,
            "id_perizinan": self.id_perizinan,
            "id_lokasi_pemasaran": self.id_lokasi_pemasaran,
            "id_kategori": self.id_kategori,
            
            # Mengambil data teks hasil join tabel lewat relationship
            "nama_jenis": self.jenis_rel.nama_jenis if self.jenis_rel else "Tanpa Jenis",
            "nama_kabupaten": self.kabupaten_rel.nama_kabupaten if self.kabupaten_rel else "Lokal",
            "nama_perizinan": self.perizinan.nama_perizinan if self.perizinan else "Tanpa Izin",
            "nama_kategori": self.kategori_rel.nama_kategori if self.kategori_rel else "Tanpa Kategori",
        }