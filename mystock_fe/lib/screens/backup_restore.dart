import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  _BackupRestoreScreenState createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      var url = 'https://steady-vervet-emerging.ngrok-free.app/data_barang';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        _data = List<Map<String, dynamic>>.from(data['data_barang'])
            .map((item) => {...item, 'isChecked': false})
            .toList();
        setState(() {
          _data = _data;
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

  Future<void> _restoreData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        String jsonContent = await File(file.path!).readAsString();

        var url = 'https://steady-vervet-emerging.ngrok-free.app/restore';
        var response = await http.post(
          Uri.parse(url),
          body: jsonContent,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Content-Disposition': 'attachment; filename="${file.name}"',
          },
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data Berhasil Direstore'),
              duration: Duration(seconds: 2),
              backgroundColor: const Color.fromRGBO(82, 165, 90, 0.78),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal Restore Data'),
              duration: Duration(seconds: 2),
              backgroundColor: const Color.fromRGBO(162, 87, 114, 0.78),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak Ada File Yang Di Pilih'),
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
          title: const Text('Restore Data'),
          backgroundColor: const Color(0xFF90AFC5),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.upload_file_sharp),
              onPressed: _restoreData,
            ),
          ]),
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
                      _data.clear();
                      _fetchData();
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _data = _data.where((item) {
                    return item['namaBarang']
                        .toLowerCase()
                        .contains(value.toLowerCase());
                  }).toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(219, 219, 219, 0.78),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nama Barang',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(_data[index]['namaBarang'] ?? ''),
                                ],
                              ),
                              const SizedBox(width: 75),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Jumlah',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      _data[index]['jumlahBarang']?.toString() ??
                                          ''),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
