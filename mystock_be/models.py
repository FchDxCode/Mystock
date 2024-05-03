from conn import db

# Definisi model Barang, merepresentasikan tabel Barang dalam database
class Barang(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nama_stock = db.Column(db.String(50))
    nama_barang = db.Column(db.String(100))
    ukuran_barang = db.Column(db.String(50))
    harga_barang = db.Column(db.Float)
    jumlah_barang = db.Column(db.Integer)
    tanggal = db.Column(db.Date)
    deleted = db.Column(db.Boolean, default=False)
    notifikasi = db.Column(db.String(100))  

 # Representasi string dari objek Barang
    def __repr__(self):
        return f"<Barang {self.nama_barang}>"
