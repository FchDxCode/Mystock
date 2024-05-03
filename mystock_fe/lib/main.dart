import 'package:flutter/material.dart';
import 'package:mystock_fe/screens/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => const IndexScreen(),
      },
    );
  }
}
