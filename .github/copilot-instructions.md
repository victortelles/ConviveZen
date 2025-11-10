
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


## Fase: Interconexion entre aplicacion y servicios o apps externas 
Objetivo: Necesito que en base a la aplicacion de este proyecto, al momento de que el usuario le da accionar al boton de panico, y seleccione la musica, necesito que el dispositivo o la aplicacion identifique las aplicaciones de musica instaladas en el dispositivo movil (spotify, youtube music, apple music, etc) y se abra al que tenga seleccionado por defecto en el dispositivo movil para reproducir la musica de contencion rapida.
y base a los datos del usuario (preferencias) en (musicGenres) que se encuentren en la base de datos de firebase que el usuario configuro al inicio para seleccionar el genero de musica que le gusta escuchar en momentos de crisis, que la aplicacion abra la app de musica seleccionada y reproduzca una lista de reproduccion o album relacionado al genero musical seleccionado por el usuario en su perfil. y lo reproduzca.

idea del flujo:
1. usuario le da una crisis y acciona el boton de panico
2. le aparece el menu de opciones y selecciona musica
3. la app identifica con base el id del usuario en la coleccion de 'preferences' en 'main' busca la coleccion 'musicGenres' y obtiene el genero musical seleccionado por el usuario.
4. la app identifica las aplicaciones de musica instaladas en el dispositivo movil y selecciona la app de musica por defecto.
5. la app abre la aplicacion de musica seleccionada y reproduce una lista de reproduccion o album relacionado al genero musical seleccionado por el usuario en su perfil.
6. la app reproduce la musica de contencion rapida.

### Detalle técnico y consideraciones de implementación

El objetivo es que la app, al activar el modo emergencia y seleccionar música, abra automáticamente la app de música preferida del usuario (Spotify, YouTube Music, Apple Music, etc.) y reproduzca contenido relacionado al género musical configurado en su perfil. El flujo debe ser multiplataforma, pero con lógica diferenciada para Android/iOS.

#### Consideraciones técnicas:
- En Android se puede detectar apps instaladas y abrirlas con `intent` (paquete `android_intent_plus` o `url_launcher`).
- En iOS solo se puede abrir apps externas si están instaladas, pero no se puede listar todas las apps instaladas.
- Se requiere mapear géneros musicales a URLs/Intents específicos para cada app de música.
- La app debe consultar Firestore para obtener el género musical preferido del usuario.
- La reproducción directa no es posible, solo se puede abrir la app con una búsqueda, playlist o álbum sugerido.

#### Estructura de archivos implementados:
```
lib/
├── services/
│   └── music_service.dart          # Servicio para gestionar apertura de apps de música
├── screens/
│   └── music/
│       ├── music_screen.dart       # Pantalla principal de selección de música
│       └── widgets/
│           ├── music_genre_card.dart       # Widget de tarjeta de género musical
│           └── music_loading_overlay.dart  # Widget de overlay de carga
```

#### Notas de implementación:
- El servicio `MusicService` detecta automáticamente la plataforma (Android/iOS) y prioriza las apps de música según el sistema operativo.
- La pantalla `MusicScreen` se integra con el botón de emergencia en `HomeScreen`.
- Al abrir la pantalla de música, se carga automáticamente el primer género configurado en las preferencias del usuario y se intenta abrir la app de música correspondiente.
- El usuario puede seleccionar manualmente otro género de música desde la lista si lo desea.
- Si no hay apps de música instaladas, se muestra un diálogo informativo al usuario.

#### Ejemplo de flujo técnico (Android):
1. Consultar Firestore y obtener el género musical.
2. Detectar si Spotify está instalado.
3. Si está, construir intent para abrir Spotify con búsqueda del género.
4. Si no, intentar con YouTube Music, luego Apple Music.
5. Si ninguna está instalada, mostrar mensaje de error.

#### Ejemplo de flujo técnico (iOS):
1. Consultar Firestore y obtener el género musical.
2. Intentar abrir Apple Music con búsqueda/playlist del género.
3. Si no está instalada, intentar con Spotify.
4. Si ninguna está instalada, mostrar mensaje de error.

-----------------------------------------------------------

## Fase: Unificacion de listas y algoritmo de seleccion inteligente

