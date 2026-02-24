# Google NotebookLM MCP - Guía Completa

## ✅ Instalación Completada

Se ha instalado y configurado el **Model Context Protocol (MCP) para Google NotebookLM** en DNI-Connect.

### 📦 Componentes Instalados

1. **MCP Server** (`notebooklm-mcp-server` v3.0.7)
   - Servidor MCP oficial para NotebookLM
   - Soporte completo para API

2. **MCP Configuration** (`.mcp/`)
   - `notebooklm-mcp.json` - Definición de capacidades
   - `notebooklm-client.ts` - Cliente TypeScript personalizado

3. **Skill de Automatización** (`.agents/skills/`)
   - Documentación y ejemplos
   - 3 casos de uso incluidos

4. **Variables de Entorno**
   - `.env.notebooklm.example` - Plantilla de configuración

---

## 🔐 Tu Notebook

**ID:** `8f79890a-531b-4b8f-8f09-d98fe6b60bbc`

**Acceso:** https://notebooklm.google.com/notebook/8f79890a-531b-4b8f-8f09-d98fe6b60bbc

---

## 🚀 Configuración Inicial

### 1. Obtener API Key

1. Ve a [https://notebooklm.google.com](https://notebooklm.google.com)
2. Inicia sesión
3. Ve a **Settings** (⚙️)
4. Busca **API Keys** o **Developers**
5. Genera una nueva API Key
6. Copia la clave completa

### 2. Configurar Variables de Entorno

```bash
# Copiar plantilla
cp .env.notebooklm.example .env.notebooklm

# Editar con tus credenciales
nano .env.notebooklm
```

Necesitas:
```env
NOTEBOOKLM_API_KEY=tu_api_key_aqui
NOTEBOOKLM_NOTEBOOK_ID=8f79890a-531b-4b8f-8f09-d98fe6b60bbc
```

### 3. Cargar en Tu Código

**Backend (Node.js):**

```typescript
import { initializeNotebookLM } from './.mcp/notebooklm-client';

const notebooklm = initializeNotebookLM({
  apiKey: process.env.NOTEBOOKLM_API_KEY!,
  notebookId: process.env.NOTEBOOKLM_NOTEBOOK_ID!
});
```

---

## 📚 Uso del MCP

### Operaciones de Notebook

```typescript
import { getNotebookLMClient } from './.mcp/notebooklm-client';

const client = getNotebookLMClient();

// Listar todos los notebooks
const notebooks = await client.listNotebooks();

// Obtener información de un notebook
const notebook = await client.getNotebook('8f79890a-531b-4b8f-8f09-d98fe6b60bbc');

// Crear nuevo notebook
const newNotebook = await client.createNotebook('Mi Notebook', 'Descripción');
```

### Realizar Consultas

```typescript
// Hacer una pregunta al notebook
const answer = await client.askQuestion(
  '8f79890a-531b-4b8f-8f09-d98fe6b60bbc',
  '¿Cuál es el resumen de este documento?'
);

console.log(answer.data.answer);
```

### Generar Contenido

```typescript
// Generar podcast
const podcast = await client.generatePodcast(
  '8f79890a-531b-4b8f-8f09-d98fe6b60bbc',
  { style: 'educational' }
);

// Generar guía de estudio
const guide = await client.generateStudyGuide(
  '8f79890a-531b-4b8f-8f09-d98fe6b60bbc',
  'markdown'
);

console.log(guide.data.content);
```

### Cargar Documentos

```typescript
// Subir documento al notebook
const doc = await client.uploadDocument(
  '8f79890a-531b-4b8f-8f09-d98fe6b60bbc',
  './documento.pdf',
  'documento.pdf'
);

// Listar documentos
const documents = await client.listDocuments('8f79890a-531b-4b8f-8f09-d98fe6b60bbc');
```

### Exportar Contenido

```typescript
// Exportar a PDF
await client.exportToPDF(
  '8f79890a-531b-4b8f-8f09-d98fe6b60bbc',
  './export/notebook.pdf'
);

// Exportar a Markdown
await client.exportToMarkdown(
  '8f79890a-531b-4b8f-8f09-d98fe6b60bbc',
  './export/notebook.md'
);
```

### Obtener Fuentes

```typescript
// Obtener todas las fuentes citadas
const sources = await client.getSources('8f79890a-531b-4b8f-8f09-d98fe6b60bbc');

sources.data.forEach(source => {
  console.log(`${source.title}: ${source.url}`);
});
```

---

## 🔌 API Endpoints (Opcionales)

Puedes crear rutas Express para exponer NotebookLM:

```typescript
// backend/src/routes/notebooklm.ts
import { Router } from 'express';
import { getNotebookLMClient } from '../../.mcp/notebooklm-client';

const router = Router();
const client = getNotebookLMClient();

// Consultar notebook
router.post('/ask', async (req, res) => {
  const { question, notebookId } = req.body;
  const answer = await client.askQuestion(notebookId, question);
  res.json(answer);
});

// Generar podcast
router.post('/podcast', async (req, res) => {
  const { notebookId } = req.body;
  const podcast = await client.generatePodcast(notebookId);
  res.json(podcast);
});

// Generar guía
router.post('/study-guide', async (req, res) => {
  const { notebookId, format } = req.body;
  const guide = await client.generateStudyGuide(notebookId, format);
  res.json(guide);
});

export default router;
```

Agregar a `backend/src/server.ts`:

```typescript
import notebooklmRouter from './routes/notebooklm.js';
app.use('/api/notebooklm', notebooklmRouter);
```

---

## 📊 Casos de Uso en DNI-Connect

### 1. Análisis de Políticas de Seguridad

```typescript
// Preguntar sobre políticas específicas
const answer = await client.askQuestion(
  notebookId,
  '¿Cuáles son los estándares de seguridad para ICAO 9303?'
);
```

### 2. Generar Material Educativo

```typescript
// Crear podcast sobre el proceso de verificación
const podcast = await client.generatePodcast(notebookId, {
  style: 'educational',
  audience: 'developers'
});
```

### 3. Documentación Automática

```typescript
// Generar guía de implementación
const guide = await client.generateStudyGuide(notebookId, 'markdown');
fs.writeFileSync('./docs/implementation-guide.md', guide.data.content);
```

### 4. Análisis de Requisitos

```typescript
// Extraer información de documentos de requisitos
const sources = await client.getSources(notebookId);
console.log('Fuentes citadas:', sources.data);
```

---

## 🛠️ Skill de Automatización

El skill está disponible en `.agents/skills/notebooklm-integration/`

### Uso desde Terminal

```bash
# Hacer pregunta
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

---

## 🔒 Seguridad

### Proteger API Key

- ✅ **Nunca** commites `.env.notebooklm` al repositorio
- ✅ Usa GitHub Secrets para CI/CD
- ✅ Rota la API key periódicamente
- ✅ Usa variables de entorno en servidor

### Acceso al Notebook

- El notebook está vinculado a tu cuenta Google
- La API Key controla el acceso programático
- Las solicitudes se registran en NotebookLM

---

## 📋 Monitoreo

### Ver Logs

```bash
# Logs del cliente
tail -f logs/notebooklm.log
```

### Verificar Conexión

```typescript
// Verificar que el cliente está inicializado
try {
  const notebooks = await client.listNotebooks();
  console.log(`✅ Conectado. ${notebooks.length} notebooks encontrados.`);
} catch (error) {
  console.error('❌ Error de conexión:', error);
}
```

---

## 🆘 Solución de Problemas

### "API key inválida"

```bash
# Verificar que NOTEBOOKLM_API_KEY está configurada
echo $NOTEBOOKLM_API_KEY

# Regenerar clave en NotebookLM Settings
```

### "Notebook not found"

```
ID correcto: 8f79890a-531b-4b8f-8f09-d98fe6b60bbc
URL: https://notebooklm.google.com/notebook/[ID]
```

### "Rate limit exceeded"

Esperar antes de reintentar. El cliente incluye retry automático.

### "Permission denied"

- Verificar que la API Key tiene permisos
- Verificar que el notebook está en tu cuenta
- Re-generar API Key si es necesario

---

## 📖 Referencias

- [Google NotebookLM](https://notebooklm.google.com)
- [Tu Notebook](https://notebooklm.google.com/notebook/8f79890a-531b-4b8f-8f09-d98fe6b60bbc)
- [NotebookLM MCP Server NPM](https://www.npmjs.com/package/notebooklm-mcp-server)
- [Documentación del Skill](./.agents/skills/notebooklm-integration/SKILL.md)

---

## ✨ Funcionalidades Disponibles

- ✅ **Notebooks:** list, get, create, update, delete
- ✅ **Documents:** upload, download, analyze
- ✅ **Queries:** ask, generatePodcast, generateStudyGuide
- ✅ **Sources:** list, analyze
- ✅ **Export:** PDF, Markdown, JSON
- ✅ **Analysis:** AI-powered insights
- ✅ **Automation:** Skill incluido

---

**Instalación:** 23 de febrero, 2026 ✅  
**Versión:** 1.0.0  
**MCP Server:** notebooklm-mcp-server v3.0.7  
**Estado:** ✅ Listo para usar
