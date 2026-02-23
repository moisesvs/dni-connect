import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DNI-Connect'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.pushNamed('qr_scan'),
              child: const Text('Escanear QR'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pushNamed('nfc_input'),
              child: const Text('Leer NFC'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pushNamed('history'),
              child: const Text('Historial'),
            ),
          ],
        ),
      ),
    );
  }
}
