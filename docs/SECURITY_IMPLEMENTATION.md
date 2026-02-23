# 🔧 Plan de Implementación de Seguridad - DNI-Connect

Guía paso a paso para implementar todas las mejoras de seguridad recomendadas en la aplicación.

---

## 📋 Prioridades de Implementación

```
FASE 1: Seguridad Crítica (1-2 semanas)
├── Rate limiting
├── Validación de inputs (Zod)
├── JWT seguro
├── CORS restrictivo
└── Security headers

FASE 2: Encriptación (2-3 semanas)
├── Encripción de fotos en GCS
├── Field-level encryption en Firestore
├── Certificado pinning
└── OCSP validation

FASE 3: Compliance (1-2 semanas)
├── Logging de auditoría
├── GDPR/CCPA implementation
├── Data retention policies
└── Consentimiento

FASE 4: Testing & Monitoring (1 semana)
├── Tests de seguridad
├── Vulnerability scanning
├── Monitoring continuo
└── Incident response procedures
```

---

## FASE 1: Seguridad Crítica

### 1.1 Implementar Rate Limiting

**Archivo**: `backend/src/middleware/rateLimit.ts`

```typescript
import rateLimit from 'express-rate-limit';
import RedisStore from 'rate-limit-redis';
import { redis } from '../config/redis';

export const globalLimiter = rateLimit({
  store: new RedisStore({
    client: redis,
    prefix: 'rate-limit:',
  }),
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100,
  message: 'Demasiados intentos, intenta más tarde',
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.ip || 'unknown',
});

export const authLimiter = rateLimit({
  store: new RedisStore({
    client: redis,
    prefix: 'auth-limit:',
  }),
  windowMs: 5 * 60 * 1000, // 5 minutos
  max: 5,
  skipSuccessfulRequests: true,
});

export const apiLimiter = rateLimit({
  store: new RedisStore({
    client: redis,
    prefix: 'api-limit:',
  }),
  windowMs: 1 * 60 * 1000, // 1 minuto
  max: 30,
});
```

**En `backend/src/server.ts`**:

```typescript
import { globalLimiter, authLimiter, apiLimiter } from './middleware/rateLimit';

// Aplicar globalmente
app.use(globalLimiter);

// En endpoints específicos
app.post('/api/v1/auth/token', authLimiter, async (req, res) => {
  // ...
});

app.post('/api/v1/verify/qr', apiLimiter, async (req, res) => {
  // ...
});
```

**Dependencias**: `npm install express-rate-limit rate-limit-redis`

**Verificación**:
```bash
# Test rate limiting
for i in {1..6}; do curl -X POST http://localhost:3000/api/v1/auth/token; done
# A partir del 5to request debe mostrar: "Demasiados intentos"
```

---

### 1.2 Validación de Inputs con Zod

**Archivo**: `backend/src/schemas/index.ts`

```typescript
import { z } from 'zod';

export const VerifyQRSchema = z.object({
  qrData: z.string()
    .base64('QR data must be base64 encoded')
    .min(100, 'QR data too short')
    .max(10000, 'QR data too long'),
  format: z.enum(['base64', 'hex', 'binary']).default('base64'),
  validateSignature: z.boolean().default(true),
  checkRevocation: z.boolean().default(true),
  checkOcsp: z.boolean().default(true),
});

export const AuthTokenSchema = z.object({
  email: z.string().email(),
  password: z.string().min(12, 'Password too short'),
  rememberMe: z.boolean().optional(),
});

export const CreateUserSchema = z.object({
  email: z.string().email(),
  documentNumber: z.string().regex(/^\d{8}[A-Z]$/),
  fullName: z.string().min(3).max(100),
  birthDate: z.coerce.date(),
});

export type VerifyQRRequest = z.infer<typeof VerifyQRSchema>;
export type AuthTokenRequest = z.infer<typeof AuthTokenSchema>;
export type CreateUserRequest = z.infer<typeof CreateUserSchema>;
```

**En endpoints**:

```typescript
app.post('/api/v1/verify/qr', async (req, res) => {
  const result = VerifyQRSchema.safeParse(req.body);
  
  if (!result.success) {
    return res.status(400).json({
      error: 'Invalid input',
      details: result.error.flatten(),
    });
  }
  
  const { qrData, ...options } = result.data;
  // Procesar
});
```

