import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PesanTengkulak extends StatefulWidget {
  static String routeName = "/pesan_tengkulak";
  const PesanTengkulak({Key? key}) : super(key: key);

  @override
  State<PesanTengkulak> createState() => _PesanTengkulakState();
}

class _PesanTengkulakState extends State<PesanTengkulak> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> petaniList = []; // Menyimpan daftar pengguna petani
  List<DocumentSnapshot> receivedMessages =
      []; // Menyimpan pesan yang diterima oleh petani

  @override
  void initState() {
    super.initState();
    _getPetaniList();
    _getReceivedMessages();
  }

  void _getPetaniList() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('isPetani', isEqualTo: true)
        .get();

    setState(() {
      petaniList = querySnapshot.docs;
    });
  }

  void _showMessageDetailDialog(
    BuildContext context,
    String messageContent,
    String senderUsername,
    Timestamp timestamp,
    String senderId,
  ) {
    DateTime sentTime = timestamp.toDate();
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(sentTime);

    TextEditingController replyController =
        TextEditingController(); // Untuk mengatur pesan balasan

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(senderUsername),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(messageContent),
              SizedBox(height: 8),
              Text(
                '$formattedTime',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: replyController,
                decoration: InputDecoration(
                  labelText: 'Balas Pesan',
                ),
                maxLines: null,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                // Kirim pesan balasan dengan replyController.text dan data penerima pesan
                kirimPesanTengkulak(replyController.text, senderId);
                Navigator.of(context).pop();
              },
              child: Text('Balas'),
            ),
          ],
        );
      },
    );
  }

  void _getReceivedMessages() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String petaniId = user.uid; // Mendapatkan UID dari petani yang login

      QuerySnapshot querySnapshot = await _firestore
          .collection('messages')
          .where('receiverId', isEqualTo: petaniId)
          .get();

      setState(() {
        receivedMessages = querySnapshot.docs;
      });
    }
  }

  void kirimPesanTengkulak(String message, String receiverId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Mendapatkan informasi username pengguna dari Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String senderUsername = userSnapshot.get('username');

      FirebaseFirestore.instance.collection('messages').add({
        'message': message,
        'senderId': user.uid,
        'senderUsername': senderUsername, // Menyimpan username pengirim pesan
        'receiverId': receiverId,
        'timestamp': FieldValue.serverTimestamp(),
        // Tambahkan informasi lain yang dibutuhkan
      }).then((value) {
        print('Pesan terkirim!');
      }).catchError((error) {
        print('Error: $error');
      });
    }
  }

  Future<String?> getTengkulakUsername(String senderId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(senderId).get();
    if (snapshot.exists) {
      return snapshot.get('username');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan Petani'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Daftar Petani',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: petaniList.length,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, dynamic> data =
                    petaniList[index].data() as Map<String, dynamic>;
                String tengkulakName = data['username'] ?? '';
                String tengkulakId = petaniList[index].id;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(tengkulakName),
                    leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(
                          255, 3, 172, 65), // Warna latar belakang ikon
                      child:
                          Icon(Icons.person, color: Colors.white), // Warna ikon
                    ),
                    onTap: () {
                      _displayAddMessageDialog(context, tengkulakId);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Kotak Masuk',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: receivedMessages.length,
            itemBuilder: (BuildContext context, int index) {
              final Map<String, dynamic> data =
                  receivedMessages[index].data() as Map<String, dynamic>;
              String messageContent = data['message'] ?? '';
              String senderId =
                  data['senderId'] ?? ''; // Ambil ID pengirim pesan

              Timestamp? timestamp = data['timestamp'] as Timestamp?;
              if (timestamp != null) {
                return FutureBuilder<String?>(
                  future: getTengkulakUsername(senderId),
                  builder:
                      (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasData) {
                        String senderUsername = snapshot.data ?? '';
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          elevation: 4.0,
                          child: ListTile(
                            title: Text(
                              senderUsername,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(messageContent),
                                Text(
                                  '${DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch))}',
                                  // Menampilkan waktu dan tanggal pengiriman jika tersedia
                                ),
                              ],
                            ),
                            leading: CircleAvatar(
                              child: Icon(Icons.message),
                            ),
                            onTap: () {
                              _showMessageDetailDialog(context, messageContent,
                                  senderUsername, timestamp, senderId);
                            },
                          ),
                        );
                      } else {
                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          elevation: 4.0,
                          child: ListTile(
                            title: Text('Unknown'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(messageContent),
                                Text(
                                  'Dari: Unknown',
                                ), // Jika username tidak ditemukan
                              ],
                            ),
                            leading: CircleAvatar(
                              child: Icon(Icons.message),
                            ),
                            onTap: () {
                              _showMessageDetailDialog(
                                context,
                                messageContent,
                                'Unknown',
                                Timestamp.now(),
                                senderId,
                              );
                            },
                          ),
                        );
                      }
                    }
                  },
                );
              } else {
                return SizedBox(); // Tambahkan widget kosong jika timestamp adalah null
              }
            },
          )),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog detail pesan

  Future<void> _displayAddMessageDialog(
      BuildContext context, String tengkulakId) async {
    TextEditingController messageController = TextEditingController();

    Future<String> _getTengkulakUsername(String tengkulakId) async {
      String username = '';

      try {
        DocumentSnapshot tengkulakSnapshot =
            await _firestore.collection('users').doc(tengkulakId).get();

        if (tengkulakSnapshot.exists) {
          Map<String, dynamic>? tengkulakData =
              tengkulakSnapshot.data() as Map<String, dynamic>?;
          username = tengkulakData?['username'] ?? '';
        }
      } catch (e) {
        print('Error getting tengkulak username: $e');
      }
      return username;
    }

    String tengkulakUsername = await _getTengkulakUsername(tengkulakId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(
                'Kirim pesan kepada ',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Text(
                tengkulakUsername,
                style: TextStyle(
                  color: Color.fromARGB(255, 3, 172, 65),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: 'Ketik pesan',
                ),
                maxLines: null,
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                kirimPesanTengkulak(
                  messageController.text,
                  tengkulakId,
                );
                Navigator.of(context).pop();
              },
              child: Text('Kirim'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }
}
