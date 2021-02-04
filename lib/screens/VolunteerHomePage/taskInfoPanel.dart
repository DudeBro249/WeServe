import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WeServe/models/task.dart';
import 'package:WeServe/services/database.dart';
import 'package:provider/provider.dart';

class TaskInfoPanel extends StatefulWidget {
  final int index;
  final List<Task> tasks;
  TaskInfoPanel({this.index, this.tasks});

  @override
  _TaskInfoPanelState createState() => _TaskInfoPanelState();
}

class _TaskInfoPanelState extends State<TaskInfoPanel> {
  InkWell _backButton() {
    return InkWell(
      child: Icon(Icons.arrow_back),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _acceptTaskButton(List<Task> tasks) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (tasks == null) {
      return Center(
        child: Text(
          "Loading...",
          style: TextStyle(fontSize: 30.0),
        ),
      );
    } else {
      return InkWell(
        borderRadius: BorderRadius.circular(80.0),
        onTap: () {
          DatabaseService(uid: user.uid).updateTask(
            taskId: tasks[widget.index].taskId,
            isComplete: false,
          );
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
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
          child: Text(
            "Accept Task",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      );
    }
  }

  Container _informationForm(
      {String taskType,
      List<Task> tasks,
      String task,
      String phoneNumber,
      String address,
      String byWhen,
      String name}) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
      padding: EdgeInsets.only(top: 20),
      child: Container(
        padding: EdgeInsets.all(0),
        height: 250,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Type: $taskType",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              "Name: $name",
              style: TextStyle(fontSize: 23.0),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Task: " + task.toString(),
                  style: TextStyle(fontSize: 23.0),
                ),
              ],
            ),
            Text(
              "Phone Number: $phoneNumber",
              style: TextStyle(fontSize: 23.0),
            ),
            if (byWhen != '')
              Text(
                "Time: $byWhen",
                style: TextStyle(fontSize: 23.0),
              ),
            Text(
              "Address: $address",
              style: TextStyle(fontSize: 23.0),
            ),
            SizedBox(
              height: 20,
            ),
            _acceptTaskButton(tasks),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String taskType = widget.tasks[widget.index].taskType.toString();
    String task = widget.tasks[widget.index].task.toString();
    String byWhen = widget.tasks[widget.index].byWhen.toString();
    String issuedByName = widget.tasks[widget.index].issuedByName.toString();
    String issuedByPhoneNumber =
        widget.tasks[widget.index].issuedByPhoneNumber.toString();
    String issuedByAddress =
        widget.tasks[widget.index].issuedByAddress.toString();
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
                ]),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Row(
                children: <Widget>[
                  _backButton(),
                ],
              ),
              Text(
                "Task Info",
                style: TextStyle(
                  fontSize: 60.0,
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
                  tasks: widget.tasks,
                  taskType: taskType,
                  task: task,
                  phoneNumber: issuedByPhoneNumber,
                  address: issuedByAddress,
                  name: issuedByName,
                  byWhen: byWhen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
