import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WeServe/services/auth.dart';
import 'package:WeServe/services/database.dart';
import 'package:provider/provider.dart';

class VolunteerSettingsPage extends StatefulWidget {
  @override
  _VolunteerSettingsPageState createState() => _VolunteerSettingsPageState();
}

class _VolunteerSettingsPageState extends State<VolunteerSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  String error = '';

  _showDeleteUserAlert(FirebaseUser user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Are you Sure?"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                DatabaseService(uid: user.uid).deleteAllVolunteerData();
                user.delete();
                Navigator.pop(context);
              },
              color: Colors.green,
              child: Text("Yes"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.green,
              child: Text("No"),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  InkWell _signOutButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(80.0),
      onTap: () async {
        var result = await _authService.signOut();
        if (result != null) {
          if (mounted) {
            setState(() {
              error = "Error signing out. Please try again later.";
            });
          }
        } else if (result == null) {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.red, Colors.red]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: Text(
          "Sign Out",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  InkWell _deleteAccountButton() {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return InkWell(
      borderRadius: BorderRadius.circular(80.0),
      onTap: () {
        _showDeleteUserAlert(user);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.red, Colors.red]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: Text(
          "Delete Account",
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
            _signOutButton(),
            SizedBox(
              height: 20,
            ),
            _deleteAccountButton(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
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
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _backButton(),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text("Settings",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 60.0)),
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60.0),
                ),
                child: _form(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
