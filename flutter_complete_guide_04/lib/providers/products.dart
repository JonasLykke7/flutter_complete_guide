import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './product.dart';

import '../models/http_exception.dart';

class Products with ChangeNotifier {
  static const _firebaseURL =
      'fluttercompleteguide-7ed4c-default-rtdb.europe-west1.firebasedatabase.app';

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageURL:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageURL:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageURL:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageURL:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prod) => prod.isFavorite).toList();
    // }

    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(_firebaseURL, '/products.json');

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      final List<Product> loadedProducts = [];

      extractedData.forEach((id, data) {
        loadedProducts.add(Product(
          id: id,
          title: data['title'],
          description: data['description'],
          price: data['price'],
          imageURL: data['imageURL'],
          isFavorite: data['isFavorite'],
        ));
      });

      _items = loadedProducts;
      // _items = [..._items, ...loadedProducts];
      // _items = _items..addAll(loadedProducts);

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findByID(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(_firebaseURL, '/products.json');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageURL': product.imageURL,
            'isFavorite': product.isFavorite
          },
        ),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageURL: product.imageURL,
      );

      _items.add(newProduct);
      // _items.insert(0, newProduct); // At the start of the list.
      notifyListeners();
    } catch (error) {
      print(error);

      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      final url = Uri.https(_firebaseURL, '/products/$id.json');

      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageURL': product.imageURL
          }));

      _items[index] = product;

      notifyListeners();
    } else {
      print('Error');
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[index];

    _items.removeAt(index);

    final url = Uri.https(_firebaseURL, '/products/$id.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(index, existingProduct);

      notifyListeners();

      throw HTTPException('Could not delete product.');
    }

    existingProduct = null;

    notifyListeners();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;

  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;

  //   notifyListeners();
  // }
}
