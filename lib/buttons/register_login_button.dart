import 'package:flutter/material.dart';

import '../theme/colors.dart';

class LoginTextButton extends StatelessWidget {
  final VoidCallback onTap;

  LoginTextButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Text(
        'Giriş yap',
        style: TextStyle(
            color: AppColors.green1,
            fontSize: height * 0.021,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
