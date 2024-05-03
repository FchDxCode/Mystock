import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:mystock_fe/widgets/check_box.dart';

class ExportImportScreen extends StatefulWidget {
  const ExportImportScreen({super.key});

  @override
  _ExportImportScreenState createState() => _ExportImportScreenState();
}

class _ExportImportScreenState extends State<ExportImportScreen> {
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

  String queryString() {
    List<Map<String, dynamic>> selectedData = [];
    for (var item in _data) {
      if (item['isChecked'] ?? false) {
        selectedData.add(item);
      }
    }
    return selectedData.map((item) => "id=${item['id']}").join("&");
  }

  Future<String?> _showExportOptionsDialog() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Export Data'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Export to PDF'),
                  onTap: () {
                    Navigator.of(context).pop('PDF');
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  child: const Text('Export to JSON'),
                  onTap: () {
                    Navigator.of(context).pop('JSON');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _exportData(String format) async {
    if (format == 'PDF') {
      downloadPdf();
    } else if (format == 'JSON') {
      await downloadJson();
    }
  }

  Future<void> downloadJson() async {
    List<Map<String, dynamic>> selectedData =
        _data.where((item) => item['isChecked'] ?? false).toList();

    if (selectedData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada data yang dipilih untuk diekspor.'),
          duration: Duration(seconds: 2),
          backgroundColor: const Color.fromRGBO(162, 87, 114, 0.78),
        ),
      );
      return;
    }

    try {
      Map<String, List<Map<String, dynamic>>> groupedData = {};
      for (var item in selectedData) {
        String namaBarang = item['namaBarang'];
        if (!groupedData.containsKey(namaBarang)) {
          groupedData[namaBarang] = [];
        }
        groupedData[namaBarang]!.add(item);
      }

      for (var namaBarang in groupedData.keys) {
        List<Map<String, dynamic>> dataToDownload = groupedData[namaBarang]!;

        String query =
            dataToDownload.map((item) => "id=${item['id']}").join("&");
        var url =
            'https://steady-vervet-emerging.ngrok-free.app/download_json?$query';

        await launch(url);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File JSON untuk $namaBarang telah diunduh.'),
            duration: Duration(seconds: 2),
            backgroundColor: const Color.fromRGBO(82, 165, 90, 0.78),
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

  Future<void> downloadPdf() async {
    List<Map<String, dynamic>> selectedData =
        _data.where((item) => item['isChecked'] ?? false).toList();

    if (selectedData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada data yang dipilih untuk diekspor.'),
          duration: Duration(seconds: 2),
          backgroundColor: const Color.fromRGBO(162, 87, 114, 0.78),
        ),
      );
      return;
    }

    try {
      Map<String, List<Map<String, dynamic>>> groupedData = {};
      for (var item in selectedData) {
        String namaBarang = item['namaBarang'];
        if (!groupedData.containsKey(namaBarang)) {
          groupedData[namaBarang] = [];
        }
        groupedData[namaBarang]!.add(item);
      }

      for (var namaBarang in groupedData.keys) {
        List<Map<String, dynamic>> dataToDownload = groupedData[namaBarang]!;

        String query =
            dataToDownload.map((item) => "id=${item['id']}").join("&");
        var url =
            'https://steady-vervet-emerging.ngrok-free.app/download_pdf?$query';

        await launch(url);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File PDF untuk $namaBarang telah diunduh.'),
            duration: Duration(seconds: 2),
            backgroundColor: const Color.fromRGBO(82, 165, 90, 0.78),
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
        title: const Text('Export Import Data'),
        backgroundColor: const Color(0xFF90AFC5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_for_offline_rounded),
            onPressed: () async {
              final selectedFormat = await _showExportOptionsDialog();
              if (selectedFormat != null) {
                _exportData(selectedFormat);
              }
            },
          ),
        ],
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
          const SizedBox(height: 10),
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
                      const SizedBox(width: 10),
                      CustomCheckbox(
                        height: 68.0,
                        initialValue: _data[index]['isChecked'] ?? false,
                        onChanged: (value) {
                          setState(() {
                            _data[index]['isChecked'] = value;
                          });
                        },
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
