import 'package:flutter/material.dart';
import 'package:WeServe/screens/VolunteerTasksPage/volunteerTaskInfoPanel.dart';
import 'package:provider/provider.dart';
import 'package:WeServe/models/task.dart';

class VolunteerTasksList extends StatefulWidget {
  @override
  _VolunteerTasksListState createState() => _VolunteerTasksListState();
}

class _VolunteerTasksListState extends State<VolunteerTasksList> {
  @override
  Widget build(BuildContext context) {
    List<Task> tasks = Provider.of<List<Task>>(context);

    if (tasks == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Loading...",
            style: TextStyle(fontSize: 30.0),
          ),
        ),
      );
    }
    return Scaffold(
      body: CustomScrollView(
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
                            tasks: tasks.toList(),
                            index: index,
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
                          style: TextStyle(color: Colors.grey, fontSize: 20.0),
                        ),
                        if (tasks[index].byWhen != '')
                          Text(
                            "Time: ${tasks[index].byWhen}",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 20.0),
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
                              tasks: tasks.toList(),
                              index: index,
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
      ),
    );
  }
}
