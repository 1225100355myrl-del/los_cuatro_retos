# Los cuatro retos – Desarrollo de Aplicaciones Móviles 2026

**Alumno:** (Ramirez Lopez Maria Yazmin)
**Matrícula:** (1225100355)
**Grupo:** (GTID241)
**Materia:** Desarrollo de Aplicaciones Móviles 2026

Aplicación desarrollada en **Flutter** con cuatro pestañas (una por reto), probada en un emulador de Android (Pixel 8, API 36). Cada reto consume una API pública distinta.

| Reto | Archivo | API usada |
|------|---------|-----------|
| 1. Recomendador de películas | `lib/reto1_peliculas.dart` | TMDB |
| 2. Memes de gatos | `lib/reto2_gatos.dart` | Cataas |
| 3. Clima minimalista (+ geolocalización) | `lib/reto3_clima.dart` | OpenWeatherMap |
| 4. Convertidor de criptomonedas | `lib/reto4_cripto.dart` | CoinGecko |

---

## Cómo ejecutar el proyecto

1. Instala las dependencias: `flutter pub get`
2. Reemplaza las API keys de ejemplo por las tuyas:
   - `lib/reto1_peliculas.dart` → `_apiKey` (TMDB)
   - `lib/reto3_clima.dart` → `_apiKey` (OpenWeatherMap)
3. Enciende un emulador y ejecuta: `flutter run`

Los retos 2 (gatos) y 4 (cripto) no necesitan API key.



## Evidencia de ejecución

Estas capturas muestran el emulador detectado por Flutter y la aplicación compilándose y ejecutándose.

**Dispositivos detectados (`flutter devices`)**

![Dispositivos](capturas/G1_dispositivos.png)

**Aplicación en ejecución (`flutter run`)**

![Flutter run](capturas/G2_flutter_run.png)
---

## Reto 1 – Recomendador de Películas del Fin de Semana

Consume la API de **TMDB** y muestra películas en tarjetas con póster, calificación y sinopsis. Permite filtrar por estado de ánimo y elegir una película al azar.

**Películas en tendencia**

![Tendencias](capturas/R1_1_tendencias.png)

**Filtro por estado de ánimo: Feliz**

![Ánimo feliz](capturas/R1_2_animo_feliz.png)

**Filtro por otro estado de ánimo**

![Otro ánimo](capturas/R1_3_otro_animo.png)

**Película al azar con "Sorpréndeme"**

![Sorpréndeme](capturas/R1_4_sorpresa.png)

---

## Reto 2 – Generador de Memes de Gatos

Consume la API **Cataas**. El texto escrito por el usuario se agrega a la URL para que aparezca sobre la imagen del gato.

**Gato con el texto inicial**

![Gato inicial](capturas/R2_1_gato_inicial.png)

**Gato con una frase personalizada**

![Frase propia](capturas/R2_2_frase_propia.png)

**Cambio de tamaño y color del texto**

![Tamaño y color](capturas/R2_3_tamano_color.png)

**Otro gato con la misma frase**

![Otro gato](capturas/R2_4_otro_gato.png)

---

## Reto 3 – App del Clima Minimalista

Consume la API de **OpenWeatherMap** para mostrar el clima actual por ciudad. Incluye el "plus" de ubicación automática con el paquete `geolocator`.

**Clima de una ciudad**

![Clima ciudad](capturas/R3_2_clima_ciudad.png)

**Búsqueda de otra ciudad**

![Otra ciudad](capturas/R3_3_otra_ciudad.png)

**Permiso de ubicación de Android**

![Permiso ubicación](capturas/R3_4_permiso_ubicacion.png)

**Clima con ubicación automática**

![Ubicación automática](capturas/R3_5_ubicacion_auto.png)

**Manejo de errores: ciudad no encontrada**

![Error ciudad](capturas/R3_6_error_ciudad.png)

---

## Reto 4 – Convertidor de Criptomonedas en Tiempo Real

Consume la API pública de **CoinGecko** para mostrar el precio en USD de Bitcoin, Ethereum y Solana, y calcula cuántas fracciones se comprarían con el monto ingresado.

**Precios actuales y conversión de 100 USD**

![Precios](capturas/R4_1_precios.png)


**Conversión con un monto con decimales**

![Monto propio](capturas/R4_3_monto_propio.png)

**Precios después de actualizar**

![Actualizar](capturas/R4_4_actualizar.png)

---

## Qué se practicó en cada reto

1. **Películas:** peticiones HTTP con `http`, parseo de JSON a un modelo (`Pelicula.fromJson`), `FutureBuilder` y `Card` con póster.
2. **Gatos:** URL dinámica con `Uri.encodeComponent` y los parámetros `fontSize` y `fontColor`.
3. **Clima:** búsqueda por ciudad, `CircularProgressIndicator`, manejo de errores y ubicación con `geolocator`.
4. **Cripto:** endpoint `simple/price`, `double.tryParse`, cálculo monto ÷ precio y refresco con `setState`.
