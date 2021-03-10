import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  static const _firebaseURL =
      'fluttercompleteguide-7ed4c-default-rtdb.europe-west1.firebasedatabase.app';

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageURL,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;

    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = this.isFavorite;
    this.isFavorite = !this.isFavorite;

    notifyListeners();

    final url = Uri.https(_firebaseURL, '/products/$id.json');

    try {
      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': isFavorite}),
      );

      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);

        throw HTTPException('Something went wrong.');
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);
    }
  }
}
