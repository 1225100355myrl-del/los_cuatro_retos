import 'dart:convert';
import 'dart:math';
 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 
// ============================================================
// RETO 1: Recomendador de Películas del Fin de Semana (TMDB)
// ------------------------------------------------------------
// 1. Crea una cuenta gratis en https://www.themoviedb.org
// 2. Ve a Configuración > API y copia tu "API Key (v3 auth)"
// 3. Pégala abajo en _apiKey
// ============================================================
const String _apiKey = 'TU_API_KEY_DE_TMDB';
 
class Pelicula {
  final int id;
  final String titulo;
  final String sinopsis;
  final String? posterPath;
  final double calificacion;
  final String fecha;
 
  Pelicula({
    required this.id,
    required this.titulo,
    required this.sinopsis,
    required this.posterPath,
    required this.calificacion,
    required this.fecha,
  });
 
  factory Pelicula.fromJson(Map<String, dynamic> json) {
    return Pelicula(
      id: json['id'] as int,
      titulo: (json['title'] ?? 'Sin título') as String,
      sinopsis: (json['overview'] ?? '') as String,
      posterPath: json['poster_path'] as String?,
      calificacion: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      fecha: (json['release_date'] ?? '') as String,
    );
  }
 
  String? get posterUrl =>
      posterPath == null ? null : 'https://image.tmdb.org/t/p/w500$posterPath';
}
 
/// Servicio que habla con la API de TMDB.
class TmdbService {
  static const _base = 'https://api.themoviedb.org/3';
 
  /// Películas en tendencia de la semana.
  Future<List<Pelicula>> tendencias() async {
    final uri = Uri.parse(
        '$_base/trending/movie/week?api_key=$_apiKey&language=es-MX');
    return _pedir(uri);
  }
 
  /// Películas filtradas por género (según el estado de ánimo).
  Future<List<Pelicula>> porGenero(int generoId) async {
    // Página aleatoria para que no siempre salgan las mismas.
    final pagina = Random().nextInt(5) + 1;
    final uri = Uri.parse('$_base/discover/movie'
        '?api_key=$_apiKey&language=es-MX&sort_by=popularity.desc'
        '&with_genres=$generoId&vote_count.gte=200&page=$pagina');
    return _pedir(uri);
  }
 
  Future<List<Pelicula>> _pedir(Uri uri) async {
    final respuesta = await http.get(uri);
    if (respuesta.statusCode != 200) {
      throw Exception(
          'Error ${respuesta.statusCode}. Revisa tu API key de TMDB.');
    }
    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    final resultados = datos['results'] as List<dynamic>;
    return resultados
        .map((e) => Pelicula.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
 
/// Estados de ánimo y el género de TMDB que les corresponde.
class Animo {
  final String nombre;
  final String emoji;
  final int? generoId; // null = tendencias
  const Animo(this.nombre, this.emoji, this.generoId);
}
 
const _animos = [
  Animo('Tendencias', '🔥', null),
  Animo('Feliz', '😄', 35), // Comedia
  Animo('Aventurero', '🧭', 12), // Aventura
  Animo('Romántico', '💕', 10749), // Romance
  Animo('Con miedo', '😱', 27), // Terror
  Animo('Pensativo', '🤔', 18), // Drama
  Animo('Emocionado', '💥', 28), // Acción
];
 
class PeliculasPage extends StatefulWidget {
  const PeliculasPage({super.key});
 
  @override
  State<PeliculasPage> createState() => _PeliculasPageState();
}
 
class _PeliculasPageState extends State<PeliculasPage> {
  final _servicio = TmdbService();
  Animo _animo = _animos.first;
  Future<List<Pelicula>>? _futuro;
  Pelicula? _alAzar;
 
  @override
  void initState() {
    super.initState();
    _cargar();
  }
 
  void _cargar() {
    setState(() {
      _alAzar = null;
      _futuro = _animo.generoId == null
          ? _servicio.tendencias()
          : _servicio.porGenero(_animo.generoId!);
    });
  }
 
  void _sorpresa(List<Pelicula> lista) {
    if (lista.isEmpty) return;
    setState(() => _alAzar = lista[Random().nextInt(lista.length)]);
  }
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('¿Cómo te sientes hoy?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _animos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final a = _animos[i];
              return ChoiceChip(
                label: Text('${a.emoji} ${a.nombre}'),
                selected: a == _animo,
                onSelected: (_) {
                  _animo = a;
                  _cargar();
                },
              );
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Pelicula>>(
            future: _futuro,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${snap.error}', textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton(
                            onPressed: _cargar, child: const Text('Reintentar')),
                      ],
                    ),
                  ),
                );
              }
              final lista = snap.data ?? [];
              final mostrar = _alAzar != null ? [_alAzar!] : lista;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: () => _sorpresa(lista),
                          icon: const Icon(Icons.casino),
                          label: const Text('Sorpréndeme'),
                        ),
                        if (_alAzar != null) ...[
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () => setState(() => _alAzar = null),
                            child: const Text('Ver lista'),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: mostrar.length,
                      itemBuilder: (_, i) => PeliculaCard(pelicula: mostrar[i]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
 
/// Tarjeta (Card) con póster, título, calificación y sinopsis.
class PeliculaCard extends StatelessWidget {
  final Pelicula pelicula;
  const PeliculaCard({super.key, required this.pelicula});
 
  @override
  Widget build(BuildContext context) {
    final url = pelicula.posterUrl;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 110,
              child: url == null
                  ? const ColoredBox(
                      color: Colors.black12,
                      child: Icon(Icons.movie, size: 40),
                    )
                  : Image.network(
                      url,
                      fit: BoxFit.cover,
                      loadingBuilder: (c, child, p) => p == null
                          ? child
                          : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pelicula.titulo,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(pelicula.calificacion.toStringAsFixed(1)),
                        const SizedBox(width: 12),
                        Text(pelicula.fecha),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pelicula.sinopsis.isEmpty
                          ? 'Sin sinopsis disponible.'
                          : pelicula.sinopsis,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 