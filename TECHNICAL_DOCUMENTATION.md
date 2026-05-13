# Documentación Técnica: ExchangeRate App

**Versión:** 1.0.0  
**Estado:** Estable  
**Framework:** Flutter (Dart 3.10.4+)  
**Autor:** jorgeanalista2008

---

## 1. Introducción
ExchangeRate es una aplicación multiplataforma diseñada para el monitoreo en tiempo real de las fluctuaciones cambiarias entre el Dólar Estadounidense (USD) y el Bolívar Venezolano (VES). La aplicación destaca por un enfoque en la experiencia de usuario (UX) mediante el uso intensivo de transiciones elásticas y micro-interacciones.

## 2. Arquitectura del Proyecto
El proyecto sigue un patrón de **Composición de Widgets** organizado bajo una estructura de directorios inspirada en *Atomic Design*:

- **Core (`/lib/core`)**: Centraliza la identidad visual (colores y temas).
- **Models (`/lib/models`)**: Define la estructura de datos inmutable.
- **Molecules (`/lib/molecules`)**: Widgets compuestos de mediana complejidad (reutilizables).
- **Pages (`/lib/pages`)**: Orquestadores de pantalla completa que manejan el ciclo de vida y la navegación.

## 3. Especificaciones del Modelo de Datos
### 3.1 DolarModel
Ubicado en `lib/models/dolar_model.dart`, este modelo es el núcleo de la información financiera.

*   **Campos**: `fuente`, `nombre`, `promedio` (double) y `fechaActualizacion` (DateTime opcional).
*   **Lógica de Negocio**: Utiliza un constructor `factory` para la deserialización segura de JSON, implementando una conversión explícita a `double` para evitar errores de tipo comunes en APIs REST.

## 4. Componentes Clave (Molecules)
### 4.1 PowerQuoteWidget
Un componente dinámico que muestra citas de "Las 48 Leyes del Poder".
*   **Gestión de Estado**: Utiliza un `SingleTickerProviderStateMixin` para orquestar animaciones de desvanecimiento (`FadeTransition`).
*   **Lógica de Interacción**: Al detectar un `GestureDetector.onTap`, el widget ejecuta una secuencia `reverse()` -> `setState()` -> `forward()` del controlador de animación para garantizar una transición suave entre frases.

### 4.2 RateCard
Componente visual para mostrar las tasas.
*   **Diseño**: Implementa bordes redondeados (16px) y sombras proyectadas dinámicas basadas en el color de la fuente (Oficial vs Paralelo).

## 5. Flujo de Control y Red
### 5.1 Proceso de Inicialización (`LoadingPage`)
La aplicación implementa un flujo de arranque asíncrono:
1.  **Animación de Entrada**: Un `ScaleTransition` elástico presenta el logo mientras se inicia la petición HTTP.
2.  **Fetch de Datos**: Consume `https://ve.dolarapi.com/v1/dolares` con un timeout de 10 segundos.
3.  **Procesamiento**: Transforma el `List<dynamic>` de la respuesta en un `Map<String, DolarModel>` usando la llave `fuente` para acceso rápido.
4.  **Inyección de Dependencias**: Los datos cargados se pasan directamente al constructor de `HomePage`, evitando estados globales innecesarios.

### 5.2 Manejo de Errores
Se implementó un sistema de reintentos mediante un `SnackBar` persistente y un botón de refresco en la UI, gestionando excepciones de red y códigos de estado HTTP distintos de 200.

## 6. Diseño Visual
*   **Paleta de Colores**: Basada en `AppColors`, utiliza gradientes lineales (`LinearGradient`) para dar profundidad a las superficies.
*   **Tipografía**: Se utiliza un sistema de pesos jerárquicos (Bold para precios, Light para etiquetas) para facilitar la lectura rápida de datos financieros.

## 7. Configuración de Assets
La aplicación utiliza `flutter_launcher_icons` para la generación automatizada de iconos adaptativos en Android e iOS, asegurando que la marca sea consistente en todas las plataformas.

---
*Fin de la documentación técnica.*