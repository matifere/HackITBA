import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PlacesApiGoogle extends StatefulWidget {
  @override
  State<PlacesApiGoogle> createState() => PlacesApiGoogleState();
}

class PlacesApiGoogleState extends State<PlacesApiGoogle> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  List<dynamic> _placePredictions = [];
  bool _isLoading = false;
  String _sessionToken = '';
  final Uuid _uuid = Uuid();

  static const String _apiKey = 'AIzaSyCmJaeIx_WlTXasB0MHULv6TGPYE5C4trY';

  @override
  void initState() {
    super.initState();
    _sessionToken = _uuid.v4();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _debouncer.run(() {
      if (_searchController.text.isNotEmpty) {
        _getPlacePredictions(_searchController.text);
      } else {
        setState(() => _placePredictions = []);
      }
    });
  }

  Future<void> _getPlacePredictions(String input) async {
    if (input.isEmpty) return;

    setState(() => _isLoading = true);
    
    try {
      final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$input&key=$_apiKey&sessiontoken=$_sessionToken'
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _placePredictions = data['predictions'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error: ${e.toString()}');
    }
  }

  Future<void> _selectPlace(String placeId, String description) async {
    try {
      final locations = await locationFromAddress(description);
      if (locations.isNotEmpty) {
        final location = locations.first;
        
        // Cierra el teclado y actualiza la UI
        FocusScope.of(context).unfocus();
        setState(() {
          _searchController.text = description;
          _placePredictions = [];
          _sessionToken = _uuid.v4(); // Nuevo token para próxima búsqueda
        });

        // Aquí tu lógica con las coordenadas
        print('Coordenadas: ${location.latitude}, ${location.longitude}');
      }
    } catch (e) {
      _showError('Error al obtener coordenadas: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildSuggestionsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(30),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar ubicación...',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.white.withOpacity(0.9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15, 
              horizontal: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    if (_isLoading) {
      return const CircularProgressIndicator();
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _placePredictions.length,
        itemBuilder: (context, index) {
          final place = _placePredictions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(place['description']),
              onTap: () => _selectPlace(
                place['place_id'],
                place['description'],
              ),
            ),
          );
        },
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

  void dispose() {
    _timer?.cancel();
  }
}