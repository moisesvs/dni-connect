# Skill: Supabase Integration

## Descripción

Integración completa con Supabase para DNI-Connect. Permite operaciones de base de datos, autenticación, almacenamiento de archivos y suscripciones en tiempo real.

## Estado

✅ Instalado y configurado

## Capacidades

### Base de Datos
- ✅ Consultar datos
- ✅ Insertar registros
- ✅ Actualizar registros
- ✅ Eliminar registros
- ✅ Filtrado avanzado
- ✅ Paginación

### Autenticación
- ✅ Registro de usuarios
- ✅ Inicio de sesión
- ✅ Cierre de sesión
- ✅ Obtener usuario actual
- ✅ Reset de contraseña

### Storage
- ✅ Subir archivos
- ✅ Descargar archivos
- ✅ Listar archivos
- ✅ Eliminar archivos

### Realtime
- ✅ Suscripciones a cambios
- ✅ Notificaciones en tiempo real

---

## Inputs

### Parámetros Globales

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `action` | string | ✅ | Acción a ejecutar (db, auth, storage, realtime) |
| `operation` | string | ✅ | Operación específica (query, insert, update, delete, signup, signin, etc.) |
| `table` | string | ✅* | Tabla a usar (*en operaciones DB) |
| `data` | object | ✅* | Datos a insertar/actualizar (*en operaciones DB) |
| `filters` | object | ❌ | Filtros para consultas |
| `limit` | number | ❌ | Límite de resultados (default: 10) |

### Ejemplos de Parámetros

**Consultar:**
```json
{
  "action": "db",
  "operation": "query",
  "table": "users",
  "filters": { "verified": true },
  "limit": 20
}
```

**Insertar:**
```json
{
  "action": "db",
  "operation": "insert",
  "table": "users",
  "data": {
    "email": "user@example.com",
    "nombre": "Juan",
    "verified": false
  }
}
```

**Registrarse:**
```json
{
  "action": "auth",
  "operation": "signup",
  "email": "user@example.com",
  "password": "secure123"
}
```

**Subir archivo:**
```json
{
  "action": "storage",
  "operation": "upload",
  "bucket": "avatars",
  "path": "user-123/profile.jpg",
  "filePath": "/local/path/to/file.jpg"
}
```

---

## Outputs

### Respuesta Exitosa

```json
{
  "success": true,
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "email": "user@example.com",
    "created_at": "2026-02-23T10:30:00Z"
  },
  "count": 1,
  "duration_ms": 245
}
```

### Respuesta de Error

```json
{
  "success": false,
  "error": "Database error",
  "message": "Table not found",
  "code": "PGRST116"
}
```

---

## Ejemplos de Uso

### Desde Terminal

```bash
# Consultar usuarios
./run-skill.sh supabase-integration \
  --action db \
  --operation query \
  --table users \
  --limit 20

# Registrar nuevo usuario
./run-skill.sh supabase-integration \
  --action auth \
  --operation signup \
  --email user@example.com \
  --password secure123

# Subir archivo biométrico
./run-skill.sh supabase-integration \
  --action storage \
  --operation upload \
  --bucket biometrics \
  --path user-123/photo.jpg \
  --filePath ./photo.jpg

# Suscribirse a cambios
./run-skill.sh supabase-integration \
  --action realtime \
  --operation subscribe \
  --table users
```

### Desde TypeScript

```typescript
import { execSync } from 'child_process';

// Consultar datos
const result = execSync(`
  ./run-skill.sh supabase-integration \
    --action db \
    --operation query \
    --table users \
    --limit 10
`).toString();

const users = JSON.parse(result);
console.log(`Usuarios encontrados: ${users.count}`);
```

### Desde GitHub Actions

```yaml
- name: Query users from Supabase
  run: |
    ./run-skill.sh supabase-integration \
      --action db \
      --operation query \
      --table users \
      --limit 10 > users.json
    
- name: Process results
  run: cat users.json | jq '.data | length'
```

---

## Implementación

### Rutas API Disponibles

El backend expone los siguientes endpoints:

