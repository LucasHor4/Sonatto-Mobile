import 'package:flutter/material.dart';
import 'package:mobile_sonatto/produtos.dart';
void main() {
  runApp(const Produtos());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}