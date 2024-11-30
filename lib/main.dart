import 'package:flutter/material.dart';
import 'package:milestone/pages/forgot_password.dart';
import 'package:milestone/pages/codeVerificationScreen.dart';
import 'package:milestone/pages/register%20page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:milestone/pages/singIn_page.dart';
import 'package:milestone/pages/successCodePage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 18),
        bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: 14),
        headlineLarge: TextStyle(
            fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24),
        headlineMedium: TextStyle(
            fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ),
    debugShowCheckedModeBanner: false,
    initialRoute: '/signin',
    routes: {
      '/register': (context) => RegisterPage(),
      '/signin': (context) => SignInPage(),
      '/forgotPassword': (context) => forgotPassword(),
      '/codeVerificationScreen': (context) => codeVerificationScreen(),
      '/success': (context) => SuccessScreen(),
    },
  ));
}
