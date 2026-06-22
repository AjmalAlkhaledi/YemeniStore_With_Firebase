import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/cart_icon_button.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
        actions: const [CartIconButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (_, _, _) => const SizedBox(
                height: 300,
                child:
                    Center(child: Icon(Icons.image_not_supported, size: 60)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(product.category),
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${product.price.toStringAsFixed(0)} \$',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('الوصف',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 15, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<CartProvider>(
                          builder: (context, cart, _) {
                            return ElevatedButton.icon(
                              onPressed: () {
                                cart.addToCart(product);
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('تمت الإضافة إلى السلة'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                              },
                              icon: const Icon(Icons.add_shopping_cart),
                              label: const Text('إضافة للسلة'),
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Consumer<FavoritesProvider>(
                        builder: (context, favorites, _) {
                          final fav = favorites.isFavorite(product.id);
                          return OutlinedButton.icon(
                            onPressed: () {
                              favorites.toggleFavorite(product);
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text(fav
                                        ? 'تمت الإزالة من المفضلة'
                                        : 'تمت الإضافة إلى المفضلة'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                            },
                            icon: Icon(
                              fav ? Icons.favorite : Icons.favorite_border,
                              color: fav ? Colors.red : null,
                            ),
                            label: const Text('المفضلة'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
