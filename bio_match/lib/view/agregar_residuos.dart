import 'package:bio_match/view/notificaciones.dart';
import 'package:bio_match/view/pagina_principal.dart';
import 'package:flutter/material.dart';

// Agrega esta clase para manejar los datos de los residuos
class WasteProduct {
  final String name;
  final String description;
  final DateTime date;
  final String category;
  final String precio;
  final String cantidad;

  WasteProduct({
    required this.name,
    required this.description,
    required this.date,
    required this.category,
    required this.precio,
    required this.cantidad,
  });
}

class WasteListScreen extends StatefulWidget {
  @override
  _WasteListScreenState createState() => _WasteListScreenState();
}

class _WasteListScreenState extends State<WasteListScreen> {
  List<WasteProduct> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 241, 240),
      appBar: AppBar(
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
      body: Stack(
        children: [
          WasteListBody(products: products),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () async {
                  final newProduct = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WasteRegistrationScreen(),
                    ),
                  );
                  
                  if (newProduct != null) {
                    setState(() {
                      products.add(newProduct);
                    });
                  }
                },
                backgroundColor: Colors.black,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 2,),
    );
  }
}

class WasteListBody extends StatelessWidget {
  final List<WasteProduct> products;

  const WasteListBody({required this.products});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFD1C6B9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) => WasteItemCard(
                          product: products[index],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WasteItemCard extends StatelessWidget {
  final WasteProduct product;

  const WasteItemCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${product.date.day}/${product.date.month}/${product.date.year}",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  product.category,
                  style: TextStyle(
                    color: Colors.cyan[800],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Modifica tu WasteRegistrationScreen para que devuelva un WasteProduct
class WasteRegistrationScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Residuo')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre del residuo'),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Categoría'),
            ),
             TextField(
              controller: precioController,
              decoration: InputDecoration(labelText: 'Precio'),
            ),
             TextField(
              controller: cantidadController,
              decoration: InputDecoration(labelText: 'Cantidad'),
            ),
            ElevatedButton(
              onPressed: () {
                final newProduct = WasteProduct(
                  name: nameController.text,
                  description: descController.text,
                  date: DateTime.now(),
                  category: categoryController.text,
                  cantidad: cantidadController.text,
                  precio: precioController.text
                );
                Navigator.pop(context, newProduct);
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

// Mantén el resto de las clases (CustomBottomNavBar, WasteTableHeader) igual