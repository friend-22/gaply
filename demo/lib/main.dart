import 'package:demo/widget/home.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaply Animation Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const GaplyDemoHome(),
    );
  }
}
