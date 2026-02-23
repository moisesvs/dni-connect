import 'package:flutter/material.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
      ),
      body: const Center(
        child: Text('Pantalla de escaneo QR'),
      ),
    );
  }
}
