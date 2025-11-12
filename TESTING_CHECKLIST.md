# Testing Checklist - Nuevas Funcionalidades

## Pre-requisitos
- [ ] Flutter instalado (versión 3.27.2 o superior)
- [ ] Dependencias actualizadas (`flutter pub get`)
- [ ] Firebase configurado correctamente
- [ ] Dispositivo físico o emulador para testing

## 1. Contactos de Emergencia

### Flujo Normal (Desde Perfil)
- [ ] Navegar a Mi Perfil → Configuración de la App → Contactos de Emergencia
- [ ] Verificar pantalla vacía con mensaje apropiado
- [ ] Tap en "Agregar primer contacto"
- [ ] Completar formulario:
  - [ ] Ingresar nombre
  - [ ] Seleccionar relación (Familiar, Amigo, Terapeuta, etc.)
  - [ ] Seleccionar tipo de contacto (Teléfono, WhatsApp, Email)
  - [ ] Ingresar información de contacto
  - [ ] Marcar como contacto principal (opcional)
- [ ] Tap en "Guardar"
- [ ] Verificar que el contacto aparece en la lista
- [ ] Verificar que se puede editar el contacto
- [ ] Verificar que se puede eliminar el contacto (con confirmación)

### Flujo de Emergencia
- [ ] Ir a pantalla principal (Home)
- [ ] Tap en botón de emergencia (botón rojo central)
- [ ] Verificar que aparece modal de herramientas
- [ ] Tap en "Contactos de Emergencia"
- [ ] Verificar pantalla en modo emergencia (fondo rojo)
- [ ] Verificar mensaje informativo en la parte superior
- [ ] Verificar botones de "Llamar" y "Mensaje" en cada contacto
- [ ] Tap en "Llamar" - verificar que se abre el marcador
- [ ] Tap en "Mensaje" - verificar que se abre WhatsApp/SMS con mensaje predefinido

### Validaciones
- [ ] No se puede guardar contacto sin nombre
- [ ] No se puede guardar contacto sin información de contacto
- [ ] Email debe contener @
- [ ] Confirmación al eliminar contacto
- [ ] Actualización en tiempo real (StreamBuilder)

### Edge Cases
- [ ] Agregar múltiples contactos (verificar orden por prioridad)
- [ ] Marcar diferentes contactos como principales
- [ ] Editar contacto principal
- [ ] Eliminar todos los contactos
- [ ] Contactos con nombres muy largos (truncamiento)
- [ ] Números de teléfono con diferentes formatos

---

## 2. Ejercicios de Respiración

### Flujo Principal
- [ ] Ir a pantalla principal (Home)
- [ ] Tap en botón de emergencia
- [ ] Tap en "Respiración Guiada"
- [ ] Verificar pantalla de introducción con:
  - [ ] Nombre del ejercicio
  - [ ] Descripción
  - [ ] Número de ciclos
  - [ ] Duración total
  - [ ] Nivel de dificultad
  - [ ] Patrón de respiración
  - [ ] Beneficios
  - [ ] Instrucciones (si aplica)
- [ ] Tap en "Comenzar ejercicio"
- [ ] Verificar animación:
  - [ ] Círculo crece al inhalar (azul)
  - [ ] Círculo se mantiene al sostener (morado)
  - [ ] Círculo decrece al exhalar (verde)
  - [ ] Pausas (naranja)
- [ ] Verificar indicadores:
  - [ ] Progreso del ciclo actual
  - [ ] Porcentaje completado
  - [ ] Contador de segundos
  - [ ] Instrucción clara de la fase actual
- [ ] Controles:
  - [ ] Tap en pausa - verificar que se pausa
  - [ ] Tap en play - verificar que se reanuda
  - [ ] Tap en reiniciar - verificar que reinicia desde el ciclo 1

### Diferentes Ejercicios
- [ ] Respiración 4-7-8 (4 ciclos)
  - [ ] Inhala 4s → Sostén 7s → Exhala 8s
- [ ] Respiración Cuadrada (4 ciclos)
  - [ ] Inhala 4s → Sostén 4s → Exhala 4s → Sostén 4s
- [ ] Respiración Profunda (5 ciclos)
  - [ ] Inhala 5s → Sostén 2s → Exhala 6s
