import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrimerInicio extends StatefulWidget {
  const PrimerInicio({super.key});

  @override
  State<PrimerInicio> createState() => _PrimerInicioState();
}

class _PrimerInicioState extends State<PrimerInicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/login');
        },
        child: Center(
          child: Column(
            children: [
              const Text('BioMatch', 
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'DoppioOne',
                      color: Color.fromARGB(255, 0, 0, 0))),
            ],
          ),
        ),
      ),
    );
  }
}