/**
 * Google NotebookLM MCP Client
 * Integración con Google NotebookLM para DNI-Connect
 */

interface NotebookLMConfig {
  apiKey: string;
  notebookId?: string;
}

interface NotebookLMSession {
  token: string;
  expiresAt: number;
}

/**
 * Cliente para Google NotebookLM
 */
export class NotebookLMClient {
  private apiKey: string;
  private notebookId: string | null = null;
  private session: NotebookLMSession | null = null;
  private baseUrl = 'https://notebooklm.google.com/api';

  constructor(config: NotebookLMConfig) {
    if (!config.apiKey) {
      throw new Error('NOTEBOOKLM_API_KEY es requerida');
    }
    this.apiKey = config.apiKey;
    this.notebookId = config.notebookId || null;
  }

  /**
   * Obtener información del notebook
   */
  async getNotebook(notebookId: string) {
    try {
      const response = await fetch(`${this.baseUrl}/notebooks/${notebookId}`, {
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
          'Content-Type': 'application/json'
        }
      });

      if (!response.ok) {
        throw new Error(`Error getting notebook: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      throw new Error(`Failed to get notebook: ${error}`);
    }
  }

  /**
   * Listar todos los notebooks del usuario
   */
  async listNotebooks() {
    try {
      const response = await fetch(`${this.baseUrl}/notebooks`, {
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
          'Content-Type': 'application/json'
        }
      });

      if (!response.ok) {
        throw new Error(`Error listing notebooks: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      throw new Error(`Failed to list notebooks: ${error}`);
    }
  }

  /**
   * Crear un nuevo notebook
   */
  async createNotebook(title: string, description?: string) {
    try {
      const response = await fetch(`${this.baseUrl}/notebooks`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${this.apiKey}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          title,
          description: description || ''
        })
      });

      if (!response.ok) {
        throw new Error(`Error creating notebook: ${response.statusText}`);
      }

      const notebook = await response.json();
      this.notebookId = notebook.id;
      return notebook;
    } catch (error) {
      throw new Error(`Failed to create notebook: ${error}`);
    }
  }

  /**
   * Cargar documento al notebook
   */
  async uploadDocument(notebookId: string, filePath: string, fileName: string) {
    try {
      const fs = await import('fs');
      const fileContent = fs.readFileSync(filePath);

      const formData = new FormData();
      formData.append('file', new Blob([fileContent]), fileName);

      const response = await fetch(
        `${this.baseUrl}/notebooks/${notebookId}/documents`,
        {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${this.apiKey}`
          },
          body: formData
        }
      );

      if (!response.ok) {
        throw new Error(`Error uploading document: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      throw new Error(`Failed to upload document: ${error}`);
    }
  }

  /**
   * Realizar consulta al notebook
   */
  async askQuestion(notebookId: string, question: string) {
    try {
      const response = await fetch(
        `${this.baseUrl}/notebooks/${notebookId}/ask`,
        {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${this.apiKey}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ question })
        }
      );

      if (!response.ok) {
        throw new Error(`Error asking question: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      throw new Error(`Failed to ask question: ${error}`);
    }
  }

  /**
   * Generar podcast a partir del contenido
   */
  async generatePodcast(notebookId: string, options?: any) {
    try {
      const response = await fetch(
        `${this.baseUrl}/notebooks/${notebookId}/generate-podcast`,
        {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${this.apiKey}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(options || {})
        }
      );

      if (!response.ok) {
        throw new Error(`Error generating podcast: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      throw new Error(`Failed to generate podcast: ${error}`);
    }
  }

  /**
   * Generar guía de estudio
   */
  async generateStudyGuide(notebookId: string, format?: string) {
    try {
      const response = await fetch(
        `${this.baseUrl}/notebooks/${notebookId}/generate-study-guide`,
        {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${this.apiKey}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ format: format || 'markdown' })
        }
      );

      if (!response.ok) {
        throw new Error(`Error generating study guide: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      throw new Error(`Failed to generate study guide: ${error}`);
    }
  }

  /**
   * Listar documentos del notebook
   */
  async listDocuments(notebookId: string) {
    try {
      const response = await fetch(
        `${this.baseUrl}/notebooks/${notebookId}/documents`,
        {
          headers: {
            'Authorization': `Bearer ${this.apiKey}`,
            'Content-Type': 'application/json'
          }
        }
      );

      if (!response.ok) {
        throw new Error(`Error listing documents: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      throw new Error(`Failed to list documents: ${error}`);
    }
  }

  /**
   * Obtener fuentes del notebook
   */
  async getSources(notebookId: string) {
    try {
      const response = await fetch(
        `${this.baseUrl}/notebooks/${notebookId}/sources`,
        {
          headers: {
            'Authorization': `Bearer ${this.apiKey}`,
            'Content-Type': 'application/json'
          }
        }
      );

      if (!response.ok) {
        throw new Error(`Error getting sources: ${response.statusText}`);
      }

      return await response.json();
    } catch (error) {
      throw new Error(`Failed to get sources: ${error}`);
    }
  }

  /**
   * Exportar notebook a PDF
   */
  async exportToPDF(notebookId: string, outputPath: string) {
    try {
      const response = await fetch(
        `${this.baseUrl}/notebooks/${notebookId}/export/pdf`,
        {
          headers: {
            'Authorization': `Bearer ${this.apiKey}`
          }
        }
      );

      if (!response.ok) {
        throw new Error(`Error exporting PDF: ${response.statusText}`);
      }

      const buffer = await response.arrayBuffer();
      const fs = await import('fs');
      fs.writeFileSync(outputPath, Buffer.from(buffer));
      return { success: true, path: outputPath };
    } catch (error) {
      throw new Error(`Failed to export PDF: ${error}`);
    }
  }

  /**
   * Exportar notebook a Markdown
   */
  async exportToMarkdown(notebookId: string, outputPath: string) {
    try {
      const response = await fetch(
        `${this.baseUrl}/notebooks/${notebookId}/export/markdown`,
        {
          headers: {
            'Authorization': `Bearer ${this.apiKey}`
          }
        }
      );

      if (!response.ok) {
        throw new Error(`Error exporting markdown: ${response.statusText}`);
      }

      const text = await response.text();
      const fs = await import('fs');
      fs.writeFileSync(outputPath, text);
      return { success: true, path: outputPath };
    } catch (error) {
      throw new Error(`Failed to export markdown: ${error}`);
    }
  }
}

/**
 * Crear instancia única del cliente
 */
let client: NotebookLMClient | null = null;

export function initializeNotebookLM(config: NotebookLMConfig): NotebookLMClient {
  client = new NotebookLMClient(config);
  return client;
}

export function getNotebookLMClient(): NotebookLMClient {
  if (!client) {
    throw new Error('NotebookLM not initialized. Call initializeNotebookLM first.');
  }
  return client;
}

export default {
  NotebookLMClient,
  initializeNotebookLM,
  getNotebookLMClient
};
