import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance.collection("users");

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Firebase Authentication ile kullanıcıyı kaydet
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kullanıcı kaydedildikten sonra Firestore'a ek bilgiler ekleyin
      await userCollection.doc(userCredential.user!.uid).set({
        "name": name,
        "email": email,
        // Şifreyi Firestore'da saklamamak daha güvenlidir
      });

      print("Kayıt başarılı: Kullanıcı ID -> ${userCredential.user!.uid}");
    } catch (e) {
      print("Kayıt sırasında hata oluştu: $e");
    }
  }
}
