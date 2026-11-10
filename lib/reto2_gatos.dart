import 'package:flutter/material.dart';
 
// ============================================================
// RETO 2: Generador de Memes de Gatos (API Cataas)
// Sin API key. La URL cambia según el texto escrito:
//   https://cataas.com/cat/says/HOLA?fontSize=40&fontColor=white
// ============================================================
 
class GatosPage extends StatefulWidget {
  const GatosPage({super.key});
 
  @override
  State<GatosPage> createState() => _GatosPageState();
}
 
class _GatosPageState extends State<GatosPage> {
  final _controlador = TextEditingController(text: '¡Hola mundo!');
  String _texto = '¡Hola mundo!';
  int _semilla = DateTime.now().millisecondsSinceEpoch;
  double _tamano = 40;
  Color _color = Colors.white;
 
  static const _colores = <String, Color>{
    'white': Colors.white,
    'yellow': Colors.yellow,
    'red': Colors.red,
    'black': Colors.black,
  };
 
  /// Construye la URL dinámica. Uri.encodeComponent convierte espacios,
  /// acentos y signos (¡ ? etc.) para que viajen seguros en la URL.
  /// El parámetro "t" cambia en cada gato nuevo para evitar que Flutter
  /// muestre la imagen anterior guardada en caché.
  String get _url {
    final nombreColor =
        _colores.entries.firstWhere((e) => e.value == _color).key;
    final base = _texto.trim().isEmpty
        ? 'https://cataas.com/cat'
        : 'https://cataas.com/cat/says/${Uri.encodeComponent(_texto.trim())}';
    return '$base?fontSize=${_tamano.round()}&fontColor=$nombreColor&t=$_semilla';
  }
 
  void _aplicar() => setState(() => _texto = _controlador.text);
 
  void _otroGato() => setState(() {
        _semilla = DateTime.now().millisecondsSinceEpoch;
        _texto = _controlador.text;
      });
 
  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _controlador,
          maxLength: 60,
          decoration: InputDecoration(
            labelText: 'Escribe tu frase',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.check),
              onPressed: _aplicar,
            ),
          ),
          onSubmitted: (_) => _aplicar(),
        ),
        Row(
          children: [
            const Text('Tamaño'),
            Expanded(
              child: Slider(
                value: _tamano,
                min: 20,
                max: 80,
                divisions: 12,
                label: _tamano.round().toString(),
                onChanged: (v) => setState(() => _tamano = v),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Text('Color'),
            const SizedBox(width: 12),
            for (final c in _colores.values)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: _color == c ? 13 : 15,
                      backgroundColor: c,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              _url,
              key: ValueKey(_url),
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progreso) {
                if (progreso == null) return child;
                return const ColoredBox(
                  color: Colors.black12,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (_, __, ___) => const ColoredBox(
                color: Colors.black12,
                child: Center(
                  child: Text('No se pudo cargar el gato 😿\nRevisa tu internet.',
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _otroGato,
          icon: const Icon(Icons.refresh),
          label: const Text('Otro gato'),
        ),
      ],
    );
  }
}