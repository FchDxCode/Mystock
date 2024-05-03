import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State {
  bool _notificationPermissionEnabled = false;
  String _downloadDirectory = '';
  String _appVersion = '1.0.0';
  String _githubUrl =
      'https://github.com/FchDxCode'; 
  String _InstagramUrl = 'https://www.instagram.com/f4_rpl2/';
  String _butuhBantuanUrl = 'butuh bantuan';

  @override
  void initState() {
    super.initState();
    
    _loadNotificationPermissionStatus();
    _loadDownloadDirectory();
  }

  Future<void> _loadNotificationPermissionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationPermissionEnabled =
          prefs.getBool('notificationPermission') ?? false;
    });
  }

  Future<void> _loadDownloadDirectory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _downloadDirectory = prefs.getString('downloadDirectory') ?? '';
    });
  }

  Future<void> _requestNotificationPermission() async {
    PermissionStatus permissionStatus = await Permission.notification.request();
    if (permissionStatus.isGranted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificationPermission', true);
      setState(() {
        _notificationPermissionEnabled = true;
      });
    }
  }

  Future<void> _selectDownloadDirectory() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String newDirectory = directory.path;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('downloadDirectory', newDirectory);
    setState(() {
      _downloadDirectory = newDirectory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: const Color(0xFF90AFC5),
      ),
      backgroundColor: const Color(0xFF90AFC5),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Notification Permission'),
            trailing: Switch(
              value: _notificationPermissionEnabled,
              onChanged: (value) {
                if (value) {
                  _requestNotificationPermission();
                } else {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.remove('notificationPermission');
                  });
                  setState(() {
                    _notificationPermissionEnabled = false;
                  });
                }
              },
            ),
          ),
          ListTile(
            title: Text('Download Directory'),
            subtitle: Text(_downloadDirectory),
            onTap: () {
              _selectDownloadDirectory();
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFF90AFC5),
              ),
              child: Text(
                'App Version $_appVersion',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              title: Text('My Github Account'),
              onTap: () {
                Navigator.pop(context); 
                launch(_githubUrl);
              },
            ),
            ListTile(
              title: Text('My Instagram Account'),
              onTap: () {
                Navigator.pop(context);
                launch(_InstagramUrl);
              },
            ),
            ListTile(
              title: Text('Butuh Bantuan?'),
              onTap: () {
                Navigator.pop(context);
                launch(_butuhBantuanUrl);
              },
            )
          ],
        ),
      ),
    );
  }
}
