import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Imports Flutter material
import 'package:WeServe/services/auth.dart'; // Imports the auth.dart file which has the AuthService Class
import 'screens/wrapper.dart';
import 'package:provider/provider.dart'; // Imports the provider package
import 'package:flutter/services.dart';

void main() => runApp(RootWidget());

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
