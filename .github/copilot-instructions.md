
# ConviveZen - Instrucciones para Asistentes de Codificación IA

## Contexto del proyecto
ConviveZen es una aplicación móvil tipo “botón de emergencia” dirigida a jóvenes adultos (18-30) que sufren ataques de ansiedad. La app permite al usuario crear un perfil con sus preferencias y tipos de ansiedad, y configurar opciones de contención rápida (música, juegos, palabras de afirmación, meditaciones guiadas, IA conversacional y contactos de confianza). Al detectarse o percibirse una crisis, el usuario pulsa el botón de emergencia y la app muestra un menú personalizado con las opciones previamente definidas para contener la crisis de forma inmediata. El modelo de negocio es freemium: música y contacto de confianza serán gratis; funciones premium (meditaciones personalizadas, IA conversacional, juegos y alertas avanzadas, afirmaciones personalizadas) mediante suscripción mensual.

## Patrones de Arquitectura

### Gestión de Estado
- **Patrón Provider**: Usa el paquete `provider` con `AppState` como contenedor principal de estado (`lib/providers/app_state.dart`).
- **Integración con Firebase**: Escucha en tiempo real el estado de autenticación en el método `AppState._init()`.
- **Estado Centralizado**: Todo el seguimiento de hábitos, preferencias de usuario y autenticación se gestiona en `AppState`.

### Arquitectura Firebase
- **Autenticación**: Firebase Auth con soporte para Google Sign-In.
- **Base de datos**: Cloud Firestore con colecciones estructuradas (`users`, preferencias de usuario).
- **Almacenamiento**: Firebase Storage para imágenes de perfil.
- **Configuración**: `firebase_options.dart` autogenerado mediante FlutterFire CLI.

### Organización de Pantallas
```
lib/screens/
├── auth/           # Flujos de autenticación (login, registro)
├── home/           # Dashboard principal y seguimiento de hábitos
├── onboarding/     # Configuración y personalización de usuario
└── profile/        # Gestión de perfil de usuario
```

### Capa de Servicios
- **FirestoreService** (`lib/services/firebase.dart`): Operaciones CRUD para datos de usuario.
- **ProfileImageService**: Manejo de subida/gestión de imágenes.
- **AuthService**: Lógica de autenticación separada de la UI.

## Flujo de Desarrollo

### Configuración de Firebase
- ID de proyecto: `convivezen-c4eb4`
- Requiere `flutterfire configure` para configurar los archivos específicos de cada plataforma.
- Android: `google-services.json` se autogenera.
- iOS: Configuración de Firebase embebida en el proyecto.

### Requisitos de Versiones
- Flutter: 3.27.2
- Dart SDK: 3.6.1
- FlutterFire: 1.1.0
- Firebase: 14.0.1

## Convenciones Clave

### Estructura de Modelos
- **UserModel** (`lib/models/user.dart`): Datos completos de usuario, incluyendo campos específicos de ansiedad.
- **UserPreferences**: Modelo separado para ajustes y preferencias de la app.
- Todos los modelos incluyen `toMap()` y `fromMap()` para serialización con Firestore.
- En esa carpeta `models` concentra todos los modelos de datos usados en la app.

### Componentes UI
- **Widgets reutilizables**: Biblioteca extensa en `lib/widgets/`.
- - los widgets reutilizables mantenlos en `widgets/` con separación adecuada de responsabilidades. para no volver a repetir código.
- **Material Design**: Usa Material 3 con esquemas de color personalizados.
sando componentes de Material Design.

## Puntos Críticos de Integración

### Persistencia de Datos
- Listeners en tiempo real de Firestore para actualizaciones de datos de usuario
- Estado de hábitos almacenado como `Map<String, bool>` en `AppState`
- Preferencias de usuario cacheadas localmente y sincronizadas con Firestore

### Patrón de Navegación
- Navegación inferior con preservación de estado
- Enrutamiento de pantallas mediante Navigator y gestión adecuada de estado
- Manejo del botón atrás para flujos de autenticación

## Gestión de Recursos
- Imágenes: `assets/images/` Ubicacion para recursos de imagenes
- PDFs: `assets/pdf/` Ubicación para documentos PDF (para colocar terminos y condiciones)
- Generación de íconos: Usa `flutter_launcher_icons` con `assets/images/splash/logo.png`

## Consideraciones de Build
- **Compatibilidad Java/Gradle**: Java 17 + Gradle 7.3 o Java 23 + Gradle 8.10
- **Multiplataforma**: Soporte para Android, iOS, Web, Windows, macOS, Linux
- **Splash nativo**: Configurado mediante el plugin `flutter_native_splash`


## Reglas
- El codigo del proyecto tiene que ser en inglés (nombres de variables, funciones, clases en English).
- Los comentarios deben de ser breves en español (widget [nombre] logica de login, perfil etc...), sin exceso de comentario unicamente en puntos clave para identificar.
- No utilizar emojis ni caracteres especiales en nombres de archivos o comentarios.
- Cada carpeta debe tener responsabilidad única (Single Responsibility Principle).
- Seguir buenas prácticas: SOLID, separación de capas, evitar lógica en controllers, usar servicios.
- Usar ORM para persistencia;
- Archivos de configuración sensibles (keys, contraseñas) NO deben estar en el repo; reportar cualquier secreto detectado.
