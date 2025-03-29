import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart'as http;
import 'package:uuid/uuid.dart';
class Mapa extends StatefulWidget {
  Mapa({super.key});

  final List<Marker> markerList = [
    Marker(
      markerId: const MarkerId('first'),
      position: const LatLng(-34.602536503444846, -58.411559814725344),
      infoWindow: const InfoWindow(title: "Tu ubicacion"),
    )
  ];

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-34.602536503444846, -58.411559814725344),
    zoom: 14,
  );
  String tokenForSession = "37465";
  var uid = Uuid();
  List<dynamic> listForPlaces = [];
  void makeSuggestion(String input) async{
    String googlePlacesApiKey = "AIzaSyCmJaeIx_WlTXasB0MHULv6TGPYE5C4trY";
    String groundURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
     String request = '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';

     var responseResult = await http.get(Uri.parse(request));
     var resultData = responseResult.body.toString();
     print(resultData);
     setState(() {
       listForPlaces = jsonDecode(responseResult.body.toString()) ["predictions"];
     });
  }
  void onModify(){
    if(tokenForSession == null){
      setState(() {
        
      });
    }
  }
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();
  List<Marker> mymarker = [];

  @override
  void initState() {
    super.initState();
    mymarker.addAll(widget.markerList);
    packData();
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition();
  }

  void packData() {
    getUserLocation().then((value) async {
      setState(() {
        mymarker.add(
          Marker(
            markerId: const MarkerId("CurrentLocation"),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: const InfoWindow(title: "Tu posición actual"),
          ),
        );
      });

      final cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  void _searchLocation() async {
    if (_searchController.text.isEmpty) return;
    
   
    final newPosition = LatLng(-34.6037, -58.3816);
    
    setState(() {
      mymarker.add(
        Marker(
          markerId: MarkerId(_searchController.text),
          position: newPosition,
          infoWindow: InfoWindow(title: _searchController.text),
        ),
      );
    });

    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: newPosition, zoom: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: Set<Marker>.of(mymarker),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar ubicación...',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchLocation,
                    ),
                  ),
                  onSubmitted: (value) => _searchLocation(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching),
        onPressed: packData,
      ),
    );
  }
}