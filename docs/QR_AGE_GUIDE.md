// GUÍA: Cómo probar el QR de Edad

## Ejemplos de Datos QR de Edad para Pruebas

El QR de edad puede venir en varios formatos. Aquí hay algunos ejemplos que puedes usar para probar:

### Formato 1: Texto Simple con Separadores
```
ID|12345678|GARCÍA|RODRÍGUEZ|JUAN|25/03/1992|M|ES
```

Estructura:
- ID = Tipo de documento
- 12345678 = Número de documento
- GARCÍA = Primer apellido
- RODRÍGUEZ = Segundo apellido
- JUAN = Nombre
- 25/03/1992 = Fecha de nacimiento (DD/MM/YYYY)
- M = Sexo (M=Masculino, F=Femenino)
- ES = País

### Formato 2: Texto con Separador @
```
ID@45678901@MARTÍNEZ@FERNÁNDEZ@MARÍA@12/11/1999@F@ES
```

### Formato 3: Hex Encodificado
Si la policía proporciona datos en hex, el servicio los convertirá automáticamente.

Ejemplo (hex del formato anterior):
```
4944407765616B403234353637383932303340F0B9A3A3D8993140F0B9A3A3D89931418078
```

### Formato 4: Base64
El servicio también soporta Base64 encodificado:

```
SUR8MTPNNDU2NzgxOTkyMDd8TcOBUlTDjU258|4+CTU1RiTcOBUlTDj358w
```

## Cómo Usar para Pruebas

### Opción 1: Usar el Lector QR
1. Abre la app DNI-Connect
2. Abre la app MiDNI oficial de tu teléfono
3. Genera un QR de edad desde tu DNI
4. Escanea con DNI-Connect

### Opción 2: Prueba Manual (si tienes acceso al código fuente)
En la pantalla QR, puedes pasar datos manualmente al método:

```dart
final ageService = QrAgeService.instance;
final ageData = await ageService.decodeAgeQr('ID|12345678|GARCÍA|RODRÍGUEZ|JUAN|25/03/1992|M|ES');
print('Edad: ${ageData.age} años');
print('Mayor 18: ${ageData.isOver18}');
```

## Lo que el Servicio Detecta Automáticamente

✅ Tipo de QR (Age, Full, Unknown)
✅ Edad calculada automáticamente
✅ Mayor de 18 años
✅ Mayor de 21 años
✅ Nombre completo (nombre + apellidos)
✅ Documento de identidad

## Posibles Errores y Soluciones

| Error | Causa | Solución |
|-------|-------|----------|
| "No se pudo decodificar el QR" | Formato no reconocido | Asegúrate de que el QR contiene datos de edad válidos |
| "Número de documento vacío" | Datos incompletos | El QR debe tener al menos el documento y nombre |
| "Fecha de nacimiento inválida" | Formato de fecha incorrecto | Usar DD/MM/YYYY o DDMMYYYY |

## Estado de Implementación

✅ QR de Edad: COMPLETADO
⏳ QR Completo (Full DNI): En progreso
⏳ QR de Dirección: Pendiente

## Próximos Pasos

1. Prueba con el QR de edad real de la policía
2. Proporciona ejemplos de los otros 2 tipos de QR
3. Actualizaremos el servicio para soportarlos
