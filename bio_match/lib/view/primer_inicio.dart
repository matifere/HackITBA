import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class PrimerInicio extends StatelessWidget {
  const PrimerInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primer Inicio', style: TextStyle(),),
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
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('wasa').doc('wasa').snapshots(),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData ? '¡Hola, ${snapshot.data!.get('wasa')}!' : 'Cargando...',
                    style: const TextStyle(fontSize: 20),
                  );	
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}