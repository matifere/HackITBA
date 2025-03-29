import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatefulWidget {
  Mapa({super.key});

  // Marker list can be part of the widget since it's final
  final List<Marker> markerList = const [
    Marker(
      markerId: MarkerId('first'),
      position: LatLng(-34.602536503444846, -58.411559814725344),
      infoWindow: InfoWindow(title: "Tu ubicacion"),
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

  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> mymarker = [];

  @override
  void initState() {
    super.initState();
    mymarker.addAll(widget.markerList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          markers: Set<Marker>.of(mymarker),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching),
        onPressed:() 
        async
        {
            GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(
              const CameraPosition(
                target: LatLng(-34.602536503444846, -58.411559814725344),
                zoom: 14
              )
            ));
        }, 
      ),
    );
  }
}