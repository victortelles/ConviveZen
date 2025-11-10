# Nuevas Funcionalidades - ConviveZen

## 1. Contactos de Emergencia

### Descripción
Sistema completo para gestionar contactos de confianza que pueden ser contactados durante una crisis de ansiedad.

### Características
- ✅ Agregar, editar y eliminar contactos de emergencia
- ✅ Clasificar contactos por tipo de relación (familiar, amigo, terapeuta, etc.)
- ✅ Marcar contacto principal
- ✅ Llamada directa desde la app
- ✅ Envío de mensajes (WhatsApp/SMS) con mensaje predefinido
- ✅ Historial de últimos contactos
- ✅ Modo emergencia con acceso rápido
- ✅ Gestión desde perfil de usuario

### Ubicación en la App
1. **Modo Emergencia**: Botón de pánico → Herramientas de emergencia → Contactos de emergencia
2. **Perfil**: Mi Perfil → Configuración de la App → Contactos de Emergencia

### Estructura de Datos (Firebase)
```
users/{userId}/contacts/{contactId}
  - id: string
  - userId: string
  - name: string
  - relationship: string (family, friend, partner, therapist, doctor, psychologist)
  - contactInfo: string (phone/email)
  - contactType: string (phone, whatsapp, email)
  - notifyInEmergency: boolean
  - isPrimary: boolean
  - priority: number
  - createdAt: timestamp
  - lastContacted: timestamp
```

### Archivos Creados
- `lib/services/contacts_service.dart` - Servicio de Firebase para CRUD
- `lib/screens/contacts/emergency_contacts_screen.dart` - Pantalla principal
- `lib/screens/contacts/widgets/contact_card.dart` - Tarjeta de contacto
- `lib/screens/contacts/widgets/add_contact_dialog.dart` - Diálogo para agregar
- `lib/screens/contacts/widgets/edit_contact_dialog.dart` - Diálogo para editar

---

## 2. Ejercicios de Respiración Guiada

### Descripción
Sistema de ejercicios de respiración con animaciones interactivas para ayudar a calmar ataques de ansiedad.

### Ejercicios Disponibles
1. **Respiración 4-7-8** - Técnica del Dr. Andrew Weil para relajación rápida
2. **Respiración Cuadrada** - Técnica Navy SEALs para mantener la calma
3. **Respiración Profunda** - Ejercicio simple y efectivo
4. **Respiración Calmante** - Ritmo equilibrado 5-5
5. **Respiración Triangular** - Patrón de 3 pasos

### Características
- ✅ Selección aleatoria de ejercicio al abrir
- ✅ Animaciones fluidas y atractivas
- ✅ Círculo que crece/decrece según la fase (inhalar/exhalar)
- ✅ Contador de progreso por ciclo
- ✅ Instrucciones visuales claras
- ✅ Colores que cambian según la fase
- ✅ Opciones de pausa, reanudar y reiniciar
- ✅ Pantalla de completado con feedback
- ✅ Información detallada de beneficios

### Fases de Respiración
- **Inhalar** (azul) - Círculo crece
- **Sostener** (morado) - Círculo en tamaño máximo
- **Exhalar** (verde) - Círculo decrece
- **Pausa** (naranja) - Círculo en tamaño mínimo

### Ubicación en la App
**Modo Emergencia**: Botón de pánico → Herramientas de emergencia → Respiración Guiada

### Archivos Creados
- `lib/models/breathing_exercise.dart` - Modelo de ejercicios y definiciones
- `lib/screens/breathing/breathing_exercise_screen.dart` - Pantalla con animaciones

---

## Integración

### Archivos Modificados
- `lib/screens/home/home.dart` - Integración de ambas funcionalidades
- `lib/screens/profile/widgets/configuration_section.dart` - Opción de contactos en perfil

### Dependencias Usadas
- `firebase_auth` - Autenticación del usuario
- `cloud_firestore` - Base de datos de contactos
- `google_fonts` - Fuentes Poppins
- `url_launcher` - Llamadas y mensajes
- Material Design - Animaciones y widgets

---

## Colores y Tema

### Contactos de Emergencia
- **Normal**: Pink theme (Pink 50-400)
- **Emergencia**: Red theme (Red 50-400)

### Ejercicios de Respiración
- **Inhalar**: Blue 500
- **Sostener**: Purple 500
- **Exhalar**: Green 500
- **Pausa**: Orange 500
- **Background**: Blue 50

---

## Próximos Pasos Sugeridos

1. **Testing en dispositivo real**
   - Probar llamadas telefónicas
   - Probar mensajes WhatsApp/SMS
   - Validar animaciones en diferentes dispositivos

2. **Mejoras futuras**
   - Agregar sonidos a ejercicios de respiración
   - Estadísticas de uso de contactos
   - Más ejercicios de meditación
   - Notificaciones de recordatorio

3. **Premium Features**
   - Meditaciones guiadas con voz
   - Ejercicios personalizados según tipo de ansiedad
   - Estadísticas avanzadas

---

## Notas de Implementación

- ✅ Código con comentarios en español
- ✅ Respeta estructura de carpetas existente
- ✅ Usa Provider para estado (si es necesario)
- ✅ Integrado con Firebase Firestore
- ✅ Manejo de errores implementado
- ✅ UI consistente con el diseño actual
- ✅ Material Design 3
