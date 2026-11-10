import 'dart:convert';
 
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
 
// ============================================================
// RETO 3: App del Clima "Minimalista" (OpenWeatherMap + geolocator)
// ------------------------------------------------------------
// 1. Crea una cuenta gratis en https://openweathermap.org
// 2. Copia tu API key (My API keys). Puede tardar unos minutos
//    en activarse después de registrarte.
// 3. Pégala abajo en _apiKey
// ============================================================
const String _apiKey = 'TU_API_KEY_DE_OPENWEATHERMAP';
 
class Clima {
  final String ciudad;
  final String pais;
  final double temp;
  final double sensacion;
  final int humedad;
  final double viento; // m/s
  final String descripcion;
  final String icono;
 
  Clima({
    required this.ciudad,
    required this.pais,
    required this.temp,
    required this.sensacion,
    required this.humedad,
    required this.viento,
    required this.descripcion,
    required this.icono,
  });
 
  /// Parseo del JSON de OpenWeatherMap.
  factory Clima.fromJson(Map<String, dynamic> j) {
    final clima = (j['weather'] as List).first as Map<String, dynamic>;
    final main = j['main'] as Map<String, dynamic>;
    return Clima(
      ciudad: j['name'] as String,
      pais: (j['sys']?['country'] ?? '') as String,
      temp: (main['temp'] as num).toDouble(),
      sensacion: (main['feels_like'] as num).toDouble(),
      humedad: (main['humidity'] as num).toInt(),
      viento: ((j['wind']?['speed'] ?? 0) as num).toDouble(),
      descripcion: clima['description'] as String,
      icono: clima['icon'] as String,
    );
  }
}
 
class ClimaService {
  static const _base = 'https://api.openweathermap.org/data/2.5/weather';
 
  Future<Clima> porCiudad(String ciudad) {
    final uri = Uri.parse('$_base?q=${Uri.encodeComponent(ciudad)}'
        '&appid=$_apiKey&units=metric&lang=es');
    return _pedir(uri);
  }
 
  Future<Clima> porCoordenadas(double lat, double lon) {
    final uri = Uri.parse(
        '$_base?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=es');
    return _pedir(uri);
  }
 
  Future<Clima> _pedir(Uri uri) async {
    final r = await http.get(uri);
    if (r.statusCode == 404) throw Exception('Ciudad no encontrada.');
    if (r.statusCode == 401) {
      throw Exception('API key inválida o aún no activada.');
    }
    if (r.statusCode != 200) throw Exception('Error ${r.statusCode}.');
    return Clima.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }
}
 
class ClimaPage extends StatefulWidget {
  const ClimaPage({super.key});
 
  @override
  State<ClimaPage> createState() => _ClimaPageState();
}
 
class _ClimaPageState extends State<ClimaPage> {
  final _servicio = ClimaService();
  final _controlador = TextEditingController(text: 'Mexico City');
 
  bool _cargando = false;
  String? _error;
  Clima? _clima;
 
  @override
  void initState() {
    super.initState();
    _buscarCiudad();
  }
 
  Future<void> _buscarCiudad() async {
    final ciudad = _controlador.text.trim();
    if (ciudad.isEmpty) return;
    await _ejecutar(() => _servicio.porCiudad(ciudad));
  }
 
  /// "Plus": detecta la ubicación automáticamente con geolocator.
  Future<void> _usarUbicacion() async {
    await _ejecutar(() async {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Activa el GPS de tu dispositivo.');
      }
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        throw Exception('Permiso de ubicación denegado.');
      }
      final pos = await Geolocator.getCurrentPosition();
      return _servicio.porCoordenadas(pos.latitude, pos.longitude);
    });
  }
 
  Future<void> _ejecutar(Future<Clima> Function() accion) async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final c = await accion();
      if (!mounted) return;
      setState(() => _clima = c);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }
 
  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controlador,
                  decoration: const InputDecoration(
                    labelText: 'Ciudad',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _buscarCiudad(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _cargando ? null : _buscarCiudad,
                icon: const Icon(Icons.search),
              ),
              IconButton.filledTonal(
                onPressed: _cargando ? null : _usarUbicacion,
                icon: const Icon(Icons.my_location),
                tooltip: 'Usar mi ubicación',
              ),
            ],
          ),
          Expanded(child: Center(child: _contenido())),
        ],
      ),
    );
  }
 
  Widget _contenido() {
    if (_cargando) return const CircularProgressIndicator();
    if (_error != null) {
      return Text(_error!,
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error));
    }
    final c = _clima;
    if (c == null) return const Text('Busca una ciudad');
 
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${c.ciudad}, ${c.pais}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
        Image.network(
          'https://openweathermap.org/img/wn/${c.icono}@4x.png',
          width: 140,
          height: 140,
          errorBuilder: (_, __, ___) => const Icon(Icons.cloud, size: 100),
        ),
        Text('${c.temp.round()}°C',
            style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w200)),
        Text(
          c.descripcion[0].toUpperCase() + c.descripcion.substring(1),
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _dato(Icons.thermostat, 'Sensación', '${c.sensacion.round()}°'),
            _dato(Icons.water_drop, 'Humedad', '${c.humedad}%'),
            _dato(Icons.air, 'Viento', '${(c.viento * 3.6).round()} km/h'),
          ],
        ),
      ],
    );
  }
 
  Widget _dato(IconData icono, String etiqueta, String valor) {
    return Column(
      children: [
        Icon(icono),
        const SizedBox(height: 4),
        Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(etiqueta, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
 