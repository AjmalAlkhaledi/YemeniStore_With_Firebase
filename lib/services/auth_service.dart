import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> register(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() => _auth.signOut();

  String messageFromError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'البريد الإلكتروني غير صالح';
        case 'user-not-found':
          return 'لا يوجد حساب بهذا البريد';
        case 'wrong-password':
        case 'invalid-credential':
          return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
        case 'email-already-in-use':
          return 'هذا البريد مستخدم بالفعل';
        case 'weak-password':
          return 'كلمة المرور ضعيفة (6 أحرف على الأقل)';
        default:
          return 'حدث خطأ، حاول مرة أخرى';
      }
    }
    return 'حدث خطأ، حاول مرة أخرى';
  }
}
