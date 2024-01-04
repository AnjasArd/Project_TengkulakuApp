import 'package:flutter/material.dart';
import 'package:project_tengkulaku_app/screens/home_petani.dart';
import 'package:project_tengkulaku_app/screens/kelola_produk.dart';
import 'package:project_tengkulaku_app/screens/pantau_stok.dart';

// void main() => runApp(const BottomNavigationBarExampleApp());

// class BottomNavigationBarExampleApp extends StatelessWidget {
//   const BottomNavigationBarExampleApp({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const BottomNavigationBarExample(),
//     );
//   }
// }

class BottomNavigationBarExample extends StatefulWidget {
  static String routeName = "/bottomNavbar";
  const BottomNavigationBarExample({Key? key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePetani(),
    PantauStok(),
    KelolaProduk(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons
                .show_chart), // Mengganti ikon ke chart untuk "Pantau Stok"
            label: 'Pantau Stok',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons
                .production_quantity_limits), // Mengganti ikon ke chart untuk "Pantau Stok"
            label: 'Kelola Produk',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 61, 194, 0),
        unselectedItemColor: const Color.fromARGB(255, 114, 114, 114),
        onTap: _onItemTapped,
      ),
    );
  }
}
