import 'package:flutter/material.dart';

import '../theme/colors.dart';

class AiPage extends StatelessWidget {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color:
            AppColors.darkgrey2, // Arkaplan rengini değiştirin (isteğe bağlı)
        child: const Text(
          'Coming Soon',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.green1, // Yazı rengi
          ),
        ),
      ),
    );
  }
}
