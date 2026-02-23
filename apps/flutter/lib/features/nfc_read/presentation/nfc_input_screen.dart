import 'package:flutter/material.dart';

class NfcInputScreen extends StatefulWidget {
  const NfcInputScreen({Key? key}) : super(key: key);

  @override
  State<NfcInputScreen> createState() => _NfcInputScreenState();
}

class _NfcInputScreenState extends State<NfcInputScreen> {
  final _canController = TextEditingController();

  @override
  void dispose() {
    _canController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingreso de PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _canController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'PIN (6 dígitos)',
                hintText: '123456',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_canController.text.length == 6) {
                  // TODO: navigate to NFC read
                }
              },
              child: const Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }
}
