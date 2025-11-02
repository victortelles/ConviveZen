# convivezen
convivezen es una aplicación móvil diseñada para transformar el hábito del ejercicio físico en una experiencia motivadora y social. La aplicación se enfoca en ayudar a los usuarios a establecer, mantener y disfrutar de rutinas de ejercicio personalizadas mediante un enfoque gamificado y centrado en la comunidad.

# Características principales

- Seguimiento personalizado de actividades físicas y progreso
- Recomendaciones inteligentes de rutinas basadas en tu perfil
- Rutinas estructuradas con progresión gradual de dificultad
- Sistema de retos locales para conectar con usuarios cercanos
- Gamificación con recompensas, rachas y logros desbloqueables

# Requisitos previos
> [!IMPORTANT]
> Importante tener las siguientes versiones.

- `Flutter: Version: 3.27.2 o Superior`
- `Dart SDK version: 3.6.1 o Superior`
- `FlutterFire Version: 1.1.0 o Superior`
- `Firebase Version: 14.0.1 o Superior`

# Instalación
1. Clonar el repositorio
```bash
git clone https://github.com/victortelles/convivezen.git
```
```bash
cd convivezen
```
2. Instalar dependencias
```bash
flutter pub get
```
3. Configurar variables de entorno (si es necesario)
Crea un archivo .env en la raíz del proyecto basándote en el archivo .env.example.

4. Configurar Firebase y seleccionar tu proyecto
Actualmente se esta utilizando:
- Firebase Auth
- Firebase FireStore
```bash
flutterfire configure
```
Y despues seleccionar tu proyecto.

5. Ejecutar la aplicación
```bash
flutter run
```

Para ejecutar en un dispositivo específico:
```bash
flutter devices                  # Lista los dispositivos disponibles
flutter run -d <device_id>       # Ejecuta en el dispositivo especificado
```

## Dependencias del proyecto
*Aqui iran las dependencias del proyecto + su*


# Estructura del proyecto

```bash
    ├── lib/
```


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Compatibilidad Java-Graddle

- Java 17 es compatible con Gradle 7.3
- Java 23 es compatible con Gradle 8.10

## Comandos para implementar el log-in

1. flutter configure 
  - Asegúrate de seleccionar el convivezen
  - Selecciona android y ios
2. flutter pub add firebase_core
3. flutter pub add firebase_auth
4. flutter pub add firebase_ui_auth

## Agregar flutter_dotenv

1. Correr en terminal:
``` bash
flutter pub add flutter_dotenv
```
2. Crear un .env con los secretos
3. Importar las variables de entorno
``` bash
import 'package:flutter_dotenv/flutter_dotenv.dart';
```