// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import
import 'package:flutter/material.dart';
import 'package:milestone/buttons/custom_button.dart';
import '../services/auth_service.dart';
import '../textfields/custom_snackbar.dart';
import '../buttons/google_login_button.dart';
import '../buttons/register_button.dart';
import '../buttons/register_login_button.dart';
import '../services/validation_service.dart';
import '../textfields/email_text_field.dart';
import '../textfields/password_text_field.dart';
import '../textfields/username_text_field.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';

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
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // Tüm TextField'lardan odağı kaldırır
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: appBackground,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Sifremi Unuttum",
                  style: TextStyle(
                    fontSize: height * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.05),
                Text(
                  "Please enter your email to reset the passsword",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: height * 0.05),
                EmailTextField(controller: _tForgotEmail),
                SizedBox(height: height * 0.05),
                CustomButton(
                  button_text: 'Mail Gonder',
                  onPressed: () async {
                    final forgotEmail = _tForgotEmail.text;
                    print("$forgotEmail");
                    final result = await AuthService()
                        .forgotPasswordEmailCheck(email: forgotEmail);
                    if (result == false) {
                      AuthService().forgotPasswordEmailSend(email: forgotEmail);
                      Navigator.pushNamed(context, '/register');
                    } else if (result == true) {
                      CustomSnackbar.showMessage(
                        context,
                        "Bu email ile kayıtlı bir hesap bulunmuyor.",
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
