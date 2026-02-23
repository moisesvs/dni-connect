import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dni_connect/core/models/dni_data.dart';
import 'package:dni_connect/core/widgets/dni_connect_components.dart';

/// Pantalla que muestra los campos del DNI extraídos del QR
/// y verifica el QR en segundo plano
class QrResultScreen extends ConsumerStatefulWidget {
  final String qrData;

  const QrResultScreen({
    required this.qrData,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<QrResultScreen> createState() => _QrResultScreenState();
}

class _QrResultScreenState extends ConsumerState<QrResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  int _currentFieldIndex = 0;
  bool _isVerifying = false;
  String _verificationStatus = 'Verificando QR...';
  bool _verificationComplete = false;
  bool _verificationSuccess = false;
  DniData? _dniData;

  // Campos del DNI para mostrar uno por uno
  late List<_DniField> _dniFields;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pageController = PageController();

    // Inicializar campos del DNI (simulado)
    _initializeDniFields();

    // Iniciar verificación en background
    _startBackgroundVerification();
  }

  void _initializeDniFields() {
    _dniFields = [
      _DniField(
        label: 'Número de Documento',
        value: 'Procesando...',
        icon: Icons.badge,
      ),
      _DniField(
        label: 'Nombre Completo',
        value: 'Procesando...',
        icon: Icons.person,
      ),
      _DniField(
        label: 'Fecha de Nacimiento',
        value: 'Procesando...',
        icon: Icons.cake,
      ),
      _DniField(
        label: 'Sexo',
        value: 'Procesando...',
        icon: Icons.wc,
      ),
      _DniField(
        label: 'Nacionalidad',
        value: 'Procesando...',
        icon: Icons.public,
      ),
      _DniField(
        label: 'Autoridad Emisora',
        value: 'Procesando...',
        icon: Icons.location_city,
      ),
      _DniField(
        label: 'Fecha de Expedición',
        value: 'Procesando...',
        icon: Icons.event,
      ),
      _DniField(
        label: 'Fecha de Expiración',
        value: 'Procesando...',
        icon: Icons.schedule,
      ),
    ];
  }

  Future<void> _startBackgroundVerification() async {
    setState(() {
      _isVerifying = true;
      _verificationStatus = 'Verificando QR...';
    });

    // Simular extracción de datos del QR y verificación
    await Future.delayed(const Duration(milliseconds: 500));

    // Actualizar campos con datos extraídos
    _updateDniFields();

    // Simular verificación en background
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _verificationStatus = 'Validando integridad...';
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _verificationStatus = 'Verificando OCSP...';
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _verificationStatus = 'Completado ✓';
      _verificationComplete = true;
      _verificationSuccess = true;
    });

    // Animar hacia el siguiente campo si es necesario
    if (_currentFieldIndex < _dniFields.length - 1) {
      _animateToNextField();
    }
  }

  void _updateDniFields() {
    // Simular datos extraídos del QR
    _dniFields[0].value = '12345678X';
    _dniFields[1].value = 'Juan Pérez García';
    _dniFields[2].value = '15/03/1990';
    _dniFields[3].value = 'Varón';
    _dniFields[4].value = 'Español';
    _dniFields[5].value = 'Dirección General de la Policía';
    _dniFields[6].value = '10/01/2020';
    _dniFields[7].value = '10/01/2030';

    setState(() {
      _dniFields = List.from(_dniFields);
    });
  }

  void _animateToNextField() {
    if (_currentFieldIndex < _dniFields.length - 1) {
      setState(() {
        _currentFieldIndex++;
      });
      _pageController.animateToPage(
        _currentFieldIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificando DNI'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barra de progreso de verificación
          LinearProgressIndicator(
            value: _verificationComplete ? 1.0 : null,
            backgroundColor: colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              _verificationSuccess ? colorScheme.primary : Colors.orange,
            ),
            minHeight: 4,
          ),
          // Estado de verificación
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_isVerifying)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                    ),
                  )
                else if (_verificationSuccess)
                  Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _verificationStatus,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
                Text(
                  '${_currentFieldIndex + 1}/${_dniFields.length}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          // Campos del DNI
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentFieldIndex = index;
                });
              },
              itemCount: _dniFields.length,
              itemBuilder: (context, index) {
                return _buildFieldCard(context, _dniFields[index], index);
              },
            ),
          ),
          // Botones de navegación
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _currentFieldIndex > 0
                        ? () {
                            if (_currentFieldIndex > 0) {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          }
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Anterior'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentFieldIndex < _dniFields.length - 1
                        ? () {
                            _animateToNextField();
                          }
                        : _verificationComplete
                            ? () {
                                context.pushNamed('result');
                              }
                            : null,
                    icon: Icon(
                      _currentFieldIndex < _dniFields.length - 1
                          ? Icons.arrow_forward
                          : Icons.check,
                    ),
                    label: Text(
                      _currentFieldIndex < _dniFields.length - 1
                          ? 'Siguiente'
                          : 'Finalizar',
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

  Widget _buildFieldCard(
    BuildContext context,
    _DniField field,
    int index,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCurrentField = index == _currentFieldIndex;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono del campo
          ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.elasticOut,
              ),
            ),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                field.icon,
                size: 50,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Etiqueta
          Text(
            field.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Valor
          ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
              ),
            ),
            child: SelectableText(
              field.value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          // Indicador de progreso
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _dniFields.length,
              (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i <= _currentFieldIndex
                      ? colorScheme.primary
                      : colorScheme.surfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DniField {
  final String label;
  String value;
  final IconData icon;

  _DniField({
    required this.label,
    required this.value,
    required this.icon,
  });
}
