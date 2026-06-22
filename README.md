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


