# MCP Supabase - Instalación y Configuración

## ✅ Instalación Completada

Se ha instalado y configurado el **Model Context Protocol (MCP) para Supabase** en DNI-Connect.

### 📦 Componentes Instalados

1. **Cliente oficial de Supabase** (`@supabase/supabase-js`)
   - Instalado en `package.json`
   - Versión: última estable

2. **Archivos de configuración MCP**
   - `.mcp/supabase-mcp.json` - Definición de capacidades
   - `.mcp/supabase-client.ts` - Cliente TypeScript
   - `.env.supabase.example` - Variables de entorno

---

## 🚀 Configuración Inicial

### 1. Obtener Credenciales de Supabase

1. Ve a [https://app.supabase.com](https://app.supabase.com)
2. Crea un nuevo proyecto o selecciona uno existente
3. Ve a **Settings > API**
4. Copia:
   - `Project URL` → `SUPABASE_URL`
   - `anon public key` → `SUPABASE_ANON_KEY`
   - `service_role secret` → `SUPABASE_SERVICE_ROLE_KEY`

### 2. Configurar Variables de Entorno

```bash
cp .env.supabase.example .env.supabase
```

Edita `.env.supabase` y reemplaza los valores:

```env
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 3. Cargar Configuración en tu Código

**En Backend (Node.js):**

```typescript
import { initializeSupabase } from './.mcp/supabase-client';

const supabase = initializeSupabase({
  url: process.env.SUPABASE_URL!,
  key: process.env.SUPABASE_SERVICE_ROLE_KEY!
});
```

**En Frontend (Flutter/Dart):**

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

await Supabase.initialize(
  url: 'https://xxxxx.supabase.co',
  anonKey: 'YOUR_ANON_KEY',
);
```

---

## 📚 Uso del MCP

### Operaciones de Base de Datos

```typescript
import { DatabaseOps } from './.mcp/supabase-client';

// Consultar
const usuarios = await DatabaseOps.query('usuarios', {
  filters: { active: true },
  limit: 10
});

// Insertar
const nuevo = await DatabaseOps.insert('usuarios', {
  email: 'user@example.com',
  nombre: 'Juan'
});

// Actualizar
await DatabaseOps.update('usuarios', 'id-123', {
  nombre: 'Juan Pérez'
});

// Eliminar
await DatabaseOps.delete('usuarios', 'id-123');
```

### Autenticación

```typescript
import { AuthOps } from './.mcp/supabase-client';

// Registrarse
await AuthOps.signUp('user@example.com', 'password123');

// Iniciar sesión
const session = await AuthOps.signIn('user@example.com', 'password123');

// Obtener usuario actual
const user = await AuthOps.getUser();

// Cerrar sesión
await AuthOps.signOut();

// Resetear contraseña
await AuthOps.resetPassword('user@example.com');
```

### Storage (Archivos)

```typescript
import { StorageOps } from './.mcp/supabase-client';

// Subir archivo
await StorageOps.upload('avatars', 'user-123/avatar.jpg', file);

// Descargar archivo
const file = await StorageOps.download('avatars', 'user-123/avatar.jpg');

// Listar archivos
const files = await StorageOps.list('avatars', 'user-123');

// Eliminar archivo
await StorageOps.delete('avatars', 'user-123/avatar.jpg');
```

### Suscripciones en Tiempo Real

```typescript
import { RealtimeOps } from './.mcp/supabase-client';

// Suscribirse a cambios
const subscription = RealtimeOps.subscribe('usuarios', (payload) => {
  console.log('Cambio detectado:', payload);
});

// Desuscribirse
RealtimeOps.unsubscribe(subscription);
```

---

## 📋 Casos de Uso en DNI-Connect

### 1. Almacenamiento de Datos de Usuarios

```typescript
// Guardar usuario después de autenticación QR
await DatabaseOps.insert('users', {
  email: user.email,
  dni: qrData.dni,
  verified: true,
  created_at: new Date()
});
```

### 2. Sincronización de Biometría

```typescript
// Subir foto biométrica
await StorageOps.upload('biometrics', `${userId}/photo.jpg`, photoBuffer);

// Registrar en DB
await DatabaseOps.insert('biometric_records', {
  user_id: userId,
  type: 'photo',
  storage_path: `biometrics/${userId}/photo.jpg`,
  verified: false
});
```

### 3. Auditoría en Tiempo Real

```typescript
// Suscribirse a cambios en tabla de verificaciones
RealtimeOps.subscribe('verifications', (payload) => {
  if (payload.eventType === 'INSERT') {
    logger.info('Nueva verificación:', payload.new);
  }
});
```

---

## 🔒 Seguridad

### Reglas de Fila (RLS)

En Supabase Console, habilita RLS y crea políticas:

```sql
-- Usuarios solo ven sus propios datos
CREATE POLICY "Users can view own data"
ON users FOR SELECT USING (auth.uid() = id);

-- Solo administradores pueden eliminar
CREATE POLICY "Only admins can delete"
ON users FOR DELETE USING (auth.jwt() ->> 'role' = 'admin');
```

### Variables de Entorno

- ✅ Usa `.env.supabase` para desarrollo local
- ✅ Guarda claves en **GitHub Secrets** para CI/CD
- ✅ Nunca commites archivos `.env` al repositorio
- ✅ Usa `SUPABASE_SERVICE_ROLE_KEY` solo en backend

---

## 📊 Verificación de la Instalación

```bash
# Verificar que el cliente está instalado
npm list @supabase/supabase-js

# Verificar archivos MCP
ls -la .mcp/

# Probar conexión (desde Node.js)
node -e "
const { initializeSupabase } = require('./.mcp/supabase-client.ts');
const client = initializeSupabase({
  url: 'https://xxxxx.supabase.co',
  key: 'YOUR_KEY'
});
console.log('✅ Supabase MCP listo');
"
```

---

## 🆘 Solución de Problemas

### "SUPABASE_URL y SUPABASE_KEY son requeridos"

✅ Solución: Configura `.env.supabase` con las credenciales correctas

```bash
source .env.supabase
```

### "Supabase no está inicializado"

✅ Solución: Llama a `initializeSupabase()` antes de usar operaciones

```typescript
import { initializeSupabase, DatabaseOps } from './.mcp/supabase-client';

initializeSupabase({
  url: process.env.SUPABASE_URL!,
  key: process.env.SUPABASE_KEY!
});

const data = await DatabaseOps.query('users');
```

### Errores de CORS

✅ Solución: En Supabase Console, configura CORS en **Settings > API**

```
Allowed Origins:
- http://localhost:3000
- http://localhost:8080
- https://tudominio.com
```

### Conexión rechazada

✅ Solución: Verifica que:
- El proyecto Supabase está activo
- La URL es correcta (sin trailing slash)
- La clave API es válida

---

## 📖 Referencias

- [Documentación oficial de Supabase](https://supabase.com/docs)
- [JavaScript Client Library](https://supabase.com/docs/reference/javascript/introduction)
- [Flutter Supabase](https://supabase.com/docs/reference/flutter/introduction)
- [RLS Documentation](https://supabase.com/docs/guides/auth/row-level-security)

---

## ✨ Próximos Pasos

1. **Crear tablas en Supabase Console**
   - `users` - Información de usuarios
   - `biometric_records` - Registros de biometría
   - `verifications` - Auditoría de verificaciones

2. **Configurar autenticación OAuth** (opcional)
   - Google
   - GitHub
   - Apple

3. **Habilitar extensiones** (opcional)
   - `vector` - Para búsqueda semántica
   - `pgvector` - Para embeddings
   - `uuid-ossp` - Para IDs únicos

4. **Configurar backups automáticos**
   - En **Settings > Backups**

---

**Instalación completada:** 23 de febrero, 2026  
**Versión:** 1.0.0  
**Estado:** ✅ Listo para usar
