import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/products_provider.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const YemeniStoreApp());
}

class YemeniStoreApp extends StatelessWidget {
  const YemeniStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
        Provider(create: (_) => firestore),
        ChangeNotifierProvider(create: (_) => ProductsProvider(firestore)),
        ChangeNotifierProvider(create: (_) => FavoritesProvider(firestore)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'متجر اليمن',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E7C66)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F6F8),
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        locale: const Locale('ar'),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        home: const AuthGate(),
      ),
    );
  }
}
