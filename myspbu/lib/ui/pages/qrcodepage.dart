import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myspbu/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

final databaseReference = FirebaseDatabase.instance.reference();

void tambahPoin() async {
  const String userId = "user1";
  final int poinDitambahkan = 10;

  // Dapatkan poin saat ini pengguna
  DatabaseEvent userSnapshot =
      await databaseReference.child("User").child(userId).child("Poin").once();
  int poinSaatIni =
      userSnapshot.snapshot.value as int; // Konversi ke tipe data int

  // Tambahkan poin baru
  int poinBaru = poinSaatIni + poinDitambahkan;

  // Perbarui nilai poin di Firebase
  await databaseReference
      .child("User")
      .child(userId)
      .child("Poin")
      .set(poinBaru);
}

class QRCodePage extends StatelessWidget {
  final int currentIndex; // Tambahkan variabel currentIndex

  QRCodePage({required this.currentIndex, Key? key, required String userId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final String userId = "user1"; // Ganti dengan user_id yang sesuai
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200, // Atur lebar sesuai kebutuhan
              height: 200, // Atur tinggi sesuai kebutuhan
              decoration: BoxDecoration(
                color: Colors.white, // Warna latar belakang
                borderRadius: BorderRadius.circular(16), // Bentuk QR Code
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: QrImageView(
                data:
                    "penambahan:10", // Sesuaikan data dengan format yang Anda butuhkan
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "QR Code untuk Pengisian BBM",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
