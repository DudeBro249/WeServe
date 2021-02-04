
import 'package:WeServe/screens/VolunteerWrapper/volunteerWrapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Imports Flutter material
import 'package:WeServe/screens/ElderlyHomePage/elderlyHomePage.dart';
import 'package:WeServe/services/database.dart';
import 'package:provider/provider.dart';
import 'package:WeServe/screens/WelcomePage/welcomePage.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isVolunteer;
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (user == null) {
      return WelcomePage();
    } else {
      return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService(uid: user.uid).userStream,
        builder: (context, snapshot) {
          if ((snapshot.hasData == false) || snapshot == null) {
            return Scaffold(
              body: Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
            );
          } else {
            if (user != null &&
                snapshot.data != null &&
                snapshot != null &&
                snapshot.hasData == true) {
              try {
                isVolunteer = snapshot.data['isVolunteer'];
              } catch (e) {}
            }
            if (isVolunteer) {
              return VolunteerWrapper();
            } else if (isVolunteer == false) {
              return ElderlyHomePage();
            }
          }
        },
      );
    }
  }
}
