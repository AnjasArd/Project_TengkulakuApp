import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_tengkulaku_app/komponen/button.dart';
import 'package:project_tengkulaku_app/komponen/form_error.dart';
import 'package:project_tengkulaku_app/komponen/icon.dart';
import 'package:project_tengkulaku_app/konfigurasi_layar.dart';
import 'package:project_tengkulaku_app/konstan.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/navigationbar_petani.dart';
import 'package:project_tengkulaku_app/screens/homepage_tengkulak/navigationbar_tengkulak.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          // Row(
          //   children: [
          //     Checkbox(
          //       value: remember,
          //       activeColor: kPrimaryColor,
          //       onChanged: (value) {
          //         setState(() {
          //           remember = value;
          //         });
          //       },
          //     ),
          //     Text("Ingat akun ini"),
          //     Spacer(), //Prototype Slurd
          //     GestureDetector(
          //        onTap: () => Navigator.pushNamed(
          //            context, ForgotPasswordScreen.routeName),
          //        child: Text(
          //          "Lupa password",
          //          style: TextStyle(decoration: TextDecoration.underline),
          //        ),
          //      )
          //   ],
          // ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Login",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                try {
                  UserCredential userCredential =
                      await _auth.signInWithEmailAndPassword(
                    email: email!,
                    password: password!,
                  );

                  if (userCredential.user != null) {
                    User? user = userCredential.user;
                    DocumentSnapshot<Map<String, dynamic>> userData =
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .get();

                    if (userData.exists) {
                      bool isPetani = userData.data()!['isPetani'] ?? false;
                      bool isTengkulak =
                          userData.data()!['isTengkulak'] ?? false;

                      if (isPetani) {
                        Navigator.pushNamed(
                            context, BottomNavigationBarPetani.routeName);
                      } else if (isTengkulak) {
                        Navigator.pushNamed(
                            context, BottomNavigationBarTengkulak.routeName);
                      } else {
                        // Handle other roles or cases
                      }
                    }
                  }
                } catch (e) {
                  if (e is FirebaseAuthException) {
                    if (e.code == 'user-not-found') {
                      print('Pengguna tidak ditemukan!');
                    } else if (e.code == 'wrong-password') {
                      print('Password salah!');
                    } else {
                      print('Error: $e');
                    }
                  } else {
                    print('Error: $e');
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Masukan password anda",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 3, 172, 65), width: 2.0),
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 3, 172, 65),
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Masukan email anda",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 3, 172, 65), width: 2.0),
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 3, 172, 65),
        ),
      ),
    );
  }
}
