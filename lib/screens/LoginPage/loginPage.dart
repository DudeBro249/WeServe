import 'package:flutter/material.dart';
import 'package:WeServe/services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  String email = '';
  String password = '';

  String error = '';

  Container _emailField() {
    return Container(
      child: TextFormField(
        onChanged: (String value) {
          setState(() {
            email = value.trim();
          });
        },
        validator: (String val) {
          if (val.isEmpty) {
            return 'This field cannot be left empty';
          } else if (val.contains("@") == false) {
            return 'Not a valid email';
          } else {
            return null;
          }
        },
        obscureText: false,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
            ),
            hintText: "Enter email here",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
      ),
    );
  }

  Container _passwordField() {
    return Container(
      child: TextFormField(
        onChanged: (String value) {
          setState(() {
            password = value.toString();
          });
        },
        validator: (String val) {
          if (val.isEmpty) {
            return 'This field cannot be left empty';
          } else {
            return null;
          }
        },
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
            ),
            hintText: "Enter password here",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
      ),
    );
  }

  InkWell _submitButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(80.0),
      onTap: () async {
        if (_formKey.currentState.validate()) {
          var result = await _authService.signInWithEmailAndPassword(
              email: email, password: password);
          if (result == null) {
            setState(() {
              error = 'Error in signing you in. Please try again later';
            });
          } else {
            Navigator.pop(context);
          }
        } else {
          setState(() {
            error = 'Could not sign in with those credentials';
          });
        }
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
          "Submit",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  InkWell _backButton() {
    return InkWell(
      child: Icon(Icons.arrow_back),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Container _form() {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            _emailField(),
            SizedBox(
              height: 20,
            ),
            _passwordField(),
            SizedBox(height: 20),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: <Color>[
                      Colors.green,
                      Colors.blue,
                    ],
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _backButton(),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 60.0)),
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      child: _form(),
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 17.0),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
