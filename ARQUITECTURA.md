# Arquitectura de las Nuevas Funcionalidades

## Diagrama de Flujo de Navegación

```
┌─────────────────────────────────────────────────────────────┐
│                        HOME SCREEN                          │
│                   (Pantalla Principal)                      │
│                                                             │
│           ┌───────────────────────────┐                    │
│           │   BOTÓN DE EMERGENCIA    │                    │
│           │      (Botón Rojo)         │                    │
│           └───────────┬───────────────┘                    │
└───────────────────────┼─────────────────────────────────────┘
                        │
                        ▼
        ┌───────────────────────────────┐
        │  MODAL DE HERRAMIENTAS        │
        │  (Emergency Tools Modal)      │
        │                               │
        │  ┌─────────────────────────┐ │
        │  │ Respiración Guiada      │─┼──────┐
        │  └─────────────────────────┘ │      │
        │  ┌─────────────────────────┐ │      │
        │  │ Meditación (Premium)    │ │      │
        │  └─────────────────────────┘ │      │
        │  ┌─────────────────────────┐ │      │
        │  │ Música Relajante        │ │      │
        │  └─────────────────────────┘ │      │
        │  ┌─────────────────────────┐ │      │
        │  │ Contactos Emergencia    │─┼──┐   │
        │  └─────────────────────────┘ │  │   │
        └───────────────────────────────┘  │   │
                                           │   │
        ┌──────────────────────────────────┘   │
        │                                      │
        ▼                                      ▼
┌────────────────────────┐      ┌────────────────────────────┐
│ EMERGENCY CONTACTS     │      │  BREATHING EXERCISE        │
│      SCREEN            │      │       SCREEN               │
│  (Modo Emergencia)     │      │                            │
│                        │      │  ┌──────────────────────┐  │
│ ┌──────────────────┐   │      │  │   Intro Screen       │  │
│ │  ContactCard     │   │      │  │  - Descripción       │  │
│ │  [Llamar]        │   │      │  │  - Beneficios        │  │
│ │  [Mensaje]       │   │      │  │  - Instrucciones     │  │
│ └──────────────────┘   │      │  └────────┬─────────────┘  │
│                        │      │           │                │
│ ┌──────────────────┐   │      │           ▼                │
│ │  ContactCard     │   │      │  ┌──────────────────────┐  │
│ │  [Llamar]        │   │      │  │  Exercise Screen     │  │
│ │  [Mensaje]       │   │      │  │  - Animación         │  │
│ └──────────────────┘   │      │  │  - Contador          │  │
└────────────────────────┘      │  │  - Progreso          │  │
                                │  └────────┬─────────────┘  │
                                │           │                │
                                │           ▼                │
                                │  ┌──────────────────────┐  │
                                │  │  Completion Screen   │  │
                                │  │  - Feedback          │  │
                                │  │  - Repetir           │  │
                                │  └──────────────────────┘  │
                                └────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                     PROFILE SCREEN                          │
│                   (Perfil de Usuario)                       │
│                                                             │
│  ┌───────────────────────────────────────────────────┐     │
│  │    CONFIGURACIÓN DE LA APP                        │     │
│  │                                                    │     │
│  │  ┌─────────────────────────────────────────────┐  │     │
│  │  │  Contactos de Emergencia                    │──┼─┐   │
│  │  └─────────────────────────────────────────────┘  │ │   │
│  └───────────────────────────────────────────────────┘ │   │
└─────────────────────────────────────────────────────────┼───┘
                                                         │
                                                         ▼
                              ┌────────────────────────────────┐
                              │ EMERGENCY CONTACTS SCREEN      │
                              │   (Modo Gestión)               │
                              │                                │
                              │ ┌────────────────────────────┐ │
                              │ │  Lista de Contactos        │ │
                              │ │  - ContactCard             │ │
                              │ │    [Editar] [Eliminar]     │ │
                              │ └────────────────────────────┘ │
                              │                                │
                              │ [+ Agregar Contacto]           │
                              │         │                      │
                              │         ▼                      │
                              │ ┌────────────────────────────┐ │
                              │ │  AddContactDialog          │ │
                              │ │  - Nombre                  │ │
                              │ │  - Relación                │ │
                              │ │  - Tipo contacto           │ │
                              │ │  - Info contacto           │ │
                              │ └────────────────────────────┘ │
                              └────────────────────────────────┘
```

