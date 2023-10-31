import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(QRCodeScannerApp());
}

class QRCodeScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QRCodeScannerScreen(
        imageTitle: '',
      ),
    );
  }
}

class QRCodeScannerScreen extends StatefulWidget {
  final String imageTitle;

  const QRCodeScannerScreen({required this.imageTitle});

  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  String scanResult = "Arahkan ke QR code untuk memindai.";
  int poin = 0;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    _initTotalPoin();
  }

  Future<void> _initTotalPoin() async {
    int totalPoin = await _getTotalPoin('user1');
    setState(() {
      poin = totalPoin;
    });
  }

  Future<void> scanQRCode() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      "#FF6600",
      "Batal",
      false,
      ScanMode.QR,
    );

    if (barcodeScanResult != "-1") {
      List<String> scanData = barcodeScanResult.split(":");
      if (scanData.length == 2) {
        String qrType = scanData[0];
        int poinTambahan = int.parse(scanData[1]);
        String eventName = ''; // Variabel untuk nama event

        int? angka;

        if (qrType == "penambahan") {
          angka = await showDialog<int>(
            context: context,
            builder: (context) {
              int? inputAngka;
              return AlertDialog(
                title: Text('Masukkan Angka'),
                content: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    inputAngka = int.tryParse(value);
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Batal'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(inputAngka);
                    },
                  ),
                ],
              );
            },
          );
        }

        if (angka != null) {
          poinTambahan *= angka; // Kalikan angka dengan poinTambahan
        }

        if (qrType == "penambahan") {
          int totalPoin = await _getTotalPoin('user1');
          totalPoin += poinTambahan;
          await _updatePoin('user1', totalPoin);
          eventName = 'Pengisian BBM';

          setState(() {
            scanResult = "Hasil Pemindaian: $poinTambahan poin";
            poin = totalPoin;
          });
        } else if (qrType == "pengurangan") {
          int totalPoin = await _getTotalPoin('user1');
          if (totalPoin >= poinTambahan) {
            totalPoin -= poinTambahan;
            await _updatePoin('user1', totalPoin);
            eventName = 'Penukaran Event';

            setState(() {
              scanResult = "Hasil Pemindaian: $barcodeScanResult";
              poin = totalPoin;
            });
          } else {
            setState(() {
              scanResult = "Poin tidak mencukupi untuk pemindaian ini.";
            });
          }
        }

        // Catat transaksi
        await catatTransaksi('user1', eventName, poinTambahan);
      } else {
        setState(() {
          scanResult = "QR code tidak valid.";
        });
      }
    }
  }

  Future<int> _getTotalPoin(String userId) async {
    int totalPoin = 0;
    try {
      final snapshot =
          await _databaseReference.child('User/$userId/Poin').get();
      if (snapshot != null && snapshot.exists) {
        totalPoin = snapshot.value as int;
      }
    } catch (error) {
      print("Error: $error");
    }
    return totalPoin;
  }

  Future<void> _updatePoin(String userId, int totalPoin) async {
    try {
      await _databaseReference.child('User/$userId/Poin').set(totalPoin);
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<void> catatTransaksi(String userId, String event, int poin) async {
    try {
      DatabaseReference transaksiReference =
          _databaseReference.child('Transaksi');
      DatabaseReference newTransaksiReference = transaksiReference.push();

      final Map<String, dynamic> transaksiData = {
        'NamaEvent': event,
        'PoinBerkurang': poin,
        'TanggalTransaksi': DateTime.now().toIso8601String(),
        'UserID': userId,
      };

      await newTransaksiReference.set(transaksiData);
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: scanQRCode,
                    child: Text('Pindai QR Code'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(scanResult),
            ),
          ),
        ],
      ),
    );
  }
}
