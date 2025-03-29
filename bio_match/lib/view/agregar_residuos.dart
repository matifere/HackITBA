import 'package:flutter/material.dart';
import 'package:bio_match/view/formulario_residuos.dart'; 
import 'package:bio_match/view/notificaciones.dart';
import 'package:bio_match/view/pagina_principal.dart';
class WasteListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0EEF1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'BioMatch',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
  children: [
    WasteListBody(), // Tu pantalla principal
    Positioned(
      bottom: 450, // Ajusta según necesites
      right: 285, // Ajusta según necesites
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WasteRegistrationScreen()),
          );
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
      ),
    ),
  ],
),
    );
  }
}
class WasteListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFD1C6B9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    WasteTableHeader(),
                    SizedBox(height: 16),
                    // Aquí puedes agregar una lista de residuos en el futuro
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class WasteTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nombre del residuo',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                'Descripción',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Fecha',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                'Categoría',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
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
    if (index == 3) {
      // Si el usuario toca el botón "+", navega a la lista de residuos
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationsScreen()),
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
  }}