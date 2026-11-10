Los cuatro retos – Desarrollo de Aplicaciones Móviles 2026

Alumno: (escribe tu nombre completo) Matrícula: (tu matrícula) Grupo: (tu grupo) Materia: Desarrollo de Aplicaciones Móviles 2026

Aplicación desarrollada en Flutter con cuatro pestañas (una por reto), probada en un emulador de Android (Pixel 8, API 36). Cada reto consume una API pública distinta.

Reto	Archivo	API usada
1. Recomendador de películas	lib/reto1_peliculas.dart	TMDB
2. Memes de gatos	lib/reto2_gatos.dart	Cataas
3. Clima minimalista (+ geolocalización)	lib/reto3_clima.dart	OpenWeatherMap
4. Convertidor de criptomonedas	lib/reto4_cripto.dart	CoinGecko
Cómo ejecutar el proyecto
Instala las dependencias: flutter pub get
Reemplaza las API keys de ejemplo por las tuyas:
lib/reto1_peliculas.dart → _apiKey (TMDB)
lib/reto3_clima.dart → _apiKey (OpenWeatherMap)
Enciende un emulador y ejecuta: flutter run

Los retos 2 (gatos) y 4 (cripto) no necesitan API key.

Reto 1 – Recomendador de Películas del Fin de Semana

Consume la API de TMDB y muestra películas en tarjetas con póster, calificación y sinopsis. Permite filtrar por estado de ánimo y elegir una película al azar.

Películas en tendencia

Tendencias

Filtro por estado de ánimo: Feliz

Ánimo feliz

Filtro por otro estado de ánimo

Otro ánimo

Película al azar con "Sorpréndeme"

Sorpréndeme

Reto 2 – Generador de Memes de Gatos

Consume la API Cataas. El texto escrito por el usuario se agrega a la URL para que aparezca sobre la imagen del gato.

Gato con el texto inicial

Gato inicial

Gato con una frase personalizada

Frase propia

Cambio de tamaño y color del texto

Tamaño y color

Otro gato con la misma frase

Otro gato

Reto 3 – App del Clima Minimalista

Consume la API de OpenWeatherMap para mostrar el clima actual por ciudad. Incluye el "plus" de ubicación automática con el paquete geolocator.

Clima de una ciudad

Clima ciudad

Búsqueda de otra ciudad

Otra ciudad

Permiso de ubicación de Android

Permiso ubicación

Clima con ubicación automática

Ubicación automática

Manejo de errores: ciudad no encontrada

Error ciudad

Reto 4 – Convertidor de Criptomonedas en Tiempo Real

Consume la API pública de CoinGecko para mostrar el precio en USD de Bitcoin, Ethereum y Solana, y calcula cuántas fracciones se comprarían con el monto ingresado.

Precios actuales y conversión de 100 USD

Precios

Conversión con un monto de 1000 USD

Monto 1000

Conversión con un monto con decimales

Monto propio

Precios después de actualizar

Actualizar

Qué se practicó en cada reto
Películas: peticiones HTTP con http, parseo de JSON a un modelo (Pelicula.fromJson), FutureBuilder y Card con póster.
Gatos: URL dinámica con Uri.encodeComponent y los parámetros fontSize y fontColor.
Clima: búsqueda por ciudad, CircularProgressIndicator, manejo de errores y ubicación con geolocator.
Cripto: endpoint simple/price, double.tryParse, cálculo monto ÷ precio y refresco con setState.
