import 'package:flutter/material.dart';
import 'package:milestone/services/auth_service.dart';
import '../buttons/google_login_button.dart';
import '../buttons/register_button.dart';
import '../buttons/register_login_button.dart';
import '../textfields/email_text_field.dart';
import '../textfields/password_text_field.dart';
import '../textfields/username_text_field.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _tName = TextEditingController();
  final _tEmail = TextEditingController();
  final _tPassword = TextEditingController();

  @override
  void dispose() {
    _tName.dispose();
    _tEmail.dispose();
    _tPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Tüm TextField'lardan odağı kaldırır
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
              UsernameTextField(controller: _tName),
              SizedBox(height: height * 0.015),
              EmailTextField(
                controller: _tEmail,
              ),
              SizedBox(height: height * 0.015),
              PasswordTextField(
                controller: _tPassword,
              ),
              SizedBox(height: height * 0.06),
              RegisterButton(
                onPressed: () {
                  final name = _tName.text;
                  final email = _tEmail.text;
                  final password = _tPassword.text;

                  print("name: $name");
                  print("email: $email");
                  print("password: $password");

                  if (name.isEmpty || email.isEmpty || password.isEmpty) {
                    print("Lütfen tüm alanları doldurun.");
                    return;
                  } else {
                    AuthService().registerUser(
                      name: name,
                      email: email,
                      password: password,
                    );
                  }
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
    ));
  }
}
