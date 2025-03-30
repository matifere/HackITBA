import 'package:bio_match/view/mapa.dart';
import 'package:flutter/material.dart';
import 'package:bio_match/view/agregar_residuos.dart'; // Importa la pantalla de lista de residuos
import 'package:bio_match/view/notificaciones.dart'; // Importa la pantalla de lista de residuos

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key, required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0EEF1), // Color del fondo general
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'BioMatch',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: CategorySelectionBody(username: username),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 1,
        username: username,
      ),
    );
  }
}

class CategorySelectionBody extends StatelessWidget {
  const CategorySelectionBody({super.key, required this.username});
  final String username; // Cambia esto por el nombre de usuario real

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Hola $username!",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'DoppioOne',
                color: Colors.black87,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selecciona la categoría que te gustaría reutilizar!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'DoppioOne',
                color: Colors.black87,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: 8,
                children: [
                  Expanded(
                    child: Image.asset("assets/images/map.png"),
                  ),
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CategoryButton('Verduras y frutas', Colors.cyan),
                      CategoryButton('Restos animales', Colors.pink),
                    ],
                  ),
                  CategoryButton('Restos de café', Colors.brown),
                  SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String text;
  final Color color;

  const CategoryButton(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Acción cuando se presiona el botón
      },
      child: Container(
        height: 50,
        
        decoration: BoxDecoration(
          
          color: color.withOpacity(.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
        spreadRadius: 2,
        blurRadius: 2,
        offset: Offset(1, 3)
            )
          ]
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontFamily: 'DoppioOne'),
            ),
          ),
        ),
      ),
    );
  }
}