```
GET  /api/supabase/health              - Verificar conexión
POST /api/supabase/auth/signup         - Registrarse
POST /api/supabase/auth/signin         - Iniciar sesión
POST /api/supabase/auth/signout        - Cerrar sesión
GET  /api/supabase/auth/me             - Usuario actual
POST /api/supabase/auth/reset-password - Reset de contraseña
GET  /api/supabase/data/:table         - Consultar tabla
POST /api/supabase/data/:table         - Insertar registro
PATCH /api/supabase/data/:table/:id    - Actualizar registro
DELETE /api/supabase/data/:table/:id   - Eliminar registro
```

### Cliente TypeScript

Ubicación: `.mcp/supabase-client.ts`

```typescript
import { DatabaseOps, AuthOps, StorageOps } from './.mcp/supabase-client';

// Usar operaciones directamente
const users = await DatabaseOps.query('users');
await AuthOps.signUp('user@example.com', 'password');
await StorageOps.upload('bucket', 'path', file);
```

### Middleware

Ubicación: `backend/src/middleware/supabase.ts`

```typescript
import { supabaseMiddleware, requireSupabaseAuth } from './middleware/supabase';

app.use(supabaseMiddleware);        // Inicializar cliente
app.use('/protected', requireSupabaseAuth);  // Proteger rutas
```

---

## Configuración Requerida

### 1. Credenciales de Supabase

Crear archivo `.env.supabase`:

```env
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 2. Tablas en Supabase

Crear las siguientes tablas en Supabase Console:

```sql
-- Tabla de usuarios
CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email varchar(255) NOT NULL UNIQUE,
  nombre varchar(255),
  dni varchar(20),
  verified boolean DEFAULT false,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now()
);

-- Tabla de registros biométricos
CREATE TABLE biometric_records (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  type varchar(50),
  storage_path varchar(500),
  verified boolean DEFAULT false,
  created_at timestamp DEFAULT now()
);

-- Tabla de verificaciones
CREATE TABLE verifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  method varchar(50),
  status varchar(50),
  created_at timestamp DEFAULT now(),
  verified_at timestamp
);
```

### 3. Buckets de Storage

En Supabase Console, crear los siguientes buckets:

- `avatars` - Fotos de perfil
- `biometrics` - Fotos biométricas
- `documents` - Documentos escaneados

---

## Errores Comunes

### ❌ "SUPABASE_URL y SUPABASE_KEY son requeridos"

**Causa:** Variables de entorno no configuradas

**Solución:**
```bash
source .env.supabase
echo $SUPABASE_URL  # Debe mostrar la URL
```

### ❌ "Table not found"

**Causa:** La tabla no existe en la base de datos

**Solución:** Crear la tabla en Supabase Console o usar el SQL proporcionado arriba

### ❌ "Unauthorized"

**Causa:** Token expirado o credenciales inválidas

**Solución:** Re-autenticar con `/api/supabase/auth/signin`

### ❌ "Bucket not found"

**Causa:** El bucket de storage no existe

**Solución:** Crear el bucket en Supabase Console

---

## Seguridad

### ✅ Row Level Security (RLS)

Habilitar RLS en todas las tablas:

```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Usuarios solo ven sus propios datos
CREATE POLICY "Users can view own data"
ON users FOR SELECT USING (auth.uid() = id);

-- Usuarios solo pueden actualizar sus propios datos
CREATE POLICY "Users can update own data"
ON users FOR UPDATE USING (auth.uid() = id);
```

### ✅ Credenciales

- Usar `SUPABASE_ANON_KEY` en cliente
- Usar `SUPABASE_SERVICE_ROLE_KEY` solo en servidor
- Nunca commitear claves al repositorio
- Rotar claves periódicamente

---

## Monitoreo

### Ver Logs

```bash
# Backend
tail -f logs/supabase.log

# Supabase Console
# https://app.supabase.com/project/[id]/logs/api
```

### Métricas

Accedible en Supabase Console:
- Uso de almacenamiento
- Número de usuarios
- Queries ejecutadas
- Errores de autenticación

---

## Documentación

- [Documentación completa](./.mcp/SUPABASE_MCP.md)
- [Configuración inicial](./.env.supabase.example)
- [API backend](./backend/src/routes/supabase.ts)

---

**Instalado:** 23 de febrero, 2026  
**Versión:** 1.0.0  
**Estado:** ✅ Listo para producción
