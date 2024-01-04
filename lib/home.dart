import 'package:flutter/material.dart';

class Product {
  final String name;
  final String description;
  final double price;

  Product({required this.name, required this.description, required this.price});
}

class HomeScreen extends StatelessWidget {
  final List<Product> products = [
    Product(name: 'Produk 1', description: 'Deskripsi Produk 1', price: 29.99),
    Product(name: 'Produk 2', description: 'Deskripsi Produk 2', price: 19.99),
    Product(name: 'Produk 3', description: 'Deskripsi Produk 3', price: 39.99),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Produk Terbaru',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductItem(product: products[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          // Tambahkan gambar produk jika tersedia
          backgroundColor: Colors.blue,
        ),
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: Text('\$${product.price.toStringAsFixed(2)}'),
        onTap: () {
          // Tambahkan aksi saat item produk ditekan
        },
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TengkulakuApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
