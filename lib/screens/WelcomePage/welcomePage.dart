import 'package:WeServe/screens/LoginPage/loginPage.dart';
import 'package:flutter/material.dart';

import 'package:WeServe/screens/RegisterPage/registerPage.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  InkWell _choiceButton(String btnText, Widget ScreenPage) {
    return InkWell(
      borderRadius: BorderRadius.circular(80.0),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ScreenPage));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, Colors.green]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Text(
          btnText,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.green,
                  Colors.blue,
                ]),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("We",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0)),
              Text("Serve",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0)),
              SizedBox(
                height: 40,
              ),
              _choiceButton("Login", LoginPage()),
              SizedBox(
                height: 40,
              ),
              _choiceButton(
                  "Sign Up As a Senior",
                  RegisterPage(
                    isVolunteer: false,
                  )),
              SizedBox(
                height: 40,
              ),
              _choiceButton(
                  "Sign Up As a Volunteer",
                  RegisterPage(
                    isVolunteer: true,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
