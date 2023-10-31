// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final DatabaseReference _transaksiRef =
      FirebaseDatabase.instance.reference().child('Transaksi');

  List<TransactionData> transactionDataList = [];

  @override
  void initState() {
    super.initState();

    _transaksiRef.onChildAdded.listen((event) {
      var data = event.snapshot.value as Map<dynamic, dynamic>;
      if (data != null) {
        String namaEvent = data['NamaEvent'];
        if (namaEvent != null && namaEvent.isNotEmpty) {
          setState(() {
            transactionDataList.add(TransactionData(
              key: event.snapshot.key,
              namaEvent: namaEvent,
              poinBerkurang: data['PoinBerkurang'] != null
                  ? int.parse(data['PoinBerkurang'].toString())
                  : -1,
              tanggalTransaksi: data['TanggalTransaksi'] ?? "",
            ));
            // Sort the list by 'tanggalTransaksi' in ascending order
            transactionDataList.sort(
                (a, b) => a.tanggalTransaksi.compareTo(b.tanggalTransaksi));
            transactionDataList = transactionDataList.reversed.toList();
          });
        }
      }
    });
  }

  // Fungsi untuk menghapus transaksi dari Firebase Database
  void deleteTransactionFromFirebase(String? transactionKey) {
    if (transactionKey != null) {
      _transaksiRef.child(transactionKey).remove().then((_) {
        // Transaksi dihapus dari Firebase, sekarang Anda dapat menghapusnya dari daftar lokal
        setState(() {
          transactionDataList
              .removeWhere((transaction) => transaction.key == transactionKey);
        });
      }).catchError((error) {});
    }
  }

  String getTransactionSymbol(String namaEvent) {
    if (namaEvent.toLowerCase().contains("penukaran event")) {
      return "-";
    } else if (namaEvent.toLowerCase().contains("pengisian bbm")) {
      return "+";
    }
    return "?"; // Jika jenis transaksi tidak dikenali
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 80), // Tambahkan padding ke daftar g
        child: ListView.builder(
          itemCount: transactionDataList.length,
          itemBuilder: (context, index) {
            String symbol =
                getTransactionSymbol(transactionDataList[index].namaEvent);
            return Card(
              child: ListTile(
                title:
                    Text('Keterangan: ${transactionDataList[index].namaEvent}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Poin: $symbol ${transactionDataList[index].poinBerkurang >= 0 ? transactionDataList[index].poinBerkurang.toString() : "Data tidak ditemukan"} Poin'),
                    Text(
                        'Tanggal Transaksi: ${transactionDataList[index].tanggalTransaksi}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Panggil fungsi untuk menghapus transaksi dari Firebase
                    deleteTransactionFromFirebase(
                        transactionDataList[index].key);
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 60, left: 30),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Mengatur border radius
          ),
          color: Colors.orange,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
            child: Text(
              'Riwayat Transaksi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionData {
  final String? key; // Kunci transaksi di Firebase Database
  final String namaEvent;
  final int poinBerkurang;
  final String tanggalTransaksi;

  TransactionData(
      {this.key,
      required this.namaEvent,
      required this.poinBerkurang,
      required this.tanggalTransaksi});
}
