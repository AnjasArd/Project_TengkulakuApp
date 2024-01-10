import 'package:flutter/material.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/home_petani.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/menu_pesan_petani.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/kelola_produk.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/pantau_stok_petani.dart';

class BottomNavigationBarPetani extends StatefulWidget {
  static String routeName = "/bottomNavbarPetani";
  const BottomNavigationBarPetani({Key? key});

  @override
  State<BottomNavigationBarPetani> createState() =>
      _BottomNavigationBarPetaniState();
}

class _BottomNavigationBarPetaniState extends State<BottomNavigationBarPetani> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePetani(),
    PantauStokPetani(),
    KelolaProduk(),
    PesanPetani(),
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
        selectedItemColor: Color.fromARGB(255, 3, 172, 65),
        unselectedItemColor: const Color.fromARGB(255, 114, 114, 114),
        onTap: _onItemTapped,
      ),
    );
  }
}
