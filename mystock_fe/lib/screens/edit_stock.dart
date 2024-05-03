import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mystock_fe/widgets/button.dart';

class EditStockScreen extends StatefulWidget {
  final Map<String, dynamic> stockData;

  const EditStockScreen({super.key, required this.stockData});

  @override
  _EditStockScreenState createState() => _EditStockScreenState();
}

class _EditStockScreenState extends State<EditStockScreen> {
  final TextEditingController _namaStockController = TextEditingController();
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _ukuranBarangController = TextEditingController();
  final TextEditingController _hargaBarangController = TextEditingController();
  final TextEditingController _jumlahBarangController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaStockController.text = widget.stockData['namaStock'].toString();
    _namaBarangController.text = widget.stockData['namaBarang'].toString();
    _ukuranBarangController.text = widget.stockData['ukuranBarang'].toString();
    _hargaBarangController.text = widget.stockData['hargaBarang'].toString();
    _jumlahBarangController.text = widget.stockData['jumlahBarang'].toString();
  }

  Future<void> _editData() async {
    try {
      var url = 'https://steady-vervet-emerging.ngrok-free.app/edit_data/${widget.stockData['id']}';

      setState(() {
        widget.stockData['namaStock'] = _namaStockController.text;
        widget.stockData['namaBarang'] = _namaBarangController.text;
        widget.stockData['ukuranBarang'] = _ukuranBarangController.text;
        widget.stockData['hargaBarang'] = _hargaBarangController.text;
        widget.stockData['jumlahBarang'] = _jumlahBarangController.text;
        widget.stockData['tanggal'] = _getCurrentDate();
      });

      var response = await http.put(
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

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data Berhasil Di Perbarui!'),
          duration: Duration(seconds: 2),
          backgroundColor:  const Color.fromRGBO(82, 165, 90, 0.78),
        ),
      );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal Memperbarui Data'),
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

  String _getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Stock'),
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
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      onPressed: _editData,
                      text: 'Simpan',
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: 'Detail Stock',
                      backgroundColor:  const Color.fromRGBO(162, 87, 114, 0.78),
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
