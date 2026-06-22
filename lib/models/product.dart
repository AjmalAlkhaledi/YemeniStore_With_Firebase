import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory Product.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Product(
      id: doc.id,
      title: (data['title'] ?? '').toString(),
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      description: (data['description'] ?? '').toString(),
      category: (data['category'] ?? '').toString(),
      image: (data['image'] ?? '').toString(),
    );
  }

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      title: (data['title'] ?? '').toString(),
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      description: (data['description'] ?? '').toString(),
      category: (data['category'] ?? '').toString(),
      image: (data['image'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
    };
  }
}
