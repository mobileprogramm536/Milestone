import 'package:flutter/material.dart';
import '../buttons/google_login_button.dart';
import '../buttons/register_button.dart';
import '../buttons/register_login_button.dart';
import '../textfields/email_text_field.dart';
import '../textfields/password_text_field.dart';
import '../textfields/username_text_field.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: appBackground,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.08,
              ),
              Text(
                'Hoş Geldiniz',
                style: TextStyle(color: Colors.white, fontSize: height * 0.021),
              ),
              Text(
                'Kayıt Ol',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.038,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height * 0.05),
              UsernameTextField(),
              SizedBox(height: height * 0.013),
              EmailTextField(),
              SizedBox(height: height * 0.013),
              PasswordTextField(),
              SizedBox(height: height * 0.06),
              RegisterButton(
                onPressed: () {
                  // Kayıt ol butonu tıklandığında yapılacak işlemler
                },
              ),
              SizedBox(height: height * 0.02),
              LoginTextButton(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: height * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.white1,
                      indent: 40,
                      endIndent: 20,
                      thickness: 2.5,
                    ),
                  ),
                  Text(
                    'ya da',
                    style: TextStyle(
                        color: AppColors.white1, fontSize: height * 0.017),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.white1,
                      indent: 20,
                      endIndent: 40,
                      thickness: 2.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.04),
              GoogleButton(
                onPressed: () {
                  // Google ile giriş işlemi
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
