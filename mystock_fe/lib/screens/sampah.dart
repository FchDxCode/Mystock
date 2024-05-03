import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SampahScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) addItemToDataStock;
  const SampahScreen({super.key, required this.addItemToDataStock});

  @override
  _SampahScreenState createState() => _SampahScreenState();
}

class _SampahScreenState extends State<SampahScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _trashData = [];

  @override
  void initState() {
    super.initState();
    _fetchTrashData();
  }

  Future<void> _fetchTrashData() async {
    try {
      var url = 'https://steady-vervet-emerging.ngrok-free.app/sampah_data';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _trashData = List<Map<String, dynamic>>.from(data['sampah_data']);
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

  void _recycleItem(int index) async {
    final Map<String, dynamic> movedItem = _trashData[index];
    try {
      var url =
          'https://steady-vervet-emerging.ngrok-free.app/recyclebin/${movedItem['id']}';
      var response = await http.put(Uri.parse(url));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File Di Masukan Ke Recycle Bin'),
            duration: Duration(seconds: 2),
            backgroundColor: const Color.fromRGBO(82, 165, 90, 0.78),
          ),
        );
        setState(() {
          _trashData.removeAt(index);
        });

        widget.addItemToDataStock(movedItem);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memindahkan item ke Recycle Bin'),
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

  void _permanenHapusItem(int index) async {
    final Map<String, dynamic> deletedItem = _trashData[index];
    try {
      var url =
          'https://steady-vervet-emerging.ngrok-free.app/permanen_hapus/${deletedItem['id']}';
      var response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil Menghapus Data'),
            duration: Duration(seconds: 2),
            backgroundColor: const Color.fromRGBO(82, 165, 90, 0.78),
          ),
        );
        setState(() {
          _trashData.removeAt(index);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal Menghapus Data'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sampah'),
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
                    _fetchTrashData();
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _trashData = _trashData.where((trash) {
                    return trash['namaBarang']
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
              itemCount: _trashData.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_trashData[index]['namaBarang'].toString()),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: const Color.fromRGBO(82, 165, 90, 0.78),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    color: const Color.fromRGBO(162, 87, 114, 0.78),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      _recycleItem(index);
                    } else if (direction == DismissDirection.endToStart) {
                      _permanenHapusItem(index);
                    }
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Jumlah',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Tanggal',
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                child:
                                    Text(_trashData[index]['namaBarang'] ?? ''),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_trashData[index]['jumlahBarang']
                                        ?.toString() ??
                                    ''),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_trashData[index]['tanggal'] ?? ''),
                              ),
                            ),
                          ],
                        ),
                      ],
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
