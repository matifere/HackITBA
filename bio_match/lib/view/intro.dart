import 'package:bio_match/view/pagina_principal.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                currentPage = value;
              });
            },
            children: [
              Explanation(
                titulo: Text(
                  "¡Hola!\nSoy BioMatch",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'DoppioOne',
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                imagen: Image.asset(
                  'assets/images/hands.png',
                  width: 229,
                  height: 166,
                ),
                texto: Text(
                  "Tu aplicación para darle valor a los residuos orgánicos que hoy estan contaminando nuestro planeta",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'DoppioOne',
                    color: Colors.black,
                  ),
                ),
              ),
              Explanation(
                titulo: Text(
                  "Conmigo podes ofrecer y retirar residuos orgánicos de forma simple y ágil, dándoles un segundo uso y reduciendo su impacto ambiental",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'DoppioOne',
                    color: Colors.black,
                  ),
                ),
                imagen: Image.asset('assets/images/trash.png'),
                texto: Column(
                  spacing: 16,
                  children: [
                    Text(
                      "En pocas palabras...",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'DoppioOne',
                        color: Colors.black,
                      ),
                    ),

                    Text("¡Te beneficias vos y beneficias al planeta!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'DoppioOne',
                        color: Colors.black,
                      ),
                    ),
                    FilledButton(onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategorySelectionScreen()));
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Color.fromARGB(255, 0, 0, 0),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ), child: Text("¡Comencemos!",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'DoppioOne',
                        color: Colors.white,
                      ),
                    ),
                    )

                  ],
                ),
              ),
            ],
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Dot(isActive: index == currentPage,),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({
    super.key, required this.isActive,
  });
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isActive ? 20 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ), duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }
}

class Explanation extends StatelessWidget {
  const Explanation({
    super.key,
    required this.titulo,
    required this.imagen,
    required this.texto,
  });
  final Text titulo;
  final Image imagen;
  final Widget texto;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        Expanded(child: Container(color: Colors.transparent)),
        titulo,
        imagen,
        texto,
        Expanded(child: Container(color: Colors.transparent)),
      ],
    );
  }
}
