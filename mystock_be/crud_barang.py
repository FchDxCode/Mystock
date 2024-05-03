from flask import Blueprint, request, jsonify
from datetime import datetime
from conn import db
from models import Barang

crud_app = Blueprint('crud_app', __name__)

# Membuat objek Barang dalam format yang sesuai untuk respons JSON
def serialize_barang(barang):
    tanggal = barang.tanggal.strftime('%d/%m/%Y') if barang.tanggal else None
    return {
        'id': barang.id,
        'namaStock': barang.nama_stock,
        'namaBarang': barang.nama_barang,
        'ukuranBarang': barang.ukuran_barang,
        'hargaBarang': barang.harga_barang,
        'jumlahBarang': barang.jumlah_barang,
        'tanggal': tanggal,
        'notifikasi': barang.notifikasi
    }

# Fungsi untuk menambahkan data baru
@crud_app.route('/tambah_data', methods=['POST'])
def tambah_data():
    data = request.json
    if not data:
        return jsonify({'message': 'Data tidak ditemukan'}), 400

    tanggal_str = data.get('tanggal')
    if not tanggal_str:
        return jsonify({'message': 'Tanggal tidak boleh kosong'}), 400

    try:
        tanggal = datetime.strptime(tanggal_str, '%d/%m/%Y')
    except ValueError:
        return jsonify({'message': 'Format tanggal tidak valid'}), 400

    new_barang = Barang(
        nama_stock=data.get('namaStock'),
        nama_barang=data.get('namaBarang'),
        ukuran_barang=data.get('ukuranBarang'),
        harga_barang=data.get('hargaBarang'),
        jumlah_barang=data.get('jumlahBarang'),
        tanggal=tanggal
    )

    db.session.add(new_barang)
    db.session.commit()

    return jsonify({'message': 'Data berhasil disimpan'}), 201

# Fungsi untuk mengedit data berdasarkan ID
@crud_app.route('/edit_data/<int:id>', methods=['PUT'])
def edit_data(id):
    data = request.json
    if not data:
        return jsonify({'message': 'Data tidak ditemukan'}), 400

    barang = Barang.query.get(id)
    if not barang:
        return jsonify({'message': 'Barang tidak ditemukan'}), 404

    barang.nama_stock = data.get('namaStock')
    barang.nama_barang = data.get('namaBarang')
    barang.ukuran_barang = data.get('ukuranBarang')
    barang.harga_barang = data.get('hargaBarang')
    barang.jumlah_barang = data.get('jumlahBarang')

    db.session.commit()

    return jsonify({'message': 'Data berhasil diperbarui'}), 200

# Fungsi untuk memindahkan data barang ke dalam recycle bin
@crud_app.route('/hapus_data/<int:id>', methods=['DELETE'])
def hapus_data(id):
    barang = Barang.query.get(id)
    if not barang:
        return jsonify({'message': 'Barang tidak ditemukan'}), 404

    barang.deleted = True
    db.session.commit()

    return jsonify({'message': 'Data berhasil dipindahkan ke sampah'}), 200

# Fungsi untuk memulihkan data barang dari recycle bin
@crud_app.route('/recyclebin/<int:id>', methods=['PUT'])
def move_to_recyclebin(id):
    item_to_move = Barang.query.get(id)
    if not item_to_move:
        return jsonify({'message': 'Item tidak ditemukan'}), 404

    item_to_move.deleted = False
    db.session.commit()

    return jsonify({'message': 'Item berhasil dipindahkan ke Recycle Bin'}), 200

# Fungsi untuk menghapus data secara permanen 
@crud_app.route('/permanen_hapus/<int:id>', methods=['DELETE'])
def permanen_hapus(id):
    barang = Barang.query.get(id)
    if not barang:
        return jsonify({'message': 'Barang tidak ditemukan'}), 404

    db.session.delete(barang)
    db.session.commit()

    return jsonify({'message': 'Data berhasil dihapus secara permanen'}), 200

# Fungsi untuk mengambil data barang yang aktif di database
@crud_app.route('/data_barang', methods=['GET'])
def get_data_barang():
    try:
        barangs = Barang.query.filter_by(deleted=False).all()
        data_barang = [serialize_barang(barang) for barang in barangs]
        return jsonify({'data_barang': data_barang}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Fungsi untuk mengambil data barang yang sudah dipindahkan ke recycle bin 
@crud_app.route('/sampah_data', methods=['GET'])
def sampah_data():
    try:
        sampah_barangs = Barang.query.filter_by(deleted=True).all()
        data_sampah = [serialize_barang(barang) for barang in sampah_barangs]
        return jsonify({'sampah_data': data_sampah}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
