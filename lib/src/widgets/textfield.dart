import 'package:farmers_market/src/styles/text.dart';
import 'package:farmers_market/src/styles/textfields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final bool isIOS;
  final String hintText;
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final TextInputType textInputType;
  final bool obscureText;
  final void Function(String) onChanged;
  final String errorText;

  AppTextField({
    @required this.isIOS,
    @required this.hintText,
    @required this.materialIcon,
    @required this.cupertinoIcon,
    this.textInputType=TextInputType.text,
    this.obscureText=false,
    this.onChanged,
    this.errorText,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode _node;
  bool displayCupertinoErrorBorder;
  TextEditingController _controller;

  @override
  void initState() {
    _node=FocusNode();
    _controller=TextEditingController();
    _node.addListener(_handleFocusChange);
    displayCupertinoErrorBorder=false;
    super.initState();
  }

  void _handleFocusChange(){
    if(_node.hasFocus==false && widget.errorText!=null){
      displayCupertinoErrorBorder=true;
    }else{
      displayCupertinoErrorBorder=false;
    }
    widget.onChanged(_controller.text);
  }

  @override
  void dispose(){
    _node.removeListener(_handleFocusChange);
    _node.dispose();
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (widget.isIOS) {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: TextfieldStyles.textBoxHorizontal,
            vertical: TextfieldStyles.textBoxVertical,
          ),
        child: Column(
          children: <Widget>[
            CupertinoTextField(
              keyboardType: widget.textInputType,
              padding: EdgeInsets.all(12.0),
              placeholder: widget.hintText,
              placeholderStyle: TextfieldStyles.placeholder,
              style: TextfieldStyles.text,
              textAlign: TextfieldStyles.textAlign,
              cursorColor: TextfieldStyles.cursorColor,
              decoration: (displayCupertinoErrorBorder)?TextfieldStyles.cupertinoErrorDecoration:TextfieldStyles.cupertinoDecoration,
              prefix: TextfieldStyles.iconPrefix(widget.cupertinoIcon),
              obscureText: widget.obscureText,
              onChanged: widget.onChanged,
              focusNode:_node,
              controller: _controller,
            ),
            (widget.errorText!=null)?Padding(
              padding: const EdgeInsets.only(top:5.0,left:10.0),
              child: Row(children: <Widget>[Text(widget.errorText,style: TextStyles.error,)],),
            ):Container()
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: TextfieldStyles.textBoxHorizontal,
            vertical: TextfieldStyles.textBoxVertical,
          ),
        child: TextField(
          keyboardType: widget.textInputType,
          cursorColor: TextfieldStyles.cursorColor,
          style: TextfieldStyles.text,
          textAlign: TextfieldStyles.textAlign,
          decoration: TextfieldStyles.materialDecoration(widget.hintText, widget.materialIcon,widget.errorText),
          obscureText: widget.obscureText,
          onChanged: widget.onChanged,
        ),
      );
    }
  }
}
