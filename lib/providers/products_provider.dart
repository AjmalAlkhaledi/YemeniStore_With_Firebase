import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class ProductsProvider extends ChangeNotifier {
  final FirestoreService _service;
  StreamSubscription<List<Product>>? _subscription;

  List<Product> _products = [];
  bool _isLoading = true;

  ProductsProvider(this._service) {
    _subscription = _service.productsStream().listen((data) {
      _products = data;
      _isLoading = false;
      notifyListeners();
    }, onError: (_) {
      _isLoading = false;
      notifyListeners();
    });
  }

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  List<String> get categories =>
      _products.map((p) => p.category).toSet().toList();

  List<Product> byCategory(String category) =>
      _products.where((p) => p.category == category).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
