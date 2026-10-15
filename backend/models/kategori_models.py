from models.kabupaten_models import db


class Kategori(db.Model):
    __tablename__ = "kategori"

    id_kategori = db.Column(db.Integer, primary_key=True)
    nama_kategori = db.Column(db.String(100), nullable=False)
