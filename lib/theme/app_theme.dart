// lib/theme.dart
import 'package:flutter/material.dart';

import 'colors.dart';

// Gradient (degrade) sabiti
const LinearGradient appBackground = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    AppColors.darkgrey1,
    AppColors.darkgrey2,
  ],
);
