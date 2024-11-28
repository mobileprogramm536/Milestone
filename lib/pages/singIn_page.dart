import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:milestone/buttons/signIn_button.dart';
import 'package:milestone/buttons/signIn_register_button.dart';
import 'package:milestone/pages/register%20page.dart';
import 'package:milestone/services/auth_service.dart';
import '../buttons/google_login_button.dart';
import '../services/validation_service.dart';
import '../textfields/custom_snackbar.dart';
import '../textfields/custom_textfield.dart';
import '../textfields/password_text_field.dart';
import '../theme/app_theme.dart';
import '../theme/colors.dart';
import 'forgot_password.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _tEmail = TextEditingController();
  final _tPassword = TextEditingController();

  @override
  void dispose() {
    _tEmail.dispose();
    _tPassword.dispose();
    super.dispose();
  }

  void _Login() async {
    final email = _tEmail.text;
    final password = _tPassword.text;

    // 1. Girdileri doğrula
    final emailError = ValidationService.validateEmail(email);
    final passwordError = ValidationService.validatePassword(password);

    if (emailError != null) {
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

    // 2. Firebase giriş kontrol yap
    final result = await AuthService().signIn
      (
      email: email,
      password: password,
    );

    if (result != null) {
      // Firebase'den hata mesajı dönerse göster
      _showMessage(result);
    } else {
      // Giriş başarılıysa
      CustomSnackbar.showMessage(
        context,
        "Giriş başarılı!",
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
                      height: height * 0.25,
                    ),
                    Text(
                      'milestone',
                      style: TextStyle(
                          color: AppColors.white1,
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.07),
                    ),
                    SizedBox(height: height * 0.05),
                    CustomTextField(
                    controller: _tEmail,
                    hintText: 'E-Posta',
                    icon: EvaIcons.emailOutline,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    ),
                    SizedBox(height: height * 0.015),
                    PasswordTextField(
                      controller: _tPassword,
                    ),
                    SizedBox(height: height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end ,
                      children: [
                        GestureDetector(
                          onTap:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> forgotPassword()));
                          },
                          child: Text(
                            'Şifremi Unuttum',
                            style: TextStyle(
                                color: AppColors.green1,
                                fontSize: height * 0.017),
                          ),
                        ),
                        Spacer(flex:20)
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    SignInButton(
                      onPressed: () async {
                        _Login();
                        _tEmail.clear();
                        _tPassword.clear();
                        
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    RegisterTextButton(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
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