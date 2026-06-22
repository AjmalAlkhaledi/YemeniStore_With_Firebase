import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final FirestoreService _service;
  StreamSubscription<List<Product>>? _subscription;
  String? _uid;
  List<Product> _items = [];

  FavoritesProvider(this._service);

  List<Product> get items => List.unmodifiable(_items);

  int get count => _items.length;

  bool isFavorite(String id) => _items.any((p) => p.id == id);

  void bind(String? uid) {
    if (uid == _uid) return;
    _uid = uid;
    _subscription?.cancel();
    _items = [];
    if (uid != null) {
      _subscription = _service.favoritesStream(uid).listen((data) {
        _items = data;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(Product product) async {
    final uid = _uid;
    if (uid == null) return;
    if (isFavorite(product.id)) {
      await _service.removeFavorite(uid, product.id);
    } else {
      await _service.addFavorite(uid, product);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
