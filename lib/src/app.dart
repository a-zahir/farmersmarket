import 'dart:io';

import 'package:farmers_market/src/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'blocs/auth_bloc.dart';
import 'routes.dart';

final authBloc = AuthBloc();

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider(
        create: (context) => authBloc,
      )
    ], child: PlatformApp());
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }
}

class PlatformApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        home: Login(),
        onGenerateRoute: Routes.cupertinoRoutes,
        theme: CupertinoThemeData(scaffoldBackgroundColor: Colors.white),
      );
    } else {
      return MaterialApp(
        home: Login(),
        onGenerateRoute: Routes.materialRoutes,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      );
    }
  }
}
