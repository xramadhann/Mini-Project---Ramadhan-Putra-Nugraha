import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsApiProvider with ChangeNotifier {
  bool _isLoading = false;
  List _posts = [];

  bool get isLoading => _isLoading;
  List get posts => _posts;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          'https://newsapi.org/v2/everything?q=bahan bakar pertamina&apiKey=e6ca956d78254d5ea9c444240d8f1062',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _posts = data['articles'];
      }
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }
}
