import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateProduk extends StatefulWidget {
  final String productId;

  const UpdateProduk({Key? key, required this.productId}) : super(key: key);

  @override
  _UpdateProdukState createState() => _UpdateProdukState();
}

class _UpdateProdukState extends State<UpdateProduk> {
  late TextEditingController namaController;
  late TextEditingController hargaController;
  late TextEditingController deskripsiController;
  late TextEditingController kategoriController;
  late TextEditingController gambarController; // Add this line

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> productSnapshot =
          await FirebaseFirestore.instance
              .collection('produk')
              .doc(widget.productId)
              .get();

      namaController = TextEditingController(text: productSnapshot['nama']);
      hargaController =
          TextEditingController(text: productSnapshot['harga'].toString());
      deskripsiController =
          TextEditingController(text: productSnapshot['deskripsi']);
      kategoriController =
          TextEditingController(text: productSnapshot['kategori']);
      gambarController = TextEditingController(text: productSnapshot['gambar']); // Add this line
    } catch (e) {
      print('Error fetching data for update: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama Produk'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: hargaController,
              decoration: InputDecoration(labelText: 'Harga Produk'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi Produk'),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: kategoriController,
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: gambarController,
              decoration: InputDecoration(labelText: 'Gambar Produk URL'), // Add this line
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateProduct(
                  widget.productId,
                  namaController.text,
                  double.parse(hargaController.text),
                  deskripsiController.text,
                  kategoriController.text,
                  gambarController.text, // Add this line
                );
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateProduct(String productId, String nama, double harga,
      String deskripsi, String kategori, String gambar) async {
    try {
      await FirebaseFirestore.instance.collection('produk').doc(productId).update({
        'nama': nama,
        'harga': harga,
        'deskripsi': deskripsi,
        'kategori': kategori,
        'gambar': gambar, // Add this line
      });

      print('Produk berhasil diupdate di Firestore');

      Navigator.pop(context); // Navigate back to the previous screen
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }
}
