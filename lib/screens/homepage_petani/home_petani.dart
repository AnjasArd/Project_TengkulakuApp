import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:project_tengkulaku_app/komponen/product_card.dart';
import 'package:project_tengkulaku_app/screens/login/login_screen.dart';
import 'package:project_tengkulaku_app/screens/product.dart';

class HomePetani extends StatefulWidget {
  static String routeName = "/home_petani";
  const HomePetani({Key? key}) : super(key: key);

  @override
  State<HomePetani> createState() => _HomePetaniState();
}

class _HomePetaniState extends State<HomePetani> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  String _sapa = '';
  String _sapamodif = '';
  String _username = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
    _setSapa();
    _ambilUsername();
  }

  Future<void> _ambilUsername() async {
    DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(_user!.uid)
        .get();

    if (userData.exists) {
      setState(() {
        _username = userData.data()!['username'];
      });
    }
  }

  Future<void> _getUserData() async {
    User? currentUser = _auth.currentUser;
    setState(() {
      _user = currentUser!;
    });
  }

  void _setSapa() {
    var jam = DateTime.now().hour;

    if (jam < 12) {
      setState(() {
        _sapa = 'Selamat pagi ';
      });
    } else if (jam < 18) {
      setState(() {
        _sapa = 'Selamat siang ';
      });
    } else {
      setState(() {
        _sapa = 'Selamat malam ';
      });
    }
    setState(() {
      _sapamodif = _sapa;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(),
                  SizedBox(height: 10),
                  Text(
                    _username,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Settings()),
                // );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Konfirmasi Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text("Apakah anda yakin ingin logout?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Batal',
                            style: TextStyle(
                                color: Color.fromARGB(255, 3, 172, 65)),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await _auth.signOut();
                            Navigator.pushNamed(
                                context, SignInScreen.routeName);
                          },
                          child: Text(
                            'Ya',
                            style: TextStyle(
                                color: Color.fromARGB(255, 3, 172, 65)),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleSmall,
                children: <TextSpan>[
                  TextSpan(
                    text: _sapamodif,
                  ),
                  TextSpan(
                      text: _username,
                      style: TextStyle(
                        color: Color.fromARGB(255, 3, 172, 65),
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(
            color: Colors.grey), // Atur warna ikon pada tombol burger
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {},
              icon: const Icon(IconlyBroken.notification),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //searching
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari produk anda...",
                      isDense: true,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(99)),
                      ),
                      prefixIcon: const Icon(IconlyLight.search),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: IconButton.filled(
                      onPressed: () {}, icon: Icon(IconlyLight.filter)),
                )
              ],
            ),
          ),

          // const card
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: SizedBox(
              height: 170,
              child: Card(
                color:
                    Colors.green.shade100, // Adjust the card background color
                elevation: 2, // Adjust the elevation for a subtle shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  // You can also set the border color and width here
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      // Texts
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Iklan Produk",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                            ),
                            Text(
                              "Dapatkan diskon promo spesial Natal dan Tahun baru",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            FilledButton(
                              onPressed: () {},
                              child: Text(
                                "Click",
                                style: TextStyle(
                                  color: Colors.white, // Button text color
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 47, 148,
                                    63), // Change the background color of the button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/images/cardbaru.png',
                        width: 140,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          //teks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Data barang",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(onPressed: () {}, child: const Text("Lihat semua"))
            ],
          ),

          //fiturnya
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, Index) {
              return ProductCard(
                product: products[Index],
              );
            },
          )
        ],
      ),
    );
  }
}
