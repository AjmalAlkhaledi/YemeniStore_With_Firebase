import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
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
}
