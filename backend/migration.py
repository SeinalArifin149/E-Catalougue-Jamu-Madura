import csv
import sqlite3

conn = sqlite3.connect("database.db")
cursor = conn.cursor()


def get_or_create(table, column, value):

    cursor.execute(
        f"SELECT id_{table} FROM {table} WHERE {column}=?",
        (value,)
    )

    result = cursor.fetchone()

    if result:
        return result[0]

    cursor.execute(
        f"INSERT INTO {table} ({column}) VALUES (?)",
        (value,)
    )

    return cursor.lastrowid


with open('data_jamu_274.csv', newline='', encoding='utf-8') as file:

    reader = csv.DictReader(file)

    for row in reader:

        # ambil id dari tabel lain
        id_kategori = get_or_create("kategori","nama_kategori",row["KATEGORI"])
        id_jenis = get_or_create("jenis","nama_jenis",row["JENIS"])
        id_produsen = get_or_create("produsen","nama_produsen",row["PRODUSEN"])
        id_lokasi_produksi = get_or_create("lokasi_produksi","nama_lokasi",row["LOKASI PRODUKSI"])
        id_kabupaten = get_or_create("kabupaten","nama_kabupaten",row["KABUPATEN"])
        id_perizinan = get_or_create("perizinan","nama_perizinan",row["PERIZINAN"])

        # insert jamu
        cursor.execute("""
        INSERT INTO jamu (
            nama_jamu,
            khasiat,
            kandungan,
            aturan_minum,
            efek_samping,
            id_kategori,
            id_jenis,
            id_produsen,
            id_lokasi_produksi,
            id_kabupaten,
            id_perizinan
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,(
            row["NAMA JAMU"],
            row["KHASIAT"],
            row["KANDUNGAN"],
            row["ATURAN MINUM"],
            row["EFEK SAMPING"],
            id_kategori,
            id_jenis,
            id_produsen,
            id_lokasi_produksi,
            id_kabupaten,
            id_perizinan
        ))


conn.commit()
conn.close()

print("Data berhasil dimasukkan 🚀")