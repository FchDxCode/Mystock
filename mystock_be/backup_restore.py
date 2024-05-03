import os
import platform
from flask import request, Blueprint, jsonify, Response
from models import Barang  
from conn import db
import json
from datetime import datetime

backup_restore_app = Blueprint('backup_restore_app', __name__)

# Fungsi untuk mendapatkan folder unduhan berdasarkan sistem operasi
def get_download_folder():
    if platform.system() == 'Android':
        download_folder = '/storage/emulated/0/Download'
        if not os.path.exists(download_folder):
            create_folder_permission = input("Folder 'Download' tidak ditemukan. Izinkan aplikasi untuk membuat folder? (y/n): ")
            if create_folder_permission.lower() == 'y':
                os.makedirs(download_folder)
            else:
                download_folder = os.getcwd()
        return download_folder
    
    elif platform.system() == 'Windows':
        download_folder = os.path.join(os.path.expanduser('~'), 'Downloads')
        return download_folder
    else:
        return os.getcwd()

# Endpoint untuk melakukan backup data ke file JSON
@backup_restore_app.route('/backup_json', methods=['POST'])
def backup_json():
    try:
        requestData = request.get_json()
        selected_data = requestData.get('selectedData', [])
        
        if not selected_data:
            return jsonify({'error': 'Tidak ada data yang dipilih untuk dibackup'}), 400

        download_folder = get_download_folder()
        if download_folder:
            if not os.path.exists(download_folder):
                os.makedirs(download_folder)
            
            for index, data in enumerate(selected_data, start=1):
                selected_barangs = []
                for item in data:
                    barang = Barang.query.filter_by(id=item['id'], deleted=False).first()
                    if barang:
                        selected_barangs.append({
                            'Nama Stock': barang.nama_stock,
                            'Nama Barang': barang.nama_barang,
                            'Ukuran Barang': barang.ukuran_barang,
                            'Harga Barang': barang.harga_barang,
                            'Jumlah Barang': barang.jumlah_barang,
                            'Tanggal': barang.tanggal.strftime('%d/%m/%Y')
                        })

                timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
                file_name = f"DataBarang_{timestamp}_{index}.json"
                json_file_path = os.path.join(download_folder, file_name)
                with open(json_file_path, "w") as json_file:
                    json.dump(selected_barangs, json_file, indent=4)
            
            return jsonify({'download_folder': download_folder}), 200
        else:
            return jsonify({'error': 'Gagal menentukan folder unduhan'}), 500
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': 'Kesalahan Server Internal'}), 500

# Endpoint untuk mendownload data dalam format JSON
@backup_restore_app.route('/download_json', methods=['GET'])
def download_json():
    try:
        ids = request.args.getlist('id')
        selected_barangs = Barang.query.filter(Barang.id.in_(ids)).all()

        if not selected_barangs:
            return jsonify({'error': 'Data tidak ditemukan'}), 404

        for barang in selected_barangs:
            selected_data = {
                'Nama Stock': barang.nama_stock,
                'Nama Barang': barang.nama_barang,
                'Ukuran Barang': barang.ukuran_barang,
                'Harga Barang': barang.harga_barang,
                'Jumlah Barang': barang.jumlah_barang,
                'Tanggal': barang.tanggal.strftime('%d/%m/%Y')
            }

            file_name = f"{barang.nama_barang}.json"
            json_data = json.dumps(selected_data, indent=4)

            response = Response(json_data, mimetype='application/json')
            response.headers['Content-Disposition'] = f'attachment; filename={file_name}'

            return response, 200
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': 'Kesalahan Server Internal'}), 500

# Endpoint untuk melakukan restore data dari file JSON
@backup_restore_app.route('/restore', methods=['POST'])
def restore():
    try:
        data = request.get_json()

        if not data:
            return jsonify({'error': 'Data tidak ditemukan'}), 400
        
        required_fields = ["Nama Stock", "Nama Barang", "Ukuran Barang", "Harga Barang", "Jumlah Barang", "Tanggal"]
        for field in required_fields:
            if field not in data:
                return jsonify({'error': f'Field "{field}" tidak ditemukan'}), 400

        new_barang = Barang(
            nama_stock=data['Nama Stock'],
            nama_barang=data['Nama Barang'],
            ukuran_barang=data['Ukuran Barang'],
            harga_barang=data['Harga Barang'],
            jumlah_barang=data['Jumlah Barang'],
            tanggal=datetime.strptime(data['Tanggal'], '%d/%m/%Y'),
            deleted=0,  
            notifikasi=0, 
            id=None  
        )
        db.session.add(new_barang)
        
        db.session.commit()

        return jsonify({'message': 'Data berhasil direstore ke dalam database'}), 200
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': 'Kesalahan Server Internal'}), 500
