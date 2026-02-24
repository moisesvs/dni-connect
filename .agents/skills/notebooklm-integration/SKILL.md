# Skill: Google NotebookLM Integration

## Descripción

Integración completa con Google NotebookLM para DNI-Connect. Permite interactuar con notebooks, cargar documentos, realizar consultas, generar podcasts y guías de estudio.

## Estado

✅ Instalado y configurado

## Capacidades

### Gestión de Notebooks
- ✅ Listar notebooks
- ✅ Obtener información de notebook
- ✅ Crear nuevos notebooks
- ✅ Actualizar notebooks
- ✅ Eliminar notebooks

### Documentos
- ✅ Cargar documentos
- ✅ Listar documentos
- ✅ Descargar documentos
- ✅ Analizar documentos

### Consultas y Análisis
- ✅ Realizar preguntas al notebook
- ✅ Generar podcasts
- ✅ Generar guías de estudio
- ✅ Generar esquemas/outlines

### Exportación
- ✅ Exportar a PDF
- ✅ Exportar a Markdown
- ✅ Exportar a JSON
- ✅ Obtener fuentes

---

## Inputs

### Parámetros Globales

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `action` | string | ✅ | notebooks, documents, queries, sources, export |
| `operation` | string | ✅ | list, get, ask, generatePodcast, etc |
| `notebookId` | string | ✅* | ID del notebook (*en la mayoría de operaciones) |
| `query` | string | ✅* | Pregunta para NotebookLM (*en queries) |
| `documentPath` | string | ✅* | Ruta del documento (*para upload) |

### Ejemplos de Parámetros

**Realizar pregunta:**
```json
{
  "action": "queries",
  "operation": "ask",
  "notebookId": "8f79890a-531b-4b8f-8f09-d98fe6b60bbc",
  "query": "¿Cuáles son los puntos principales del documento?"
}
```

**Generar podcast:**
```json
{
  "action": "queries",
  "operation": "generatePodcast",
  "notebookId": "8f79890a-531b-4b8f-8f09-d98fe6b60bbc"
}
```

**Cargar documento:**
```json
{
  "action": "documents",
  "operation": "upload",
  "notebookId": "8f79890a-531b-4b8f-8f09-d98fe6b60bbc",
  "documentPath": "/path/to/document.pdf"
}
```

---

## Outputs

### Respuesta Exitosa

```json
{
  "success": true,
  "data": {
    "id": "notebook-id",
    "title": "Mi Notebook",
    "created_at": "2026-02-23T10:30:00Z",
    "documents": 5,
    "sources": 12
  },
  "duration_ms": 245
}
```

### Respuesta de Error

```json
{
  "success": false,
  "error": "Unauthorized",
  "message": "API key inválida",
  "code": "AUTH_ERROR"
}
```

---

## Ejemplos de Uso

### Desde Terminal

```bash
# Listar notebooks
./run-skill.sh notebooklm-integration \
  --action notebooks \
  --operation list

# Realizar pregunta
./run-skill.sh notebooklm-integration \
  --action queries \
  --operation ask \
  --notebookId 8f79890a-531b-4b8f-8f09-d98fe6b60bbc \
  --query "¿Cuál es el tema principal?"

# Generar podcast
./run-skill.sh notebooklm-integration \
  --action queries \
  --operation generatePodcast \
  --notebookId 8f79890a-531b-4b8f-8f09-d98fe6b60bbc

# Exportar a Markdown
./run-skill.sh notebooklm-integration \
  --action export \
  --operation markdown \
  --notebookId 8f79890a-531b-4b8f-8f09-d98fe6b60bbc
```

### Desde TypeScript

```typescript
import { NotebookLMClient } from './.mcp/notebooklm-client';

const client = new NotebookLMClient({
  apiKey: process.env.NOTEBOOKLM_API_KEY!,
  notebookId: '8f79890a-531b-4b8f-8f09-d98fe6b60bbc'
});

// Realizar pregunta
const answer = await client.askQuestion(
  '8f79890a-531b-4b8f-8f09-d98fe6b60bbc',
  '¿Cuál es el resumen del documento?'
);

// Generar guía de estudio
const guide = await client.generateStudyGuide(
  '8f79890a-531b-4b8f-8f09-d98fe6b60bbc',
  'markdown'
);
```

