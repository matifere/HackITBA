import 'package:bio_match/view/mapa.dart';
import 'package:flutter/material.dart';
import 'package:bio_match/view/agregar_residuos.dart'; // Importa la pantalla de lista de residuos
import 'package:bio_match/view/pagina_principal.dart';
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BioMatch',
          style: TextStyle(color: Colors.teal, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  NotificationCard(
                    title: 'Nuevo residuo disponible!',
                    message: 'Buscabas verduras? Mira las nuevas publicaciones disponibles.',
                    buttonText: 'Buscar',
                    color: Colors.greenAccent,
                  ),
                  SizedBox(height: 12),
                  NotificationCard(
                    title: '¡Ya retiraron tus residuos!',
                    message: 'Un usuario notificó que ya retiró tus residuos. Si es así, ¡ya podés eliminar la publicación!',
                    buttonText: 'Eliminar publicación',
                    color: Colors.white,
                    textColor: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final Color color;
  final Color textColor;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.color,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                color: Colors.black54,
                onPressed: () {},
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: textColor),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 1; // Índice inicial (pantalla principal)

  void _onItemTapped(int index) {
     if (index == 1) {
      // Si el usuario toca el botón "+", navega a la lista de residuos
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategorySelectionScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index; // Actualiza el índice seleccionado
      });
    }
    if (index == 2) {
      // Si el usuario toca el botón "+", navega a la lista de residuos
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WasteListScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index; // Actualiza el índice seleccionado
      });
    }
    if (index ==3){
      // Si el usuario toca el botón "+", navega a la lista de residuos
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationsScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index; // Actualiza el índice seleccionado
      });
    }
    if(index == 0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Mapa()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      backgroundColor: Colors.white,
      selectedItemColor: const Color.fromARGB(255, 101, 180, 172),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: _onItemTapped, // Maneja la navegación
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          label: '',
        ),
      ],
    );
  }
  
  }
  
  class CustomBottomNavBar extends StatefulWidget {
    @override
    _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
  }