### Objetivo
Unificar las listas de opciones entre onboarding y profile para asegurar consistencia en los datos de Firebase, e implementar un algoritmo inteligente que seleccione el genero musical mas efectivo segun los tipos de ansiedad del usuario.

#### Mapeo Ansiedad → Generos (Scoring 1-5)
Basado en investigacion de musicoterapia y efectividad terapeutica:

**Ansiedad Generalizada** (preocupacion constante):
- Ambient: 5 (reduce activacion cognitiva)
- Meditacion: 5 (promueve mindfulness)
- Clasica: 4 (efecto Mozart, reduce cortisol)
- Lo-Fi Hip Hop: 4 (ritmo constante, sin letra distrae)
- Instrumental: 4 (sin letra, evita sobrecarga cognitiva)
- Jazz suave: 3 (relajante pero requiere atencion)
- Sonidos de la naturaleza: 4 (efecto biofilia)

**Ansiedad Social** (miedo a interacciones):
- Lo-Fi Hip Hop: 5 (favorito en comunidad, no invasivo)
- Instrumental: 4 (sin letra, menos exposicion emocional)
- Ambient: 4 (crea espacio seguro mental)
- Clasica: 3 (puede sentirse formal/expuesto)
- Jazz suave: 3 (asociado a contextos sociales)
- Electronica: 3 (ritmo predecible, sensacion control)

**Ataques de Panico** (sintomas fisicos intensos):
- Meditacion: 5 (diseñada para crisis)
- Sonidos de la naturaleza: 5 (grounding, conexion presente)
- Frecuencias binaurales: 5 (efecto fisiologico directo)
- Ambient: 4 (reduce hiperarousal)
- Clasica: 4 (efecto calmante cardiovascular)
- Musica para dormir: 4 (induce respuesta parasimpatica)
- Instrumental: 3 (util pero menos especifico)

**Fobias Especificas** (miedo a objetos/situaciones):
- Meditacion: 4 (tecnicas de exposicion gradual)
- Clasica: 4 (distraccion cognitiva efectiva)
- Ambient: 4 (crea ambiente seguro)
- Instrumental: 3 (distraccion moderada)
- Sonidos de la naturaleza: 3 (puede ayudar segun fobia)

**Ansiedad de Rendimiento** (evaluaciones/presentaciones):
- Clasica: 5 (mejora concentracion, reduce cortisol)
- Lo-Fi Hip Hop: 4 (mejora focus, ritmo productivo)
- Jazz suave: 4 (estimula creatividad sin distraer)
- Instrumental: 4 (mantiene alerta sin ansiedad)
- Musica para concentrarse: 5 (diseñada para performance)
- Ambient: 3 (puede ser demasiado relajante)

**Ansiedad Mixta/Combinada**:
- Ambient: 4 (versatil, efectivo general)
- Meditacion: 4 (aborda multiples sintomas)
- Clasica: 4 (beneficios amplios)
- Lo-Fi Hip Hop: 3 (popular, accesible)
- Instrumental: 3 (seguro, neutral)

### Implementacion tecnica

**Estructura del algoritmo:**
```dart
// 1. Obtener generos del usuario y tipos de ansiedad
// 2. Calcular score para cada genero
// 3. Retornar genero con mayor puntuacion
// 4. En caso de empate, usar orden de preferencia del usuario
```

**Archivos a modificar:**
- `lib/services/music_service.dart` - Añadir mapeo y algoritmo
- `lib/screens/music/music_screen.dart` - Usar algoritmo en auto-launch
- `lib/data/anxiety_music_mapping.dart` - (opcional) Centralizar mapeo

-----------------------------------------------------------

## Reglas
- El codigo del proyecto tiene que ser en inglés (nombres de variables, funciones, clases en English).
- Los comentarios deben de ser breves en español (widget [nombre] logica de login, perfil etc...), sin exceso de comentario unicamente en puntos clave para identificar.
- No utilizar emojis ni caracteres especiales en nombres de archivos o comentarios.
- Cada carpeta/archivo debe tener responsabilidad única (Single Responsibility Principle).
- Seguir buenas prácticas: SOLID, separación de capas, evitar lógica en controllers, usar servicios.
- Usar ORM para persistencia;
- Archivos de configuración sensibles (keys, contraseñas) NO deben estar en el repo; reportar cualquier secreto detectado.
