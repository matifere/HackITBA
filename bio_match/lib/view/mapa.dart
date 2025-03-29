import 'package:flutter/material.dart';

class Mapa extends StatelessWidget {
  const Mapa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Mapa', 
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'DoppioOne',
                    color: Color.fromARGB(255, 0, 0, 0))),
          ],
        ),
      ),
    );
    }
  }