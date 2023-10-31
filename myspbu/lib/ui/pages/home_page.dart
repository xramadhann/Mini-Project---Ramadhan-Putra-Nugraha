import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myspbu/data/models/shared_data.dart';
import 'package:myspbu/provider/user_points_provider.dart';
import 'package:myspbu/widget/carousel_widget.dart' as MyCarousel;
import 'package:myspbu/provider/news_api_provider.dart';
import 'package:provider/provider.dart';

import 'chatbot.dart';
import 'qrcodepage.dart';

class HomePage extends StatefulWidget {
  final int currentIndex;

  const HomePage({required this.currentIndex, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(currentIndex);
}

class _HomePageState extends State<HomePage> {
  late int _currentIndex;

  _HomePageState(this._currentIndex);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    // Fetch user points and news data when the widget initializes
    Provider.of<UserPointsProvider>(context, listen: false)
        .getUserPointsFromFirebase();
    Provider.of<NewsApiProvider>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final userPointsProvider = Provider.of<UserPointsProvider>(context);
    final newsApiProvider = Provider.of<NewsApiProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Hallo',
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  Text(
                    'Semangat hari ini!',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: 1000,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userPointsProvider.isLoading)
                        CircularProgressIndicator() // Display loader while loading
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Poin ${userPointsProvider.userPoints}',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const Text(
                              'Sisa poin anda',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QRCodePage(
                                      currentIndex: _currentIndex,
                                      userId: 'user1',
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Tampilkan QR Code Anda'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) {
                                    return userPointsProvider.isLoading
                                        ? Colors.grey
                                        : Colors.orange;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Event Mingguan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            MyCarousel.CarouselWidget(
              imagesData: imagesData
                  .map((data) => MyCarousel.ImageInfo(
                        imagePath: data.imagePath,
                        title: data.title,
                        description: data.description,
                        content: data.content,
                      ))
                  .toList(),
              onPageChanged: (index) {
                // Actions to be executed when the page changes
              },
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Berita Terkini',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: newsApiProvider.isLoading
                    ? 1
                    : newsApiProvider.posts.length,
                itemBuilder: (context, index) {
                  if (newsApiProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          elevation: 4,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${newsApiProvider.posts[index]['title']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${newsApiProvider.posts[index]['description']}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatBotScreen(),
            ),
          );
        },
        child: const Icon(Icons.chat),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
