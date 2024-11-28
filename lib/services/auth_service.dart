import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance.collection("users");

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      return "Giriş sırasında hata oluştu: $e";
    }
  }

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Firestore’da aynı e-posta veya kullanıcı adını kontrol et
      final existingUsers =
          await userCollection.where("email", isEqualTo: email).get();
      if (existingUsers.docs.isNotEmpty) {
        return "Bu e-posta zaten kullanımda.";
      }

      final existingUsernames =
          await userCollection.where("name", isEqualTo: name).get();
      if (existingUsernames.docs.isNotEmpty) {
        return "Bu kullanıcı adı zaten kullanımda.";
      }

      // Firebase Auth ile kullanıcıyı kaydet
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore’a ek bilgiler ekle
      await userCollection.doc(userCredential.user!.uid).set({
        "name": name,
        "email": email,
      });

      return null; // Başarılı bir kayıt dönerse null döndürür
    } catch (e) {
      return "Kayıt sırasında hata oluştu: $e";
    }
  }

  Future<bool?> forgotPasswordEmailCheck({required String email}) async {
    try {
      final existingEmail =
          await userCollection.where("email", isEqualTo: email).get();
      if (existingEmail.docs.isEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> forgotPasswordEmailSend({required String email}) async {
    try {
      _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return null;
    }
  }
}
