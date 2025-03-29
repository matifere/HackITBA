import 'package:flutter/material.dart';

class PrimerInicios extends StatelessWidget {
  const PrimerInicios({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primer Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('¡Bienvenido a la aplicación!'),
            ElevatedButton(
              onPressed: () {
                // Acción al presionar el botón
              },
              child: const Text('Comenzar'),
            ),
          ],
        ),
      ),
    );
  }
}