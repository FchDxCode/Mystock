import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mystock_fe/screens/data_stock.dart';
import 'package:mystock_fe/widgets/button.dart';

class TambahStockScreen extends StatefulWidget {
  const TambahStockScreen({super.key});

  @override
  _TambahStockScreenState createState() => _TambahStockScreenState();
}

class _TambahStockScreenState extends State<TambahStockScreen> {
  final TextEditingController _namaStockController = TextEditingController();
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _ukuranBarangController = TextEditingController();
  final TextEditingController _hargaBarangController = TextEditingController();
  final TextEditingController _jumlahBarangController = TextEditingController();

  Future<void> _simpanData() async {
    try {
      if (_hargaBarangController.text.contains('.') ||
          _jumlahBarangController.text.contains('.')) {
        _showDotAlert();
        return;
      }

      var url = 'https://steady-vervet-emerging.ngrok-free.app/tambah_data';

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'namaStock': _namaStockController.text,
          'namaBarang': _namaBarangController.text,
          'ukuranBarang': _ukuranBarangController.text,
          'hargaBarang': _hargaBarangController.text,
          'jumlahBarang': _jumlahBarangController.text,
          'tanggal': _getCurrentDate(),
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil ditambahkan!'),
            duration: Duration(seconds: 2),
            backgroundColor: const Color.fromRGBO(82, 165, 90, 0.78),
          ),
        );
        _resetForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menambahkan data!'),
            duration: Duration(seconds: 2),
            backgroundColor: const Color.fromRGBO(162, 87, 114, 0.78),
          ),
        );
      }
    } catch (error) {
      final errorMessage = 'Error: $error';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 2),
          backgroundColor: const Color.fromRGBO(162, 87, 114, 0.78),
        ),
      );
    }
  }

  void _resetForm() {
    _namaStockController.clear();
    _namaBarangController.clear();
    _ukuranBarangController.clear();
    _hargaBarangController.clear();
    _jumlahBarangController.clear();
  }

  void _showDotAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error!'),
          content: const Text(
              'Harga Barang dan Jumlah Barang tidak boleh menggunakan titik desimal!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Stock'),
        backgroundColor: const Color(0xFF90AFC5),
      ),
      backgroundColor: const Color(0xFF90AFC5),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                TextFormField(
                  controller: _namaStockController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Stock',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: _namaBarangController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Barang',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: _ukuranBarangController,
                  decoration: const InputDecoration(
                    labelText: 'Ukuran Barang',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: _hargaBarangController,
                  decoration: const InputDecoration(
                    labelText: 'Harga Barang',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: _jumlahBarangController,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Barang',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      onPressed: _simpanData,
                      text: "Simpan Data",
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DataStockScreen()),
                        );
                      },
                      text: 'Detail Stock',
                      backgroundColor: const Color.fromRGBO(162, 87, 114, 0.78),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
