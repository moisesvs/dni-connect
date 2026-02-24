# 📖 Ejecutar el Notebook de Expertise en MiDNI

## ⚡ Inicio Rápido (5 minutos)

```bash
# 1. Navegar al directorio del proyecto
cd /Users/e032284/Proyectos/DNI-Connect/dni-connect

# 2. Activar entorno Python (si no está activo)
python -m venv venv_midni
source venv_midni/bin/activate

# 3. Instalar dependencias
pip install jupyter pandas numpy

# 4. Iniciar Jupyter Notebook
jupyter notebook MiDNI_Expertise_Analysis.ipynb
```

---

## 📚 Estructura del Aprendizaje

```
MiDNI_Expertise_Analysis.ipynb
│
├── 📦 SECCIÓN 1: Importar Librerías
│   └── Objetivo: Preparar entorno
│       Tiempo: ~2 minutos
│       Acción: Ejecutar celda para instalar dependencias
│
├── 📊 SECCIÓN 2: Cargar y Explorar Datos
│   └── Objetivo: Entender estructura de MiDNI
│       Tiempo: ~10 minutos
│       Acción: Analizar muestras de datos reales
│       Output: Gráficos y estadísticas básicas
│
├── ✓ SECCIÓN 3: Validación de Estructura
│   └── Objetivo: Detectar datos inválidos
│       Tiempo: ~15 minutos
│       Acción: Ejecutar validadores básicos
│       Output: Reporte de errores estructurales
│
├── 🔍 SECCIÓN 4: Análisis de Campos
│   └── Objetivo: Entender cada campo individualmente
│       Tiempo: ~15 minutos
│       Acción: Análisis profundo por campo
│       Output: Matriz de validación de campos
│
├── 🔒 SECCIÓN 5: Verificación de Integridad
│   └── Objetivo: Garantizar coherencia de datos
│       Tiempo: ~15 minutos
│       Acción: Validar checksums y relaciones
│       Output: Score de integridad
│
├── 🛠️ SECCIÓN 6: Validadores Personalizados
│   └── Objetivo: Crear reglas de negocio
│       Tiempo: ~20 minutos
│       Acción: Implementar motor de validación
│       Output: Funciones reutilizables
│
└── 📋 SECCIÓN 7: Generar Reportes
    └── Objetivo: Comunicar resultados
        Tiempo: ~10 minutos
        Acción: Crear reportes ejecutivos
        Output: JSON, HTML, recomendaciones
```

**Tiempo total estimado**: 90 minutos para primera ejecución completa

---

## 🎯 Objetivos de Aprendizaje por Sección

### Sección 1: Importar Librerías ✅
**Concepto clave**: Configurar ambiente profesional

```python
# Lo que aprenderás:
- pandas: Análisis de datos
- numpy: Cálculos numéricos
- json: Manejo de datos JSON
- hashlib: Cálculos de checksum
- datetime: Validación de fechas
- re: Expresiones regulares para validación
```

**Ejercicio**: Verifica que todas las librerías se importan sin error

---

### Sección 2: Cargar y Explorar Datos 📊
**Concepto clave**: Entender la anatomía de un MiDNI

**Campos típicos a reconocer**:
```
✓ DNI Number:      "12345678ABC"     (13 caracteres)
✓ Surname:         "GARCÍA PÉREZ"    (40 máx)
✓ Given Names:     "JUAN CARLOS"     (40 máx)
✓ Date of Birth:   "15041985"        (DDMMYY)
✓ Expiry Date:     "15042035"        (DDMMYY)
✓ Gender:          "M"               (M/F)
✓ Nationality:     "ES"              (Código ISO)
✓ Document Number: "00012345ABC"     (11 caracteres)
```

**Ejercicio**: Ejecuta `df.head()` y `df.describe()` para ver distribuciones

---

### Sección 3: Validación de Estructura ✓
**Concepto clave**: Primeras líneas de defensa contra datos inválidos

```python
# Validaciones a implementar:
✓ Formato de DNI: ^[0-9]{8}[A-Z]{1}$
✓ Fecha válida: Día (01-31), Mes (01-12), Año válido
✓ Tipo de dato: Números vs strings
✓ Longitud: Respeta máximos
```

**Ejercicio**: Identifica qué registros fallan estructura básica

---

### Sección 4: Análisis de Campos 🔍
**Concepto clave**: Cada campo tiene reglas propias

```python
# Análisis por campo:
📅 Date of Birth:
   - Edad: 0-130 años razonable
   - No en futuro
   - Coherente con edad aparente en foto

📅 Expiry Date:
   - No antes de fecha de emisión
   - Vigencia típica: 10 años
   - Alertar si < 6 meses para expirar

👤 Name Fields:
   - Solo letras, espacios, guiones
   - Máximo 40 caracteres
   - Sin números

🏢 Nationality:
   - Código ISO válido (ES, FR, etc.)
   - Coherente con datos de emisión
```

**Ejercicio**: Crea una matriz de anomalías por campo

---

### Sección 5: Verificación de Integridad 🔒
**Concepto clave**: Validar que datos son congruentes entre sí

```python
# Técnicas de integridad:

1. CHECKSUM (MOD-23)
   - DNI tiene letra de control
   - Fórmula: número % 23 → letra
   - Detecta errores de transcripción

2. VALIDACIONES CRUZADAS
   - Edad coherente: nacimiento < hoy
   - Vencimiento: emisión < vencimiento
   - Coherencia de sexo con nombre

3. COMPLETITUD
   - % de campos llenos
   - Qué campos son opcionales vs obligatorios
```

