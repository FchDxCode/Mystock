import os
import platform
from flask import request, send_file, Blueprint, jsonify
from reportlab.lib import colors
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle
from io import BytesIO
from datetime import datetime
from models import Barang  

export_import_app = Blueprint('export_import_app', __name__)

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

# Fungsi untuk membuat laporan PDF dari data barang
def pdf_report(data):
    buffer = BytesIO()
    pdf_canvas = SimpleDocTemplate(buffer, pagesize=letter)
    
    # Data untuk tabel dalam laporan PDF
    table_data = []
    for barang in data:
        table_data.append(["Nama Stock", barang.nama_stock])
        table_data.append(["Nama Barang", barang.nama_barang])
        table_data.append(["Ukuran Barang", barang.ukuran_barang])
        table_data.append(["Harga Barang", barang.harga_barang])
        table_data.append(["Jumlah Barang", barang.jumlah_barang])
        table_data.append(["Tanggal", barang.tanggal.strftime('%d/%m/%Y')])

    col_width = 200

    #create table
    table = Table(table_data, colWidths=col_width, repeatRows=1)
    table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.lightgrey),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.black),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
        ('BACKGROUND', (0, 1), (-1, -1), colors.white),
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
    ]))

    pdf_canvas.build([table])
    pdf_data = buffer.getvalue()
    buffer.close()
    return pdf_data

# Endpoint untuk ekspor data ke file PDF
@export_import_app.route('/export_data_pdf', methods=['POST'])
def export_data_pdf():
    try:
        requestData = request.get_json()
        selected_data = requestData.get('selectedData', [])
        
        if not selected_data:
            return jsonify({'error': 'Tidak ada data yang dipilih untuk diekspor'}), 400

        download_folder = get_download_folder()
        if download_folder:
            if not os.path.exists(download_folder):
                os.makedirs(download_folder)
            
            for index, data in enumerate(selected_data, start=1):
                selected_barangs = []
                for item in data:
                    barang = Barang.query.filter_by(id=item['id'], deleted=False).first()
                    if barang:
                        selected_barangs.append(barang)

                pdf_data = pdf_report(selected_barangs)
                timestamp = datetime.now().strftime('%Y%m%d%H%M%S')
                file_name = f"DataBarang_{timestamp}_{index}.pdf"
                pdf_file_path = os.path.join(download_folder, file_name)
                with open(pdf_file_path, "wb") as pdf_file:
                    pdf_file.write(pdf_data)
            
            return jsonify({'download_folder': download_folder}), 200
        else:
            return jsonify({'error': 'Gagal menentukan folder unduhan'}), 500
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': 'Kesalahan Server Internal'}), 500

# Endpoint untuk mengunduh file PDF
@export_import_app.route('/download_pdf', methods=['GET'])
def download_pdf():
    try:
        ids = request.args.getlist('id')
        selected_barangs = Barang.query.filter(Barang.id.in_(ids)).all()

        pdf_data = pdf_report(selected_barangs)
        file_name = f"{selected_barangs[0].nama_barang}.pdf"

        return send_file(
            BytesIO(pdf_data),
            mimetype='application/pdf',
            as_attachment=True,
            download_name=file_name
        )
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': 'Kesalahan Server Internal'}), 500