**Dependencias**: `npm install zod`

---

### 1.3 JWT Seguro

**Archivo**: `backend/src/auth/jwt.ts`

```typescript
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET;
const JWT_REFRESH_SECRET = process.env.JWT_REFRESH_SECRET;

if (!JWT_SECRET || !JWT_REFRESH_SECRET) {
  throw new Error('JWT secrets not configured');
}

export interface JWTPayload {
  userId: string;
  email: string;
  iat: number;
  exp: number;
  iss: string;
}

export function generateAccessToken(userId: string, email: string): string {
  return jwt.sign(
    { userId, email, iss: 'dni-connect' },
    JWT_SECRET,
    {
      expiresIn: '15m',
      algorithm: 'HS256',
      issuer: 'dni-connect',
      audience: 'dni-connect-client',
    }
  );
}

export function generateRefreshToken(userId: string): string {
  return jwt.sign(
    { userId, type: 'refresh', iss: 'dni-connect' },
    JWT_REFRESH_SECRET,
    {
      expiresIn: '7d',
      algorithm: 'HS256',
    }
  );
}

export function verifyToken(token: string): JWTPayload | null {
  try {
    return jwt.verify(token, JWT_SECRET, {
      issuer: 'dni-connect',
      audience: 'dni-connect-client',
    }) as JWTPayload;
  } catch (err) {
    return null;
  }
}
```

**En `.env.example`**:

```bash
JWT_SECRET=your-256-bit-secret-key-min-32-chars
JWT_REFRESH_SECRET=your-refresh-secret-key-min-32-chars
JWT_EXPIRATION=15m
JWT_REFRESH_EXPIRATION=7d
```

**Generar secrets seguros**:

```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

---

### 1.4 CORS Restrictivo

**Archivo**: `backend/src/middleware/cors.ts`

```typescript
import cors from 'cors';

const allowedOrigins = (process.env.ALLOWED_ORIGINS || '').split(',').filter(Boolean);

