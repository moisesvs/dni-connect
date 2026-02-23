# 🎨 Guía Visual - DNI-Connect

## Sistema de Diseño Completo

### 1. Paleta de Colores

```
PRIMARY COLORS
├─ Primary: #2563EB (Azul brillante)
├─ Primary Light: #60A5FA (Azul claro)
└─ Primary Dark: #1E40AF (Azul oscuro)

SEMANTIC COLORS
├─ Success: #10B981 (Verde)
├─ Warning: #F59E0B (Naranja)
├─ Error: #EF4444 (Rojo)
└─ Info: #3B82F6 (Azul info)

NEUTRAL COLORS
├─ Surface: #F8FAFC (Fondo)
├─ Foreground: #1E293B (Texto oscuro)
├─ Border: #E2E8F0 (Bordes)
└─ Muted: #64748B (Texto muted)
```

### 2. Tipografía

**Font**: Google Inter (sin serif)

```
SIZES
├─ Display: 56px (nunca usado en web)
├─ Headline 1: 32px (Títulos principales)
├─ Headline 2: 28px (Subtítulos)
├─ Headline 3: 24px (Secciones)
├─ Title: 20px (Card titles)
├─ Body: 16px (Texto principal)
├─ Body Small: 14px (Subtexto)
└─ Label: 12px (Labels, captions)

WEIGHTS
├─ Bold: 700 (Énfasis)
├─ SemiBold: 600 (Títulos)
└─ Regular: 400 (Body)
```

### 3. Espaciado (8px Grid)

```
8px   = 1 unit
16px  = 2 units
24px  = 3 units
32px  = 4 units
48px  = 6 units
64px  = 8 units
```

### 4. Esquinas Redondeadas

```
12px  = Botones, inputs
14px  = Tarjetas pequeñas
16px  = Tarjetas medianas
20px  = Gradients grandes
```

### 5. Sombras (Elevation)

```
LIGHT THEME
├─ Card (0): Sin sombra, borde gris
├─ Hover (2): Sombra leve
└─ Modal (4): Sombra notable

DARK THEME
└─ Similar con colores invertidos
```

---

## 📐 Componentes Principales

### Botón Primario

```
┌─────────────────────────────────────┐
│   Iniciar sesión                    │
└─────────────────────────────────────┘
Color: #2563EB
Padding: 14px vertical, 24px horizontal
Border Radius: 12px
Font Weight: 600
Font Size: 16px
```

### Card de Verificación

```
┌─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┐
│ [Icon]  Título           [Arrow]    │
│         Subtítulo                   │
└─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┘
Borde: #E2E8F0
Background: Blanco
Padding: 20px
```

### Input Field

```
┌─────────────────────────────────────┐
│ [Icon] Label                        │
│ Placeholder text...                 │
└─────────────────────────────────────┘
Border: #E2E8F0 (1px)
Focus Border: #2563EB (2px)
Background: #F8FAFC
```

### Info Card

```
┌─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┐
│ [Shield] Título                    │
│          Descripción                │
└─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┘
Background: #F0F9FF
Border: #E0E7FF
Icon Color: #2563EB
```

### Gradient Card (Header)

```
╔═══════════════════════════════════════╗
║ ¡Bienvenido!                          ║
║ Verifica tu identidad de forma segura ║
╚═══════════════════════════════════════╝
Gradient: #2563EB → #1E40AF
Padding: 24px
Border Radius: 20px
```

---

## 🎯 Patrones de Uso

### 1. Login Flow

```
[Logo + Título]
   ↓
[Email Input]
[Password Input with toggle]
   ↓
[Primary Button]
   ↓
[Divider "O continúa con"]
   ↓
[Google Button]
   ↓
[Signup Link]
```

### 2. Home Dashboard

```
[Header con Avatar]
   ↓
[Gradient Welcome Card]
   ↓
[Método QR Card]
[Método NFC Card]
   ↓
[Security Info Card]
   ↓
[Bottom Navigation]
```

### 3. Settings Panel

```
[Back Button]
   ↓
[Settings Items]
 • Perfil
 • Seguridad
 • Notificaciones
 • Acerca de
   ↓
[Logout Button - Danger]
```

---

## 🔄 Estados de Componentes

### Botón

```
DEFAULT    → Enabled, ready to click
HOVER      → Darker background
ACTIVE     → Pressed state
DISABLED   → Grayed out, opacity 0.6
LOADING    → Spinner en lugar de texto
```

### Input

```
EMPTY      → Border gris
FOCUSED    → Border azul, background blanco
FILLED     → Background gris claro
ERROR      → Border rojo, hint rojo
SUCCESS    → Border verde
```

### Card

```
DEFAULT    → Borde gris claro
HOVER      → Sombra leve aparece
ACTIVE     → Sombra notoria
```

---

## 📱 Responsive Breakpoints

```
Mobile   < 600px  (Single column, full padding)
Tablet   600-900px (2 columns, comfortable spacing)
Desktop  > 900px   (3+ columns, max-width constraints)
```

---

## 🎬 Animaciones

```
TRANSITIONS
├─ Page change: 300ms fade + slide
├─ Button press: 100ms scale
├─ Card hover: 150ms shadow + lift
└─ Loading: Continuous spinner

EASING
├─ Default: easeInOut (cubic)
└─ Quick actions: easeOut (quad)
```

---

## ♿ Accesibilidad

```
CONTRAST
├─ Normal text: 4.5:1 ratio (WCAG AA)
├─ Large text: 3:1 ratio
└─ Graphics: 3:1 ratio

INTERACTIVE
├─ Touch target: Mínimo 48x48px
├─ Focus visible: Borde azul 2px
└─ Labels: Siempre presente en inputs

SEMANTIC
├─ Headings: Jerarquía clara (h1 > h2 > h3)
├─ Buttons: type="button" explícito
└─ Links: Distinguibles de texto normal
```

---

## 🌙 Modo Oscuro

```
COLORS (Dark)
├─ Surface: #1E293B
├─ Foreground: #F1F5F9
├─ Border: #334155
└─ Muted: #CBD5E1

COMPONENTS
├─ Cards: Fondo #0F172A, borde #334155
├─ Inputs: Fondo #1E293B, borde #475569
└─ Buttons: Mantienen color primary
```

---

## 📊 Densidad de Espaciado

```
COMPACT    (Mobile)
├─ Padding: 16px
├─ Gaps: 12px
└─ Card padding: 16px

NORMAL     (Tablet)
├─ Padding: 24px
├─ Gaps: 16px
└─ Card padding: 20px

COMFORTABLE (Desktop)
├─ Padding: 32px
├─ Gaps: 24px
└─ Card padding: 24px
```

---

## ✨ Elementos Especiales

### Loading State
- Spinner circular (2px stroke)
- Color: Primary (#2563EB)
- Reemplaza el texto en botones

### Empty State
- Icono grande (64px)
- Gris claro (Colors.grey[300])
- Título + subtítulo
- Botón acción opcional

### Toast/Snackbar
- Bottom positioned (safe area)
- Sombra notable
- Auto-dismiss 3-4 segundos

### Modal Overlay
- Fondo opaco negro (0.4)
- Animate in/out
- Cierre con back button

---

**Última actualización**: 23 de febrero de 2026  
**Version**: 1.0.0
