import 'package:flutter/material.dart';
import 'package:milestone/pages/create_route_page.dart';
import 'package:milestone/pages/exploreMore_page.dart';
import 'package:milestone/pages/explore_page.dart';
import 'package:milestone/pages/forgot_password.dart';
import 'package:milestone/pages/codeVerificationScreen.dart';
import 'package:milestone/pages/main_page.dart';
import 'package:milestone/pages/profile_page.dart';
import 'package:milestone/pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:milestone/pages/savedRoutesPage.dart';
import 'package:milestone/pages/singIn_page.dart';
import 'package:milestone/pages/splash_screen.dart';
import 'package:milestone/pages/successCodePage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: '/splash', // Set splash screen as the initial route
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (context) => SplashScreen());
          case '/signIn':
            return _createPageRoute(SignInPage());
          case '/createRoute':
            return _createPageRoute(CreateRoutePage());
          case '/register':
            return _createPageRoute(RegisterPage());
          case '/forgotPassword':
            return _createPageRoute(forgotPassword());
          case '/codeVerificationScreen':
            return _createPageRoute(codeVerificationScreen());
          case '/success':
            return _createPageRoute(SuccessScreen());
          case '/savedRoutesPage':
            return _createPageRoute(SavedRoutesPage());
          case '/mainPage':
            return _createPageRoute(MainPage());
          case '/explorePage':
            return _createPageRoute(ExplorePage());
          case '/exploreMorePage':
            return _createPageRoute(ExploreMorePage());
          case '/profilePage':
            return _createPageRoute(ProfilePage());
          default:
            return null; // Add a default route if needed
        }
      },
    );
  }
}

// Custom Page Route to Apply Animations
PageRouteBuilder _createPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Slide from right
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      // Slide transition
      return SlideTransition(position: offsetAnimation, child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
