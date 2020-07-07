import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS){
      return CupertinoPageScaffold(  
        child: pageBody(),
      );
    }else{
      return Scaffold(
        body: pageBody(),
      );
    }
  }

  Widget pageBody(){
    return Center(child: Text('Products'),);
  }
}