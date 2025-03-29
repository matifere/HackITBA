import 'package:bio_match/view/mapa.dart';
import 'package:flutter/material.dart';
import 'package:bio_match/view/agregar_residuos.dart'; // Importa la pantalla de lista de residuos
import 'package:bio_match/view/notificaciones.dart'; // Importa la pantalla de lista de residuos
class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0EEF1), // Color del fondo general
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'BioMatch',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 24,
            fontFamily: 'DoppioOne',
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: CategorySelectionBody(),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
class CategorySelectionBody extends StatelessWidget {
  const CategorySelectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selecciona la categoría que te gustaría reutilizar!',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'DoppioOne',
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:  Color(0xFFD1C6B9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    CategoryButton('Verduras y frutas', Colors.green),
                    CategoryButton('Restos de productos animales', Colors.cyan),
                    CategoryButton('Restos de café', Colors.brown),
                    CategoryButton('Otros residuos', Colors.green.shade700),
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
class CategoryButton extends StatelessWidget {
  final String text;
  final Color color;

  const CategoryButton(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Acción cuando se presiona el botón
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'DoppioOne',
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

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
    if (index == 0){
      // Si el usuario toca el botón "+", navega a la lista de residuos
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Mapa()),
      );
    } else {
      setState(() {
        _selectedIndex = index; // Actualiza el índice seleccionado
      });
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



