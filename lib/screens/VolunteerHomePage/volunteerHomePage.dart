import 'package:flutter/material.dart';
import 'package:WeServe/models/task.dart';
import 'package:WeServe/screens/VolunteerHomePage/allTasksList.dart';
import 'package:WeServe/services/database.dart';
import 'package:provider/provider.dart';

class VolunteerHomePage extends StatefulWidget {
  @override
  _VolunteerHomePageState createState() => _VolunteerHomePageState();
}

class _VolunteerHomePageState extends State<VolunteerHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Task>>.value(
      value: DatabaseService().allTasksStream,
      child: Scaffold(
        body: AllTasksList(),
      ),
    );
  }
}
