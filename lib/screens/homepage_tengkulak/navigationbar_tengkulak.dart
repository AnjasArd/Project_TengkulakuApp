import 'package:flutter/material.dart';
import 'package:project_tengkulaku_app/screens/homepage_tengkulak/home_tengkulak.dart';
import 'package:project_tengkulaku_app/screens/homepage_tengkulak/menu_pesan_tengkulak.dart';
import 'package:project_tengkulaku_app/screens/homepage_tengkulak/pantau_stok_tengkulak.dart';

class BottomNavigationBarTengkulak extends StatefulWidget {
  static String routeName = "/bottomNavbarTengkulak";
  const BottomNavigationBarTengkulak({Key? key});

  @override
  State<BottomNavigationBarTengkulak> createState() =>
      _BottomNavigationBarTengkulakState();
}

class _BottomNavigationBarTengkulakState
    extends State<BottomNavigationBarTengkulak> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeTengkulak(),
    PantauStokTengkulak(),
    PesanTengkulak(),
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
            icon: Icon(Icons.message),
            label: 'Pesan',
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
