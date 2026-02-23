import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String verificationResult;

  const ResultScreen({Key? key, required this.verificationResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text('Verificación completada'),
            const SizedBox(height: 24),
            SelectableText(verificationResult),
          ],
        ),
      ),
    );
  }
}
