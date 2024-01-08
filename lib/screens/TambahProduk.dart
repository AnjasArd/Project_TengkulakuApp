import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_tengkulaku_app/screens/kelola_produk.dart';

class TambahProduk extends StatelessWidget {
  TambahProduk({Key? key}) : super(key: key);

  // Variables to hold form field values
  String gambar = '';
  String nama = '';
  double harga = 0.0;
  String deskripsi = '';
  String kategori = '';

  // Method to save data to Firestore
  Future<void> _saveProduct(String gambar, String nama, double harga, String deskripsi, String kategori, BuildContext context) async {
    try {
      // Get a reference to the 'produk' collection in Firestore
      CollectionReference produkCollection = FirebaseFirestore.instance.collection('produk');

      // Add product data to Firestore
      await produkCollection.add({
        'gambar': gambar,
        'nama': nama,
        'harga': harga,
        'deskripsi': deskripsi,
        'kategori': kategori,
      });

      // Display success message if the save is successful
      print('Produk berhasil disimpan ke Firestore');

      // Return to the KelolaProduk screen after successful save
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => KelolaProduk()));
    } catch (e) {
      // Display error message if there is a problem
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image field
            TextFormField(
              decoration: InputDecoration(labelText: 'Gambar Produk'),
              onChanged: (value) {
                gambar = value;
              },
            ),
            SizedBox(height: 10),

            // Product name field
            TextFormField(
              decoration: InputDecoration(labelText: 'Nama Produk'),
              onChanged: (value) {
                nama = value;
              },
            ),
            SizedBox(height: 10),

            // Price field
            TextFormField(
              decoration: InputDecoration(labelText: 'Harga Produk'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                harga = double.tryParse(value) ?? 0.0;
              },
            ),
            SizedBox(height: 10),

            // Description field
            TextFormField(
              decoration: InputDecoration(labelText: 'Deskripsi Produk'),
              maxLines: 3,
              onChanged: (value) {
                deskripsi = value;
              },
            ),
            SizedBox(height: 10),

            // Category field
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Kategori'),
              items: ['Sayur', 'Buah'].map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                kategori = value ?? '';
              },
            ),
            SizedBox(height: 20),

            // Save button
            ElevatedButton(
              onPressed: () {
                // Call the method to save data to Firestore
                _saveProduct(gambar, nama, harga, deskripsi, kategori, context);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
