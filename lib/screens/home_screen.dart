import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/products_provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../widgets/cart_icon_button.dart';
import '../widgets/product_card.dart';
import 'category_products_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('متجر اليمن'),
        actions: [
          const CartIconButton(),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () => context.read<AuthService>().signOut(),
          ),
        ],
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.products.isEmpty) {
            return const _EmptyProducts();
          }
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            children: [
              for (final category in provider.categories)
                _CategorySection(
                  category: category,
                  products: provider.byCategory(category),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyProducts extends StatefulWidget {
  const _EmptyProducts();

  @override
  State<_EmptyProducts> createState() => _EmptyProductsState();
}

class _EmptyProductsState extends State<_EmptyProducts> {
  bool _seeding = false;

  Future<void> _seed() async {
    setState(() => _seeding = true);
    try {
      await FirestoreService().seedProducts();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذّر رفع المنتجات')),
        );
      }
    } finally {
      if (mounted) setState(() => _seeding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inventory_2_outlined,
              size: 80, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('لا توجد منتجات بعد', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _seeding ? null : _seed,
            icon: _seeding
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_upload_outlined),
            label: const Text('رفع المنتجات إلى Firestore'),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String category;
  final List<Product> products;

  const _CategorySection({required this.category, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CategoryProductsScreen(category: category),
                    ),
                  );
                },
                child: const Text('عرض الكل'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 160,
                child: ProductCard(product: products[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
