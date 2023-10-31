import 'package:flutter/material.dart';
import 'package:myspbu/data/models/shared_data.dart';
import 'package:myspbu/widget/image_detail_page.dart';

class ImageListPage extends StatelessWidget {
  const ImageListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            top: 70), // Tambahkan padding ke daftar gambar
        child: ListView.builder(
          itemCount: imagesData.length,
          itemBuilder: (context, index) {
            final imageInfo = imagesData[index];
            if (imageInfo != null) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageDetailPage(
                        assetImagePath: imageInfo.imagePath ?? '',
                        imageTitle: imageInfo.title ?? '',
                        imageDescription: imageInfo.description ?? '',
                        imageContent: imageInfo.content ?? '',
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  elevation: 4, // Elevasi card
                  child: ListTile(
                    title: Text(imageInfo.title ?? ''),
                    subtitle: Text(imageInfo.description ?? ''),
                    leading: Image.asset(
                      imageInfo.imagePath ?? '',
                      width: 80, // Lebar gambar
                      height: 80, // Tinggi gambar
                    ),
                  ),
                ),
              );
            } else {
              // Handle the case where imageInfo is null
              return const SizedBox(); // Return an empty container or other UI as needed
            }
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
            padding: const EdgeInsets.symmetric(horizontal: 115, vertical: 10),
            child: Text(
              'Event Mingguan',
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
