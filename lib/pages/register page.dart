import 'package:flutter/material.dart';
import 'package:milestone/services/auth_service.dart';
import '../buttons/google_login_button.dart';
import '../buttons/register_button.dart';
import '../buttons/register_login_button.dart';
import '../services/validation_service.dart';
import '../textfields/custom_snackbar.dart';
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

  void _register() async {
    final name = _tName.text;
    final email = _tEmail.text;
    final password = _tPassword.text;

    // 1. Girdileri doğrula
    final nameError = ValidationService.validateName(name);
    final emailError = ValidationService.validateEmail(email);
    final passwordError = ValidationService.validatePassword(password);

    if (nameError != null) {
      CustomSnackbar.showMessage(
        context,
        nameError,
        backgroundColor: Colors.red,
      );
      return;
    } else if (emailError != null) {
      CustomSnackbar.showMessage(
        context,
        emailError,
        backgroundColor: Colors.red,
      );
      return;
    } else if (passwordError != null) {
      CustomSnackbar.showMessage(
        context,
        passwordError,
        backgroundColor: Colors.red,
      );
      return;
    }

    // 2. Firebase kayıt işlemi yap
    final result = await AuthService().registerUser(
      name: name,
      email: email,
      password: password,
    );

    if (result != null) {
      // Firebase'den hata mesajı dönerse göster
      _showMessage(result);
    } else {
      // Kayıt başarılıysa
      CustomSnackbar.showMessage(
        context,
        "Kayıt başarılı!",
        backgroundColor: Colors.green,
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: GestureDetector(
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
                    SizedBox(
                      height: height * 0.15,
                    ),
                    Text(
                      'Hoş Geldiniz',
                      style: TextStyle(
                          color: Colors.white, fontSize: height * 0.021),
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
                      onPressed: () async {
                        _register();
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
                        const Expanded(
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
                              color: AppColors.white1,
                              fontSize: height * 0.017),
                        ),
                        const Expanded(
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
                    SizedBox(
                      height: height * 0.2,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
