import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantauStokPetani extends StatefulWidget {
  const PantauStokPetani({Key? key}) : super(key: key);

  @override
  _PantauStokPetaniState createState() => _PantauStokPetaniState();
}

class _PantauStokPetaniState extends State<PantauStokPetani> {
  late List<Map<String, dynamic>> categoryCounts;
  bool isLoading = true;

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

      QuerySnapshot<Map<String, dynamic>> categorySnapshot =
          await FirebaseFirestore.instance.collection('produk').get();

      // Group products by category and count them
      Map<String, int> categoryCountMap = {};
      categorySnapshot.docs.forEach((doc) {
        String category = doc['kategori'] ?? 'Lainnya';
        categoryCountMap[category] = (categoryCountMap[category] ?? 0) + 1;
      });

      // Convert the map to a list of Map<String, dynamic>
      categoryCounts = categoryCountMap.entries
          .map((entry) => {'kategori': entry.key, 'jumlah': entry.value})
          .toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching category data: $e');
      setState(() {
        isLoading = false;
      });
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pantau Stok',
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: categoryCounts.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> category = categoryCounts[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Card(
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              title: Text('${category['kategori']}'),
                              subtitle: Text('Jumlah: ${category['jumlah']}'),
                              leading: Image.network(
                                getCategoryImage(category['kategori']),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to get the image URL based on category
  String getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'buah':
        return 'https://th.bing.com/th/id/OIP.jiZ_fQfjqWjQtcVMJJlLbwHaFP?w=800&h=567&rs=1&pid=ImgDetMain';
      case 'sayur':
        return 'https://th.bing.com/th/id/R.4c631fc8d4cc2f7840e16c4a80f40bdd?rik=25xJHZOFEvWecA&riu=http%3a%2f%2fwww.bhubaneswarbuzz.com%2fwp-content%2fuploads%2f2017%2f10%2fodisha-eats-maximum-vegetables-in-india-500x332.jpg&ehk=Uv3VVUlcU0XwF40Qgc0mGnoLzh2AMCkZtoed3lbSPJ0%3d&risl=&pid=ImgRaw&r=0';
      case 'kacang':
        return 'https://th.bing.com/th/id/OIP.H9wk3wBON7TvCF7YVdqUTQAAAA?rs=1&pid=ImgDetMain';
      default:
        return 'https://th.bing.com/th/id/OIP.H9wk3wBON7TvCF7YVdqUTQAAAA?rs=1&pid=ImgDetMain';
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: PantauStokPetani(),
  ));
}

// class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.blue,
//             Colors.green,
//           ],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//       ),
//       child: AppBar(
//         title: Text(
//           'Pantau Stok',
//           style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor:
//             Colors.transparent, // Set AppBar background to transparent
//         elevation: 0, // Remove AppBar shadow
//       ),
//     );
//   }
// }
