import 'package:WeServe/screens/HistoryTasksPage/historyTasksPage.dart';
import 'package:WeServe/screens/VolunteerHomePage/volunteerHomePage.dart';
import 'package:WeServe/screens/VolunteerSettingsPage/volunteerSettingsPage.dart';
import 'package:WeServe/screens/VolunteerTasksPage/volunteerTasksPage.dart';
import 'package:flutter/material.dart';

class VolunteerWrapper extends StatefulWidget {
  @override
  _VolunteerWrapperState createState() => _VolunteerWrapperState();
}

class _VolunteerWrapperState extends State<VolunteerWrapper>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 3,
      vsync: this,
    );
  }

  SliverAppBar _customAppBar() {
    return SliverAppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VolunteerSettingsPage()));
          },
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      floating: true,
      pinned: false,
      snap: false,
      title: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              "Home - APR",
              style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
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
      bottom: TabBar(
        tabs: [
          Tab(
            text: 'All Requests',
          ),
          Tab(
            text: 'My Requests',
          ),
          Tab(
            text: 'History',
          ),
        ],
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _customAppBar(),
          // SliverList(
          SliverFillRemaining(
            child: TabBarView(
              controller: controller,
              children: <Widget>[
                VolunteerHomePage(),
                VolunteerTasksPage(),
                HistoryTasksPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
