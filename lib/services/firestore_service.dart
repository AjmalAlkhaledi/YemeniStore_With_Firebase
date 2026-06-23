import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../data/seed_data.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _products =>
      _db.collection('products');

  Stream<List<Product>> productsStream() {
    return _products.snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Product.fromDoc(doc)).toList(),
        );
  }

  Future<void> seedProducts() {
    final batch = _db.batch();
    for (final item in seedProductsData) {
      final ref = _products.doc();
      batch.set(ref, item);
    }
    return batch.commit();
  }

  Future<bool> isEmpty() async {
    final snapshot = await _products.limit(1).get();
    return snapshot.docs.isEmpty;
  }

  CollectionReference<Map<String, dynamic>> _favorites(String uid) =>
      _db.collection('users').doc(uid).collection('favorites');

  Stream<List<Product>> favoritesStream(String uid) {
    return _favorites(uid).snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Product.fromDoc(doc)).toList(),
        );
  }

  Future<void> addFavorite(String uid, Product product) {
    return _favorites(uid).doc(product.id).set(product.toMap());
  }

  Future<void> removeFavorite(String uid, String productId) {
    return _favorites(uid).doc(productId).delete();
  }

  CollectionReference<Map<String, dynamic>> _cart(String uid) =>
      _db.collection('users').doc(uid).collection('cart');

  Stream<List<CartItem>> cartStream(String uid) {
    return _cart(uid).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        return CartItem(
          product: Product.fromMap(doc.id, data),
          quantity: (data['quantity'] as num?)?.toInt() ?? 1,
        );
      }).toList(),
    );
  }

  Future<void> addToCart(String uid, Product product) {
    return _cart(uid).doc(product.id).set({
      ...product.toMap(),
      'quantity': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Future<void> updateQuantity(String uid, String productId, int delta) {
    return _cart(uid).doc(productId).update({
      'quantity': FieldValue.increment(delta),
    });
  }

  Future<void> removeFromCart(String uid, String productId) {
    return _cart(uid).doc(productId).delete();
  }

  Future<void> clearCart(String uid) async {
    final snapshot = await _cart(uid).get();
    final batch = _db.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
