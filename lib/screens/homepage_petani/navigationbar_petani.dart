import 'package:flutter/material.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/home_petani.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/menu_pesan_petani.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/kelola_produk.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/pantau_stok.dart';

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
    PesanPetani(), // Tambahkan widget Pesan ke daftar widgetOptions
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
            icon: Icon(Icons.show_chart),
            label: 'Pantau Stok',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'Kelola Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message), // Tambahkan ikon untuk menu pesan
            label: 'Pesan', // Atur label untuk menu pesan
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
