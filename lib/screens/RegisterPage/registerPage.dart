import 'package:flutter/material.dart';
import 'package:WeServe/services/auth.dart';

class RegisterPage extends StatefulWidget {
  final bool isVolunteer;
  RegisterPage({this.isVolunteer});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  List<String> _communities = ["Adarsh Palm Retreat"];
  String _defaultCommunity = "Adarsh Palm Retreat";
  final AuthService _authService = AuthService();

  String username = '';
  String password = '';
  String email = '';
  String phoneNumber = '';
  String towerNumber = '';
  String block = '';
  String houseNumber = '';

  String error = '';

  InkWell _backButton() {
    return InkWell(
      child: Icon(Icons.arrow_back),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Container _houseNumberField() {
    return Container(
      height: 75,
      child: TextFormField(
        onChanged: (String value) {
          setState(() {
            houseNumber = value.trim();
          });
        },
        validator: (String val) {
          if (val.isEmpty) {
            return 'This field cannot be left empty';
          } else if (val.length > 10) {
            return "Invalid house number";
          } else {
            return null;
          }
        },
        obscureText: false,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.home,
            ),
            hintText: "Enter villa/apartment number",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
      ),
    );
  }

  Container _blockField() {
    return Container(
      height: 75,
      child: TextFormField(
        onChanged: (String value) {
          setState(() {
            block = value.trim().toUpperCase();
          });
        },
        validator: (String val) {
          if (val.isEmpty) {
            return 'This field cannot be left empty';
          } else if (val.length > 1) {
            return 'Invalid block';
          } else {
            return null;
          }
        },
        obscureText: false,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.home,
            ),
            hintText: "Enter block",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
      ),
    );
  }

  Container _towerField() {
    return Container(
      height: 75,
      child: TextFormField(
        onChanged: (String value) {
          setState(() {
            towerNumber = value.trim();
          });
        },
        validator: (String value) {
          if (value == "") {
            return null;
          } else if (value.length > 1) {
            return "Invalid tower number";
          } else {
            if (value.length > 1) {
              return "Not a valid entry";
            }
          }
        },
        obscureText: false,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.home),
            hintText: "Enter tower number",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
      ),
    );
  }

  Container _phoneField() {
    return Container(
      height: 75,
      child: TextFormField(
        onChanged: (String value) {
          setState(() {
            phoneNumber = value.trim();
          });
        },
        validator: (String val) {
          if (val.isEmpty) {
            return 'This field cannot be left empty';
          } else if (val.length != 10) {
            return "Invalid phone number";
          } else {
            return null;
          }
        },
        obscureText: false,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
            ),
            hintText: "Enter phone no. starting after +91...",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
      ),
    );
  }

  Container _emailField() {
    return Container(
      height: 75,
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
              Icons.mail,
            ),
            hintText: "Enter email here",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
      ),
    );
  }

  Container _usernameField() {
    return Container(
      height: 75,
      child: TextFormField(
        onChanged: (String value) {
          setState(() {
            username = value.trim();
          });
        },
        validator: (String val) {
          if (val.isEmpty) {
            return 'This field cannot be left empty';
          } else if (val.length > 40) {
            return "Username too long";
          } else {
            return null;
          }
        },
        obscureText: false,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
            ),
            hintText: "Enter username here",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
      ),
    );
  }

  Container _passwordField() {
    return Container(
      height: 75,
      child: TextFormField(
        onChanged: (String value) {
          setState(() {
            password = value;
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
            hintText: "Enter 6-character password here",
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
          dynamic result = await _authService.registerWithEmailAndPassword(
            email: email,
            password: password,
            username: username,
            phoneNumber: phoneNumber,
            isVolunteer: widget.isVolunteer,
            towerNumber: towerNumber,
            block: block,
            houseNumber: houseNumber,
          );
          if (result == null) {
            setState(() {
              error = "Error in creating account. Try again later";
            });
          } else {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        } else {
          setState(() {
            error = 'Check sign up credentials and try again';
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

  Container _communityDropDown() {
    return Container(
      height: 89.0,
      child: DropdownButtonFormField(
        value: _defaultCommunity,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
        onChanged: (value) {
          setState(() {
            _defaultCommunity = value;
          });
        },
        items: _communities.map((String _community) {
          return DropdownMenuItem(
            value: _community,
            child: Text(
              _community,
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }).toList(),
      ),
    );
  }

  Container _form() {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
      padding: EdgeInsets.only(top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 275,
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Scroll all the way down for more fields",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                      ),
                      Icon(Icons.arrow_downward, color: Colors.grey)
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  _communityDropDown(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _emailField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _usernameField(),
                  SizedBox(
                    height: 20,
                  ),
                  _phoneField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _towerField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _blockField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _houseNumberField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _passwordField(),
                  SizedBox(height: 240.0),
                ],
              ),
            ),
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
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[_backButton()],
                    ),
                    Text("Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 60.0)),
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      child: _form(),
                    ),
                    Text(
                      error,
                      style: TextStyle(fontSize: 17.0, color: Colors.red),
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
