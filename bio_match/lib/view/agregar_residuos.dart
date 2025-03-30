import 'package:bio_match/classes/producto.dart';
import 'package:bio_match/classes/user.dart';
import 'package:bio_match/view/notificaciones.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WasteListScreen extends StatefulWidget {
  const WasteListScreen({super.key, required this.username});
  final String username;
  @override
  // ignore: library_private_types_in_public_api
  _WasteListScreenState createState() => _WasteListScreenState();
}

class _WasteListScreenState extends State<WasteListScreen> {
  List<Producto> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 241, 240),
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
      body: Stack(
        children: [
          WasteListBody(products: products, name: widget.username),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () async {
                  final newProduct = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              WasteRegistrationScreen(name: widget.username),
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
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 2,
        username: widget.username,
      ),
    );
  }
}

class WasteListBody extends StatelessWidget {
  final List<Producto> products;
  final String name;
  const WasteListBody({super.key, required this.products, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream:
                          FirebaseFirestore.instance
                              .collection('productos')
                              .where('nombreDelVendedor', isEqualTo: name)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
            
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Expanded(child: Center(child: CircularProgressIndicator()));
                        }
                        if(snapshot.data == null || snapshot.data!.docs.isEmpty) {
                          return Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Stock vacío", style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'DoppioOne',
                                    color: Colors.black87,
                                  ),),
                                  Text(
                                    'Para comezar a agregar residuos, presiona el botón de agregar.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
            
                        final productos =
                            snapshot.data!.docs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return Producto(
                                categoria: data['categoria'] ?? '',
                                nombre: data['nombre'] ?? '',
                                descripcion: data['descripcion'] ?? '',
                                direccion: data['direccion'] ?? '',
                                nombreDelVendedor:
                                    data['nombreDelVendedor'] ?? '',
                                cantidad: (data['cantidad'] ?? 0).toInt(),
                                ingreso:
                                    (data['ingreso'] as Timestamp).toDate(),
                                expiracion:
                                    (data['expiracion'] as Timestamp)
                                        .toDate(),
                                precio: (data['precio'] ?? 0.0).toDouble(),
                              );
                            }).toList();
            
                        return ListView.builder(
                          itemCount: productos.length,
                          itemBuilder:
                              (context, index) =>
                                  WasteItemCard(product: productos[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WasteItemCard extends StatelessWidget {
  final Producto product;

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
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\$${product.precio}",
                  style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'DoppioOne',),
                ),
                Text(
                  product.nombre,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "${product.cantidad} Kg",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  product.descripcion,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: product.categoria  == "Restos de café" ?  Colors.brown.withOpacity(0.2) : product.categoria == "Restos animales" ? Colors.red.withOpacity(0.2) : Colors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  product.categoria,
                  style: TextStyle(color: Colors.cyan[800], fontSize: 12),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "${product.ingreso.day}/${product.ingreso.month}/${product.ingreso.year}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 15),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "${product.expiracion.day}/${product.expiracion.month}/${product.expiracion.year}",
                  style: TextStyle(color: Colors.red[600], fontSize: 15),
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

  WasteRegistrationScreen({super.key, required this.name});
  final String name;

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
            DropdownButtonFormField(
              items: [
                DropdownMenuItem(child: Text('Verduras'), value: 'Verduras'),
                DropdownMenuItem(
                  child: Text('Restos animales'),
                  value: 'Restos animales',
                ),
                DropdownMenuItem(
                  child: Text('Restos de café'),
                  value: 'Restos de café',
                ),
              ],
              onChanged: (value) {
                categoryController.text = value.toString();
                print(categoryController.text);
              },

              hint: Text("Categoria"),
            ),

            TextField(
              controller: cantidadController,
              decoration: InputDecoration(labelText: 'Cantidad (en Kg)'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Añade async aquí
                if (categoryController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selecciona una categoría')),
                  );
                  return;
                }

                try {
                  final newProduct = Producto(
                    nombreDelVendedor: name,
                    nombre: nameController.text,
                    descripcion: descController.text,
                    ingreso: DateTime.now(),
                    expiracion: DateTime.now().add(Duration(days: 1)),
                    categoria: categoryController.text,
                    cantidad: int.tryParse(cantidadController.text) ?? 0,
                    precio: // Cambia esto por el valor real
                        categoryController.text == 'Verduras'
                            ? 596.0
                            : categoryController.text == 'Restos animales'
                            ? 330.0
                            : 0.0,
                    direccion: await User("", "").getUserDir(name),
                  ); // Tus parámetros actuales

                  await newProduct.sendToFirestore(); // Añade await aquí
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al guardar: $e')),
                  );
                }
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
