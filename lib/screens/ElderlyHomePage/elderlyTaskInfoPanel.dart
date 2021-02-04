import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WeServe/services/database.dart';
import 'package:provider/provider.dart';

class ElderlyTaskInfoPanel extends StatefulWidget {
  final int index;

  ElderlyTaskInfoPanel({this.index});

  @override
  _ElderlyTaskInfoPanelState createState() => _ElderlyTaskInfoPanelState();
}

class _ElderlyTaskInfoPanelState extends State<ElderlyTaskInfoPanel> {
  List<dynamic> subTasks;
  String taskId = '';
  String volunteer = '';
  String phoneNumber = '';
  String address = '';
  String name = '';
  String taskType = '';
  String byWhen = '';
  bool isComplete = false;

  Future<void> _getCitizenInformation(String uid) async {
    var ds = await DatabaseService(uid: uid).getCitizenInformation();
    if (mounted) {
      setState(() {
        name = ds['username'];
        phoneNumber = ds['phoneNumber'];
        address = ds['address'];
      });
    }
  }

  InkWell _backButton() {
    return InkWell(
      child: Icon(Icons.arrow_back),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _deleteTaskButton(String taskId) {
    return InkWell(
      onTap: () {
        DatabaseService().deleteTask(taskId: taskId);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(80.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.red, width: 2),
        ),
        child: Center(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  Widget _dismissTaskButton(String taskId) {
    return InkWell(
      onTap: () {
        DatabaseService().dismissCompletedTask(taskId: taskId);
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      borderRadius: BorderRadius.circular(80.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Center(
          child: Text("Confirm Completion",
              style: TextStyle(fontSize: 20.0, color: Colors.white)),
        ),
      ),
    );
  }

  Container _informationForm(
      {String taskType,
      String taskId,
      String volunteer,
      String phoneNumber,
      String address,
      String byWhen,
      String name,
      bool isComplete}) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (taskType != '')
                Text(
                  "Type: $taskType",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          if (name == '')
            Text(
              "Task has not been accepted yet",
              style: TextStyle(fontSize: 23.0),
            ),
          if (name != '')
            Text(
              "Name: $name",
              style: TextStyle(fontSize: 23.0),
            ),
          if (phoneNumber != '')
            Text(
              "Phone Number: $phoneNumber",
              style: TextStyle(fontSize: 23.0),
            ),
          if (byWhen != '')
            Text(
              "Time: $byWhen",
              style: TextStyle(fontSize: 23.0),
            ),
          if (address != '')
            Text(
              "Address: $address",
              style: TextStyle(fontSize: 23.0),
            ),
          SizedBox(
            height: 20,
          ),
          if (isComplete == false && volunteer == '') _deleteTaskButton(taskId),
          if (isComplete == true) _dismissTaskButton(taskId),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService(uid: user.uid).elderlyTaskStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Text(
                "Loading...",
                style: TextStyle(fontSize: 30.0),
              ),
            ),
          );
        } else {
          taskId = snapshot.data.documents[widget.index].documentID;
          isComplete = snapshot.data.documents[widget.index]['isComplete'];
          subTasks = snapshot.data.documents[widget.index]['subTasks'];
          volunteer = snapshot.data.documents[widget.index]['volunteer'];
          taskType = snapshot.data.documents[widget.index]['taskType'];
          byWhen = snapshot.data.documents[widget.index]['byWhen'];
          if (volunteer != '') {
            _getCitizenInformation(volunteer);
          } else {
            name = '';
            address = '';
            phoneNumber = '';
            byWhen = '';
          }
          return Scaffold(
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
                    SizedBox(height: 40.0),
                    Row(
                      children: <Widget>[
                        _backButton(),
                      ],
                    ),
                    Text(
                      "Volunteer Info",
                      style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      child: _informationForm(
                          taskType: taskType,
                          taskId: taskId,
                          volunteer: volunteer,
                          phoneNumber: phoneNumber,
                          address: address,
                          name: name,
                          byWhen: byWhen,
                          isComplete: isComplete),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
