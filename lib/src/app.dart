import 'dart:io';

import 'package:farmers_market/src/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformApp();
  }
}

class PlatformApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        home: Login(),
        onGenerateRoute: Routes.cupertinoRoutes,
      );
    } else {
      return MaterialApp(
        home: Login(),
        onGenerateRoute: Routes.materialRoutes,
      );
    }
  }
}
