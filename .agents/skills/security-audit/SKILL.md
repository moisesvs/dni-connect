# Skill: security-audit

Auditoría completa de seguridad para aplicaciones Flutter + Node.js, incluyendo validación de OWASP Top 10, dependencias vulnerables, configuración de seguridad y cumplimiento de estándares.

## Descripción

Este skill automatiza auditorías de seguridad exhaustivas incluyendo:

1. **OWASP Top 10 Validation**: Verificar contra las 10 vulnerabilidades más críticas
2. **Dependency Scanning**: Detectar dependencias con vulnerabilidades conocidas
3. **Secret Detection**: Encontrar API keys, tokens y credenciales expuestas
4. **Input Validation**: Auditar validación de inputs en formularios y APIs
5. **Authentication Audit**: Verificar configuración de autenticación (JWT, OAuth)
6. **Authorization Audit**: Validar roles y permisos
7. **Encryption Check**: Verificar cifrado en tránsito (HTTPS/TLS) y en reposo
8. **CORS/CSRF Protection**: Validar headers de seguridad
9. **Rate Limiting**: Verificar protección contra fuerza bruta
10. **Security Headers**: Auditar headers de seguridad HTTP
11. **Data Protection**: Validar cumplimiento RGPD/CCPA
12. **Dependency Updates**: Sugerir actualizaciones de seguridad

## Inputs

