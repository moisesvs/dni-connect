import 'package:flutter/material.dart';

class NfcReadScreen extends StatelessWidget {
  final String accessKey;

  const NfcReadScreen({Key? key, required this.accessKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lectura NFC'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Acerca tu DNI al dispositivo...'),
          ],
        ),
      ),
    );
  }
}
