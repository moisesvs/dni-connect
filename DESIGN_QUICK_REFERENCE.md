# 🎨 Quick Reference - Tema DNI-Connect v2.0

## 🎯 Uso Rápido de AppTheme

### Importar
```dart
import 'package:dni_connect/core/theme/app_theme.dart';
```

### Detectar Dark Mode
```dart
final isDarkMode = Theme.of(context).brightness == Brightness.dark;
```

### Colores Primarios
```dart
// Light Mode
AppTheme.primaryColor        // #1E40AF (azul profesional)

// Dark Mode
AppTheme.primaryLight        // #3B82F6 (azul brillante)
```

### Colores Comunes
```dart
// Secundario
AppTheme.secondaryColor      // #7C3AED (púrpura)

// Estados
AppTheme.successColor        // #059669 (verde)
AppTheme.dangerColor         // #DC2626 (rojo)
AppTheme.warningColor        // #D97316 (naranja)
AppTheme.infoColor           // #0369A1 (azul info)

// Fondos Light
AppTheme.lightBackground     // #FAFAFA
AppTheme.lightSurface        // #FFFFFF

// Fondos Dark
AppTheme.darkBackground      // #050F1F
AppTheme.darkSurface         // #0F172A

// Texto Light
AppTheme.textLight           // #111827 (casi negro)

// Texto Dark
AppTheme.textDark            // #FAFAFA (casi blanco)
```

## 🎨 Patrón Recomendado

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? AppTheme.primaryLight : AppTheme.primaryColor;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        color: primaryColor,
      ),
    );
  }
}
```

## 📏 Border Radius Estándar

```
Pequeño:    16px  (inputs, small buttons)
Medio:      20px  (cards, medium components)
Grande:     24px  (important cards)
Muy Grande: 28px  (dialogs, major components)
```

## 🎭 Sombras Estándar

### Light Mode (Sutil)
```dart
boxShadow: [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.06),
    blurRadius: 12,
    offset: const Offset(0, 4),
  ),
],
```

### Dark Mode (Pronunciada)
```dart
boxShadow: [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.3),
    blurRadius: 12,
    offset: const Offset(0, 4),
  ),
],
```

## 🔤 Tipografía Poppins

```dart
// Display Large (36px w800)
Text('...', style: Theme.of(context).textTheme.displayLarge)

// Headline Medium (24px w700)
Text('...', style: Theme.of(context).textTheme.headlineMedium)

// Body Medium (14px w500)
Text('...', style: Theme.of(context).textTheme.bodyMedium)
```

## 🔘 Botones

### Elevated (Primario)
```dart
ElevatedButton(
  onPressed: () {},
  child: Text('Action'),
)
```

### Outlined (Secundario)
```dart
OutlinedButton(
  onPressed: () {},
  child: Text('Secondary'),
)
```

## 📦 Componentes

### Card
```dart
Card(
  child: Container(
    padding: const EdgeInsets.all(16),
    child: Text('Content'),
  ),
)
```

### TextField
```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Type here...',
  ),
)
```

## ✅ Checklist de Actualización

Para cada pantalla:

- [ ] Importar AppTheme
- [ ] Detectar isDarkMode
- [ ] Reemplazar colores hardcodeados
- [ ] Aplicar border radius correcto
- [ ] Agregar sombras
- [ ] Usar Poppins typography
- [ ] Compilar sin errores
- [ ] Testear dark mode
- [ ] Documentar cambios

## 🎯 Colores Por Caso de Uso

### Acciones Primarias
```dart
isDarkMode ? AppTheme.primaryLight : AppTheme.primaryColor
```

### Acciones Secundarias
```dart
AppTheme.secondaryColor
```

### Estados Positivos
```dart
AppTheme.successColor
```

### Estados Negativos
```dart
AppTheme.dangerColor
```

### Fondos
```dart
isDarkMode ? AppTheme.darkBackground : AppTheme.lightBackground
```

### Superficies
```dart
isDarkMode ? AppTheme.darkSurface : AppTheme.lightSurface
```

### Texto Principal
```dart
isDarkMode ? AppTheme.textDark : AppTheme.textLight
```

### Texto Secundario
```dart
isDarkMode ? AppTheme.textDarkSecondary : AppTheme.textLightSecondary
```

## 🚀 Comandos Útiles

```bash
# Compilar
flutter build web --release

# Analizar
flutter analyze

# Correr en Chrome
flutter run -d chrome

# Ver git log
git log --oneline -5

# Ver status
git status
```

---

**Versión:** 2.0  
**Última actualización:** 23 de Febrero, 2026
