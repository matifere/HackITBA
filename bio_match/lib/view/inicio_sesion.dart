import 'dart:async';
import 'dart:convert';
import 'package:bio_match/classes/user.dart';
import 'package:bio_match/view/pagina_principal.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final _formKey = GlobalKey<FormState>();
  late User user;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  List<dynamic> _placePredictions = [];
  bool _isLoading = false;
  String _sessionToken = '';
  final Uuid _uuid = Uuid();
  LatLng? _selectedLocation;

  static const String _apiKey = 'AIzaSyCmJaeIx_WlTXasB0MHULv6TGPYE5C4trY';

  @override
  void initState() {
    super.initState();
    user = User(" ", " ");
    user.setName(" ");
    user.setDir(" ");
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
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
        'input=$input&key=$_apiKey&sessiontoken=$_sessionToken'
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
      _showError('Error de búsqueda: ${e.toString()}');
    }
  }

  Future<void> _selectPlace(String description) async {
    try {
      final locations = await locationFromAddress(description);
      if (locations.isNotEmpty) {
        final location = locations.first;
        FocusScope.of(context).unfocus();
        setState(() {
          _searchController.text = description;
          _placePredictions = [];
          _sessionToken = _uuid.v4();
          _selectedLocation = LatLng(location.latitude, location.longitude);
          user.dir = _selectedLocation.toString();
        });
      }
    } catch (e) {
      _showError('Error al obtener coordenadas: ${e.toString()}');
    }
  }

  Future<void> _submitForm() async {
    if (_selectedLocation == null) {
      _showError('Por favor selecciona una ubicación válida');
      return;
    }

    setState(() => _isLoading = true);

    try {
      user.name = _nameController.text.trim();
      
      await user.sendToFirestore();
      
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CategorySelectionScreen(
            username: user.name.toString(),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showError('Error al guardar los datos: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      )
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
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
            _buildHeader(),
            _buildNameInput(),
            _buildLocationSearch(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Último paso...',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'DoppioOne',
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Completa tu perfil',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'DoppioOne',
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Nombre de usuario',
          hintText: 'Ej: usuario123',
          prefixIcon: Icon(Icons.person),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor ingresa un nombre de usuario';
          }
          if (value.trim().length < 4) {
            return 'Mínimo 4 caracteres';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLocationSearch() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar ubicación...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
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
          ),
          _buildSuggestionsList(),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    if (_isLoading) {
      return CircularProgressIndicator();
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _placePredictions.length,
        itemBuilder: (context, index) {
          final place = _placePredictions[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.location_on, color: Colors.blue),
              title: Text(place['description']),
              onTap: () => _selectPlace(place['description']),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: _isLoading ? null : _submitForm,
        child: _isLoading
            ? CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            )
            : const Text(
                'CONTINUAR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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

  void dispose() {
    _timer?.cancel();
  }
}