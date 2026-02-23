import 'package:flutter/material.dart';

class QrVerifyScreen extends StatelessWidget {
  final String qrRawData;

  const QrVerifyScreen({Key? key, required this.qrRawData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar QR'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Datos QR:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(qrRawData),
            ],
          ),
        ),
      ),
    );
  }
}
