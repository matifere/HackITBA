
import 'package:cloud_firestore/cloud_firestore.dart';
class Producto {
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
  set ingresoSetter(DateTime value){
    ingreso = value;
  }
  set expiracionSetter(DateTime value){
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
      'ingreso' : ingreso,
      'expiracion' : expiracion,
      'precio' : precio,
    };
  }

  void sendToFirestore(){
    FirebaseFirestore.instance.collection('productos').add(toMap()).then((value) {
      print("Producto agregado con ID: ${value.id}");
    }).catchError((error) {
      print("Error al agregar producto: $error");
    });
  }
  void getFromFirestore(String nombreDelVendedor, String nombre) async {
    //obtiene la referencia a un producto en la base de datos donde tiene el mismo nombre y vendedor
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('productos').where('nombreDelVendedor', isEqualTo: nombreDelVendedor).where('nombre', isEqualTo: nombre).get().then((value) {
      return value.docs.first;
    });
  }
  
}