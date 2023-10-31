import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myspbu/widget/image_detail_page.dart';

class ImageInfo {
  final String imagePath;
  final String title;
  final String description;
  final String content;

  ImageInfo({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.content,
  });
}

class CarouselWidget extends StatefulWidget {
  final List<ImageInfo> imagesData;
  final Function(int) onPageChanged;

  CarouselWidget({required this.imagesData, required this.onPageChanged});

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: widget.imagesData.length,
      options: CarouselOptions(
        height: 150,
        viewportFraction: 1.0,
        aspectRatio: 16 / 9,
        autoPlay: true,
        enlargeCenterPage: false,
        enableInfiniteScroll: true,
        autoPlayCurve: Curves.fastOutSlowIn,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        onPageChanged: (index, reason) {
          widget.onPageChanged(index);
        },
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageDetailPage(
                      assetImagePath: widget.imagesData[index].imagePath,
                      imageTitle: widget.imagesData[index].title,
                      imageDescription: widget.imagesData[index].description,
                      imageContent: widget.imagesData[index].content,
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  image: DecorationImage(
                    image: AssetImage(widget.imagesData[index].imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
