import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//Email Auth
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> register({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Registration Success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Login Success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}

// Future<void> authOTP(String nomorTelepon) async {
//   await FirebaseAuth.instance.verifikasiNomor(nomorTelepon: nomorTel, verfikasiBerhasil: (credential) async{
//     await
//   })
// } //Prototype Slurd

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> authKirimOtp(String phoneNumber) async {
  await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('Nomor telepon tidak valid');
      }
    },
    codeSent: (String verificationId, int? resendToken) {
      print('Kode OTP telah dikirim');
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      print('Waktu pengambilan kode otomatis habis');
    },
    timeout: Duration(seconds: 120),
  );
}

Future<void> authVerifikasiOtp(
    String phoneNumber,
    Function(AuthCredential)? verificationCompleted,
    Function(FirebaseAuthException)? verificationFailed,
    Function(String, int?)? codeSent,
    Function(String)? codeAutoRetrievalTimeout) async {
  await _auth.verifyPhoneNumber(
    phoneNumber: "+6282233878525",
    verificationCompleted: (AuthCredential credential) {
      if (verificationCompleted != null) {
        verificationCompleted(credential);
      }
    },
    verificationFailed: (FirebaseAuthException e) {
      if (verificationFailed != null) {
        verificationFailed(e);
      }
    },
    codeSent: (String verificationId, int? resendToken) {
      if (codeSent != null) {
        codeSent(verificationId, resendToken);
      }
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      if (codeAutoRetrievalTimeout != null) {
        codeAutoRetrievalTimeout(verificationId);
      }
    },
    timeout: Duration(seconds: 120),
    // verificationCompletedTimeout: Duration(seconds: 0),
  );
}

Future<void> signInWithPhoneNumber(
    String verificationId, String smsCode) async {
  AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId, smsCode: smsCode);

  await _auth.signInWithCredential(credential);
}

Future<void> signOut() async {
  await _auth.signOut();
}

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = "";
  String _smsCode = "";

  Future<void> verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+6282233878525',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          // Verifikasi otomatis ketika kode terverifikasi langsung
          // Masukkan kode navigasi atau perintah sesuai kebutuhan aplikasi Anda.
        },
        verificationFailed: (FirebaseAuthException e) {
          // Penanganan kesalahan saat verifikasi nomor telepon
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          // Setelah kode terkirim ke nomor telepon
          setState(() {
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Waktu habis untuk kode otomatis diambil
          // Lakukan penanganan yang diperlukan
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signInWithPhoneNumber() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsCode,
      );
      await _auth.signInWithCredential(credential);
      // Proses masuk berhasil
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

// Future<void> authKirimUlangOtp() async {
//   try {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: '+6282233878525',
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print(e.message);
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         setState(() {
//           _verificationId = verificationId;
//         });
//         // Kode OTP telah terkirim ulang
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {},
//       forceResendingToken:
//           0, // Set token resending ke 0 untuk mengirim ulang kode OTP
//     );
//   } catch (e) {
//     print(e.toString());
//   }
// }

Future<void> authKirimUlangOtp(String phoneNumber) async {
  await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('Nomor telepon tidak valid');
      }
    },
    codeSent: (String verificationId, int? resendToken) {
      print('Kode OTP telah dikirim');
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      print('Waktu pengambilan kode otomatis habis');
    },
    timeout: Duration(seconds: 120),
  );
}
