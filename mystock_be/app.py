from flask import Flask
from flask_compress import Compress
from flask_cors import CORS
from conn import db
from export_import import export_import_app
from crud_barang import crud_app
from backup_restore import backup_restore_app

app = Flask(__name__)
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///mystock_data.db'
db.init_app(app)

app.register_blueprint(export_import_app)
app.register_blueprint(crud_app)
app.register_blueprint(backup_restore_app)

if __name__ == '__main__':
    app.run(debug=True)
Compress(app)