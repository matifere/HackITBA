import 'dart:async';
import 'dart:convert';
import 'package:bio_match/view/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class Mapa extends StatefulWidget {
  Mapa({super.key, required this.username});
  String username;

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-34.602536503444846, -58.411559814725344),
    zoom: 14,
  );

  late final GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};
  final _debouncer = Debouncer(milliseconds: 500);
  String _sessionToken = const Uuid().v4();
  bool _isLoading = false;

  // Elige el color que quieras para los marcadores aquí
  Color _markerColor = Colors.green;  // Puedes cambiar este valor

  static const String _placesApiKey = 'AIzaSyCmJaeIx_WlTXasB0MHULv6TGPYE5C4trY';
  static const String _placesBaseUrl =
      'https://maps.googleapis.com/maps/api/place';

  @override
  void initState() {
    super.initState();
    _addProductMarkers();
    _getUserLocation();

    // Escuchar cambios en la colección de productos
    FirebaseFirestore.instance
        .collection('productos')
        .snapshots() // Escucha en tiempo real
        .listen((snapshot) {
      // Cuando hay un cambio, recargar los marcadores
      _addProductMarkers();
    });
  }

  Future<List<Map<String, dynamic>>> obtenerProductos() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('productos')
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  LatLng _parseLatLng(String coordenadas) {
    try {
      String cleanStr = coordenadas.replaceAll('LatLng(', '').replaceAll(')', '');
      List<String> partes = cleanStr.split(',');
      double lat = double.parse(partes[0].trim());
      double lng = double.parse(partes[1].trim());

      return LatLng(lat, lng);
    } catch (e) {
      throw FormatException('Formato inválido: $coordenadas');
    }
  }

  Future<void> _addProductMarkers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('productos')
          .get();

      // Limpia los marcadores actuales antes de agregar los nuevos
      setState(() {
        _markers.clear();
      });

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('direccion')) {
          final String coordenadas = data['direccion'];
          final String categoria = data['categoria'];
          try {
            LatLng position = _parseLatLng(coordenadas);

            setState(() {
              _markers.add(
                Marker(
                  onTap: () {

                  },
                  markerId: MarkerId(doc.id),
                  position: position,
                  infoWindow: InfoWindow(
                    title: data['name'] ?? 'Producto sin nombre',
                    snippet: data['descripcion'] ?? 'Sin descripción',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      _getHueFromColor(categoria)),
                ),
              );
            });
          } catch (e) {
            print('Error con documento ${doc.id}: $e');
          }
        }
      }
    } catch (e) {
      _showErrorSnackbar('Error cargando productos: ${e.toString()}');
    }
  }

  double _getHueFromColor(String categoria) {
    // Convertir el color a un valor de matiz para Google Maps
    if (categoria == "Restos animales") {
      return BitmapDescriptor.hueRose;
    } else if (categoria == "Verduras") {
      return BitmapDescriptor.hueGreen;
    } else if (categoria == "Restos de café") {
      return BitmapDescriptor.hueOrange;
    }
    return BitmapDescriptor.hueRed;
  }

  Future<void> _getUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      _updateCamera(position);
      _addUserMarker(position);
    } catch (e) {
      _showErrorSnackbar('Error obteniendo ubicación: ${e.toString()}');
    }
  }

  void _updateCamera(Position position) {
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        14,
      ),
    );
  }

  void _addUserMarker(Position position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: "Tu posición actual"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              _getHueFromColor("messi")),
        ),
      );
    });
  }

  Future<void> _searchLocation(String input) async {
    if (input.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final places = await _fetchPlaces(input);
      if (places.isNotEmpty) {
        await _handlePlaceSelection(places.first['place_id']);
      }
    } catch (e) {
      _showErrorSnackbar('Error en la búsqueda: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<dynamic>> _fetchPlaces(String input) async {
    final response = await http.get(Uri.parse(
        '$_placesBaseUrl/autocomplete/json?'
        'input=$input&key=$_placesApiKey&sessiontoken=$_sessionToken'));

    return jsonDecode(response.body)['predictions'] ?? [];
  }

  Future<void> _handlePlaceSelection(String placeId) async {
    final details = await _getPlaceDetails(placeId);
    final location = details['geometry']['location'];
    final latLng = LatLng(location['lat'], location['lng']);

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(placeId),
          position: latLng,
          infoWindow: InfoWindow(title: details['name']),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              _getHueFromColor("Verdura")),
        ),
      );
    });

    _mapController.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
    _sessionToken = const Uuid().v4(); // Reset session token
  }

  Future<Map<String, dynamic>> _getPlaceDetails(String placeId) async {
    final response = await http.get(Uri.parse(
        '$_placesBaseUrl/details/json?'
        'place_id=$placeId&key=$_placesApiKey'));

    return jsonDecode(response.body)['result'];
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: _markers,
              onMapCreated: (controller) => _mapController = controller,
            ),
            _buildSearchBar(),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0, username: widget.username),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Mi ubicación',
        onPressed: _getUserLocation,
        child: const Icon(Icons.location_searching),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: Material(
        elevation: 4,
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar ubicación...',
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _searchLocation(_searchController.text),
            ),
          ),
          onChanged: (value) => _debouncer.run(() => _searchLocation(value)),
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
