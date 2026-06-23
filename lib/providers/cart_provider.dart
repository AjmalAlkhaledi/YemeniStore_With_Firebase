import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class CartProvider extends ChangeNotifier {
  final FirestoreService _service;
  StreamSubscription<List<CartItem>>? _cartSubscription;
  StreamSubscription<User?>? _authSubscription;
  String? _uid;
  List<CartItem> _items = [];

  CartProvider(this._service) {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      _bind(user?.uid);
    });
  }

  List<CartItem> get itemsList => _items;

  int get count => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);

  bool isInCart(String id) => _items.any((item) => item.product.id == id);

  void _bind(String? uid) {
    if (uid == _uid) return;
    _uid = uid;
    _cartSubscription?.cancel();
    _items = [];
    if (uid != null) {
      _cartSubscription = _service.cartStream(uid).listen((data) {
        _items = data;
        notifyListeners();
      }, onError: (_) {});
    }
    notifyListeners();
  }

  String? get _currentUid => _uid ?? FirebaseAuth.instance.currentUser?.uid;

  Future<void> addToCart(Product product) async {
    final uid = _currentUid;
    if (uid == null) return;
    await _service.addToCart(uid, product);
  }

  Future<void> increase(String id) async {
    final uid = _currentUid;
    if (uid == null) return;
    await _service.updateQuantity(uid, id, 1);
  }

  Future<void> decrease(String id) async {
    final uid = _currentUid;
    if (uid == null) return;
    final item = _items.firstWhere(
      (i) => i.product.id == id,
      orElse: () => const CartItem(
        product: Product(
            id: '', title: '', price: 0, description: '', category: '', image: ''),
        quantity: 0,
      ),
    );
    if (item.quantity <= 1) {
      await _service.removeFromCart(uid, id);
    } else {
      await _service.updateQuantity(uid, id, -1);
    }
  }

  Future<void> removeFromCart(String id) async {
    final uid = _currentUid;
    if (uid == null) return;
    await _service.removeFromCart(uid, id);
  }

  Future<void> checkout() async {
    final uid = _currentUid;
    if (uid == null) return;
    await _service.clearCart(uid);
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}
