import 'package:flutter/material.dart';

class CategorySelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0EEF1), // Color del fondo general
      appBar: AppBar(
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
                color: Color.fromARGB(255, 159, 184, 194),
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

  CategoryButton(this.text, this.color);

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
class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      backgroundColor: Colors.white,
      selectedItemColor: const Color.fromARGB(255, 101, 180, 172),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
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

