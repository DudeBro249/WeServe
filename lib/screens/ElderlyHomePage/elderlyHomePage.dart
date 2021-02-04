import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WeServe/screens/ElderlyHomePage/elderlyTaskInfoPanel.dart';
import 'package:WeServe/screens/ElderlySettingsPage/elderlySettingsPage.dart';
import '../ElderlyTaskForm/elderlyTaskForm.dart';
import 'package:WeServe/services/database.dart';
import 'package:provider/provider.dart';

class ElderlyHomePage extends StatefulWidget {
  @override
  _ElderlyHomePageState createState() => _ElderlyHomePageState();
}

class _ElderlyHomePageState extends State<ElderlyHomePage> {
  bool _showAlert = true;

  Widget _status;
  bool acknowledged;
  bool isComplete;
  String volunteer;
  String taskId;
  String taskType;
  String task;

  InkWell _addButton() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ElderlyTaskForm()));
      },
      borderRadius: BorderRadius.circular(80.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 40),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, Colors.green]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Center(
          child: Text(
            "Request Help",
            style: TextStyle(fontSize: 30.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  SliverAppBar _customAppBar() {
    return SliverAppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ElderlySettingsPage()));
          },
        ),
      ],
      floating: true,
      pinned: false,
      snap: false,
      title: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              "Home - APR",
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      centerTitle: true,
      expandedHeight: 120.0,
      elevation: 1.0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.green, Colors.blue],
          ),
        ),
      ),
    );
  }

  Widget _statusIcon(
      {bool acknowledged, String volunteer, bool isComplete, String taskId}) {
    if (volunteer == '') {
      return Text(
        "In queue",
        style: TextStyle(fontSize: 17.0, color: Colors.orange[900]),
      );
    } else if (volunteer != '' && isComplete == false) {
      return Text(
        "In progress",
        style: TextStyle(fontSize: 17.0, color: Colors.orange),
      );
    } else if (volunteer != '' && isComplete == true) {
      return IconButton(
        onPressed: () {
          DatabaseService().dismissCompletedTask(taskId: taskId);
        },
        icon: Icon(
          Icons.check,
          color: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: StreamBuilder(
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
            return CustomScrollView(
              slivers: <Widget>[
                _customAppBar(),
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 20,
                    ),
                    _addButton(),
                  ]),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      acknowledged =
                          snapshot.data.documents[index]['acknowledged'];
                      isComplete = snapshot.data.documents[index]['isComplete'];
                      volunteer = snapshot.data.documents[index]['volunteer']
                          .toString();
                      taskId = snapshot.data.documents[index].documentID;

                      _status = _statusIcon(
                          acknowledged: acknowledged,
                          isComplete: isComplete,
                          volunteer: volunteer,
                          taskId: taskId);

                      taskType =
                          snapshot.data.documents[index]['taskType'].toString();
                      task = snapshot.data.documents[index]['task'];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ElderlyTaskInfoPanel(
                                  index: index,
                                ),
                              ),
                            );
                          },
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ElderlyTaskInfoPanel(
                                    index: index,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.more_horiz),
                          ),
                          leading: _status,
                          title: Text(
                            taskType,
                            style: TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Request: ${task.toString()}",
                                      style: TextStyle(fontSize: 17.0),
                                    ),
                                  ],
                                ),
                              ),
                              if (isComplete == true)
                                Text(
                                  "Click on the check mark to confirm completion",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 17.0,
                                  ),
                                )
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: snapshot.data.documents.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
