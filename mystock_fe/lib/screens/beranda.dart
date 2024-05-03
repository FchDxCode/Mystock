import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mystock_fe/screens/tambah_stock.dart';
import 'package:mystock_fe/widgets/button_beranda.dart';
import 'package:mystock_fe/screens/data_stock.dart';
import 'package:mystock_fe/screens/sampah.dart';
import 'package:mystock_fe/screens/export_import.dart';
import 'package:mystock_fe/screens/backup_restore.dart';
import 'package:mystock_fe/screens/setting.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF90AFC5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  'assets/images/beranda.png',
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 25.0),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45.0),
                    topRight: Radius.circular(45.0),
                  ),
                ),
                padding: const EdgeInsets.all(50.0),
                child: Center(
                  child: Wrap(
                    spacing: 70.0,
                    runSpacing: 40.0,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      ButtonBeranda(
                        iconData: Icons.add_to_photos_rounded,
                        buttonText: 'Tambah Stock',
                        buttonColor: const Color.fromRGBO(82, 165, 90, 0.50),
                        iconColor: const Color.fromRGBO(27, 94, 42, 0.78),
                        iconSize: 60,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TambahStockScreen()),
                          );
                        },
                      ),
                      ButtonBeranda(
                        iconData: CupertinoIcons.trash_fill,
                        buttonText: 'Sampah',
                        buttonColor: const Color.fromRGBO(51, 107, 135, 0.50),
                        iconColor: const Color.fromRGBO(51, 107, 135, 0.78),
                        iconSize: 60,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SampahScreen(
                                addItemToDataStock: (item) {},
                              ),
                            ),
                          );
                        },
                      ),
                      ButtonBeranda(
                        iconData: CupertinoIcons.rectangle_stack_fill,
                        buttonText: 'Data Stock',
                        buttonColor: const Color.fromRGBO(42, 49, 50, 0.50),
                        iconColor: const Color.fromRGBO(42, 49, 50, 0.78),
                        iconSize: 60,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DataStockScreen()),
                          );
                        },
                      ),
                      ButtonBeranda(
                        iconData: Icons.backup_sharp,
                        buttonText: 'Backup Stock',
                        buttonColor: const Color.fromRGBO(118, 54, 38, 0.50),
                        iconColor: const Color.fromRGBO(118, 54, 38, 0.78),
                        iconSize: 60,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BackupRestoreScreen()),
                          );
                        },
                      ),
                      ButtonBeranda(
                        iconData: Icons.settings,
                        buttonText: 'Pengaturan',
                        buttonColor: const Color.fromRGBO(63, 17, 99, 0.50),
                        iconColor: const Color.fromRGBO(63, 17, 99, 0.78),
                        iconSize: 60,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingScreen()),
                          );
                        },
                      ),
                      ButtonBeranda(
                        iconData: CupertinoIcons.printer_fill,
                        buttonText: 'Ekspor Stock',
                        buttonColor: const Color.fromRGBO(162, 87, 114, 0.50),
                        iconColor: const Color.fromRGBO(162, 87, 114, 0.78),
                        iconSize: 60,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ExportImportScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