---

## Arquitectura de Capas

```
┌────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                      │
│                      (UI Screens)                          │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌──────────────────────┐    ┌──────────────────────────┐ │
│  │ Emergency Contacts   │    │  Breathing Exercise      │ │
│  │      Screen          │    │       Screen             │ │
│  │                      │    │                          │ │
│  │  - Main Screen       │    │  - Intro Screen          │ │
│  │  - Contact Card      │    │  - Exercise Screen       │ │
│  │  - Add Dialog        │    │  - Completion Screen     │ │
│  │  - Edit Dialog       │    │                          │ │
│  └──────────┬───────────┘    └───────────┬──────────────┘ │
│             │                            │                │
└─────────────┼────────────────────────────┼────────────────┘
              │                            │
              ▼                            ▼
┌────────────────────────────────────────────────────────────┐
│                     SERVICE LAYER                          │
│                   (Business Logic)                         │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌──────────────────────┐    ┌──────────────────────────┐ │
│  │ ContactsService      │    │  BreathingExercises      │ │
│  │                      │    │   (Static Methods)       │ │
│  │  - createContact()   │    │                          │ │
│  │  - getContacts()     │    │  - getAllExercises()     │ │
│  │  - updateContact()   │    │  - getRandomExercise()   │ │
│  │  - deleteContact()   │    │  - getExerciseById()     │ │
│  │  - markContacted()   │    │                          │ │
│  └──────────┬───────────┘    └───────────┬──────────────┘ │
│             │                            │                │
└─────────────┼────────────────────────────┼────────────────┘
              │                            │
              ▼                            ▼
┌────────────────────────────────────────────────────────────┐
│                      MODEL LAYER                           │
│                    (Data Models)                           │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌──────────────────────┐    ┌──────────────────────────┐ │
│  │ UserContact          │    │  BreathingExercise       │ │
│  │                      │    │                          │ │
│  │  - id                │    │  - id                    │ │
│  │  - name              │    │  - name                  │ │
│  │  - relationship      │    │  - description           │ │
│  │  - contactInfo       │    │  - phases[]              │ │
│  │  - isPrimary         │    │  - cycles                │ │
│  │  - toMap()           │    │  - benefits[]            │ │
│  │  - fromMap()         │    │                          │ │
│  │  - copyWith()        │    │  BreathingPhase          │ │
│  └──────────┬───────────┘    │  - name                  │ │
│             │                │  - duration              │ │
│             │                │  - action                │ │
│             │                └───────────┬──────────────┘ │
└─────────────┼────────────────────────────┼────────────────┘
              │                            │
              ▼                            ▼
┌────────────────────────────────────────────────────────────┐
│                    DATA LAYER                              │
│              (Firebase & Local Storage)                    │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌──────────────────────┐    ┌──────────────────────────┐ │
│  │  Cloud Firestore     │    │    In-Memory Data        │ │
│  │                      │    │                          │ │
│  │  users/{userId}/     │    │  Predefined Breathing    │ │
│  │    contacts/         │    │    Exercises             │ │
│  │      {contactId}     │    │                          │ │
│  │                      │    │  - 4-7-8                 │ │
│  │  Real-time Updates   │    │  - Box Breathing         │ │
│  │  (StreamBuilder)     │    │  - Deep Breathing        │ │
│  │                      │    │  - Calm Breathing        │ │
│  └──────────────────────┘    │  - Triangle Breathing    │ │
│                              └──────────────────────────┘ │
└────────────────────────────────────────────────────────────┘
```

---

## Flujo de Datos

### Contactos de Emergencia

```
┌─────────────────┐
│   User Action   │
│  (Add Contact)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   UI Layer      │
│ AddContactDialog│
└────────┬────────┘
         │ UserContact
         │  object
         ▼
┌─────────────────┐
│ Service Layer   │
│ ContactsService │
│ .createContact()│
└────────┬────────┘
         │ toMap()
         ▼
┌─────────────────┐
│  Data Layer     │
│  Firestore      │
│  users/contacts │
└────────┬────────┘
         │
         │ Real-time
         │ Updates
         ▼
┌─────────────────┐
│  StreamBuilder  │
│  (Auto Update   │
│   UI)           │
└─────────────────┘
```

