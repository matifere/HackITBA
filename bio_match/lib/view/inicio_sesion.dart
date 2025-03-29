import 'package:bio_match/classes/user.dart';
import 'package:bio_match/view/pagina_principal.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InicioSesion extends StatefulWidget {
  InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  late User user;

  //inicializa el usuario
  @override
  initState() {
    super.initState();
    user = User(" ", " ");
    user.setName(" ");
    user.setDir(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            const Text(
              'Una cosa mas...',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'DoppioOne',
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const Text(
              'Ingresa tu nombre de usuario',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'DoppioOne',
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                onChanged: (value) {
                  user.name = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nombre de usuario',
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                onChanged: (value) {
                  user.dir = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Dirección',
                ),
              ),
            ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Color.fromARGB(255, 0, 0, 0),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
              onPressed: () {
                if(user.name == "" || user.dir == "" || user.name == " " || user.dir == " ") {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Por favor, completa todos los campos.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Aceptar'),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                user.sendToFirestore();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategorySelectionScreen(),
                  ),
                );
              },
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