export const corsOptions = {
  origin: (origin: string | undefined, callback: (err: Error | null, allow?: boolean) => void) => {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: [
    'Content-Type',
    'Authorization',
    'X-CSRF-Token',
    'X-Requested-With',
  ],
  exposedHeaders: ['X-Total-Count', 'X-Page-Count'],
  maxAge: 3600,
  optionsSuccessStatus: 200,
};

export default cors(corsOptions);
```

**En `backend/src/server.ts`**:

```typescript
import corsMiddleware from './middleware/cors';

app.use(corsMiddleware);
app.options('*', corsMiddleware); // Para preflight requests
```

**En `.env`**:

```bash
ALLOWED_ORIGINS=https://app.dni-connect.example.com,https://admin.dni-connect.example.com
```

---

### 1.5 Security Headers con Helmet

**En `backend/src/server.ts`**:

```typescript
import helmet from 'helmet';

app.use(helmet());
app.use(helmet.hsts({
  maxAge: 31536000, // 1 año
  includeSubDomains: true,
  preload: true,
}));
app.use(helmet.contentSecurityPolicy({
  directives: {
    defaultSrc: ["'self'"],
    scriptSrc: ["'self'", "https://trusted-cdn.example.com"],
    styleSrc: ["'self'", "'unsafe-inline'"],
    imgSrc: ["'self'", "data:", "https:"],
    connectSrc: ["'self'", "https://api.dni-connect.example.com"],
    frameSrc: ["'none'"],
    objectSrc: ["'none'"],
    upgradeInsecureRequests: [],
  },
}));
app.use(helmet.noSniff());
app.use(helmet.xssFilter());
app.use(helmet.referrerPolicy({ policy: 'no-referrer' }));
app.use(helmet.frameguard({ action: 'deny' }));
```

**Dependencias**: `npm install helmet`

---

## FASE 2: Encriptación

### 2.1 Encriptación de Fotos en Google Cloud Storage

**Archivo**: `backend/src/services/encryption.ts`

```typescript
import crypto from 'crypto';
import { SecretManagerServiceClient } from '@google-cloud/secret-manager';
import { Storage } from '@google-cloud/storage';

const secretManager = new SecretManagerServiceClient();
const storage = new Storage();

async function getEncryptionKey(): Promise<Buffer> {
  const [version] = await secretManager.accessSecretVersion({
    name: `projects/${process.env.GCP_PROJECT_ID}/secrets/photo-encryption-key/versions/latest`,
  });
  
  return Buffer.from(version.payload?.data || '');
}

export async function encryptPhotoBuffer(photoBuffer: Buffer): Promise<Buffer> {
  const encryptionKey = await getEncryptionKey();
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-cbc', encryptionKey, iv);
  
  let encrypted = cipher.update(photoBuffer);
  encrypted = Buffer.concat([encrypted, cipher.final()]);
  
  // Retornar: IV (16 bytes) + Encrypted data
  return Buffer.concat([iv, encrypted]);
}

export async function decryptPhotoBuffer(encryptedBuffer: Buffer): Promise<Buffer> {
  const encryptionKey = await getEncryptionKey();
  
  // Primeros 16 bytes son el IV
  const iv = encryptedBuffer.slice(0, 16);
  const encrypted = encryptedBuffer.slice(16);
  
  const decipher = crypto.createDecipheriv('aes-256-cbc', encryptionKey, iv);
  
  let decrypted = decipher.update(encrypted);
  decrypted = Buffer.concat([decrypted, decipher.final()]);
  
  return decrypted;
}

export async function uploadEncryptedPhoto(userId: string, photoBuffer: Buffer): Promise<string> {
  const bucket = storage.bucket(process.env.GCS_BUCKET!);
  const file = bucket.file(`photos/encrypted/${userId}/${Date.now()}.bin`);
  
  const encryptedPhoto = await encryptPhotoBuffer(photoBuffer);
  
  await file.save(encryptedPhoto, {
    metadata: {
      metadata: {
        encrypted: 'true',
        algorithm: 'aes-256-cbc',
        uploadDate: new Date().toISOString(),
      },
    },
  });
  
  return file.name;
}
```

**En endpoint de upload**:

```typescript
app.post('/api/v1/users/:userId/photo', authMiddleware, async (req, res) => {
  const { userId } = req.params;
  const photoBuffer = req.file?.buffer;
  
  if (!photoBuffer) {
    return res.status(400).json({ error: 'Photo required' });
  }
  
  const photoPath = await uploadEncryptedPhoto(userId, photoBuffer);
  
  await db.collection('users').doc(userId).update({
    photoPath,
    photoEncrypted: true,
    photoUploadDate: Timestamp.now(),
  });
  
  res.json({ success: true, photoPath });
});
```

---

### 2.2 Field-Level Encryption en Firestore

**Archivo**: `backend/src/services/fieldEncryption.ts`

```typescript
import crypto from 'crypto';
import { SecretManagerServiceClient } from '@google-cloud/secret-manager';

const secretManager = new SecretManagerServiceClient();

async function getSensitiveDataKey(): Promise<Buffer> {
  const [version] = await secretManager.accessSecretVersion({
    name: `projects/${process.env.GCP_PROJECT_ID}/secrets/firestore-encryption-key/versions/latest`,
  });
  
  return Buffer.from(version.payload?.data || '');
}

function createHash(data: string): string {
  return crypto
    .createHash('sha256')
    .update(data)
    .digest('hex');
}

export async function encryptField(data: string): Promise<string> {
  const key = await getSensitiveDataKey();
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-cbc', key, iv);
  
  let encrypted = cipher.update(data, 'utf-8', 'hex');
  encrypted += cipher.final('hex');
  
  // Formato: iv:encrypted
  return `${iv.toString('hex')}:${encrypted}`;
}

export async function decryptField(encrypted: string): Promise<string> {
  const key = await getSensitiveDataKey();
  const [ivHex, encryptedData] = encrypted.split(':');
  const iv = Buffer.from(ivHex, 'hex');
  
  const decipher = crypto.createDecipheriv('aes-256-cbc', key, iv);
  
  let decrypted = decipher.update(encryptedData, 'hex', 'utf-8');
  decrypted += decipher.final('utf-8');
  
  return decrypted;
}

// Guardar usuario con campos encriptados
export async function createUserWithEncryption(userData: {
  email: string;
  documentNumber: string;
  fullName: string;
  birthDate: Date;
}): Promise<string> {
  const db = admin.firestore();
  
  const docRef = await db.collection('users').add({
    email: userData.email,
    documentNumber: await encryptField(userData.documentNumber),
    fullName: await encryptField(userData.fullName),
    birthDate: userData.birthDate,
    createdAt: Timestamp.now(),
    encryptedFields: ['documentNumber', 'fullName'],
  });
  
  return docRef.id;
}
```

---

### 2.3 Certificate Pinning para policia.es

**Archivo**: `backend/src/config/https.ts`

```typescript
import axios from 'axios';
import * as https from 'https';
import * as fs from 'fs';

const certPath = process.env.POLICE_PKI_CERT_PATH;

if (!certPath) {
  throw new Error('POLICE_PKI_CERT_PATH not configured');
}

const caCert = fs.readFileSync(certPath, 'utf-8');

export const policePkiClient = axios.create({
  baseURL: 'https://pki.policia.es',
  httpsAgent: new https.Agent({
    ca: caCert,
    rejectUnauthorized: true,
  }),
  timeout: 10000,
});

policePkiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.code === 'CERT_HAS_EXPIRED') {
      logger.error('Police PKI certificate expired');
    }
    throw error;
  }
);
```

---

### 2.4 OCSP Validation

**Archivo**: `backend/src/services/ocspValidator.ts`

```typescript
import { OcspClient } from '@dni-connect/core';

