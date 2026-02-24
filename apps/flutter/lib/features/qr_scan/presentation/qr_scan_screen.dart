import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen>
    with TickerProviderStateMixin {
  late MobileScannerController controller;
  final logger = Logger();
  bool isProcessing = false;
  late AnimationController _pulseController;
  late AnimationController _arrowController;

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

    // Animación de pulso para el marco
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Animación de flechas
    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
    
    logger.i('QrScanScreen iniciado');
  }

  @override
  void dispose() {
    controller.dispose();
    _pulseController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  void _handleQrDetected(BarcodeCapture capture) {
    if (isProcessing) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? qrData = barcode.rawValue;
      if (qrData != null && qrData.isNotEmpty) {
        isProcessing = true;
        logger.i('QR detectado (${qrData.length} caracteres)');
        
        // Navegar a la pantalla de resultado con verificación
        context.pushNamed('qr_result', extra: qrData).then((_) {
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
    final colorScheme = Theme.of(context).colorScheme;

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

          // Overlay oscuro
          Container(
            color: Colors.black.withValues(alpha: 0.3),
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
                        ScaleTransition(
                          scale: Tween<double>(begin: 1.0, end: 1.1).animate(
                            CurvedAnimation(
                              parent: _pulseController,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: Icon(
                            Icons.qr_code_2,
                            size: 64,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Captura el QR del DNI',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Asegúrate de que esté bien iluminado',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Área de escaneo con flechas indicativas
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Marco principal del QR
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colorScheme.primary,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        // Pulso de borde
                        ScaleTransition(
                          scale: Tween<double>(begin: 0.95, end: 1.05).animate(
                            CurvedAnimation(
                              parent: _pulseController,
                              curve: Curves.easeInOut,
                            ),
                          ),
                          child: Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colorScheme.primary.withValues(alpha: 0.3),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),

                        // Flechas direccionales animadas
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Flecha superior
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, -0.15),
                                end: const Offset(0, -0.35),
                              ).animate(
                                CurvedAnimation(
                                  parent: _arrowController,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_upward,
                                color: colorScheme.primary,
                                size: 28,
                              ),
                            ),
                            // Flechas laterales
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(-0.15, 0),
                                    end: const Offset(-0.35, 0),
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _arrowController,
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: colorScheme.primary,
                                    size: 28,
                                  ),
                                ),
                                SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.15, 0),
                                    end: const Offset(0.35, 0),
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _arrowController,
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: colorScheme.primary,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            // Flecha inferior
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.15),
                                end: const Offset(0, 0.35),
                              ).animate(
                                CurvedAnimation(
                                  parent: _arrowController,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_downward,
                                color: colorScheme.primary,
                                size: 28,
                              ),
                            ),
                          ],
                        ),

                        // Mensaje flotante
                        Positioned(
                          bottom: -80,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Escaneando...',
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Controles inferiores
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Instrucción adicional
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Alinea el QR dentro del marco',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botones de control
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Botón de flash
                          ElevatedButton.icon(
                            onPressed: _toggleFlash,
                            icon: const Icon(Icons.flash_on),
                            label: const Text('Flash'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),

                          // Botón de cambiar cámara
                          ElevatedButton.icon(
                            onPressed: _switchCamera,
                            icon: const Icon(Icons.flip_camera_android),
                            label: const Text('Cámara'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
