import 'package:flutter/material.dart';

class KelolaProduk extends StatelessWidget {
  const KelolaProduk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Kelola Produk'),
      // ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Produk',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w200),
                ),
                ElevatedButton(
                  onPressed: () {
                    
                    // Tambahkan logika tombol di sini
                   
                  },
                  child: Text('+ Tambah Produk'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 47, 148, 63),
                    // Change the background color of the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
