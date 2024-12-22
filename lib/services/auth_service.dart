import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final userCollection = FirebaseFirestore.instance.collection("users");

  // Get the current user directly from FirebaseAuth
  User? get user => _auth.currentUser;

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Signed in user UID: ${userCredential.user!.uid}");
      return null; // No error
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
      // Check for existing email or username in Firestore
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

      // Register user with Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user details to Firestore
      await userCollection.doc(userCredential.user!.uid).set({
        "name": name,
        "email": email,
      });

      return null; // Successful registration
    } catch (e) {
      return "Kayıt sırasında hata oluştu: $e";
    }
  }

  Future<bool?> forgotPasswordEmailCheck({required String email}) async {
    try {
      final existingEmail =
          await userCollection.where("email", isEqualTo: email).get();
      return existingEmail.docs.isEmpty;
    } catch (e) {
      return null;
    }
  }

  Future<void> forgotPasswordEmailSend({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Failed to send password reset email: $e");
    }
  }
}
