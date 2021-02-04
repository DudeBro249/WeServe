import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WeServe/models/task.dart';
import 'package:WeServe/screens/VolunteerTasksPage/volunteerTasksList.dart';
import 'package:WeServe/services/database.dart';
import 'package:provider/provider.dart';

class VolunteerTasksPage extends StatefulWidget {
  @override
  _VolunteerTasksPageState createState() => _VolunteerTasksPageState();
}

class _VolunteerTasksPageState extends State<VolunteerTasksPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (user != null) {
      return StreamProvider<List<Task>>.value(
        value: DatabaseService(uid: user.uid).volunteerTasksStream,
        child: Scaffold(
          body: VolunteerTasksList(),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