```json
{
  "action": "audit|owasp|dependencies|secrets|headers|encryption|compliance",
  "scope": "frontend|backend|all",
  "targetPath": ".",
  "severity": "critical|high|medium|low|all",
  "fix": false,
  "generateReport": true
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `action` | string | ✅ | Acción: `audit`, `owasp`, `dependencies`, `secrets`, `headers`, `encryption`, `compliance` |
| `scope` | string | ❌ | `frontend`, `backend`, o `all` (default: all) |
| `targetPath` | string | ❌ | Ruta base de análisis (default: .) |
| `severity` | string | ❌ | Severidad mínima: `critical`, `high`, `medium`, `low`, `all` |
| `fix` | boolean | ❌ | Intentar auto-fix de problemas (default: false) |
| `generateReport` | boolean | ❌ | Generar reporte HTML (default: true) |

## Outputs

```json
{
  "success": true,
  "action": "audit",
  "summary": {
    "totalIssues": 12,
    "critical": 2,
    "high": 5,
    "medium": 4,
    "low": 1,
    "overallScore": 74
  },
  "findings": [
    {
      "id": "OWASP-A01-INJECTION",
      "category": "Injection",
      "severity": "critical",
      "file": "apps/web/backend/src/routes/verification.ts",
      "line": 45,
      "issue": "Posible SQL injection en query",
      "recommendation": "Usar parameterized queries",
      "cve": ["CVE-2024-xxxx"],
      "fixable": true
    }
  ],
  "owasp": {
    "A01-Injection": { "status": "failing", "issues": 2 },
    "A02-Broken-Auth": { "status": "passing", "issues": 0 },
    "A03-Broken-Access": { "status": "failing", "issues": 1 },
    "A04-Insecure-Design": { "status": "warning", "issues": 3 },
    "A05-Security-Config": { "status": "failing", "issues": 2 },
    "A06-Sensitive-Data": { "status": "passing", "issues": 0 },
    "A07-Identification": { "status": "passing", "issues": 0 },
    "A08-Software-Integrity": { "status": "warning", "issues": 4 },
    "A09-Logging": { "status": "failing", "issues": 2 },
    "A10-SSRF": { "status": "passing", "issues": 0 }
  },
  "dependencies": {
    "vulnerablePackages": 3,
    "packages": [
      {
        "name": "lodash",
        "currentVersion": "4.17.20",
        "vulnerableVersions": ["<4.17.21"],
        "latestVersion": "4.17.21",
        "severity": "high",
        "cve": ["CVE-2021-23337"]
      }
    ]
  },
  "secrets": {
    "exposed": 1,
    "locations": [
      {
        "file": ".env.example",
        "pattern": "JWT_SECRET",
        "severity": "critical",
        "fix": "Mover a .env (ignore en git)"
      }
    ]
  },
  "encryption": {
    "tls": { "status": "ok", "version": "1.2+" },
    "api": { "status": "ok", "protocol": "HTTPS" },
    "database": { "status": "warning", "message": "Sin encriptación de datos en reposo" }
  },
  "dataProtection": {
    "gdpr": "partial",
    "dataRetention": "warning",
    "pii": { "identified": 3, "protected": 2 }
  },
  "reportFiles": [
    "security-report-2026-02-23.html",
    "security-report-2026-02-23.json"
  ],
  "recommendations": [
    "Actualizar lodash a >=4.17.21",
    "Implementar rate limiting en /api/v1/verify",
    "Agregar logging de eventos de seguridad",
    "Habilitar HTTPS en todos los endpoints"
  ],
  "duration": 8500,
  "timestamp": "2026-02-23T10:30:00Z"
}
```

## Ejemplos

### Auditoría completa

```bash
./run-skill.sh security-audit --action audit --scope all --generateReport true
```

### Validación OWASP Top 10

```bash
./run-skill.sh security-audit --action owasp --severity critical,high
```

### Scan de dependencias vulnerables

```bash
./run-skill.sh security-audit --action dependencies --fix false
```

### Detectar secretos expuestos

```bash
./run-skill.sh security-audit --action secrets --scope all
```

### Auditar headers de seguridad

```bash
./run-skill.sh security-audit --action headers --scope backend
```

### Verificar encriptación

```bash
./run-skill.sh security-audit --action encryption
```

### Auditoría de cumplimiento GDPR/CCPA

```bash
./run-skill.sh security-audit --action compliance
```

## Validaciones

- ✅ OWASP Top 10 (2023)
- ✅ Dependencias vulnerables (CVE database)
- ✅ Secretos expuestos (regex patterns)
- ✅ Validación de inputs (SQL injection, XSS)
- ✅ Autenticación (JWT expiración, refresh tokens)
- ✅ Autorización (role-based access)
- ✅ HTTPS/TLS configuration
- ✅ Security headers (CSP, X-Frame-Options, etc.)
- ✅ Rate limiting configuration
- ✅ Logging y auditoría
- ✅ Protección de datos (GDPR/CCPA)
- ✅ Encriptación en tránsito y en reposo

## Errores Comunes Detectados

| Problema | Severidad | Solución |
|----------|-----------|----------|
| API keys en code | 🔴 Critical | Usar variables de entorno (.env) |
| JWT sin expiración | 🔴 Critical | Configurar exp claim con TTL corto |
| Sin rate limiting | 🟠 High | Implementar rate limiting en endpoints sensibles |
| HTTPS deshabilitado | 🔴 Critical | Forzar HTTPS en todo tráfico |
| Inputs no validados | 🟠 High | Implementar Zod/Joi para validación |
| CORS abierto (*) | 🟠 High | Restringir a dominios permitidos |
| Sin logging de seguridad | 🟡 Medium | Implementar audit logging |
| Dependencias outdated | 🟡 Medium | Actualizar regularmente |

## Recomendaciones Especiales para DNI-Connect

### Frontend (Flutter Web)

- ✅ Implementar Content Security Policy (CSP)
- ✅ Deshabilitar console en producción
- ✅ Validar respuestas de API antes de usarlas
- ✅ No almacenar datos sensibles en localStorage
- ✅ Implementar verificación de integridad de assets
- ✅ Proteger contra clickjacking (X-Frame-Options)

### Backend (Node.js)

- ✅ Validar todos los inputs con Zod
- ✅ Implementar rate limiting con redis
- ✅ Usar helmet para security headers
- ✅ Loguear eventos de seguridad (fallos auth, etc.)
- ✅ Implementar CORS restrictivo
- ✅ Validar JWT tokens antes de procesar
- ✅ Usar prepared statements para queries

### Datos Sensibles

- ✅ Encriptar fotos faciales en GCS
- ✅ Encriptar datos en Firestore
- ✅ Implementar field-level encryption
- ✅ Anonimizar logs
- ✅ Implementar data retention policies

### Certificados y PKI

- ✅ Validar certificados de policia.es
- ✅ Implementar certificate pinning
- ✅ Verificar cadenas X.509 completamente
- ✅ Validar OCSP regularmente
- ✅ Usar solo certificados con ECC P-256+

## Implementación

**Ubicación**: `packages/security/` + `apps/web/backend/src/security/`

**Módulos involucrados**:
- `OwaspValidator`: Validación OWASP Top 10
- `DependencyScanner`: Scan de vulnerabilidades
- `SecretDetector`: Detección de secretos
- `InputValidator`: Auditoría de validación
- `EncryptionChecker`: Verificación de cifrado
- `SecurityHeadersAuditor`: Auditoría de headers
- `ComplianceChecker`: Verificación GDPR/CCPA
- `ReportGenerator`: Generación de reportes

## Versionado

- **v1.0.0** (2026-02-23): Creación inicial
  - OWASP Top 10 validation
  - Dependency vulnerability scanning
  - Secret detection
  - Security headers audit
  - Encryption verification
  - Compliance checking (GDPR)
