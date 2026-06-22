import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import 'home_screen.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Consumer2<CartProvider, FavoritesProvider>(
        builder: (context, cart, favorites, _) {
          return NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              const NavigationDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon: Icon(Icons.category),
                label: 'الفئات',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: favorites.count > 0,
                  label: Text('${favorites.count}'),
                  child: const Icon(Icons.favorite_border),
                ),
                selectedIcon: const Icon(Icons.favorite),
                label: 'المفضلة',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: cart.count > 0,
                  label: Text('${cart.count}'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                selectedIcon: const Icon(Icons.shopping_cart),
                label: 'السلة',
              ),
            ],
          );
        },
      ),
    );
  }
}
