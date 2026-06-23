import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final FirestoreService _service;
  StreamSubscription<List<Product>>? _favSubscription;
  StreamSubscription<User?>? _authSubscription;
  String? _uid;
  List<Product> _items = [];

  FavoritesProvider(this._service) {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      _bind(user?.uid);
    });
  }

  List<Product> get items => List.unmodifiable(_items);

  int get count => _items.length;

  bool isFavorite(String id) => _items.any((p) => p.id == id);

  void _bind(String? uid) {
    if (uid == _uid) return;
    _uid = uid;
    _favSubscription?.cancel();
    _items = [];
    if (uid != null) {
      _favSubscription = _service.favoritesStream(uid).listen((data) {
        _items = data;
        notifyListeners();
      }, onError: (_) {});
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(Product product) async {
    final uid = _uid ?? FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    if (isFavorite(product.id)) {
      await _service.removeFavorite(uid, product.id);
    } else {
      await _service.addFavorite(uid, product);
    }
  }

  @override
  void dispose() {
    _favSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}
