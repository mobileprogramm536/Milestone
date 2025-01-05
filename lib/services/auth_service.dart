import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users");

  // Mevcut kullanıcıyı döndür
  User? get user => _auth.currentUser;

  // Kullanıcı çıkışı
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Kullanıcı Girişi
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("Giriş başarılı. UID: ${userCredential.user!.uid}");
      return null; // Hata yok
    } catch (e) {
      return "Giriş sırasında hata oluştu: $e";
    }
  }

  // Kullanıcı Kaydı
  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
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

      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCollection.doc(userCredential.user!.uid).set({
        "name": name,
        "email": email,
        "profileImage": "",
        "followers": 0,
        "routes": 0,
        "categories": [],
        "savedRoutes": [],
      });

      return null;
    } catch (e) {
      return "Kayıt sırasında hata oluştu: $e";
    }
  }

  // Şifremi unuttum kontrolü
  Future<bool?> forgotPasswordEmailCheck({required String email}) async {
    try {
      final existingEmail =
      await userCollection.where("email", isEqualTo: email).get();
      return existingEmail.docs.isEmpty;
    } catch (e) {
      return null;
    }
  }

  // Şifre sıfırlama e-postası gönderme
  Future<void> forgotPasswordEmailSend({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Şifre sıfırlama e-postası gönderilemedi: $e");
    }
  }

  // Kullanıcı Profil Bilgilerini Getir
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Kullanıcı profili alınamadı: $e");
    }
    return null;
  }

  // Profil Resmi Güncelle
  Future<void> updateProfileImage(String uid, String imageUrl) async {
    try {
      await userCollection.doc(uid).update({
        "profileImage": imageUrl,
      });
    } catch (e) {
      print("Profil resmi güncellenemedi: $e");
    }
  }

  // Kullanıcı Adı Güncelle
  Future<void> updateUsername(String uid, String newName) async {
    try {
      await userCollection.doc(uid).update({
        "name": newName,
      });
    } catch (e) {
      print("Kullanıcı adı güncellenemedi: $e");
    }
  }

  // Kullanıcının Takipçi Sayısını Artır
  Future<void> updateFollowers(String uid, int increment) async {
    try {
      await userCollection.doc(uid).update({
        "followers": FieldValue.increment(increment),
      });
    } catch (e) {
      print("Takipçi sayısı güncellenemedi: $e");
    }
  }

  // Kullanıcının Rota Sayısını Artır
  Future<void> updateRoutes(String uid, int increment) async {
    try {
      await userCollection.doc(uid).update({
        "routes": FieldValue.increment(increment),
      });
    } catch (e) {
      print("Rota sayısı güncellenemedi: $e");
    }
  }

  // Kullanıcının Kaydedilen Rotalarını Al
  Future<List<String>> getSavedRoutes(String uid) async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        return List<String>.from(doc['savedRoutes'] ?? []);
      }
    } catch (e) {
      print("Kaydedilen rotalar alınamadı: $e");
    }
    return [];
  }

  // Kaydedilen Rotayı Güncelle
  Future<void> updateSavedRoutes(String uid, String routeId, bool add) async {
    try {
      if (add) {
        await userCollection.doc(uid).update({
          "savedRoutes": FieldValue.arrayUnion([routeId]),
        });
      } else {
        await userCollection.doc(uid).update({
          "savedRoutes": FieldValue.arrayRemove([routeId]),
        });
      }
    } catch (e) {
      print("Rota kaydetme işlemi başarısız: $e");
    }
  }

  // Kategori Güncelleme
  Future<void> updateCategory(String uid, String category) async {
    try {
      await userCollection.doc(uid).update({
        "categories": FieldValue.arrayUnion([category]),
      });
    } catch (e) {
      print("Kategori güncellenemedi: $e");
    }
  }

  // Oturumu Açmış Kullanıcının UID'sini Al
  Future<String?> getUserId() async {
    try {
      final User? currentUser = _auth.currentUser;
      return currentUser?.uid;
    } catch (e) {
      print("Kullanıcı ID alınamadı: $e");
      return null;
    }
  }
}