const ocspClient = new OcspClient('http://ocsp.policia.es');

export async function validateCertificateRevocation(
  certificateRef: string,
  options = { cacheResults: true, cacheTTL: 3600 }
): Promise<'good' | 'revoked' | 'unknown'> {
  try {
    const status = await ocspClient.checkStatus(certificateRef, options);
    
    if (status === 'revoked') {
      logger.warn(`Certificate revoked: ${certificateRef}`);
      throw new Error('Certificate has been revoked');
    }
    
    return status;
  } catch (err) {
    logger.error(`OCSP check failed for ${certificateRef}`, err);
    // En caso de error, ser conservador
    throw err;
  }
}

// Usar en verificación QR
export async function verifyQRWithRevocationCheck(qrData: string) {
  const parsed = VdsParser.parse(Buffer.from(qrData, 'base64'));
  
  // Validar que no esté revocado
  await validateCertificateRevocation(
    parsed.header.certificateReference
  );
  
  // Continuar con verificación de firma
  return IcaoVerifier.verify(parsed);
}
```

---

## FASE 3: Compliance (GDPR/CCPA)

### 3.1 Logging de Auditoría

**Archivo**: `backend/src/middleware/auditLog.ts`

```typescript
import winston from 'winston';
import { Request, Response, NextFunction } from 'express';

const auditLogger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'audit.log' }),
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
  ],
});

export interface AuditLogEntry {
  timestamp: string;
  userId: string | null;
  action: 'CREATE' | 'READ' | 'UPDATE' | 'DELETE' | 'VERIFY' | 'AUTH';
  resource: string;
  resourceId: string;
  status: 'SUCCESS' | 'FAILURE';
  statusCode: number;
  ip: string;
  userAgent: string;
  duration: number;
  errorMessage?: string;
  changes?: Record<string, any>;
}

export function auditMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const startTime = Date.now();
  const originalSend = res.send;
  
  res.send = function (data: any) {
    const duration = Date.now() - startTime;
    
    const auditEntry: AuditLogEntry = {
      timestamp: new Date().toISOString(),
      userId: req.user?.userId || null,
      action: mapMethodToAction(req.method),
      resource: req.path,
      resourceId: req.params.id || 'N/A',
      status: res.statusCode < 400 ? 'SUCCESS' : 'FAILURE',
      statusCode: res.statusCode,
      ip: req.ip || 'unknown',
      userAgent: req.get('user-agent') || 'unknown',
      duration,
    };
    
    // No loguear datos sensibles
    if (res.statusCode >= 400) {
      auditEntry.errorMessage = data?.error || 'Unknown error';
    }
    
    auditLogger.info(auditEntry);
    
    return originalSend.call(this, data);
  };
  
  next();
}

function mapMethodToAction(method: string): AuditLogEntry['action'] {
  switch (method) {
    case 'POST':
      return 'CREATE';
    case 'GET':
      return 'READ';
    case 'PUT':
      return 'UPDATE';
    case 'DELETE':
      return 'DELETE';
    default:
      return 'READ';
  }
}

