# 💱 ExchangeRate - Monitor de Divisas

ExchangeRate es una solución móvil multiplataforma desarrollada con **Flutter** para el seguimiento preciso y en tiempo real de las tasas de cambio (USD/VES) en Venezuela. La aplicación centraliza datos de fuentes oficiales y paralelas, ofreciendo una experiencia de usuario fluida mediante animaciones avanzadas y una calculadora integrada.

✨ Características principales
*   **Sincronización en tiempo real:** Integración con `DolarAPI` para obtener cotizaciones actualizadas (BCV y Paralelo).
*   **Calculadora Dual Dinámica:** Conversión instantánea entre USD y VES con capacidad de conmutación de tasa y sentido de conversión (Swap).
*   **UX/UI Premium:** Interfaz basada en **Material Design 3** con paleta de colores personalizada, gradientes y componentes visuales reactivos.
*   **Sistema de Animaciones:** Implementación de `FadeTransition`, `ScaleTransition` y `RotationTransition` para una navegación fluida.
*   **Widget Inspiracional:** Componente interactivo que gestiona estados locales para mostrar citas dinámicas de "Las 48 Leyes del Poder".

📸 Capturas de pantalla
Pendiente de agregar capturas de pantalla de la aplicación en funcionamiento.

🛠️ Tecnologías y dependencias
Tecnología	Versión	Descripción
Flutter	Dart ^3.10.4	Framework principal de desarrollo UI
http	^1.2.0	Cliente HTTP para consumo de la API
intl	^0.19.0	Formateo de fechas y localización
cupertino_icons	^1.0.8	Iconos estilo iOS
Dependencias de desarrollo
Paquete	Versión	Descripción
flutter_test	SDK	Framework de pruebas
flutter_launcher_icons	0.13.1	Generador de iconos de la aplicación
flutter_lints	6.0.0	Reglas de linting para Dart
📁 Estructura del proyecto
exchangerate/
├── android/ # Configuración plataforma Android
├── assets/
│ └── icons/
│ └── sflogo.png # Logo/icono de la aplicación
├── ios/ # Configuración plataforma iOS
├── lib/ # Código fuente principal (Dart)
│ ├── main.dart # Punto de entrada de la aplicación
│ ├── core/
│ │ ├── app_colors.dart # Paleta de colores constantes
│ │ └── app_theme.dart # Configuración del tema Material 3
│ ├── models/
│ │ └── dolar_model.dart # Modelo de datos para las tasas de cambio
│ ├── molecules/
│ │ ├── calculator_widget.dart # Widget de la calculadora de divisas
│ │ ├── power_quote_widget.dart # Widget de frases motivadoras
│ │ └── rate_card.dart # Tarjeta de visualización de tasas
│ └── pages/
│ ├── home_page.dart # Pantalla principal con tasas y calculadora
│ └── loading_page.dart # Pantalla de carga/splash con fetch de API
├── linux/ # Configuración plataforma Linux
├── macos/ # Configuración plataforma macOS
├── web/ # Configuración plataforma Web
├── windows/ # Configuración plataforma Windows
├── test/ # Directorio de pruebas
├── pubspec.yaml # Dependencias y configuración del proyecto
└── analysis_options.yaml # Reglas del analizador Dart

text


---

## 🔌 API utilizada

La aplicación consume la API pública de [DolarAPI Venezuela](https://ve.dolarapi.com):

| Parámetro | Detalle |
|-----------|---------|
| **Endpoint** | `https://ve.dolarapi.com/v1/dolares` |
| **Método** | GET |
| **Formato de respuesta** | JSON (array de objetos) |
| **Timeout** | 10 segundos |
| **Manejo de errores** | SnackBar con botón de reintento |

### Modelo de datos (DolarModel)

```dart
class DolarModel {
  final String fuente;               // Fuente (ej: "oficial", "paralelo")
  final String nombre;               // Nombre visible
  final double promedio;             // Tasa de cambio promedio
  final DateTime? fechaActualizacion; // Fecha de última actualización
}
🚀 Instalación y ejecución
Requisitos previos
Flutter SDK (Dart ^3.10.4 o superior)
Android Studio o Xcode (para desarrollo móvil)
Chrome (para ejecución web)
Un editor como VS Code con la extensión de Flutter
Pasos de instalación
bash

# 1. Clonar el repositorio
git clone https://github.com/jorgeanalista2008/exchangerate.git

# 2. Navegar al directorio del proyecto
cd exchangerate

# 3. Instalar las dependencias
flutter pub get

# 4. Generar los iconos de la aplicación
flutter pub run flutter_launcher_icons
Ejecutar la aplicación
bash

# Ejecutar en dispositivo/emulador conectado
flutter run

# Ejecutar en plataforma específica
flutter run -d chrome     # Web
flutter run -d macos      # macOS
flutter run -d windows    # Windows
flutter run -d linux      # Linux
flutter run -d <device_id> # Dispositivo específico
Compilar para producción
bash

# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios

# Web
flutter build web

# macOS
flutter build macos

# Windows
flutter build windows

# Linux
flutter build linux
🏗️ Arquitectura
El proyecto sigue una arquitectura basada en widgets con una organización inspirada en Atomic Design:

pages/ — Widgets a nivel de pantalla (páginas completas)
molecules/ — Widgets compuestos reutilizables (componentes intermedios)
models/ — Clases de datos y modelos de la aplicación
core/ — Tema, colores y constantes compartidas
Gestión de estado
Actualmente la aplicación utiliza setState para la gestión del estado. Para proyectos futuros o escalabilidad, se recomienda migrar a soluciones como Provider, Riverpod o Bloc.

📋 Roadmap y mejoras sugeridas
 Agregar pruebas unitarias y de widgets
 Implementar caché local para funcionamiento sin conexión (Hive, SharedPreferences)
 Migrar la URL de la API a un archivo de configuración o servicio dedicado
 Agregar notificaciones push cuando la tasa de cambio varíe significativamente
 Implementar gráficos históricos de la tasa de cambio
 Agregar soporte para múltiples monedas adicionales (EUR, COP, BRL)
 Incluir archivo de licencia (MIT, Apache 2.0, etc.)
 Configurar CI/CD (GitHub Actions)
 Migrar a un gestor de estado más robusto (Provider/Riverpod/Bloc)
 Agregar capturas de pantalla reales al README
👤 Autor
jorgeanalista2008

GitHub: https://github.com/jorgeanalista2008
📄 Licencia
Este proyecto actualmente no cuenta con un archivo de licencia. Se recomienda agregar uno para definir los términos de uso y distribución del código.

🤝 Contribuciones
Las contribuciones son bienvenidas. Si deseas colaborar:

Haz un fork del repositorio
Crea una rama para tu funcionalidad (git checkout -b feature/nueva-funcionalidad)
Realiza tus cambios y haz commit (git commit -m 'Agregar nueva funcionalidad')
Haz push a la rama (git push origin feature/nueva-funcionalidad)
Abre un Pull Request
Desarrollado con 💚 usando Flutter para la comunidad venezolana