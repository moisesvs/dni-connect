# 🚀 NotebookLM MCP - Configuración Rápida

## ⚡ En 3 Pasos

### 1️⃣ Obtener API Key

```
Ve a: https://notebooklm.google.com/settings
Busca: API Keys o Developers
Genera: Nueva API Key
Copia: La clave completa
```

### 2️⃣ Configurar Entorno

```bash
cp .env.notebooklm.example .env.notebooklm
nano .env.notebooklm
```

Agrega:
```env
NOTEBOOKLM_API_KEY=tu_api_key_aqui
NOTEBOOKLM_NOTEBOOK_ID=8f79890a-531b-4b8f-8f09-d98fe6b60bbc
```

### 3️⃣ Usar el Cliente

```typescript
import { getNotebookLMClient } from './.mcp/notebooklm-client';

const client = getNotebookLMClient();
const answer = await client.askQuestion(
  '8f79890a-531b-4b8f-8f09-d98fe6b60bbc',
  'Tu pregunta aquí'
);
```

---

## 📚 Documentación

- [Guía Completa](./.mcp/NOTEBOOKLM_MCP.md)
- [Skill de Automatización](./.agents/skills/notebooklm-integration/SKILL.md)
- [Tu Notebook](https://notebooklm.google.com/notebook/8f79890a-531b-4b8f-8f09-d98fe6b60bbc)

---

## ✅ Componentes Instalados

- ✅ notebooklm-mcp-server v3.0.7
- ✅ Cliente TypeScript personalizado
- ✅ Skill de automatización
- ✅ 5 ejemplos de uso
- ✅ Variables de entorno

---

## 🔗 Acceso

**Tu Notebook:**  
https://notebooklm.google.com/notebook/8f79890a-531b-4b8f-8f09-d98fe6b60bbc

**ID:**  
`8f79890a-531b-4b8f-8f09-d98fe6b60bbc`

---

**Instalado:** 23/02/2026 ✅