export async function saveAuditLogToFirestore(entry: AuditLogEntry) {
  const db = admin.firestore();
  
  await db.collection('audit_logs').add({
    ...entry,
    timestamp: Timestamp.fromDate(new Date(entry.timestamp)),
  });
}
```

**En `server.ts`**:

```typescript
import { auditMiddleware } from './middleware/auditLog';

app.use(auditMiddleware);
```

---

### 3.2 Data Retention & Cleanup

**Archivo**: `backend/src/jobs/dataRetention.ts`

```typescript
import * as admin from 'firebase-admin';
import { schedule } from 'node-cron';

const RETENTION_DAYS = {
  photos: 30,
  auditLogs: 90,
  tempData: 7,
};

export async function cleanupExpiredData() {
  const db = admin.firestore();
  const bucket = admin.storage().bucket();
  
  const cutoffDate = new Date(Date.now() - RETENTION_DAYS.photos * 24 * 60 * 60 * 1000);
  
  // Limpiar fotos antiguas
  const oldPhotos = await db.collection('photos')
    .where('createdAt', '<', admin.firestore.Timestamp.fromDate(cutoffDate))
    .get();
  
  for (const doc of oldPhotos.docs) {
    const photoPath = doc.data().gcsPath;
    
    // Eliminar de GCS
    await bucket.file(photoPath).delete();
    
    // Eliminar registro en Firestore
    await doc.ref.delete();
    
    logger.info(`Deleted expired photo: ${photoPath}`);
  }
  
  // Anonimizar logs antiguos
  const logCutoff = new Date(Date.now() - RETENTION_DAYS.auditLogs * 24 * 60 * 60 * 1000);
  
  const oldLogs = await db.collection('audit_logs')
    .where('timestamp', '<', admin.firestore.Timestamp.fromDate(logCutoff))
    .get();
  
  const batch = db.batch();
  
  for (const doc of oldLogs.docs) {
    batch.update(doc.ref, {
      userId: 'REDACTED',
      ip: 'REDACTED',
      userAgent: 'REDACTED',
    });
  }
  
  await batch.commit();
  
  logger.info(`Anonymized ${oldLogs.size} old logs`);
}

