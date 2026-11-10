import 'package:flutter/material.dart';
 
import 'reto1_peliculas.dart';
import 'reto2_gatos.dart';
import 'reto3_clima.dart';
import 'reto4_cripto.dart';
 
void main() => runApp(const CuatroRetosApp());
 
class CuatroRetosApp extends StatelessWidget {
  const CuatroRetosApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Los cuatro retos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
 
class HomePage extends StatefulWidget {
  const HomePage({super.key});
 
  @override
  State<HomePage> createState() => _HomePageState();
}
 
class _HomePageState extends State<HomePage> {
  int _indice = 0;
 
  static const _titulos = [
    'Reto 1: Recomendador de Películas',
    'Reto 2: Memes de Gatos',
    'Reto 3: Clima Minimalista',
    'Reto 4: Convertidor Cripto',
  ];
 
  final _pantallas = const [
    PeliculasPage(),
    GatosPage(),
    ClimaPage(),
    CriptoPage(),
  ];
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_indice])),
      // IndexedStack conserva el estado de cada pantalla al cambiar de pestaña.
      body: IndexedStack(index: _indice, children: _pantallas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.movie), label: 'Películas'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'Gatos'),
          NavigationDestination(icon: Icon(Icons.wb_sunny), label: 'Clima'),
          NavigationDestination(
              icon: Icon(Icons.currency_bitcoin), label: 'Cripto'),
        ],
      ),
    );
  }
}