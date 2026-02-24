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
  DateTime? _lastDetectionTime;
  static const _detectionDebounceMs = 1000; // 1 segundo entre detecciones

  @override
  void initState() {
    super.initState();
    logger.i('🟢 [initState] Iniciando QrScanScreen');
    
    try {
      logger.i('🟡 [initState] Creando MobileScannerController...');
      controller = MobileScannerController(
        formats: const [BarcodeFormat.qrCode],
        returnImage: false,
        detectionSpeed: DetectionSpeed.noDuplicates, // Evitar duplicados
        facing: CameraFacing.back,
        torchEnabled: false,
      );
      logger.i('✅ [initState] MobileScannerController creado correctamente');

      // Animación de pulso para el marco
      _pulseController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      )..repeat();
      logger.i('✅ [initState] Animación de pulso creada');

      // Animación de flechas
      _arrowController = AnimationController(
        duration: const Duration(milliseconds: 1200),
        vsync: this,
      )..repeat();
      logger.i('✅ [initState] Animación de flechas creada');
      
      logger.i('🟢 [initState] QrScanScreen iniciado correctamente');
    } catch (e, stackTrace) {
      logger.e('❌ [initState] Error general en initState: $e\n$stackTrace');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _pulseController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  void _handleQrDetected(BarcodeCapture capture) {
    logger.i('🔍 [_handleQrDetected] Callback de detección llamado');
    logger.i('   📊 isProcessing: $isProcessing');
    logger.i('   📊 Número de códigos: ${capture.barcodes.length}');
    
    if (isProcessing) {
      logger.w('⏳ [_handleQrDetected] Ya está procesando un QR, ignorando');
      return;
    }
    
    // Aplicar debounce: ignorar si la última detección fue hace menos de 1 segundo
    final now = DateTime.now();
    if (_lastDetectionTime != null) {
      final timeSinceLastDetection = now.difference(_lastDetectionTime!).inMilliseconds;
      if (timeSinceLastDetection < _detectionDebounceMs) {
        logger.d('⏱️ [_handleQrDetected] Debounce activo (${timeSinceLastDetection}ms < ${_detectionDebounceMs}ms)');
        return;
      }
    }
    _lastDetectionTime = now;
    
    final List<Barcode> barcodes = capture.barcodes;
    
    if (barcodes.isEmpty) {
      logger.d('⚠️ [_handleQrDetected] Sin códigos en este frame');
      return;
    }
    
    for (int i = 0; i < barcodes.length; i++) {
      final barcode = barcodes[i];
      final String? qrData = barcode.rawValue;
      
      logger.i('   [$i] Formato: ${barcode.format}');
      logger.i('   [$i] Tipo: ${barcode.type}');
      logger.i('   [$i] Valor: ${qrData?.substring(0, (qrData.length > 50 ? 50 : qrData.length))}${qrData != null && qrData.length > 50 ? "..." : ""}');
      
      if (qrData != null && qrData.isNotEmpty) {
        logger.i('✅ [_handleQrDetected] QR VÁLIDO DETECTADO');
        // Pausar scanner inmediatamente
        controller.stop();
        _processQrData(qrData);
        return;
      }
    }
  }

  /// Procesa los datos del QR detectado
  void _processQrData(String qrData) {
    if (isProcessing) return;
    
    isProcessing = true;
    logger.i('🟡 [_processQrData] Procesando QR detectado');
    
    try {
      context.pushNamed('qr_result', extra: qrData).then((_) {
        logger.i('🟢 [_processQrData] Retornado de qr_result, reiniciando scanner');
        if (mounted) {
          setState(() {
            _lastDetectionTime = null; // Resetear debounce
            isProcessing = false;
          });
          // Reiniciar el scanner cuando regresamos
          controller.start();
        }
      }).catchError((e) {
        logger.e('❌ [_processQrData] Error en navegación: $e');
        if (mounted) {
          setState(() {
            isProcessing = false;
          });
          // Intentar reiniciar el scanner ante error
          try {
            controller.start();
          } catch (_) {}
        }
      });
    } catch (e) {
      logger.e('❌ [_processQrData] Error general: $e');
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  void _toggleFlash() {
    logger.i('🔦 [_toggleFlash] Alternando flash');
    try {
      setState(() {
        controller.toggleTorch();
      });
      logger.i('✅ [_toggleFlash] Flash alternado correctamente');
    } catch (e) {
      logger.e('❌ [_toggleFlash] Error: $e');
    }
  }

  void _switchCamera() {
    logger.i('📷 [_switchCamera] Cambiando cámara');
    try {
      controller.switchCamera();
      logger.i('✅ [_switchCamera] Cámara cambiada correctamente');
    } catch (e) {
      logger.e('❌ [_switchCamera] Error: $e');
    }
  }

  void _showTestQrInput() {
    logger.i('🧪 [_showTestQrInput] Abriendo diálogo de entrada manual');
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Introducir QR para Testing'),
        content: TextField(
          controller: textController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Pega aquí el contenido del QR...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              logger.i('❌ [_showTestQrInput] Diálogo cancelado');
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final qrData = textController.text.trim();
              if (qrData.isNotEmpty) {
                logger.i('✅ [_showTestQrInput] QR introducido manualmente: $qrData');
                Navigator.pop(context);
                _processQrData(qrData);
              } else {
                logger.w('⚠️ [_showTestQrInput] QR vacío');
              }
            },
            child: const Text('Procesar'),
          ),
        ],
      ),
    );
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
              logger.e('📹 [MobileScanner.errorBuilder] Error: ${error.errorCode} - ${error.errorDetails}');
              return Center(
                child: Text(
                  'Error cámara: ${error.errorCode}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            },
            placeholderBuilder: (context, child) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Inicializando cámara...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
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

                          // Botón de prueba manual
                          ElevatedButton.icon(
                            onPressed: _showTestQrInput,
                            icon: const Icon(Icons.edit),
                            label: const Text('Test'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
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
