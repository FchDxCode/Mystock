# from flask import Flask, request, jsonify
# from flask_sqlalchemy import SQLAlchemy

# app = Flask(__name__)
# db = SQLAlchemy(app)

# class Barang(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     nama_stock = db.Column(db.String(50))
#     nama_barang = db.Column(db.String(100))
#     ukuran_barang = db.Column(db.String(50))
#     harga_barang = db.Column(db.Float)
#     jumlah_barang = db.Column(db.Integer)
#     tanggal = db.Column(db.Date)
#     deleted = db.Column(db.Boolean, default=False)
#     notifikasi = db.Column(db.Boolean, default=False)

# @app.route('/api/barang/<int:id>/notifikasi', methods=['PUT'])
# def toggle_notification_permission(id):
#     barang = Barang.query.get_or_404(id)
#     notifikasi = request.json.get('notifikasi', None)
#     if notifikasi is None:
#         return jsonify({'message': 'Parameter notifikasi diperlukan'}), 400
#     barang.notifikasi = notifikasi
#     db.session.commit()
#     return jsonify({'message': 'Perizinan notifikasi berhasil diperbarui'}), 200


