import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QrVerifyScreen extends StatefulWidget {
  final String qrRawData;

  const QrVerifyScreen({Key? key, required this.qrRawData}) : super(key: key);

  @override
  State<QrVerifyScreen> createState() => _QrVerifyScreenState();
}

class _QrVerifyScreenState extends State<QrVerifyScreen> {
  bool isVerifying = false;

  void _handleVerify() {
    setState(() {
      isVerifying = true;
    });

    // Simular verificación
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('QR verificado exitosamente')),
        );
        context.pop();
      }
    });
  }

  void _handleRetry() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar QR'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono de estado
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.cyan.withValues(alpha: 0.15),
                  border: Border.all(
                    color: Colors.cyan,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.qr_code_2,
                  size: 64,
                  color: Colors.cyan,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Título
            Text(
              'QR Detectado',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),

            const SizedBox(height: 12),

            // Descripción
            Text(
              'Los datos del QR MiDni se han capturado correctamente. Por favor, verifica que todos los datos sean correctos antes de continuar.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[400],
                  ),
            ),

            const SizedBox(height: 24),

            // Datos del QR
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.cyan.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Datos QR (Raw):',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.cyan,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[700]!,
                        width: 1,
                      ),
                    ),
                    child: SelectableText(
                      widget.qrRawData,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 11,
                        color: Colors.white70,
                        wordSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tamaño: ${widget.qrRawData.length} caracteres',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.grey[400],
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Datos copiados al portapapeles'),
                            ),
                          );
                        },
                        tooltip: 'Copiar',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Notas de seguridad
            Container(
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.security,
                        color: Colors.orange[400],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Información de Seguridad',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.orange[400],
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• Este QR contiene datos cifrados de tu MiDni\n'
                    '• Los datos serán verificados con los servidores de la DGP\n'
                    '• Tu privacidad está protegida con certificados X.509\n'
                    '• Solo tú puedes autorizar el uso de estos datos',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[400],
                          height: 1.6,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Botones de acción
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: isVerifying ? null : _handleVerify,
                    icon: isVerifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.verified),
                    label: Text(
                      isVerifying ? 'Verificando...' : 'Verificar QR',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: isVerifying ? null : _handleRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Escanear de Nuevo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.cyan,
                      side: const BorderSide(
                        color: Colors.cyan,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
