import 'package:flutter/material.dart';

import '../theme/colors.dart';

class SuccessScreen extends StatefulWidget {
  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.darkgrey1,
              AppColors.darkgrey2,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.greenAccent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.greenAccent,
                    size: 40,
                  ),
                ),
              ),
              SizedBox(height: 16), // İcon ile text arasında boşluk bırakır
              Text(
                'Mail Gonderildi!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
