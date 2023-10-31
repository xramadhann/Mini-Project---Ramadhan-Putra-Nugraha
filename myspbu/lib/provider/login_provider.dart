import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.reference().child('users');

  Future<String> login(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Login berhasil
        String? userEmail = userCredential.user!.email;

        DatabaseReference userRef =
            FirebaseDatabase.instance.reference().child('User').child('user1');
        userRef.update({
          'emailPengguna': userEmail,
          'passwordPengguna': password,
        });

        return "success"; // Mengembalikan pesan sukses
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
      return "Email atau password salah"; // Mengembalikan pesan kesalahan
    }

    return "Terjadi kesalahan saat login"; // Mengembalikan pesan kesalahan umum
  }
}