// Ejecutar diariamente a las 2 AM
export function scheduleDataRetention() {
  schedule('0 2 * * *', async () => {
    try {
      await cleanupExpiredData();
    } catch (err) {
      logger.error('Data retention job failed', err);
    }
  });
}
```

---

### 3.3 Consentimiento GDPR

**En frontend (Flutter)**:

```dart
class ConsentScreen extends StatefulWidget {
  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _dataProcessingConsent = false;
  bool _biometricConsent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consentimiento de Datos')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Necesitamos tu consentimiento para:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          CheckboxListTile(
            title: Text('Procesar datos personales'),
            subtitle: Text('Tu DNI, nombre y fecha de nacimiento'),
            value: _dataProcessingConsent,
            onChanged: (value) => setState(() => _dataProcessingConsent = value ?? false),
          ),
          CheckboxListTile(
            title: Text('Almacenar biometría'),
            subtitle: Text('Tu foto facial para verificación'),
            value: _biometricConsent,
            onChanged: (value) => setState(() => _biometricConsent = value ?? false),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: (_dataProcessingConsent && _biometricConsent)
                ? () => _submitConsent()
                : null,
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitConsent() async {
    await _apiService.post('/api/v1/consent', {
      'dataProcessing': _dataProcessingConsent,
      'biometric': _biometricConsent,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
```

---

## FASE 4: Testing & Monitoring

### 4.1 Tests de Seguridad

**Archivo**: `backend/src/tests/security.test.ts`

```typescript
import { describe, it, expect } from 'vitest';
import request from 'supertest';
import app from '../server';

describe('Security Tests', () => {
  it('should reject unvalidated input', async () => {
    const res = await request(app)
      .post('/api/v1/verify/qr')
      .send({ qrData: 'invalid' });
    
    expect(res.status).toBe(400);
    expect(res.body).toHaveProperty('error');
  });

  it('should enforce rate limiting', async () => {
    const makeRequest = () =>
      request(app).post('/api/v1/auth/token').send({
        email: 'test@example.com',
        password: 'password123',
      });

    // Hacer 6 requests
    for (let i = 0; i < 6; i++) {
      await makeRequest();
    }

    // El 6to debe ser rechazado
    const res = await makeRequest();
    expect(res.status).toBe(429); // Too Many Requests
  });

  it('should have security headers', async () => {
    const res = await request(app).get('/health');
    
    expect(res.headers['x-frame-options']).toBe('DENY');
    expect(res.headers['x-content-type-options']).toBe('nosniff');
    expect(res.headers['strict-transport-security']).toBeDefined();
  });

  it('should reject CORS from unknown origin', async () => {
    const res = await request(app)
      .get('/api/v1/users/me')
      .set('Origin', 'https://malicious.com');
    
    expect(res.headers['access-control-allow-origin']).toBeUndefined();
  });

  it('should handle JWT expiration', async () => {
    const expiredToken = generateTestToken({ expiresIn: '-1h' });
    
    const res = await request(app)
      .get('/api/v1/users/me')
      .set('Authorization', `Bearer ${expiredToken}`);
    
    expect(res.status).toBe(401);
  });
});
```

---

### 4.2 Vulnerability Scanning

**Instalar herramientas**:

```bash
# Scan de dependencias
npm install -g npm-check-updates
npm-check-updates -u # Actualizar dependencias

# Scan de vulnerabilidades
npm audit
npm audit fix

# SAST (Static Application Security Testing)
npm install -g snyk
snyk test

# Secret scanning
npm install -g detect-secrets
detect-secrets scan backend/
```

---

### 4.3 Monitoring y Alertas

**Archivo**: `backend/src/services/monitoring.ts`

```typescript
import * as admin from 'firebase-admin';
import { logger } from '../config/logger';

export async function monitorSecurityAlerts() {
  const db = admin.firestore();
  
  // Detectar múltiples intentos fallidos
  const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);
  
  const failedAuths = await db.collection('audit_logs')
    .where('action', '==', 'AUTH')
    .where('status', '==', 'FAILURE')
    .where('timestamp', '>', admin.firestore.Timestamp.fromDate(oneHourAgo))
    .get();
  
  if (failedAuths.size > 10) {
    await sendSecurityAlert({
      severity: 'HIGH',
      title: 'Multiple Authentication Failures',
      message: `${failedAuths.size} failed authentication attempts in the last hour`,
      timestamp: new Date(),
    });
  }
  
  // Detectar acceso a datos sensibles
  const sensitiveAccess = await db.collection('audit_logs')
    .where('resource', 'in', [
      '/api/v1/users/:userId/photo',
      '/api/v1/admin/users',
    ])
    .where('timestamp', '>', admin.firestore.Timestamp.fromDate(oneHourAgo))
    .get();
  
  logger.info(`Sensitive data access: ${sensitiveAccess.size} requests`);
}

// Ejecutar cada 5 minutos
schedule.scheduleJob('*/5 * * * *', monitorSecurityAlerts);
```

---

## ✅ Checklist de Implementación

### Fase 1: Seguridad Crítica
- [ ] Rate limiting configurado
- [ ] Validación de inputs con Zod
- [ ] JWT tokens implementados
- [ ] CORS restrictivo configurado
- [ ] Security headers con Helmet
- [ ] Tests de seguridad pasados
- [ ] Secrets en variables de entorno

### Fase 2: Encriptación
- [ ] Fotos encriptadas en GCS
- [ ] Field-level encryption en Firestore
- [ ] Certificate pinning para policia.es
- [ ] OCSP validation implementado
- [ ] Claves de encriptación guardadas en Secret Manager

### Fase 3: Compliance
- [ ] Logging de auditoría activado
- [ ] Data retention policies implementadas
- [ ] Consentimiento GDPR/CCPA
- [ ] Derechos GDPR (exportación, eliminación)
- [ ] Documentación de privacidad actualizada

### Fase 4: Testing
- [ ] Tests de seguridad completados
- [ ] Vulnerability scanning pasado
- [ ] Secret scanning sin resultados
- [ ] Monitoring y alertas configurados

---

## 📞 Soporte

Si necesitas ayuda implementando alguno de estos cambios, ejecuta:

```bash
./run-skill.sh security-audit --action audit
./run-skill.sh security-audit --action owasp
./run-skill.sh security-audit --action dependencies
./run-skill.sh security-audit --action secrets
```

Estos comandos te darán recomendaciones específicas basadas en tu código actual.
