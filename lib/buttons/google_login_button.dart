import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleButton({super.key, required this.onPressed});

  Future<void> _signInWithGoogle() async {
    try {
      // Kullanıcıyı Google ile giriş yapmaya yönlendir
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        // Google'dan doğrulama bilgilerini al
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Firebase'e giriş yapmak için bir kimlik bilgisi oluştur
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Firebase ile giriş yap
        await FirebaseAuth.instance.signInWithCredential(credential);
        debugPrint("Google Sign-In başarılı!");
      }
    } catch (e) {
      debugPrint("Google Sign-In başarısız: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        await _signInWithGoogle(); // Google ile giriş fonksiyonunu çağırıyoruz
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFF45474B),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Container(
        width: 260, // Buton genişliği
        height: 71, // Buton yüksekliği
        decoration: BoxDecoration(
          color: const Color(0xFF45474B), // Buton arka plan rengi
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            // G harfi için kutu
            Container(
              width: 60, // Kutunun genişliği
              height: 60, // Kutunun yüksekliği
              decoration: const BoxDecoration(
                color: Colors.white, // Arka plan rengi
                shape: BoxShape.circle, // Daire
              ),
              alignment: Alignment.center,
              child: const Text(
                'G', // G harfi
                style: TextStyle(
                  color: Colors.black, // Yazı rengi
                  fontSize: 30, // G yazı boyutu
                  fontWeight: FontWeight.bold, // Kalınlık
                ),
              ),
            ),
            const SizedBox(width: 35), // G ile yazı arasındaki boşluk

            const Text(
              'Google',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
