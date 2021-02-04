import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WeServe/services/database.dart';
import 'package:provider/provider.dart';

class ElderlyTaskForm extends StatefulWidget {
  @override
  _ElderlyTaskFormState createState() => _ElderlyTaskFormState();
}

class _ElderlyTaskFormState extends State<ElderlyTaskForm> {
  final _formKey = GlobalKey<FormState>();

  String error = '';

  final List<String> _taskTypes = <String>['Medicine', 'Groceries', 'Other'];
  String taskType = 'Medicine';
  String time = '';

  String task = '';

  String username = '';
  String userPhoneNumber = '';
  String userAddress = '';

  Future<void> _getCitizenInformation(FirebaseUser user) async {
    var ds = await DatabaseService(uid: user.uid).getCitizenInformation();
    setState(() {
      username = ds['username'];
      userPhoneNumber = ds['phoneNumber'];
      userAddress = ds['address'];
    });
  }

  Container _taskTypeDropDown() {
    return Container(
      height: 89.0,
      child: DropdownButtonFormField(
        value: taskType,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
        onChanged: (value) {
          setState(() {
            taskType = value;
          });
        },
        items: _taskTypes.map((String type) {
          return DropdownMenuItem(
            value: type,
            child: Text(
              type,
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }).toList(),
      ),
    );
  }

  Container _taskField(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.0),
      padding: EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        maxLines: 50,
        validator: (String value) {
          if (value.trim() == '') {
            return 'Please enter some text';
          } else {
            return null;
          }
        },
        onChanged: (String value) {
          setState(() {
            task = value;
          });
        },
        decoration: InputDecoration(
          hintText: "Enter requirement/task here",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  Container _timeField() {
    return Container(
      child: TextFormField(
        onChanged: (String value) {
          setState(() {
            time = value;
          });
        },
        validator: (String value) {
          if (value.length == 0) {
            return "This field cannot be left empty";
          } else {
            return null;
          }
        },
        obscureText: false,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.local_grocery_store,
          ),
          hintText: "Enter requirement/task here here",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
      ),
    );
  }

  InkWell _submitButton() {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return InkWell(
      borderRadius: BorderRadius.circular(80.0),
      onTap: () async {
        if (_formKey.currentState.validate()) {
          await _getCitizenInformation(user);

          task = task.toString().trim();

          if (task == '') {
            setState(() {
              error = 'Please enter some text';
            });
          } else {
            DatabaseService(uid: user.uid).addTask(
                task: task,
                taskType: taskType,
                issuedByName: username,
                issuedByAddress: userAddress,
                issuedByPhoneNumber: userPhoneNumber);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
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
              height: 30.0,
            ),
            _taskTypeDropDown(),
            Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              height: 160,
              child: _taskField(context),
            ),
            SizedBox(
              height: 5,
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
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        _backButton(),
                      ],
                    ),
                    Text("Add Task",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40.0)),
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          _form(),
                        ],
                      ),
                    ),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
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
