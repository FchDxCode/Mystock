import 'package:flutter/material.dart';
import 'package:mystock_fe/screens/beranda.dart';
import 'package:mystock_fe/widgets/button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _checkPermissionsAndNavigate();
  }

  Future<void> _checkPermissionsAndNavigate() async {
    final PermissionStatus notificationStatus =
        await Permission.notification.status;
    final PermissionStatus storageStatus = await Permission.storage.status;

    if (!notificationStatus.isGranted || !storageStatus.isGranted) {
      await _requestPermissions();
    } else {
      _navigateToBerandaScreen();
    }
  }

  Future<void> _requestPermissions() async {
    final Map<Permission, PermissionStatus> permissions =
        await [Permission.notification, Permission.storage].request();

    if (permissions.containsValue(PermissionStatus.granted)) {
      _navigateToBerandaScreen();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permissions Required'),
          content:
              const Text('Please grant the required permissions to continue.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _navigateToBerandaScreen() async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BerandaScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF90AFC5),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: orientation == Orientation.portrait ? 0.0 : 50.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: orientation == Orientation.portrait ? 300 : 200,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Atur Semua Barang Mu Hanya Di My Stock',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: orientation == Orientation.portrait ? 20 : 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(
                      height: orientation == Orientation.portrait ? 70 : 50),
                  Align(
                    alignment: Alignment.center,
                    child: CustomButton(
                      text: 'Masuk My Stock',
                      onPressed: _checkPermissionsAndNavigate,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
