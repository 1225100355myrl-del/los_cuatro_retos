Los cuatro retos – Desarrollo de Aplicaciones Móviles 2026

Alumno: Ramirez Lopez Maria Yazmin 
Matrícula: 1225100355 
Grupo: GTID241 
Fecha de entrega: 13 de noviembre

Aplicación en Flutter con 4 pestañas (una por reto), probada en un emulador de Android (Pixel 8, API 36).

Reto	Archivo	API usada	¿Necesita API key?
1. Recomendador de películas	lib/reto1_peliculas.dart	TMDB	Sí (gratis)
2. Memes de gatos	lib/reto2_gatos.dart	Cataas	No
3. Clima minimalista (+ geolocalización)	lib/reto3_clima.dart	OpenWeatherMap	Sí (gratis)
4. Convertidor de criptomonedas	lib/reto4_cripto.dart	CoinGecko	No
Cómo ejecutar el proyecto
Instala las dependencias: flutter pub get (o flutter pub add http geolocator).
Pega tus API keys en _apiKey de reto1_peliculas.dart (TMDB) y reto3_clima.dart (OpenWeatherMap).
Verifica que android/app/src/main/AndroidManifest.xml tenga, dentro de <manifest> y antes de <application>:
xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
Enciende el emulador y ejecuta: flutter run -d emulator-5554
Capturas de pantalla para demostrar que la app funciona

Capturas generales (2)
 G1 – capturas/G1_dispositivos.png: la terminal de VS Code mostrando flutter devices con el emulador detectado.
 G2 – capturas/G2_flutter_run.png: la terminal mostrando flutter run compilando y la app ya iniciada (mensaje de "Flutter run key commands" o similar).

G1 G2

Reto 1 – Recomendador de Películas (4 capturas)
 R1-1 – capturas/R1_1_tendencias.png: pantalla inicial con la lista de películas en Tendencias, con pósters, título, calificación y sinopsis.
 R1-2 – capturas/R1_2_animo_feliz.png: selecciona un estado de ánimo (por ejemplo 😄 Feliz) y captura la lista de películas filtrada (se deben ver comedias).
 R1-3 – capturas/R1_3_otro_animo.png: selecciona otro ánimo distinto (por ejemplo 😱 Con miedo o 💥 Emocionado) para demostrar que el filtro cambia el resultado.
 R1-4 – capturas/R1_4_sorpresa.png: presiona Sorpréndeme y captura la película al azar (una sola tarjeta con el botón "Ver lista").

R1-1 R1-2 R1-3 R1-4

Reto 2 – Generador de Memes de Gatos (4 capturas)
 R2-1 – capturas/R2_1_gato_inicial.png: la pantalla inicial con el gato y el texto por defecto encima.
 R2-2 – capturas/R2_2_frase_propia.png: escribe tu propia frase (por ejemplo tu nombre o una frase divertida), presiona el ✔ o Enter y captura el gato con tu texto encima.
 R2-3 – capturas/R2_3_tamano_color.png: cambia el tamaño con el control deslizante y el color del texto, y captura el resultado.
 R2-4 – capturas/R2_4_otro_gato.png: presiona Otro gato y captura una imagen distinta con la misma frase.

R2-1 R2-2 R2-3 R2-4

Reto 3 – App del Clima Minimalista (5 capturas)
 R3-1 – capturas/R3_1_cargando.png: (opcional, si logras atraparla) el CircularProgressIndicator mientras carga el clima. Puedes lograrlo presionando buscar y capturando de inmediato.
 R3-2 – capturas/R3_2_clima_ciudad.png: el clima de una ciudad con temperatura, ícono, descripción, sensación térmica, humedad y viento.
 R3-3 – capturas/R3_3_otra_ciudad.png: busca otra ciudad diferente (por ejemplo la tuya) para demostrar que la búsqueda funciona.
 R3-4 – capturas/R3_4_permiso_ubicacion.png: presiona el botón de ubicación 📍 y captura el cuadro de permiso de ubicación de Android.
 R3-5 – capturas/R3_5_ubicacion_auto.png: tras aceptar el permiso, captura el clima obtenido con la ubicación automática (plus del reto). En el emulador, configura primero unas coordenadas: botón ( ⋯ ) > Location > Send.
 R3-6 – capturas/R3_6_error_ciudad.png: escribe una ciudad que no existe (por ejemplo asdfgh) y captura el mensaje "Ciudad no encontrada" para demostrar el manejo de errores.

R3-1 R3-2 R3-3 R3-4 R3-5 R3-6

Reto 4 – Convertidor de Criptomonedas (4 capturas)
 R4-1 – capturas/R4_1_precios.png: la pantalla con el precio en USD de Bitcoin, Ethereum y Solana y el monto por defecto (100 USD) convertido a fracciones.
 R4-2 – capturas/R4_2_monto_1000.png: cambia el monto a 1000 y captura cómo se recalculan las fracciones.
 R4-3 – capturas/R4_3_monto_propio.png: escribe otro monto con decimales (por ejemplo 250.50) para demostrar que la conversión funciona con cualquier valor.
 R4-4 – capturas/R4_4_actualizar.png: presiona Actualizar precios y captura la pantalla después del refresco.

R4-1 R4-2 R4-3 R4-4

Resumen de la lista de verificación
Sección	Capturas mínimas	Capturas completas
General	G1	G1, G2
Reto 1	R1-1, R1-4	R1-1 a R1-4
Reto 2	R2-2	R2-1 a R2-4
Reto 3	R3-2, R3-5	R3-1 a R3-6
Reto 4	R4-1, R4-2	R4-1 a R4-4

Consejo: si no te da tiempo de tomar todas, con las capturas mínimas ya demuestras que cada reto funciona: peticiones a la API, datos reales en pantalla y la interacción principal de cada app.

Qué practica cada reto
Películas: peticiones HTTP con http, parseo de JSON a un modelo (Pelicula.fromJson), FutureBuilder, Card con póster, filtro por estado de ánimo y botón "Sorpréndeme".
Gatos: URL dinámica con Uri.encodeComponent y los parámetros fontSize y fontColor; el parámetro t evita que la caché muestre el gato anterior.
Clima: búsqueda por ciudad, CircularProgressIndicator, manejo de errores (404/401) y ubicación automática con geolocator.
Cripto: endpoint simple/price, double.tryParse, cálculo monto ÷ precio y refresco con setState / RefreshIndicator.
Problemas comunes
Películas no cargan / error 401: revisa que pegaste la API key v3 de TMDB (no el token largo).
Clima da "API key inválida": las keys nuevas de OpenWeatherMap tardan un rato en activarse.
Cripto da "Demasiadas consultas": CoinGecko limita las peticiones gratuitas; espera un minuto.
Gatos no cargan en el emulador: verifica el permiso INTERNET y la conexión del emulador.
