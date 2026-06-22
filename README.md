# Student Name: Ajmal Yaseen Noaman Alkhaledi
# Dep: Software(3)
# YemeniStore with Firebase — (المحاضرة العاشرة)

تطوير المتجر السابق وإضافة **Firebase Authentication** و**Cloud Firestore**.

## الميزات
- تسجيل الدخول وإنشاء حساب عبر Email/Password.
- شاشة Login وشاشة Register مع التحقق من المدخلات.
- عرض شاشة مختلفة حسب حالة المستخدم باستخدام `StreamBuilder` على `authStateChanges`.
- مجموعة `products` في Firestore، وقراءتها لحظياً عبر `snapshots()`.
- `Product Model` مع `fromDoc()` / `toMap()`.
- زر لنقل المنتجات الوهمية (Mock Data) إلى Firestore عند أول تشغيل.
- مفضلة خاصة بكل مستخدم محفوظة في `users/{uid}/favorites` مع مزامنة لحظية عبر `set()` و`delete()` و`snapshots()`.

## خطوات إعداد Firebase (مطلوبة قبل التشغيل)

1. ثبّت الأدوات:
   ```bash
   dart pub global activate flutterfire_cli
   npm install -g firebase-tools
   firebase login
   ```
2. أنشئ مشروعاً على [Firebase Console](https://console.firebase.google.com) ثم فعّل:
   - **Authentication → Sign-in method → Email/Password**.
   - **Firestore Database** (Production أو Test mode).
3. اربط المشروع (سيُولّد ملف `lib/firebase_options.dart` الحقيقي ويستبدل القيم البديلة):
   ```bash
   flutterfire configure
   ```
4. شغّل التطبيق:
   ```bash
   flutter pub get
   flutter run
   ```
5. سجّل حساباً جديداً، ثم من الصفحة الرئيسية اضغط **«رفع المنتجات إلى Firestore»** لتعبئة المنتجات.

> ملف `lib/firebase_options.dart` الحالي يحتوي قيماً بديلة (`REPLACE_WITH_...`) ليُجمّع المشروع؛ يجب استبداله بتشغيل `flutterfire configure`.

## قواعد Firestore المقترحة
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{id} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    match /users/{uid}/favorites/{id} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```
