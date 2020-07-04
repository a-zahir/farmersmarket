import 'package:farmers_market/src/styles/colors.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:flutter/material.dart';

import 'base.dart';

abstract class TextfieldStyles {
  static double get textBoxHorizontal => 25.0;

  static double get textBoxVertical => 8.0;

  static TextStyle get text=> TextStyles.body;

  static TextStyle get placeholder => TextStyles.suggestions;

  static Color get cursorColor => AppColors.darkgray;

  static Widget iconPrefix(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(
        icon,
        size: 35.0,
        color: AppColors.lightblue,
      ),
    );
  }

  static TextAlign get textAlign=> TextAlign.center;

  static BoxDecoration get cupertinoDecoration {
    return BoxDecoration(
        border: Border.all(
          color: AppColors.straw,
          width: BaseStyles.borderWidth,
        ),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius));
  }

  static InputDecoration materialDecoration(String hintText, IconData icon){
    return InputDecoration(  
      contentPadding: EdgeInsets.all(8.0),
      hintText: hintText,
      hintStyle: TextfieldStyles.placeholder,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(  
        borderSide: BorderSide(color: AppColors.straw,width: BaseStyles.borderWidth),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),
      enabledBorder: OutlineInputBorder(  
        borderSide: BorderSide(color: AppColors.straw,width: BaseStyles.borderWidth),
        borderRadius: BorderRadius.circular(BaseStyles.borderRadius)
      ),
      prefixIcon: iconPrefix(icon),
    );
  }

}
