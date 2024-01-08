import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/kelola_produk.dart';

class UpdateProduk extends StatefulWidget {
  static String routeName = "/update_produk";
  final String productId;

  UpdateProduk({Key? key, required this.productId}) : super(key: key);

  @override
  _UpdateProdukState createState() => _UpdateProdukState();
}

class _UpdateProdukState extends State<UpdateProduk> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  late String gambar = '';
  late String nama = '';
  late double harga = 0.0;
  late String deskripsi = '';
  late String kategori = '';

  @override
  void initState() {
    super.initState();
    fetchDataForUpdate();
  }

  Future<void> fetchDataForUpdate() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> productSnapshot =
          await FirebaseFirestore.instance
              .collection('produk')
              .doc(widget.productId)
              .get();

      final data = productSnapshot.data();

      if (data != null) {
        setState(() {
          gambar = data['gambar'] ?? '';
          nama = data['nama'] ?? '';
          harga = data['harga'] ?? 0.0;
          deskripsi = data['deskripsi'] ?? '';
          kategori = data['kategori'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching data for update: $e');
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<String> _uploadImageToFirebase() async {
    if (_pickedImage == null) {
      return gambar;
    }

    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('produk_${DateTime.now()}.png');

      final UploadTask uploadTask =
          storageReference.putFile(File(_pickedImage!.path));
      final TaskSnapshot downloadUrl = await uploadTask;
      final String url = await downloadUrl.ref.getDownloadURL();

      return url;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    }
  }

  Future<void> _updateProduct(BuildContext context) async {
    final String imageUrl =
        _pickedImage != null ? await _uploadImageToFirebase() : gambar;

    try {
      CollectionReference produkCollection =
          FirebaseFirestore.instance.collection('produk');

      await produkCollection.doc(widget.productId).update({
        'gambar': imageUrl,
        'nama': nama,
        'harga': harga,
        'deskripsi': deskripsi,
        'kategori': kategori,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Notifikasi'),
            content: Text('Data berhasil diperbarui.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, KelolaProduk.routeName);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Produk'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(47.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.green),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.file_upload,
                      color: Colors.green,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'Gambar Produk',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _pickedImage != null
                ? Image.file(
                    File(_pickedImage!.path),
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  )
                : SizedBox(),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nama Produk'),
              onChanged: (value) {
                nama = value;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'Harga Produk'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                harga = double.tryParse(value) ?? 0.0;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(labelText: 'Deskripsi Produk'),
              maxLines: 3,
              onChanged: (value) {
                deskripsi = value;
              },
            ),
            SizedBox(height: 20),
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
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    _updateProduct(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text('Simpan', style: TextStyle(color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
