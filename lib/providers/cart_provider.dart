import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  List<CartItem> get itemsList => _items.values.toList();

  int get count => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.values
      .fold(0.0, (sum, item) => sum + item.product.price * item.quantity);

  bool isInCart(String id) => _items.containsKey(id);

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void increase(String id) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
      notifyListeners();
    }
  }

  void decrease(String id) {
    if (!_items.containsKey(id)) return;
    final item = _items[id]!;
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
