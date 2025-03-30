import 'package:bio_match/classes/producto.dart';
import 'package:bio_match/view/mapa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bio_match/view/agregar_residuos.dart'; // Importa la pantalla de lista de residuos
import 'package:bio_match/view/notificaciones.dart'; // Importa la pantalla de lista de residuos

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key, required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(child: Scaffold(
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
  ), onWillPop: ()async{return false;});
  }

  Scaffold newMethod() {
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
                  Expanded(child: Image.asset("assets/images/map.png")),
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CategoryButton('Verduras', Colors.cyan),
                      CategoryButton('Restos animales', Colors.pink),
                    ],
                  ),
                  SizedBox(
                    width: 230,
                    child: CategoryButton('Restos de café', Colors.brown),
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showVegetablesDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Vegetales'),
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('productos')
                      .where('categoria', isEqualTo: 'Verduras')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final productos =
                    snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Producto(
                        categoria: data['categoria'],
                        nombre: data['nombre'],
                        descripcion: data['descripcion'],
                        direccion: data['direccion'],
                        nombreDelVendedor: data['nombreDelVendedor'],
                        cantidad: (data['cantidad'] ?? 0).toInt(),
                        ingreso: (data['ingreso'] as Timestamp).toDate(),
                        expiracion: (data['expiracion'] as Timestamp).toDate(),
                        precio: (data['precio'] ?? 0.0).toDouble(),
                      );
                    }).toList();

                return productos.isEmpty
                    ? const Text('No hay productos de verduras')
                    : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: productos.length,
                        itemBuilder:
                            (context, index) =>
                                WasteItemCard(product: productos[index]),
                      ),
                    );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
  );
}
void showAnimalDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Restos Animales'),
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('productos')
                      .where('categoria', isEqualTo: 'Restos animales')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final productos =
                    snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Producto(
                        categoria: data['categoria'],
                        nombre: data['nombre'],
                        descripcion: data['descripcion'],
                        direccion: data['direccion'],
                        nombreDelVendedor: data['nombreDelVendedor'],
                        cantidad: (data['cantidad'] ?? 0).toInt(),
                        ingreso: (data['ingreso'] as Timestamp).toDate(),
                        expiracion: (data['expiracion'] as Timestamp).toDate(),
                        precio: (data['precio'] ?? 0.0).toDouble(),
                      );
                    }).toList();

                return productos.isEmpty
                    ? const Text('No hay productos de verduras')
                    : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: productos.length,
                        itemBuilder:
                            (context, index) =>
                                WasteItemCard(product: productos[index]),
                      ),
                    );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
  );
}
void showCafeDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Restos de Café'),
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('productos')
                      .where('categoria', isEqualTo: 'Restos de café')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final productos =
                    snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Producto(
                        categoria: data['categoria'],
                        nombre: data['nombre'],
                        descripcion: data['descripcion'],
                        direccion: data['direccion'],
                        nombreDelVendedor: data['nombreDelVendedor'],
                        cantidad: (data['cantidad'] ?? 0).toInt(),
                        ingreso: (data['ingreso'] as Timestamp).toDate(),
                        expiracion: (data['expiracion'] as Timestamp).toDate(),
                        precio: (data['precio'] ?? 0.0).toDouble(),
                      );
                    }).toList();

                return productos.isEmpty
                    ? const Text('No hay productos de verduras')
                    : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: productos.length,
                        itemBuilder:
                            (context, index) =>
                                WasteItemCard(product: productos[index]),
                      ),
                    );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
  );
}
class CategoryButton extends StatelessWidget {
  final String text;
  final Color color;

  const CategoryButton(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        text == 'Verduras'  ? showVegetablesDialog(context)  : null;
        text == 'Restos animales'  ? showAnimalDialog(context)  : null;
        text == 'Restos de café'  ? showCafeDialog(context)  : null;

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
              offset: Offset(1, 3),
            ),
          ],
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
