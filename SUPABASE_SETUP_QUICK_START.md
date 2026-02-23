# 🚀 Supabase MCP - Configuración Rápida

## ⚡ En 3 Pasos

### 1️⃣ Obtener Credenciales

```bash
# Ve a https://app.supabase.com
# Crea un proyecto o selecciona uno
# Settings > API > Copia:

SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGc...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...
```

### 2️⃣ Configurar Entorno

```bash
cp .env.supabase.example .env.supabase
# Edita y pega las credenciales
nano .env.supabase
```

### 3️⃣ Crear Tablas

En Supabase Console, copia y ejecuta:

```sql
CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email varchar(255) NOT NULL UNIQUE,
  nombre varchar(255),
  dni varchar(20),
  verified boolean DEFAULT false,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now()
);
```

---

## 📚 Documentación Completa

- [Guía Detallada](./.mcp/SUPABASE_MCP.md)
- [Skill de Automatización](./.agents/skills/supabase-integration/SKILL.md)
- [Resumen de Instalación](./SUPABASE_INSTALLATION_SUMMARY.md)

---

## ✅ Componentes Instalados

- ✅ Cliente TypeScript (@supabase/supabase-js v2.97.0)
- ✅ MCP Configuration (.mcp/)
- ✅ Backend Middleware & Routes
- ✅ Skill de Automatización (.agents/skills/)
- ✅ 8 API Endpoints
- ✅ Ejemplos y Documentación

---

## 🔗 API Endpoints

```
GET  /api/supabase/health              ← Probar conexión
POST /api/supabase/auth/signup         ← Registrarse
POST /api/supabase/auth/signin         ← Iniciar sesión
GET  /api/supabase/data/:table         ← Consultar
POST /api/supabase/data/:table         ← Insertar
```

---

**Instalado:** 23/02/2026 ✅
