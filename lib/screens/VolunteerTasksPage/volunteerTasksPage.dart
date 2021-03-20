import 'package:WeServe/screens/TaskInfoPanel/taskInfoPanel.dart';
import 'package:WeServe/shared/volunteerTasksStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VolunteerTasksPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      body: watch(volunteerTasksStreamProvider).when(
        data: (tasks) {
          return CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskInfoPanel(
                                task: tasks[index],
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.local_grocery_store),
                        title: Text(
                          tasks[index].taskType,
                          style: TextStyle(fontSize: 20.0),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Requester: ${tasks[index].issuedByName}",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20.0),
                            ),
                            if (tasks[index].byWhen != '')
                              Text(
                                "Time: ${tasks[index].byWhen}",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 20.0),
                              ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Task: ${tasks[index].task.toString()}",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (tasks[index].isComplete == true &&
                                tasks[index].acknowledged == false)
                              Center(
                                child: Text(
                                  "Complete! Waiting for Confirmation...",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskInfoPanel(
                                  task: tasks[index],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.more_horiz),
                        ),
                      ),
                    );
                  },
                  childCount: tasks.length,
                ),
              ),
            ],
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            'Something went wrong: $error',
          ),
        ),
      ),
    );
  }
}
