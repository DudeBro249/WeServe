import 'package:WeServe/screens/HistoryTasksPage/historyTasksList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WeServe/models/task.dart';
import 'package:WeServe/services/database.dart';
import 'package:provider/provider.dart';

class HistoryTasksPage extends StatefulWidget {
  @override
  _HistoryTasksPageState createState() => _HistoryTasksPageState();
}

class _HistoryTasksPageState extends State<HistoryTasksPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (user != null) {
      return StreamProvider<List<Task>>.value(
        value: DatabaseService(uid: user.uid).historyTasksStream,
        child: Scaffold(
          body: HistoryTasksList(),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
