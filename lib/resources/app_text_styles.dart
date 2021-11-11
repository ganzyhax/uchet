import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final TextStyle blackBoldText = TextStyle(
    fontSize: 17,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle blackBigBoldText = TextStyle(
    fontSize: 24,
    color: AppColors.baseColor,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle blackSmallBoldText = TextStyle(
    fontSize: 15,
    color: AppColors.baseColor,
    fontWeight: FontWeight.w500,
  );
}
