import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myspbu/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'qrCodeScanner.dart';

final databaseReference = FirebaseDatabase.instance.reference();

Future<void> catatTransaksi(String userId, String namaEvent, int poin) async {
  var transaksiId = databaseReference.child("Transaksi").push().key!;
  var transaksiData = {
    'NamaEvent': namaEvent,
    'PoinBerkurang': poin,
    'TanggalTransaksi': DateTime.now().toLocal().toString(),
    'UserID': userId,
  };
  await databaseReference
      .child('Transaksi')
      .child(transaksiId)
      .set(transaksiData);
}

void tambahPoin() async {
  const String userId = "user1";
  final int poinDikurangkan = 10;
  // Dapatkan poin saat ini pengguna
  DataSnapshot userSnapshot = (await databaseReference
      .child("User")
      .child(userId)
      .child("Poin")
      .once()) as DataSnapshot;
  int poinSaatIni = userSnapshot.value as int;

  // Kurangi poin
  int poinBaru = poinSaatIni - poinDikurangkan;

  // Perbarui nilai poin di Firebase
  await databaseReference
      .child("User")
      .child(userId)
      .child("Poin")
      .set(poinBaru);

  // Setelah mengurangkan poin, catat transaksi
  await catatTransaksi(userId, "Nama Event", poinDikurangkan);
}

class QRCodeEvent extends StatelessWidget {
  final int currentIndex;

  const QRCodeEvent(
      {required this.currentIndex, Key? key, required String userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String userId = "user1";
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
                data: "pengurangan:10",
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "QR Code untuk Penukaran Event",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.topRight, // Posisikan di pojok kanan atas
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
