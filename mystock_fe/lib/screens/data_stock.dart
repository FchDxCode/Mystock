import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mystock_fe/screens/edit_stock.dart';

class DataStockScreen extends StatefulWidget {
  const DataStockScreen({super.key});

  @override
  _DataStockScreenState createState() => _DataStockScreenState();
}

class _DataStockScreenState extends State<DataStockScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _stockData = [];

  @override
  void initState() {
    super.initState();
    _fetchStockData();
  }

  Future<void> _fetchStockData() async {
    try {
      var url = 'https://steady-vervet-emerging.ngrok-free.app/data_barang';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil Mengambil Data'),
            duration: Duration(seconds: 2),
            backgroundColor: const Color.fromRGBO(82, 165, 90, 0.78),
          ),
        );
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _stockData = List<Map<String, dynamic>>.from(data['data_barang']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal Mengambil Data'),
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

  void _showStockDetailDialog(Map<String, dynamic> stockData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final NumberFormat formatter = NumberFormat('#,##0');
        return AlertDialog(
          title: Text(stockData['namaBarang'] ?? ''),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var key in [
                'namaStock',
                'namaBarang',
                'jumlahBarang',
                'ukuranBarang',
                'hargaBarang',
                'tanggal'
              ])
                _buildDetailRow(
                    key,
                    key == 'hargaBarang'
                        ? formatter.format(stockData[key])
                        : stockData[key]),
            ],
          ),
        );
      },
    );
  }

  void _moveToTrash(int id) async {
    try {
      var url = 'https://steady-vervet-emerging.ngrok-free.app/hapus_data/$id';
      var response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil Di Pindahkan Ke Recycle Bin'),
            duration: Duration(seconds: 2),
            backgroundColor: const Color.fromRGBO(82, 165, 90, 0.78),
          ),
        );

        setState(() {
          _stockData.removeWhere((item) => item['id'] == id);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal Memindahkan Ke Recycle Bin'),
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

  //Metode  menambahkan item
  void addStockItem(Map<String, dynamic> newItem) {
    setState(() {
      _stockData.add(newItem);
    });
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value?.toString() ?? ''),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Stock'),
        backgroundColor: const Color(0xFF90AFC5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF90AFC5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _stockData.clear();
                      _fetchStockData();
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _stockData = _stockData.where((stock) {
                    return stock['namaBarang']
                        .toLowerCase()
                        .contains(value.toLowerCase());
                  }).toList();
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _stockData.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    alignment: Alignment.centerLeft,
                    color: const Color.fromRGBO(82, 165, 90, 0.78),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    color: const Color.fromRGBO(162, 87, 114, 0.78),
                    child: const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditStockScreen(stockData: _stockData[index])),
                      );
                    } else if (direction == DismissDirection.endToStart) {
                      _moveToTrash(_stockData[index]['id']);
                    }
                  },
                  child: GestureDetector(
                    onTap: () {
                      _showStockDetailDialog(_stockData[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(219, 219, 219, 0.78),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(3), // Nama Stock
                          1: FlexColumnWidth(2), // Jumlah
                          2: FlexColumnWidth(2), // Tanggal
                        },
                        children: [
                          const TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Nama Barang',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Jumlah',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Tanggal',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      _stockData[index]['namaBarang'] ?? ''),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_stockData[index]['jumlahBarang']?.toString() ?? ''),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Text(_stockData[index]['tanggal'] ?? ''),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
