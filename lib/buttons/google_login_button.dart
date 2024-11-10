import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  GoogleButton({required this.onPressed});

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        print("Google Sign-In successful.");
      }
    } catch (e) {
      print("Google Sign-In failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return OutlinedButton.icon(
      onPressed: () async {
        await _signInWithGoogle();
        onPressed();
      },
      icon: Icon(Icons.g_mobiledata, color: Colors.white, size: height * 0.03),
      label: Text(
        'Google',
        style: TextStyle(color: Colors.white, fontSize: height * 0.025),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey),
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.12,
          vertical: height * 0.02,
        ),
      ),
    );
  }
}
