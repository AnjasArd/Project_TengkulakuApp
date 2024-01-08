import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
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

  List<List<DocumentSnapshot>> groupMessagesBySender() {
    Map<String, List<DocumentSnapshot>> groupedMessages = {};

    // Mengelompokkan pesan berdasarkan senderId
    receivedMessages.forEach((message) {
      String senderId = message['senderId'] ?? '';

      if (!groupedMessages.containsKey(senderId)) {
        groupedMessages[senderId] = [];
      }

      groupedMessages[senderId]!.add(message);
    });

    return groupedMessages.values.toList();
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
    List<DocumentSnapshot<Object?>> messages,
    String senderUsername,
    Timestamp timestamp,
    String senderId,
  ) {
    DateTime sentTime = timestamp.toDate();
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(sentTime);

    TextEditingController replyController = TextEditingController();

    List<Map<String, dynamic>> messageDataList = messages.map((message) {
      Map<String, dynamic> messageData = message.data() as Map<String, dynamic>;
      return {
        'message': messageData['message'],
        'senderId': messageData['senderId'],
        'senderUsername': messageData['senderUsername'],
        'timestamp': messageData['timestamp'],
      };
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(senderUsername),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: messageDataList
                    .map((message) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChatBubble(
                              clipper: ChatBubbleClipper8(
                                  type: BubbleType.receiverBubble),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(top: 20),
                              backGroundColor: Colors.blue,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Text(
                                  message['message'] ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                '${DateFormat('yyyy-MM-dd HH:mm').format(message['timestamp'].toDate())}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ))
                    .toList(),
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
                String replyMessage = replyController.text;
                kirimPesanTengkulak(replyMessage, senderId);

                // Update tampilan dengan menambahkan pesan balasan ke daftar pesan
                setState(() {
                  FirebaseFirestore.instance.collection('messages').add({
                    'message': replyMessage,
                    'senderId': FirebaseAuth.instance.currentUser?.uid ?? '',
                    'senderUsername': senderUsername,
                    'timestamp': FieldValue.serverTimestamp(),
                  }).then((value) {
                    print('Pesan balasan terkirim!');
                  }).catchError((error) {
                    print('Error: $error');
                  });
                });

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
      appBar: AppBar(),
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
                      backgroundColor: Color.fromARGB(255, 3, 172, 65),
                      child: Icon(Icons.person, color: Colors.white),
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
              itemCount: groupMessagesBySender().length,
              itemBuilder: (BuildContext context, int index) {
                List<DocumentSnapshot> senderMessages =
                    groupMessagesBySender()[index];

                String messageContent = senderMessages.last['message'] ?? '';
                String senderId = senderMessages.first['senderId'] ?? '';
                Timestamp? timestamp =
                    senderMessages.last['timestamp'] as Timestamp?;

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
                                  '${DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(timestamp?.millisecondsSinceEpoch ?? 0))}',
                                  // Menampilkan waktu dan tanggal pengiriman jika tersedia
                                ),
                              ],
                            ),
                            leading: CircleAvatar(
                              child: Icon(Icons.message),
                            ),
                            onTap: () {
                              // Menampilkan detail pesan
                              _showMessageDetailDialog(
                                  context,
                                  senderMessages
                                      as List<DocumentSnapshot<Object?>>,
                                  senderUsername,
                                  Timestamp.now(),
                                  senderId);
                            },
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    }
                  },
                );
              },
            ),
          ),
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
