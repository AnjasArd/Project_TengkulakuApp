import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/navigationbar_petani.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/tambah_produk.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/update_produk.dart';
import 'package:photo_view/photo_view.dart';

class KelolaProduk extends StatefulWidget {
  static String routeName = "/kelola_produk";
  const KelolaProduk({Key? key}) : super(key: key);

  @override
  _KelolaProdukState createState() => _KelolaProdukState();
}

class _KelolaProdukState extends State<KelolaProduk> {
  late List<Map<String, dynamic>> productList;
  bool isLoading = true;
  late QuerySnapshot<Map<String, dynamic>> productSnapshot;
  late String selectedCategory = 'Semua';
  List<String> categories = ['Semua', 'Buah', 'Sayur'];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      productSnapshot =
          await FirebaseFirestore.instance.collection('produk').get();

      productList = productSnapshot.docs.map((doc) {
        return doc.data();
      }).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error mendapatkan data dariFirestore: $e');
      setState(() {
        isLoading = false;
      });
      throw e;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('produk')
          .doc(productId)
          .delete();
      fetchData();
    } catch (e) {
      print('Error deleting product: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.dark_mode),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Produk',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            // IconButton(
            //   onPressed: () {
            //     final themeProvider = Provider.of<ThemeProvider>(context,
            //         listen:
            //             false); // get the provider, listen false is necessary cause is in a function

            //     setState(() {
            //       isDarkmode = !isDarkmode;
            //     }); // change the variable

            //     isDarkmode // call the functions
            //         ? themeProvider.setDarkmode()
            //         : themeProvider.setLightMode();
            //   },
            //   icon: const Icon(Icons.dark_mode),
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahProduk(),
                  ),
                );
                fetchData();
              },
              child: Text('+ Tambah Produk', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 47, 148, 63),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Spacer(),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> product = productList[index];
                        if (selectedCategory != 'Semua' &&
                            product['kategori'] != selectedCategory) {
                          return Container();
                        }
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              product['nama'] ?? '',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Harga: ${_formatCurrency(product['harga'] ?? 0)}',
                                ),
                                Text('Kategori: ${product['kategori'] ?? ''}'),
                                Text(
                                    'Deskripsi: ${product['deskripsi'] ?? ''}'),
                              ],
                            ),
                            leading: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ZoomableImage(
                                      imageUrl: product['gambar'] ?? '',
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  child: Image.network(
                                    product['gambar'] ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.grey),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateProduk(
                                          productId:
                                              productSnapshot.docs[index].id,
                                        ),
                                      ),
                                    );
                                    fetchData();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.grey),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Hapus Produk'),
                                          content: Text(
                                              'Apakah Anda yakin ingin menghapus produk ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Batal',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                deleteProduct(productSnapshot
                                                    .docs[index].id);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                'Hapus',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatCurrency(double amount) {
  final intAmount = amount.toInt();
  final currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);
  return currencyFormat.format(intAmount);
}

class ZoomableImage extends StatelessWidget {
  final String imageUrl;

  const ZoomableImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Container(
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
              backgroundDecoration: BoxDecoration(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
