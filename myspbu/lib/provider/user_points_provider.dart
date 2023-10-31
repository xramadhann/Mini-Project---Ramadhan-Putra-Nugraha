import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserPointsProvider with ChangeNotifier {
  int _userPoints = 0;
  bool _isLoading = false;

  int get userPoints => _userPoints;
  bool get isLoading => _isLoading;

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  void setUserPoints(int points) {
    _userPoints = points;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> getUserPointsFromFirebase() async {
    setLoading(true);
    try {
      int points =
          await _getUserPoints('user1'); // Ganti dengan ID pengguna yang sesuai
      setUserPoints(points);
    } catch (error) {
      print("Error: $error");
    }
    setLoading(false);
  }

  Future<int> _getUserPoints(String userId) async {
    int points = 0;
    try {
      final snapshot =
          await _databaseReference.child('User/$userId/Poin').get();
      if (snapshot != null && snapshot.exists) {
        points = snapshot.value as int;
      }
    } catch (error) {
      print("Error: $error");
    }
    return points;
  }
}
