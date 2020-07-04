import 'package:farmers_market/src/styles/textfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final bool isIOS;
  final String hintText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final TextInputType textInputType;
  final bool obscureText;

  AppTextField({
    @required this.isIOS,
    @required this.hintText,
    @required this.materialIcon,
    @required this.cupertinoIcon,
    this.textInputType,
    this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: TextfieldStyles.textBoxHorizontal,
            vertical: TextfieldStyles.textBoxVertical,
          ),
        child: CupertinoTextField(
          keyboardType: (textInputType!=null)?textInputType:TextInputType.text,
          padding: EdgeInsets.all(12.0),
          placeholder: hintText,
          placeholderStyle: TextfieldStyles.placeholder,
          style: TextfieldStyles.text,
          textAlign: TextfieldStyles.textAlign,
          cursorColor: TextfieldStyles.cursorColor,
          decoration: TextfieldStyles.cupertinoDecoration,
          prefix: TextfieldStyles.iconPrefix(cupertinoIcon),
          obscureText: (obscureText!=null)?obscureText:false,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: TextfieldStyles.textBoxHorizontal,
            vertical: TextfieldStyles.textBoxVertical,
          ),
        child: TextField(
          keyboardType: (textInputType!=null)?textInputType:TextInputType.text,
          cursorColor: TextfieldStyles.cursorColor,
          style: TextfieldStyles.text,
          textAlign: TextfieldStyles.textAlign,
          decoration: TextfieldStyles.materialDecoration(hintText, materialIcon),
          obscureText: (obscureText!=null)?obscureText:false,
        ),
      );
    }
  }
}
