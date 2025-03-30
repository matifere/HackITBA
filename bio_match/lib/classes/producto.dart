import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  String? id;
  String categoria;
  String nombre;
  String descripcion;
  String direccion;
  String nombreDelVendedor;
  int cantidad;
  DateTime ingreso;
  DateTime expiracion;
  double precio;

  Producto({
        this.id, // Añadido ID como parámetro opcional

    required this.categoria,
    required this.nombre,
    required this.descripcion,
    required this.direccion,
    required this.nombreDelVendedor,
    required this.cantidad,
    required this.ingreso,
    required this.expiracion,
    required this.precio,
  });

  set precioSetter(double value) {
    precio = value;
  }

  set categoriaSetter(String value) {
    categoria = value;
  }

  set nombreSetter(String value) {
    nombre = value;
  }

  set descripcionSetter(String value) {
    descripcion = value;
  }

  set direccionSetter(String value) {
    direccion = value;
  }

  set nombreDelVendedorSetter(String value) {
    nombreDelVendedor = value;
  }

  set cantidadSetter(int value) {
    cantidad = value;
  }

  set ingresoSetter(DateTime value) {
    ingreso = value;
  }

  set expiracionSetter(DateTime value) {
    expiracion = value;
  }

  String get categoriaGetter => categoria;
  String get nombreGetter => nombre;
  String get descripcionGetter => descripcion;
  String get direccionGetter => direccion;
  String get nombreDelVendedorGetter => nombreDelVendedor;
  int get cantidadGetter => cantidad;
  DateTime get ingresoGetter => ingreso;
  DateTime get expiracionGetter => expiracion;
  double get precioGetter => precio;

  Map<String, dynamic> toMap() {
    return {
      'categoria': categoria,
      'nombre': nombre,
      'descripcion': descripcion,
      'direccion': direccion,
      'nombreDelVendedor': nombreDelVendedor,
      'cantidad': cantidad,
      'ingreso': Timestamp.fromDate(ingreso), // Conversión clave
      'expiracion': Timestamp.fromDate(expiracion),
      'precio': precio,
    };
  }

  Future<void> sendToFirestore() async {
    try {
      if (precio < 0) throw Exception("Precio no válido");

      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('productos')
          .add(toMap());
      print("Documento ID: ${docRef.id}");
    } catch (e) {
      print("Error en Firestore: $e");
      throw e; // Propaga el error para manejo en UI
    }
  }

  factory Producto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Producto(
      id: doc.id, // Obtenemos el ID del documento
      categoria: data['categoria'] as String,
      nombre: data['nombre'] as String,
      descripcion: data['descripcion'] as String,
      direccion: data['direccion'] as String,
      nombreDelVendedor: data['nombreDelVendedor'] as String,
      cantidad: (data['cantidad'] as num).toInt(),
      ingreso: (data['ingreso'] as Timestamp).toDate(),
      expiracion: (data['expiracion'] as Timestamp).toDate(),
      precio: (data['precio'] as num).toDouble(),
    );
  }

    Future<void> deleteFromFirestore() async {


    try {
      await FirebaseFirestore.instance
          .collection('productos')
          .doc(id!)
          .delete();
      print('Producto eliminado correctamente');
    } catch (e) {
      print('Error al eliminar producto: $e');
      throw e;
    }
  }


  // Método estático para obtener producto
  static Future<Producto> getFromFirestore(
    String nombreDelVendedor,
    String nombre,
  ) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('productos')
          .where('nombreDelVendedor', isEqualTo: nombreDelVendedor)
          .where('nombre', isEqualTo: nombre)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Producto no encontrado');
      }

      return Producto.fromFirestore(querySnapshot.docs.first);
    } catch (e) {
      print('Error obteniendo producto: $e');
      throw e;
    }
  }
}
