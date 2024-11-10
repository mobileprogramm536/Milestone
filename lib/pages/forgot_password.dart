// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../textfields/custom_snackbar.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  final _tForgotEmail = TextEditingController();

  @override
  void dispose() {
    _tForgotEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sifremi Unuttum",
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              Text(
                "Please enter your email to reset the passsword",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _tForgotEmail,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF45474B),
                    hintText: "E-Posta",
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    labelText: "Please enter your email here",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    )),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final forgotEmail = _tForgotEmail.text;
                  print("$forgotEmail");
                  final result = await AuthService().forgotPasswordEmailCheck(email: forgotEmail);
                  if(result==false){
                    Navigator.pushNamed(context, '/codeVerificationScreen');
                  }
                  else if(result==true){
                    CustomSnackbar.showMessage(
                      context,
                      "Bu email ile kayıtlı bir hesap bulunmuyor.",
                      backgroundColor: Colors.red,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(260, 62),
                    backgroundColor: Color(0xFF379777)),
                child: Text(
                  'Kod Gonder',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
