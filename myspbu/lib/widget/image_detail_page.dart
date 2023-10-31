// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/pages/qrcodeEvent.dart';

class ImageDetailPage extends StatefulWidget {
  final String assetImagePath;
  final String imageTitle;
  final String imageDescription;
  final String imageContent;

  const ImageDetailPage({
    super.key,
    required this.assetImagePath,
    required this.imageTitle,
    required this.imageDescription,
    required this.imageContent,
  });

  @override
  _ImageDetailPageState createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  bool _isOfferTaken = false;
  bool _isButtonDisabled = false;
  int currentIndex = 0;
  String userId = "user1";

  @override
  void initState() {
    super.initState();
    _loadButtonStatus(); // Memeriksa status tombol saat inisialisasi halaman
  }

  // Fungsi untuk memeriksa status tombol dari SharedPreferences
  _loadButtonStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isTaken = prefs.getBool('button_taken_${widget.imageTitle}') ?? false;

    if (isTaken) {
      setState(() {
        _isOfferTaken = true;
        _isButtonDisabled = true;
      });
    }
  }

  // Fungsi untuk menyimpan status tombol ke SharedPreferences
  _saveButtonStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('button_taken_${widget.imageTitle}', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.only(
          top: 10,
        ), // Margin dari atas dan kiri
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white
              .withOpacity(0.5), // Latar belakang bulat dengan opacity
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Fungsi untuk kembali saat tombol ditekan
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startTop, // Letakkan di kiri atas
      body: Column(
        children: [
          SizedBox(height: 21),
          SizedBox(
            height: 170,
            width: 500,
            child: ClipRRect(
              child: Image.asset(
                widget.assetImagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.imageTitle,
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.imageDescription,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.imageContent,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(),
          ),
          ElevatedButton(
            onPressed: () {
              if (!_isOfferTaken) {
                _showConfirmationDialog();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isButtonDisabled ? Colors.grey : Colors.orange,
            ),
            child: Text(
              _isButtonDisabled ? 'Penawaran Sudah Diambil' : 'Ambil Penawaran',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Anda yakin ingin mengambil penawaran ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ya'),
              onPressed: () {
                setState(() {
                  _isOfferTaken = true;
                  _isButtonDisabled = true;
                });
                // Simpan status tombol ke SharedPreferences
                _saveButtonStatus();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodeEvent(
                      currentIndex: currentIndex,
                      userId: userId,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
