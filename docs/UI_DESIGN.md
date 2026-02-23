# 🎨 Diseño UI/UX - DNI-Connect Web

## Visión General

Diseño moderno y profesional para una aplicación de verificación de identidad digital mediante DNI. Implementa Material 3 con autenticación completa (login + Google OAuth).

---

## 📋 Estructura de Diseño

### 1. **Sistema de Color**

| Elemento | Color | Hex |
|----------|-------|-----|
| **Primary** | Azul profesional | `#2563EB` |
| **Primary Light** | Azul claro | `#60A5FA` |
| **Primary Dark** | Azul oscuro | `#1E40AF` |
| **Success** | Verde | `#10B981` |
| **Error** | Rojo | `#EF4444` |
| **Warning** | Naranja | `#F59E0B` |
| **Surface** | Gris claro | `#F8FAFC` |
| **Background** | Blanco | `#FFFFFF` |

### 2. **Tipografía**

- **Font**: Google Inter
- **Estilos principales**:
  - Títulos H1: 32px, Bold (700)
  - Títulos H2: 28px, SemiBold (600)
  - Títulos H3: 24px, SemiBold (600)
  - Body: 16px, Regular (400)
  - Caption: 14px, Regular (400)

### 3. **Componentes Base**

#### Botones
- **ElevatedButton**: Fondo azul, texto blanco, corners redondeados 12px
- **OutlinedButton**: Borde gris, esquinas redondeadas 12px
- **TextButton**: Sin fondo, solo texto azul

#### Campos de Entrada
- **TextField**: Borde gris claro, fondo gris50, esquinas 12px
- **Focus**: Borde azul (2px), fondo blanco
- **Prefijo/Sufijo**: Iconos grises

#### Tarjetas
- **Card**: Borde gris200, fondo blanco, esquinas 16px
- **Sombra**: Elevation 0 (diseño flat)

---

## 📱 Pantallas Principales

### 1. **Pantalla de Login**
**Ruta**: `/login`

**Componentes**:
- Logo y branding superior
- Campo email con validación
- Campo contraseña con toggle visibilidad
- Botón "¿Olvidaste contraseña?"
- CTA principal: "Iniciar sesión"
- Divider "O continúa con"
- Botón Google OAuth
- Link a signup

**Características**:
- Loading indicator en botón principal
- Validaciones en tiempo real
- Respuesta móvil completa

### 2. **Pantalla de Registro**
**Ruta**: `/signup`

**Componentes**:
- Nombre completo
- Email
- Contraseña
- Confirmar contraseña
- Checkbox términos y condiciones
- Botón crear cuenta
- Link a login

**Características**:
- Validación de coincidencia de contraseñas
- Checkbox habilitado para continuar
- Campos con iconos descriptivos

### 3. **Pantalla de Inicio (Home)**
**Ruta**: `/` (requiere autenticación)

**Secciones**:
1. **Tarjeta de Bienvenida**
   - Gradiente azul
   - Texto personalizado
   - Altura 140px

2. **Métodos de Verificación**
   - Tarjeta QR: Azul (#2563EB)
   - Tarjeta NFC: Verde (#10B981)
   - Cada una con icono, título, subtítulo

3. **Panel de Seguridad**
   - Icon: Shield
   - Información de encriptación
   - Fondo azul claro con borde

4. **Bottom Navigation**
   - Inicio
   - Historial
   - Configuración

### 4. **Pantalla de Escaneo QR**
**Ruta**: `/scan`

- Visor de cámara
- Marco de referencia QR
- Botón cancelar
- Indicador de estado

### 5. **Pantalla de Lectura NFC**
**Ruta**: `/nfc`

- Input PIN/CAN
- Instrucciones
- Indicador de progreso

### 6. **Pantalla de Resultado**
**Ruta**: `/result`

- Icono de éxito/error
- Datos verificados
- Opciones de descarga/compartir

---

## 🎯 Flujos de Usuario

### Flujo de Autenticación
```
Login → (Validar) → Home
   ↓
   Google OAuth → Home
   
Signup → (Crear) → Home
```

### Flujo de Verificación
```
Home → Elegir método (QR/NFC)
   ↓
Escanear/Leer
   ↓
Validar datos
   ↓
Resultado
   ↓
Historial
```

---

## 📐 Espaciado (8pt Grid)

- Padding pequeño: 8px
- Padding medio: 16px
- Padding grande: 24px
- Padding XL: 32px, 48px

---

## 🔐 Estado de Seguridad

Todos los campos sensibles muestran:
- Toggle de visibilidad de contraseña
- Validación en tiempo real
- Iconos de seguridad
- Mensajes de error claros

---

## 🌙 Tema Oscuro

- Surface: `#1E293B`
- Text: `#F1F5F9`
- Borders: `#334155`
- Mantiene colores de brand (Primary)

---

## ✅ Características Implementadas

### Pantalla Login
- ✅ Validación de email
- ✅ Toggle contraseña
- ✅ Button loading state
- ✅ Google OAuth button
- ✅ Link a signup
- ✅ "Forgot password" link

### Pantalla Signup
- ✅ Validación de 4 campos
- ✅ Matching password check
- ✅ Checkbox términos
- ✅ Loading state
- ✅ Link a login

### Pantalla Home
- ✅ Tarjeta de bienvenida con gradiente
- ✅ 2 métodos de verificación (QR/NFC)
- ✅ Panel de seguridad
- ✅ Bottom navigation (3 tabs)
- ✅ Settings y profile mockups

### Sistema Visual
- ✅ Material 3 design
- ✅ Color system completo
- ✅ Tipografía Google Inter
- ✅ Iconos Material Icons
- ✅ Responsive design

---

## 🚀 Próximas Mejoras

1. **Autenticación Real**
   - Firebase Auth integración
   - Google OAuth flow
   - JWT tokens

2. **Camera & NFC**
   - Integración de cámara
   - QR decoder
   - NFC reader

3. **Historial**
   - Listado de verificaciones
   - Exportar datos
   - Timestamps

4. **Animaciones**
   - Page transitions
   - Loading animations
   - Success feedback

5. **Notificaciones**
   - Push notifications
   - In-app alerts
   - Toast messages

---

**Última actualización**: 23 de febrero de 2026  
**Versión**: 1.0.0  
**Diseñador**: AI Design System
