import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListNews(),
    );
  }
}

class ListNews extends StatefulWidget {
  @override
  _ListNewsState createState() => _ListNewsState();
}

class _NewsArticle {
  final String title;
  final String description;

  _NewsArticle({
    required this.title,
    required this.description,
  });
}

class _ListNewsState extends State<ListNews> {
  List<_NewsArticle> newsData = [];

  @override
  void initState() {
    super.initState();
    _fetchNewsData();
  }

  Future<void> _fetchNewsData() async {
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=us&apiKey=e6ca956d78254d5ea9c444240d8f1062'), // Ganti dengan URL API berita Anda.
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['articles'];
      List<_NewsArticle> articles = data
          .map((article) => _NewsArticle(
                title: article['title'],
                description: article['description'],
              ))
          .toList();

      setState(() {
        newsData = articles.take(4).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Berita'),
      ),
      body: ListView.builder(
        itemCount: newsData.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(newsData[index].title),
              subtitle: Text(newsData[index].description),
            ),
          );
        },
      ),
    );
  }
}
