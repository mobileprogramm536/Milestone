import 'package:flutter/material.dart';
import 'package:milestone/services/auth_service.dart';
import 'package:milestone/pages/main_page.dart';
import 'package:milestone/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if the user is logged in using AuthService
  Future<void> _checkLoginStatus() async {
    final user = _authService.user;

    // Delay to simulate splash screen duration
    await Future.delayed(const Duration(seconds: 3));

    if (user != null) {
      // User is logged in, navigate to mainPage
      Navigator.pushReplacementNamed(context, '/mainPage');
    } else {
      // User is not logged in, navigate to signIn
      Navigator.pushReplacementNamed(context, '/signIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green1, // Your splash screen background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on, // Replace with your app's logo/icon
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              "Milestone App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
