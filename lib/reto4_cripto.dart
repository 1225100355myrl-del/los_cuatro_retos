import 'dart:convert';
 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 
// ============================================================
// RETO 4: Convertidor de Criptomonedas en Tiempo Real (CoinGecko)
// API pública, sin autenticación:
//   https://api.coingecko.com/api/v3/simple/price
//       ?ids=bitcoin,ethereum,solana&vs_currencies=usd
// Respuesta: {"bitcoin":{"usd":67000}, "ethereum":{"usd":3200}, ...}
// ============================================================
 
class Cripto {
  final String id;
  final String nombre;
  final String simbolo;
  final IconData icono;
  final Color color;
  const Cripto(this.id, this.nombre, this.simbolo, this.icono, this.color);
}
 
const _criptos = [
  Cripto('bitcoin', 'Bitcoin', 'BTC', Icons.currency_bitcoin, Colors.orange),
  Cripto('ethereum', 'Ethereum', 'ETH', Icons.diamond, Colors.indigo),
  Cripto('solana', 'Solana', 'SOL', Icons.bolt, Colors.teal),
];
 
Future<Map<String, double>> obtenerPrecios() async {
  final ids = _criptos.map((c) => c.id).join(',');
  final uri = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=$ids&vs_currencies=usd');
  final r = await http.get(uri);
  if (r.statusCode == 429) {
    throw Exception('Demasiadas consultas. Espera un minuto y reintenta.');
  }
  if (r.statusCode != 200) throw Exception('Error ${r.statusCode}.');
 
  final datos = jsonDecode(r.body) as Map<String, dynamic>;
  return {
    for (final c in _criptos)
      c.id: ((datos[c.id] as Map<String, dynamic>)['usd'] as num).toDouble(),
  };
}
 
class CriptoPage extends StatefulWidget {
  const CriptoPage({super.key});
 
  @override
  State<CriptoPage> createState() => _CriptoPageState();
}
 
class _CriptoPageState extends State<CriptoPage> {
  late Future<Map<String, double>> _futuro;
  final _controlador = TextEditingController(text: '100');
  double _monto = 100;
 
  @override
  void initState() {
    super.initState();
    _futuro = obtenerPrecios();
  }
 
  /// Refresca la pantalla volviendo a pedir los precios.
  void _refrescar() => setState(() => _futuro = obtenerPrecios());
 
  void _cambioMonto(String texto) {
    // tryParse evita que la app truene si el usuario escribe algo inválido.
    final valor = double.tryParse(texto.replaceAll(',', '.')) ?? 0;
    setState(() => _monto = valor < 0 ? 0 : valor);
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
          TextField(
            controller: _controlador,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monto en USD',
              prefixText: '\$ ',
              border: OutlineInputBorder(),
            ),
            onChanged: _cambioMonto,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<Map<String, double>>(
              future: _futuro,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            '${snap.error}'.replaceFirst('Exception: ', ''),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        FilledButton(
                            onPressed: _refrescar,
                            child: const Text('Reintentar')),
                      ],
                    ),
                  );
                }
                final precios = snap.data!;
                return RefreshIndicator(
                  onRefresh: () async {
                    _refrescar();
                    await _futuro;
                  },
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _criptos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final c = _criptos[i];
                      final precio = precios[c.id]!;
                      final fraccion = precio == 0 ? 0 : _monto / precio;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: c.color.withOpacity(0.15),
                            child: Icon(c.icono, color: c.color),
                          ),
                          title: Text('${c.nombre} (${c.simbolo})'),
                          subtitle: Text(
                              'Precio: \$${precio.toStringAsFixed(2)} USD'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                fraccion.toStringAsFixed(6),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(c.simbolo,
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          TextButton.icon(
            onPressed: _refrescar,
            icon: const Icon(Icons.refresh),
            label: const Text('Actualizar precios'),
          ),
        ],
      ),
    );
  }
}
 