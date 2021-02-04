import 'package:firebase_auth/firebase_auth.dart';
import 'package:WeServe/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Auth Change FireBaseUser stream
  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  // Register with Email and Password with Firebase Authentication
  Future registerWithEmailAndPassword(
      {String email,
      String password,
      String username,
      String phoneNumber,
      bool isVolunteer,
      String towerNumber,
      String block,
      String houseNumber}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var databaseResult = DatabaseService(uid: result.user.uid).updateUserData(
        username: username,
        phoneNumber: "+91" + phoneNumber,
        isVolunteer: isVolunteer,
        towerNumber: towerNumber,
        block: block,
        houseNumber: houseNumber,
      );
      return result.user;
    } catch (error) {
      return null;
    }
  }

  // Signs the user in using Firebase Authentication

  Future signInWithEmailAndPassword({String email, String password}) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (error) {
      return null;
    }
  }

  // Signs the user out using Firebase Authentication
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }
}
