import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  late MobileScannerController controller;
  final logger = Logger();
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
      returnImage: false,
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    
    logger.i('QrScanScreen iniciado');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleQrDetected(BarcodeCapture capture) {
    if (isProcessing) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? qrData = barcode.rawValue;
      if (qrData != null && qrData.isNotEmpty) {
        isProcessing = true;
        logger.i('QR detectado: $qrData');
        
        // Navegar a la pantalla de verificación
        context.pushNamed('qr_verify', extra: qrData).then((_) {
          isProcessing = false;
        });
        break;
      }
    }
  }

  void _toggleFlash() {
    setState(() {
      controller.toggleTorch();
    });
  }

  void _switchCamera() {
    controller.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR MiDni'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Cámara
          MobileScanner(
            controller: controller,
            onDetect: _handleQrDetected,
            errorBuilder: (context, error, child) {
              return Center(
                child: Text(
                  'Error: ${error.errorCode}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            },
            placeholderBuilder: (context, child) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),

          // Overlay con instrucciones y controles
          Positioned.fill(
            child: Column(
              children: [
                // Instrucciones superiores
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          size: 64,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Apunta hacia el QR',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Asegúrate de que esté bien iluminado',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Área de escaneo con marco
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.cyan,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),

                // Controles inferiores
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Botones de control
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Botón de flash
                            FloatingActionButton.extended(
                              onPressed: _toggleFlash,
                              label: const Text('Flash'),
                              icon: ValueListenableBuilder(
                                valueListenable: controller.torchState,
                                builder: (context, state, _) {
                                  switch (state) {
                                    case TorchState.off:
                                      return const Icon(Icons.flash_off);
                                    case TorchState.on:
                                      return const Icon(Icons.flash_on);
                                    case TorchState.unavailable:
                                      return const Icon(Icons.flash_off);
                                    case TorchState.auto:
                                      return const Icon(Icons.flash_auto);
                                  }
                                },
                              ),
                              backgroundColor: Colors.cyan.withOpacity(0.8),
                              foregroundColor: Colors.white,
                            ),

                            // Botón de cambiar cámara
                            FloatingActionButton.extended(
                              onPressed: _switchCamera,
                              label: const Text('Cambiar'),
                              icon: const Icon(Icons.flip_camera_android),
                              backgroundColor: Colors.purple.withOpacity(0.8),
                              foregroundColor: Colors.white,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Texto de ayuda
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'El QR se detectará automáticamente',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
