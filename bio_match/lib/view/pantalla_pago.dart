import 'package:bio_match/classes/producto.dart';
import 'package:bio_match/view/agregar_residuos.dart';
import 'package:flutter/material.dart';

class PantallaPago extends StatelessWidget {
  PantallaPago({
    super.key,
    required this.nombreDelVendedor,
    required this.nombreProducto,
  });

  final String nombreDelVendedor;
  final String nombreProducto;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Producto>(
      future: Producto.getFromFirestore(nombreDelVendedor, nombreProducto),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        final producto = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "CheckOut",
              style: TextStyle(fontFamily: "DoppioOne", fontSize: 27),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WasteItemCard(product: producto),
                Text(
                  "Comisión por uso de la app (2%): \$${(producto.precio * 0.02).truncate()}",
                ),
                Text(
                  "Precio total: \$${(producto.precio * 0.02).truncate() + producto.precio}",
                  style: TextStyle(fontFamily: "DoppioOne", fontSize: 25),
                ),
                SizedBox(height: 200,),
                Center(
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        shape: BoxShape.circle
                        ),
                      ),
                      IconButton(
                      iconSize: 100,
                      onPressed: () {
                        producto.deleteFromFirestore();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.check),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          Colors.greenAccent,
                        ),
                      ),
                    ),
                    ]
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
