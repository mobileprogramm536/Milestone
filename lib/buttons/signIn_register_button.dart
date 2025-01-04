import 'package:flutter/material.dart';

import '../theme/colors.dart';

class RegisterTextButton extends StatelessWidget {
  final VoidCallback onTap;

  const RegisterTextButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Text(
        'Kayıt Ol',
        style: TextStyle(
            color: AppColors.green1,
            fontSize: height * 0.021,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