- [ ] Respiración Calmante (6 ciclos)
  - [ ] Inhala 5s → Exhala 5s
- [ ] Respiración Triangular (5 ciclos)
  - [ ] Inhala 4s → Sostén 4s → Exhala 4s

### Pantalla de Completado
- [ ] Completar ejercicio hasta el final
- [ ] Verificar pantalla de éxito
- [ ] Verificar botones de feedback (Mejor/Igual/Peor)
- [ ] Tap en "Repetir ejercicio"
- [ ] Tap en "Probar otro ejercicio" - verificar que cambia aleatoriamente
- [ ] Tap en "Volver al inicio"

### Validaciones
- [ ] Cambio de colores según la fase
- [ ] Transiciones suaves de animación
- [ ] Contador preciso de segundos
- [ ] Progreso correcto de ciclos
- [ ] Diálogo de confirmación al salir durante ejercicio

### Edge Cases
- [ ] Salir durante ejercicio (botón back)
- [ ] Pausar y luego salir
- [ ] Completar todos los ciclos
- [ ] Cambiar ejercicio desde intro
- [ ] Rotación de pantalla (si aplica)

---

## 3. Integración General

### Navegación
- [ ] Home → Botón emergencia → Contactos (modo emergencia)
- [ ] Home → Botón emergencia → Respiración
- [ ] Perfil → Configuración → Contactos (modo normal)
- [ ] Navegación hacia atrás funciona correctamente
- [ ] Estado se preserva al navegar

### Consistencia Visual
- [ ] Colores consistentes con el tema pink/blue
- [ ] Fuente Poppins en todos los textos
- [ ] Iconos Material Design
- [ ] Bordes redondeados consistentes
- [ ] Elevaciones de Cards apropiadas
- [ ] Espaciado consistente

### Rendimiento
- [ ] Animaciones fluidas (60 FPS)
- [ ] Sin lag al abrir pantallas
- [ ] Carga rápida de contactos desde Firebase
- [ ] Transiciones suaves

---

## 4. Firebase Integration

### Firestore - Contactos
- [ ] Verificar colección `users/{userId}/contacts`
- [ ] Crear contacto - documento aparece en Firebase
- [ ] Editar contacto - cambios se reflejan en Firebase
- [ ] Eliminar contacto - documento se elimina de Firebase
- [ ] Actualización en tiempo real funciona
- [ ] Campo `lastContacted` se actualiza al llamar/mensajear

### Autenticación
- [ ] Solo usuarios autenticados pueden acceder
- [ ] UID correcto en contactos
- [ ] Logout no deja datos cached

---

## 5. Errores y Manejo

### Contactos
- [ ] Error al crear contacto sin conexión
- [ ] Error al cargar contactos sin permisos
- [ ] Error al llamar sin app de teléfono
- [ ] Error al mensajear sin WhatsApp/SMS

### Respiración
- [ ] Sin errores de animación
- [ ] Timer no continúa en background incorrectamente
- [ ] Dispose correcto de controllers

---

## Checklist Final

- [ ] No hay errores de compilación
- [ ] No hay warnings importantes
- [ ] Código comentado en español en puntos clave
- [ ] Imports correctos
- [ ] Estructura de carpetas respetada
- [ ] README actualizado
- [ ] Screenshots tomados (si es necesario)

---

## Comandos Útiles

```bash
# Obtener dependencias
flutter pub get

# Analizar código
flutter analyze

# Ejecutar en modo debug
flutter run

# Ejecutar en modo release
flutter run --release

# Ver logs
flutter logs

# Limpiar build
flutter clean
```

---

## Notas de Testing

### Dispositivos Recomendados
- Android físico (para probar llamadas/WhatsApp)
- iOS físico (para probar llamadas/iMessage)
- Emulador para testing general de UI

### Permisos Necesarios
- Contactos (opcional)
- Teléfono (para llamadas)
- SMS (para mensajes)

### URLs Scheme Testeados
- `tel:` - Llamadas telefónicas
- `sms:` - Mensajes SMS
- `https://wa.me/` - WhatsApp

---

## Issues Conocidos
(Ninguno por el momento - completar después del testing)

---

## Feedback de Testing
(Agregar notas después de probar en dispositivo real)