### Ejercicios de Respiración

```
┌─────────────────┐
│   User Action   │
│ (Start Exercise)│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   UI Layer      │
│  BreathingExer- │
│   ciseScreen    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Model Layer    │
│ BreathingExer-  │
│   cises         │
│ .getRandom()    │
└────────┬────────┘
         │ Exercise
         │  object
         ▼
┌─────────────────┐
│   Animation     │
│  Controller     │
│  + Timer        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Animated      │
│     Circle      │
│  (Grow/Shrink)  │
└─────────────────┘
```

---

## Componentes Reutilizables

```
widgets/
├── ContactCard
│   ├── Props:
│   │   ├── contact: UserContact
│   │   ├── isEmergencyMode: bool
│   │   ├── onCall: VoidCallback
│   │   ├── onMessage: VoidCallback
│   │   ├── onEdit: VoidCallback
│   │   └── onDelete: VoidCallback
│   └── Used in:
│       └── EmergencyContactsScreen
│
├── AddContactDialog
│   ├── Props:
│   │   ├── userId: String
│   │   └── onContactAdded: VoidCallback
│   └── Used in:
│       └── EmergencyContactsScreen
│
└── EditContactDialog
    ├── Props:
    │   ├── contact: UserContact
    │   └── onContactUpdated: VoidCallback
    └── Used in:
        └── EmergencyContactsScreen (via ContactCard)
```

---

## Estado de la Aplicación

### Contactos
```dart
Stream<List<UserContact>> contactsStream
  ↓
StreamBuilder
  ↓
List<ContactCard>
```

### Respiración
```dart
AnimationController _breathController
  ↓
Animation<double> _breathAnimation
  ↓
AnimatedBuilder
  ↓
Animated Circle Widget
```

---

## Integración con Firebase

```
Firebase Project: convivezen-c4eb4
│
├── Authentication
│   └── FirebaseAuth.currentUser.uid
│       (Used for userId)
│
└── Cloud Firestore
    └── users/{userId}
        └── contacts/{contactId}
            ├── id: String
            ├── userId: String
            ├── name: String
            ├── relationship: String
            ├── contactInfo: String
            ├── contactType: String
            ├── notifyInEmergency: Boolean
            ├── isPrimary: Boolean
            ├── priority: Number
            ├── createdAt: Timestamp
            └── lastContacted: Timestamp
```

---

## Dependencias de Paquetes

```
pubspec.yaml
├── flutter
├── firebase_core: ^3.13.0
├── firebase_auth: ^5.5.2
├── cloud_firestore: ^5.6.6
├── google_fonts: ^6.1.0
├── url_launcher: ^6.2.5
└── provider: ^6.1.4
```

---

## Colores por Feature

### Contactos de Emergencia
```dart
// Modo Normal
Colors.pink.shade50   // Background
Colors.pink.shade400  // AppBar, Buttons
Colors.pink.shade700  // Text

// Modo Emergencia
Colors.red.shade50    // Background
Colors.red.shade400   // AppBar, Buttons
Colors.red.shade700   // Text
```

### Ejercicios de Respiración
```dart
Colors.blue.shade50    // Background (default)
Colors.blue.shade400   // AppBar
Colors.blue.shade500   // Inhale
Colors.purple.shade500 // Hold
Colors.green.shade500  // Exhale
Colors.orange.shade500 // Pause
```

---

## Patrones de Diseño Utilizados

1. **Service Pattern**: ContactsService separa lógica de negocio
2. **Builder Pattern**: Widgets builders para UI dinámica
3. **Observer Pattern**: StreamBuilder para datos en tiempo real
4. **Factory Pattern**: BreathingExercise.fromMap()
5. **Singleton Pattern**: FirebaseFirestore.instance
6. **State Pattern**: StatefulWidget para animaciones

---

**Este diagrama muestra la arquitectura completa de las nuevas funcionalidades implementadas.**
