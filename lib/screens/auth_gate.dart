import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'main_navigation.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();
    return StreamBuilder<User?>(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        if (user == null) {
          return const LoginScreen();
        }
        return _FavoritesBinder(
          uid: user.uid,
          child: const MainNavigation(),
        );
      },
    );
  }
}

class _FavoritesBinder extends StatefulWidget {
  final String uid;
  final Widget child;

  const _FavoritesBinder({required this.uid, required this.child});

  @override
  State<_FavoritesBinder> createState() => _FavoritesBinderState();
}

class _FavoritesBinderState extends State<_FavoritesBinder> {
  late FavoritesProvider _favorites;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _favorites = context.read<FavoritesProvider>();
    _favorites.bind(widget.uid);
  }

  @override
  void didUpdateWidget(covariant _FavoritesBinder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uid != widget.uid) {
      _favorites.bind(widget.uid);
    }
  }

  @override
  void dispose() {
    _favorites.bind(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
