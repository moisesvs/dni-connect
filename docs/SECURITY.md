# 🔒 Guía de Seguridad - DNI-Connect

Documento de seguridad comprehensivo que define todos los requerimientos, mejores prácticas y configuraciones de seguridad para la aplicación DNI-Connect.

---

## 📋 Contenido

- [Visión General](#visión-general)
- [Seguridad en Frontend (Flutter Web)](#seguridad-en-frontend-flutter-web)
- [Seguridad en Backend (Node.js)](#seguridad-en-backend-nodejs)
- [Seguridad en Datos](#seguridad-en-datos)
- [Seguridad en PKI/Certificados](#seguridad-en-pkicertificados)
- [Cumplimiento Legal (GDPR/CCPA)](#cumplimiento-legal-gdprccpa)
- [Monitoreo y Auditoría](#monitoreo-y-auditoría)
- [Respuesta a Incidentes](#respuesta-a-incidentes)

---

## 🎯 Visión General

DNI-Connect maneja datos muy sensibles:
- 📄 Números de DNI
- 🖼️ Fotos faciales
- 📅 Fechas de nacimiento
- 🏠 Direcciones completas
- 🔐 Datos de autenticación

**Requisito de Seguridad**: Máximo nivel de protección

### Estándares Aplicables

- **OWASP Top 10** (2023)
- **GDPR** (Reglamento de Protección de Datos)
- **CCPA** (California Consumer Privacy Act)
- **PSD2** (Directive on Payment Services)
- **NIST Cybersecurity Framework**

---

## 🌐 Seguridad en Frontend (Flutter Web)

### 1. HTTPS Obligatorio

```dart
// ✅ CORRECTO: Todas las conexiones HTTPS
final client = Dio(
  BaseOptions(
    baseUrl: 'https://api.dni-connect.example.com',
    connectTimeout: Duration(seconds: 10),
  ),
);

// ❌ INCORRECTO: HTTP inseguro
// final client = Dio(BaseOptions(baseUrl: 'http://...'));
```

**Implementación**:
- Forzar HTTPS en index.html
- Configurar HSTS (HTTP Strict Transport Security)
- Usar certificate pinning para policia.es

### 2. Content Security Policy (CSP)

```html
<!-- En web/index.html -->
<meta http-equiv="Content-Security-Policy" content="
  default-src 'self';
  script-src 'self' https://analytics.dni-connect.example.com;
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: https:;
  font-src 'self';
  connect-src 'self' https://api.dni-connect.example.com;
  frame-ancestors 'none';
  form-action 'self';
  base-uri 'self';
  require-trusted-types-for 'script';
">
```

### 3. Protección contra XSS

```dart
// ✅ CORRECTO: Validar y sanitizar inputs
import 'package:html/parser.dart' as html_parser;

String sanitizeHtml(String input) {
  final document = html_parser.parse(input);
  return document.body?.text ?? '';
}

// En formularios
final documentNumber = TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) return 'Requerido';
    if (!RegExp(r'^\d{8}[A-Z]$').hasMatch(value)) {
      return 'Formato inválido (ej: 12345678X)';
    }
    return null;
  },
);
```

### 4. Protección contra CSRF

```dart
// ✅ Incluir CSRF token en requests POST
final headers = {
  'X-CSRF-Token': await _getCsrfToken(),
  'Content-Type': 'application/json',
};

final response = await dio.post(
  '/api/v1/verify/qr',
  data: {'qrData': qrBase64},
  options: Options(headers: headers),
);
```

### 5. Almacenamiento Seguro

```dart
// ✅ CORRECTO: Usar secure_storage para tokens
import 'flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Guardar JWT de forma segura
await storage.write(
  key: 'auth_token',
  value: jwt,
  aOptions: _getAndroidOptions(),
  iOptions: _getIOSOptions(),
);

// ❌ INCORRECTO: Guardar en SharedPreferences
// sharedPref.setString('auth_token', jwt); // NO HACER ESTO
```

### 6. Deshabilitación de Console en Producción

```dart
// En main.dart
void main() {
  if (kReleaseMode) {
    // Deshabilitar debug output en producción
    debugPrint = (String? message, {int? wrapWidth}) {};
  }
  runApp(MyApp());
}
```

### 7. Verificación de Integridad de Assets

```dart
// Verificar firma de APK/AAB en Android
import 'package:google_sign_in/google_sign_in.dart';

Future<bool> verifyAppIntegrity() async {
  // Implementar verificación de firma
  // using PlayIntegrity API
  return true;
}
```

### 8. Protección contra Clickjacking

```html
<!-- En web/index.html -->
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<meta http-equiv="X-UA-Compatible" content="chrome=1">
```

---

## 🖥️ Seguridad en Backend (Node.js)

### 1. Validación Exhaustiva de Inputs

```typescript
// ✅ CORRECTO: Validar todos los inputs con Zod
import { z } from 'zod';

const VerifyQRSchema = z.object({
  qrData: z.string().base64(),
  format: z.enum(['base64', 'hex', 'binary']),
  validateSignature: z.boolean().default(true),
  checkRevocation: z.boolean().default(true),
});

app.post('/api/v1/verify/qr', async (req, res) => {
  const result = VerifyQRSchema.safeParse(req.body);
  
  if (!result.success) {
    return res.status(400).json({
      error: 'Invalid input',
      details: result.error.errors,
    });
  }
  
  const { qrData, format, validateSignature } = result.data;
  // Procesar QR validado
});

// ❌ INCORRECTO: Aceptar inputs sin validar
// app.post('/api/v1/verify', (req, res) => {
//   const qrData = req.body.qrData; // Peligroso
// });
```

### 2. Rate Limiting

```typescript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100, // Máximo 100 requests por ventana
  message: 'Demasiados intentos, intenta más tarde',
  standardHeaders: true,
  legacyHeaders: false,
  skip: (req) => {
    // Permitir health checks
    return req.path === '/health';
  },
  keyGenerator: (req) => {
    // Usar IP real si está detrás de proxy
    return req.headers['x-forwarded-for'] as string ||
           req.socket.remoteAddress;
  },
});

// Rate limiting más estricto para endpoints sensibles
const strictLimiter = rateLimit({
  windowMs: 5 * 60 * 1000, // 5 minutos
  max: 5, // Máximo 5 intentos
});

app.post('/api/v1/verify/qr', strictLimiter, limiter, async (req, res) => {
  // Endpoint protegido
});

app.post('/api/v1/auth/token', strictLimiter, limiter, async (req, res) => {
  // Endpoint de autenticación
});
```

### 3. Autenticación JWT Segura

```typescript
interface JWTPayload {
  userId: string;
  email: string;
  iat: number;
  exp: number;
  iss: 'dni-connect';
}

function generateToken(userId: string, email: string): string {
  const secret = process.env.JWT_SECRET;
  
  if (!secret) {
    throw new Error('JWT_SECRET no configurado');
  }
  
  return jwt.sign(
    { userId, email, iss: 'dni-connect' },
    secret,
    {
      expiresIn: '15m', // ✅ Expiración corta
      algorithm: 'HS256',
      issuer: 'dni-connect',
      audience: 'dni-connect-client',
    }
  );
}

function generateRefreshToken(userId: string): string {
  const secret = process.env.JWT_REFRESH_SECRET;
  
  return jwt.sign(
    { userId, type: 'refresh' },
    secret,
    {
      expiresIn: '7d', // ✅ Expiración más larga pero aún controlada
      algorithm: 'HS256',
    }
  );
}

// Middleware de autenticación
const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers.authorization?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as JWTPayload;
    req.user = decoded;
    next();
  } catch (err) {
    if (err instanceof jwt.TokenExpiredError) {
      return res.status(401).json({ error: 'Token expired' });
    }
    return res.status(403).json({ error: 'Invalid token' });
  }
};
```

### 4. CORS Restrictivo

```typescript
import cors from 'cors';

const corsOptions = {
  origin: process.env.ALLOWED_ORIGINS?.split(',') || [
    'https://dni-connect.example.com',
    'https://app.dni-connect.example.com',
  ],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: [
    'Content-Type',
    'Authorization',
    'X-CSRF-Token',
  ],
  maxAge: 3600, // Cachear preflight 1 hora
  optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));

// ❌ INCORRECTO: CORS abierto
// app.use(cors()); // Permite cualquier origen
```

### 5. Security Headers con Helmet

```typescript
import helmet from 'helmet';

app.use(helmet());
app.use(helmet.hsts({ maxAge: 31536000, includeSubDomains: true }));
app.use(helmet.frameguard({ action: 'deny' }));
app.use(helmet.xssFilter());
app.use(helmet.noSniff());
app.use(helmet.referrerPolicy({ policy: 'no-referrer' }));

// Headers adicionales
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  res.setHeader('Content-Security-Policy', "default-src 'self'");
  next();
});
```

### 6. Manejo Seguro de Errores

```typescript
// ✅ CORRECTO: No revelar detalles internos
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  const isDev = process.env.NODE_ENV === 'development';
  
  const response = {
    error: 'Internal server error',
    ...(isDev && { details: err.message, stack: err.stack }),
  };
  
  logger.error({
    message: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
    userId: req.user?.userId,
  });
  
  res.status(500).json(response);
});

// ❌ INCORRECTO: Exponer detalles
// res.status(500).json({
//   error: err.message,
//   stack: err.stack, // Expone estructura interna
//   sql: err.sql, // Puede revelar queries
// });
```

### 7. Logging de Seguridad

```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'security.log' }),
  ],
});

// Loguear eventos de seguridad
function logSecurityEvent(
  event: 'auth_failed' | 'unauthorized_access' | 'data_breach' | 'config_change',
  details: Record<string, any>
) {
  logger.warn({
    timestamp: new Date().toISOString(),
    event,
    userId: details.userId,
    ip: details.ip,
    path: details.path,
    details,
  });
}

// Ejemplo de uso
app.post('/api/v1/verify/qr', async (req, res) => {
  try {
    const result = await verifyQR(req.body.qrData);
  } catch (err) {
    logSecurityEvent('auth_failed', {
      userId: req.user?.userId,
      ip: req.ip,
      path: req.path,
      error: err.message,
    });
  }
});
```

### 8. Prevención de SQL Injection (NoSQL)

```typescript
// ✅ CORRECTO: Usar prepared statements
const verifications = await db.collection('verifications')
  .where('userId', '==', userId) // Parameterized
  .where('timestamp', '>', timestamp)
  .get();

// ❌ INCORRECTO: String concatenation
// const query = `db.verifications.find({userId: "${userId}"})`;
// Peligroso a inyección NoSQL

// ✅ Validación antes de queries
const userId = z.string().uuid().parse(req.params.userId);
```

---

## 💾 Seguridad en Datos

### 1. Encriptación en Tránsito

```typescript
// Todas las conexiones deben usar TLS 1.2+
const httpsOptions = {
  key: fs.readFileSync('/path/to/private.key'),
  cert: fs.readFileSync('/path/to/certificate.crt'),
};

https.createServer(httpsOptions, app).listen(3001, () => {
  logger.info('HTTPS Server running on port 3001');
});
```

### 2. Encriptación en Reposo

```typescript
import crypto from 'crypto';
import { SecretManagerServiceClient } from '@google-cloud/secret-manager';

// ✅ Encriptar fotos faciales antes de guardar en GCS
async function encryptPhotoBeforeUpload(photoBuffer: Buffer): Promise<Buffer> {
  const secretClient = new SecretManagerServiceClient();
  const secret = await secretClient.accessSecretVersion({
    name: 'projects/dni-connect-prod/secrets/gcs-encryption-key/versions/latest',
  });
  
  const encryptionKey = Buffer.from(secret.payload?.data || '');
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-cbc', encryptionKey, iv);
  
  let encrypted = cipher.update(photoBuffer);
  encrypted = Buffer.concat([encrypted, cipher.final()]);
  
  return Buffer.concat([iv, encrypted]);
}

// Guardar en Firestore
await db.collection('users').doc(userId).set({
  photo: await encryptPhotoBeforeUpload(photoBuffer),
  photoEncrypted: true,
});
```

### 3. Field-Level Encryption

```typescript
// Encriptar campos sensibles individuales
interface UserData {
  userId: string;
  documentNumber: string; // ← Encriptar
  fullName: string; // ← Encriptar
  email: string;
  createdAt: Timestamp;
}

async function encryptSensitiveFields(data: UserData): Promise<UserData> {
  const encryptionKey = await getEncryptionKey();
  
  return {
    ...data,
    documentNumber: encrypt(data.documentNumber, encryptionKey),
    fullName: encrypt(data.fullName, encryptionKey),
  };
}
```

### 4. Data Retention Policy

```typescript
// Implementar limpieza automática de datos sensibles
async function cleanupExpiredData() {
  const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
  
  // Eliminar fotos antiguas
  const oldPhotos = await db.collection('photos')
    .where('createdAt', '<', Timestamp.fromDate(thirtyDaysAgo))
    .get();
  
  for (const doc of oldPhotos.docs) {
    await doc.ref.delete();
    logger.info(`Deleted old photo: ${doc.id}`);
  }
  
  // Anonimizar logs antiguos
  const oldLogs = await db.collection('audit_logs')
    .where('timestamp', '<', Timestamp.fromDate(thirtyDaysAgo))
    .get();
  
  for (const doc of oldLogs.docs) {
    await doc.ref.update({
      userId: 'REDACTED',
      ip: 'REDACTED',
    });
  }
}

// Ejecutar daily
schedule.scheduleJob('0 2 * * *', cleanupExpiredData);
```

---

## 🔐 Seguridad en PKI/Certificados

### 1. Validación de Certificados

```typescript
import { validateCertificateChain } from '@dni-connect/core';

async function verifyQRWithCertValidation(qrData: string) {
  const parsed = VdsParser.parse(Buffer.from(qrData, 'base64'));
  
  // ✅ Validar certificados completamente
  const certValidation = await validateCertificateChain(
    parsed.header.certificateReference,
    {
      checkRevocation: true,
      checkOcsp: true,
      throwOnInvalid: true,
    }
  );
  
  if (!certValidation.valid) {
    throw new Error(`Certificate invalid: ${certValidation.reason}`);
  }
  
  // Proceder con verificación de firma
  return IcaoVerifier.verify(parsed, {
    validateSignature: true,
    validateTimestamp: true,
  });
}
```

### 2. Certificate Pinning

```typescript
import axios from 'axios';
import * as tls from 'tls';

const axiosInstance = axios.create({
  httpsAgent: new (require('https').Agent)({
    rejectUnauthorized: true,
    ca: [
      fs.readFileSync('/certs/pki.policia.es.crt'),
      fs.readFileSync('/certs/root-ca.crt'),
    ],
  }),
});

// Usar para requests a policia.es
const certificates = await axiosInstance.get('http://pki.policia.es/cnp/MiDNI');
```

### 3. OCSP Validation

```typescript
async function verifyOcspStatus(
  certificateRef: string
): Promise<'good' | 'revoked' | 'unknown'> {
  const ocspClient = new OcspClient('http://ocsp.policia.es');
  
  const status = await ocspClient.checkStatus(certificateRef, {
    cacheResults: true,
    cacheTTL: 3600, // Cache 1 hora
  });
  
  if (status === 'revoked') {
    logger.warn(`Certificate revoked: ${certificateRef}`);
    throw new Error('Certificate revoked');
  }
  
  return status;
}
```

---

## 📋 Cumplimiento Legal (GDPR/CCPA)

### 1. Consentimiento

```dart
// En Flutter: Solicitar consentimiento explícito
Future<void> requestDataProcessingConsent() {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Consentimiento de Datos'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Usaremos tus datos para:'),
          SizedBox(height: 10),
          Text('• Verificar tu identidad'),
          Text('• Almacenar tu información de forma segura'),
          Text('• Comunicarnos contigo'),
          Text('• Cumplir requisitos legales'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Rechazar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Aceptar'),
        ),
      ],
    ),
  );
}
```

### 2. Derecho al Olvido (Right to Erasure)

```typescript
app.delete('/api/v1/users/:userId/data', authMiddleware, async (req, res) => {
  const { userId } = req.params;
  
  // Validar que el usuario solicita eliminar sus propios datos
  if (req.user!.userId !== userId) {
    return res.status(403).json({ error: 'Unauthorized' });
  }
  
  try {
    // Eliminar datos personales
    await db.collection('users').doc(userId).delete();
    
    // Eliminar fotos
    const photos = await storage.bucket().getFiles({
      prefix: `photos/${userId}/`,
    });
    
    for (const file of photos[0]) {
      await file.delete();
    }
    
    // Log de eliminación
    logSecurityEvent('data_deletion', {
      userId,
      ip: req.ip,
      timestamp: new Date(),
    });
    
    res.json({ success: true, message: 'Data deleted' });
  } catch (err) {
    logger.error('Data deletion failed', err);
    res.status(500).json({ error: 'Failed to delete data' });
  }
});
```

### 3. Portabilidad de Datos

```typescript
app.get('/api/v1/users/:userId/export', authMiddleware, async (req, res) => {
  const { userId } = req.params;
  
  if (req.user!.userId !== userId) {
    return res.status(403).json({ error: 'Unauthorized' });
  }
  
  try {
    // Exportar datos en formato JSON
    const userData = await db.collection('users').doc(userId).get();
    const verifications = await db.collection('verifications')
      .where('userId', '==', userId)
      .get();
    
    const exportData = {
      user: userData.data(),
      verifications: verifications.docs.map(doc => doc.data()),
      exportDate: new Date().toISOString(),
    };
    
    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Content-Disposition', 'attachment; filename="data-export.json"');
    res.send(JSON.stringify(exportData, null, 2));
  } catch (err) {
    res.status(500).json({ error: 'Export failed' });
  }
});
```

---

## 📊 Monitoreo y Auditoría

### 1. Logging de Auditoría

```typescript
interface AuditLog {
  timestamp: Timestamp;
  event: string;
  userId: string;
  action: 'create' | 'read' | 'update' | 'delete';
  resource: string;
  resourceId: string;
  changes?: Record<string, any>;
  ip: string;
  userAgent: string;
  status: 'success' | 'failure';
  errorMessage?: string;
}

async function logAudit(log: AuditLog) {
  await db.collection('audit_logs').add({
    ...log,
    timestamp: Timestamp.now(),
  });
  
  // También loguear en archivo
  auditLogger.info(JSON.stringify(log));
}
```

### 2. Monitoreo de Alertas

```typescript
async function checkSecurityAlerts() {
  const failedAuths = await db.collection('audit_logs')
    .where('event', '==', 'auth_failed')
    .where('timestamp', '>', Timestamp.now() - 3600) // Última hora
    .get();
  
  if (failedAuths.size > 10) {
    await sendSecurityAlert({
      severity: 'HIGH',
      message: `${failedAuths.size} intentos fallidos de autenticación en la última hora`,
      timestamp: new Date(),
    });
  }
  
  const secretsDetected = await scanForSecrets();
  if (secretsDetected.length > 0) {
    await sendSecurityAlert({
      severity: 'CRITICAL',
      message: 'Secretos expuestos detectados',
      timestamp: new Date(),
    });
  }
}

// Ejecutar cada 5 minutos
schedule.scheduleJob('*/5 * * * *', checkSecurityAlerts);
```

---

## 🚨 Respuesta a Incidentes

### 1. Plan de Respuesta

| Severidad | Tiempo de Respuesta | Acciones |
|-----------|-------------------|----------|
| 🔴 CRÍTICA | < 15 min | Notificar seguridad, investigar, contener |
| 🟠 ALTA | < 1 hora | Investigar, registrar, evaluar impacto |
| 🟡 MEDIA | < 4 horas | Registrar, evaluar, planificar fix |
| 🟢 BAJA | < 1 día | Registrar, planificar mejora |

### 2. Breach Notification

```typescript
async function notifyDataBreach(breach: DataBreach) {
  // Notificar autoridades (AEPD en España)
  await notifyAuthorities({
    type: 'data_breach',
    affectedUsers: breach.affectedUserIds.length,
    dataTypes: breach.affectedDataTypes,
    timestamp: new Date(),
  });
  
  // Notificar usuarios afectados
  for (const userId of breach.affectedUserIds) {
    const user = await db.collection('users').doc(userId).get();
    await sendNotification(user.data()!.email, {
      subject: 'Notificación de Incidente de Seguridad',
      template: 'breach-notification',
      data: {
        affectedData: breach.affectedDataTypes,
        affectDate: breach.discoveryDate,
        response: breach.responseActions,
      },
    });
  }
  
  logger.error(`Data breach reported: ${breach.id}`);
}
```

---

## ✅ Checklist de Seguridad

### Antes de Deploy a Producción

- [ ] HTTPS habilitado
- [ ] JWT con expiración corta
- [ ] Rate limiting activado
- [ ] CORS restrictivo
- [ ] Headers de seguridad configurados
- [ ] Inputs validados con Zod
- [ ] Secretos en variables de entorno
- [ ] Logging de auditoría activado
- [ ] Encriptación en tránsito y reposo
- [ ] Certificados validados
- [ ] OCSP checking activado
- [ ] Dependencias actualizadas
- [ ] No hay secretos en code
- [ ] GDPR/CCPA implementado
- [ ] Consentimiento requerido
- [ ] Security headers verificados
- [ ] CSP configurado
- [ ] Tests de seguridad pasados

### Revisión Regular (Mensual)

- [ ] Ejecutar `security-audit` skill
- [ ] Revisar audit logs
- [ ] Actualizar dependencias
- [ ] Verificar certificados PKI
- [ ] Revisar alertas de seguridad

---

## 📞 Contacto de Seguridad

- 📧 security@dni-connect.example.com
- 🔐 GPG Key: [key-fingerprint]
- 📋 Reportar vulnerabilidades: [HackerOne/BugBounty]

---

**Versión**: 1.0.0  
**Última actualización**: 23 de febrero de 2026  
**Próxima revisión**: 23 de mayo de 2026