**Ejercicio**: Implementa validador MOD-23 y prueba con DNI reales

---

### Sección 6: Validadores Personalizados 🛠️
**Concepto clave**: Crear reglas específicas de negocio

```python
# Motor de validación extensible:

class MiDNIValidator:
    def validate_dni_checksum(self) → bool
    def validate_age_range(self) → bool
    def validate_expiration(self) → bool
    def validate_name_format(self) → bool
    
    # Sistema de reglas personalizable:
    def add_custom_rule(self, rule_name, rule_func) → None
    def run_all_validations(self) → ValidationResult
```

**Ejercicio**: Agrega 3 reglas personalizadas según tu caso de uso

---

### Sección 7: Generar Reportes 📋
**Concepto clave**: Comunicar hallazgos a stakeholders

```python
# Estructura del reporte:

{
  "report_id": "abc123xyz789",
  "timestamp": "2026-02-23T14:30:45",
  "subject": "GARCÍA PÉREZ, JUAN",
  
  "executive_summary": {
    "status": "✅ COMPLIANT",
    "compliance_percentage": 98.5,
    "passed_checks": 49/50
  },
  
  "structural_validation": { ... },
  "field_analysis": { ... },
  "integrity_verification": { ... },
  "business_rule_validation": { ... },
  
  "recommendations": [
    "Revisar campo X",
    "Documento próximo a expiración"
  ],
  
  "export_formats": {
    "json": "...",
    "html": "..."
  }
}
```

**Ejercicio**: Genera reporte de 5 MiDNI diferentes y analiza diferencias

---

## 🔗 Conexión con NotebookLM

Después de completar las 7 secciones, puedes enriquecer tu conocimiento:

```python
# En cualquier sección, puedes consultar NotebookLM:
from notebooklm_client import NotebookLMClient

client = NotebookLMClient(
    api_key=os.getenv('NOTEBOOKLM_API_KEY'),
    notebook_id='8f79890a-531b-4b8f-8f09-d98fe6b60bbc'
)

# Ejemplos de consultas
insights = client.query(
    "¿Cuál es la diferencia entre DNI, DNIe y MiDNI?"
)

podcast = client.generate_podcast(
    title="Guía Completa de MiDNI",
    duration_minutes=30
)

study_guide = client.generate_study_guide(
    topic="Validación de MiDNI",
    difficulty="advanced"
)
```

---

## 📊 Checklist de Ejecución

- [ ] Sección 1: Librerías importadas sin errores
- [ ] Sección 2: Datos cargados, primeras estadísticas visibles
- [ ] Sección 3: Estructura validada, errores identificados
- [ ] Sección 4: Análisis de campos completado
- [ ] Sección 5: Checksums validados
- [ ] Sección 6: Validadores personalizados funcionando
- [ ] Sección 7: Reporte generado y exportado
- [ ] Bonus: NotebookLM consultado para expandir conocimiento

---

## 💡 Tips para Máximo Aprendizaje

### 1. **Ejecuta celda por celda**
No ejecutes todo de una vez. Lee la documentación de cada sección.

### 2. **Experimenta con datos propios**
Carga datos reales de MiDNI (anonimizados) para ver cómo se comportan.

### 3. **Modifica el código**
Cambia validaciones, agrega campos nuevos, experimenta.

### 4. **Documenta hallazgos**
Usa las celdas markdown para escribir lo que aprendes.

### 5. **Usa NotebookLM para dudas**
Si no entiendes algo, consulta el notebook de MiDNI en NotebookLM.

---

## 🚨 Problemas Comunes

### Error: "ModuleNotFoundError: No module named 'pandas'"
```bash
pip install pandas
jupyter notebook
```

### Error: "JSON decode error" al cargar datos
```python
# Verifica que el archivo JSON es válido
import json
with open('data.json') as f:
    json.load(f)  # Esto debería no lanzar error
```

### Gráficos no se muestran
```python
# Agrega al inicio del notebook:
import matplotlib.pyplot as plt
%matplotlib inline
```

---

## 📈 Métricas de Progreso

**Meta**: Completar todo el notebook en 2 horas

| Sección | Tiempo (min) | Dificultad | Estado |
|---------|-------------|-----------|--------|
| 1. Librerías | 2 | Fácil | ⏳ |
| 2. Exploración | 10 | Fácil | ⏳ |
| 3. Validación | 15 | Intermedio | ⏳ |
| 4. Análisis | 15 | Intermedio | ⏳ |
| 5. Integridad | 15 | Intermedio | ⏳ |
| 6. Personalizado | 20 | Avanzado | ⏳ |
| 7. Reportes | 10 | Intermedio | ⏳ |
| **TOTAL** | **87 min** | - | - |

---

## 🎓 Certificación de Expertise

Al completar este notebook + ejecutar las pruebas finales, obtendrás:

📜 **Certificado de Expertise en MiDNI**

Incluye:
- ✅ Validación de estructura
- ✅ Detección de anomalías
- ✅ Generación de reportes
- ✅ Integración con NotebookLM
- ✅ Mejores prácticas

---

**¿Listo para empezar?** 🚀

```bash
jupyter notebook MiDNI_Expertise_Analysis.ipynb
```

Vuelve a este documento si necesitas recordar qué viene en cada sección.

**¡Que aproveche!**

