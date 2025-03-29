import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              Container(
                color: Colors.red,
                child: const Center(
                  child: Text('Pantalla 1',
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'DoppioOne',
                          color: Color.fromARGB(255, 0, 0, 0))),
                ),
              ),
              Container(
                color: Colors.green,
                child: const Center(
                  child: Text('Pantalla 2',
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'DoppioOne',
                          color: Color.fromARGB(255, 0, 0, 0))),
                ),
              ),
              Container(
                color: Colors.blue,
                child: const Center(
                  child: Text('Pantalla 3',
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'DoppioOne',
                          color: Color.fromARGB(255, 0, 0, 0))),
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}