---

## Configuración Requerida

### 1. Obtener API Key

1. Ve a [https://notebooklm.google.com](https://notebooklm.google.com)
2. Inicia sesión con tu cuenta Google
3. Ve a Settings/Configuración
4. Genera una API Key
5. Copia la clave

### 2. Configurar Variables de Entorno

```bash
cp .env.notebooklm.example .env.notebooklm
```

Edita el archivo y agrega:
```env
NOTEBOOKLM_API_KEY=tu_api_key_aqui
NOTEBOOKLM_NOTEBOOK_ID=8f79890a-531b-4b8f-8f09-d98fe6b60bbc
```

### 3. Tu Notebook

Tu notebook está configurado con ID: `8f79890a-531b-4b8f-8f09-d98fe6b60bbc`

Acceso: https://notebooklm.google.com/notebook/8f79890a-531b-4b8f-8f09-d98fe6b60bbc

---

## Casos de Uso en DNI-Connect

### 1. Análisis de Documentación

```typescript
// Preguntar sobre la documentación del proyecto
const answer = await client.askQuestion(
  notebookId,
  '¿Cuáles son los pasos para verificar un DNI?'
);
```

### 2. Generar Podcasts Educativos

```typescript
// Crear podcast sobre el proceso de verificación
const podcast = await client.generatePodcast(notebookId, {
  style: 'educational',
  duration: 'medium'
});
```

### 3. Generar Guías de Estudio

```typescript
// Generar guía sobre seguridad criptográfica
const guide = await client.generateStudyGuide(notebookId);
```

### 4. Extraer Información

```typescript
// Obtener todas las fuentes citadas
const sources = await client.getSources(notebookId);
```

---

## Errores Comunes

### ❌ "API key inválida"

**Causa:** NOTEBOOKLM_API_KEY no está configurada correctamente

**Solución:**
```bash
# Verificar que la variable está configurada
echo $NOTEBOOKLM_API_KEY

# Regenerar la API key en NotebookLM Settings
```

### ❌ "Notebook not found"

**Causa:** El ID del notebook no es válido

**Solución:** Verificar que el notebook ID sea correcto:
```
https://notebooklm.google.com/notebook/[AQUI_VA_EL_ID]
```

### ❌ "Rate limit exceeded"

**Causa:** Demasiadas solicitudes en poco tiempo

**Solución:** Esperar y reintentar, o usar el parámetro `retries`

---

## Integración con DNI-Connect

### Backend Routes

Se pueden agregar nuevas rutas en `backend/src/routes/notebooklm.ts`:

```typescript
app.post('/api/notebooklm/ask', async (req, res) => {
  const { question, notebookId } = req.body;
  const answer = await client.askQuestion(notebookId, question);
  res.json(answer);
});

app.post('/api/notebooklm/generate-podcast', async (req, res) => {
  const { notebookId } = req.body;
  const podcast = await client.generatePodcast(notebookId);
  res.json(podcast);
});
```

### Flutter Integration

```dart
import 'package:http/http.dart' as http;

Future<String> askNotebookLM(String question) async {
  final response = await http.post(
    Uri.parse('http://localhost:3001/api/notebooklm/ask'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'question': question}),
  );
  return response.body;
}
```

---

## Documentación

- [Documentación Completa](./.mcp/NOTEBOOKLM_MCP.md)
- [Configuración inicial](./.env.notebooklm.example)
- [Notebook enlazado](https://notebooklm.google.com/notebook/8f79890a-531b-4b8f-8f09-d98fe6b60bbc)

---

**Instalado:** 23 de febrero, 2026  
**Versión:** 1.0.0  
**Estado:** ✅ Listo para producción
