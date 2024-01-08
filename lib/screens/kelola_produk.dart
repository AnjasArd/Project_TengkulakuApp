import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_tengkulaku_app/screens/TambahProduk.dart';

class KelolaProduk extends StatefulWidget {
  const KelolaProduk({Key? key}) : super(key: key);

  @override
  _KelolaProdukState createState() => _KelolaProdukState();
}

class _KelolaProdukState extends State<KelolaProduk> {
  late List<Map<String, dynamic>> productList;
  bool isLoading = true;
  late QuerySnapshot<Map<String, dynamic>> productSnapshot;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Function to get product data from Firestore
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
      }); // Trigger a rebuild after fetching data
    } catch (e) {
      print('Error fetching data from Firestore: $e');
      setState(() {
        isLoading = false;
      });
      throw e;
    }
  }

  // Function to delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance
          .collection('produk')
          .doc(productId)
          .delete();
      fetchData(); // Refresh data after deletion
    } catch (e) {
      print('Error deleting product: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daftar Produk',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w200),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TambahProduk(),
                        ),
                      );

                      // Trigger a rebuild after returning from TambahProduk
                      fetchData();
                    },
                    child: Text('+ Tambah Produk'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 47, 148, 63),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Display list of products using ListView.builder
              Container(
                height: MediaQuery.of(context).size.height -
                    150, // Adjust the height as needed
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> product = productList[index];

                          return Card(
                            child: ListTile(
                              title: Text(product['nama'] ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Harga: ${product['harga'] ?? ''}'),
                                  Text(
                                      'Kategori: ${product['kategori'] ?? ''}'),
                                  Text(
                                      'Deskripsi: ${product['deskripsi'] ?? ''}'),
                                ],
                              ),
                              leading: Image.network(
                                product['gambar'] ?? '',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Call the deleteProduct function with the product's document ID
                                  deleteProduct(productSnapshot.docs[index].id);
                                },
                              ),
                              // Add more details or customize as needed
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
