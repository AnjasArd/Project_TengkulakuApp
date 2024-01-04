// import 'package:project_tengkulaku_app/home.dart';

class Product {
  final String nama;
  final String description;
  final double price;
  final String image;

  const Product({
    required this.nama,
    required this.description,
    required this.price,
    required this.image,
  });
}

List<Product> products = [
  Product(
    nama: "Product 1",
    description: "Description for Product 1",
    price: 123.45,
    image: "assets/images/pare.png",
  ),
  Product(
    nama: "Product 2",
    description: "Description for Product 2",
    price: 67.89,
    image: "assets/images/cabai.png",
  ),
  Product(
    nama: "Product 3",
    description: "Description for Product 3",
    price: 45.67,
    image: "assets/images/kangkung.png",
  ),
  Product(
    nama: "Product 4",
    description: "Description for Product 4",
    price: 89.12,
    image: "assets/images/cabai.png",
  ),
  Product(
    nama: "Product 5",
    description: "Description for Product 5",
    price: 34.56,
    image: "assets/images/pare.png",
  ),
];
