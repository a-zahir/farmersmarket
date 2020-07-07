import 'dart:async';
import 'dart:io';
import 'package:farmers_market/src/blocs/auth_bloc.dart';
import 'package:farmers_market/src/styles/base.dart';
import 'package:farmers_market/src/styles/text.dart';
import 'package:farmers_market/src/widgets/alerts.dart';
import 'package:farmers_market/src/widgets/button.dart';
import 'package:farmers_market/src/widgets/social_button.dart';
import 'package:farmers_market/src/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Signup extends StatefulWidget {
  StreamSubscription _userSubscription;
  StreamSubscription _errorMessageSubscription;

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  void initState(){
    final authBloc=Provider.of<AuthBloc>(context,listen: false);
    widget._userSubscription= authBloc.user.listen((user) {
      if(user!=null) Navigator.pushReplacementNamed(context, '/landing');
    });
    
    widget._errorMessageSubscription=authBloc.errorMessage.listen((errorMessage) {
      if(errorMessage!=''){
        AppAlerts.showErrorDialog(Platform.isIOS, context, errorMessage).then((_)=>authBloc.clearErrorMessage());
      }  //Show our alert
     });
        
    super.initState();
  }

  @override
  void dispose() {
    widget._userSubscription.cancel();
    widget._errorMessageSubscription.cancel();
    super.dispose();
  }

  


  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        child: pageBody(context, authBloc),
      );
    } else {
      return Scaffold(
        body: pageBody(context, authBloc),
      );
    }
  }

  Widget pageBody(BuildContext context, AuthBloc authBloc) {
    return ListView(
      padding: EdgeInsets.all(0.0),
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/top_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
        ),
        StreamBuilder<String>(
            stream: authBloc.email,
            builder: (context, snapshot) {
              return AppTextField(
                isIOS: Platform.isIOS,
                hintText: 'Email',
                cupertinoIcon: CupertinoIcons.mail_solid,
                materialIcon: Icons.email,
                textInputType: TextInputType.emailAddress,
                errorText: snapshot.error,
                onChanged: authBloc.changeEmail,
              );
            }),
        StreamBuilder<String>(
            stream: authBloc.password,
            builder: (context, snapshot) {
              return AppTextField(
                isIOS: Platform.isIOS,
                hintText: 'Password',
                cupertinoIcon: IconData(0xf4c9,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage),
                materialIcon: Icons.lock,
                obscureText: true,
                errorText: snapshot.error,
                onChanged: authBloc.changePassword,
              );
            }),
        StreamBuilder<bool>(
            stream: authBloc.isValid,
            builder: (context, snapshot) {
              return AppButton(
                buttonText: 'Signup',
                buttonType: (snapshot.data == true)
                    ? ButtonType.LightBlue
                    : ButtonType.Disabled,
                onPressed: authBloc.signupEmail
              );
            }),
        SizedBox(
          height: 6.0,
        ),
        Center(
          child: Text(
            'Or',
            style: TextStyles.suggestion,
          ),
        ),
        Padding(
          padding: BaseStyles.listPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppSocialButton(
                socialType: SocialType.Facebook,
              ),
              SizedBox(width: 15.0),
              AppSocialButton(
                socialType: SocialType.Google,
              ),
            ],
          ),
        ),
        Padding(
          padding: BaseStyles.listPadding,
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Already Have an Account?',
                  style: TextStyles.body,
                  children: [
                    TextSpan(
                        text: 'Login',
                        style: TextStyles.link,
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => Navigator.pushNamed(context, '/login'))
                  ])),
        )
      ],
    );
  }
}
