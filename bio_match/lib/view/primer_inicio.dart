import 'package:bio_match/view/intro.dart';
import 'package:flutter/material.dart';

class PrimerInicio extends StatefulWidget {
  const PrimerInicio({super.key});

  @override
  State<PrimerInicio> createState() => _PrimerInicioState();
}

class _PrimerInicioState extends State<PrimerInicio> {

  double opacidad = 0;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        opacidad = 1;
      });
    });
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Intro()));
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              Expanded(child: Container(
                color: Colors.transparent,
              )),
              const Text('BioMatch', 
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'DoppioOne',
                      color: Color.fromARGB(255, 0, 0, 0))),
              AnimatedOpacity(
                opacity: opacidad,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                child: const Text("Toca para iniciar",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'DoppioOne',
                        color: Colors.grey)),
              ),
                      Expanded(child: Container(
                        color: Colors.transparent,
                      ))
            ],
          ),
        ),
      ),
      
    );
  }
}