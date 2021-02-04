import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WeServe/models/task.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  static final CollectionReference usersRef =
      Firestore.instance.collection('users');
  static final CollectionReference tasksRef =
      Firestore.instance.collection('tasks');

  static final CollectionReference communitiesRef =
      Firestore.instance.collection('communities');

  updateUserData(
      {String username,
      String phoneNumber,
      String towerNumber,
      String block,
      String houseNumber,
      bool isVolunteer}) {
    usersRef.document(this.uid).setData({
      "username": username,
      "phoneNumber": phoneNumber,
      "isVolunteer": isVolunteer,
      "address":
          "Devarabisenahalli, Varthur Post,Outer Ring Road, Bellandur Post, Bangalore-560103 T${towerNumber} ${block.toString() + houseNumber.toString()}"
    });
  }

  addTask(
      {String taskType,
      String byWhen,
      String task,
      String issuedByName,
      String issuedByAddress,
      String issuedByPhoneNumber}) {
    tasksRef.document().setData({
      "acknowledged": false,
      "byWhen": byWhen ?? '',
      "isComplete": false,
      "issuedBy": this.uid,
      "taskType": taskType,
      "task": task,
      "volunteer": "",
      "issuedByName": issuedByName,
      "issuedByPhoneNumber": issuedByPhoneNumber,
      "issuedByAddress": issuedByAddress,
    });
  }

  updateTask({String taskId, bool isComplete}) {
    tasksRef.document(taskId).updateData({
      "volunteer": this.uid,
      "isComplete": isComplete,
    });
  }

  deleteTask({String taskId}) {
    tasksRef.document(taskId).delete();
  }

  dismissCompletedTask({String taskId}) {
    tasksRef.document(taskId).updateData({
      "acknowledged": true,
    });
  }

  deleteAllElderlyUserData() {
    tasksRef
        .where('issuedBy', isEqualTo: this.uid)
        .where('isComplete', isEqualTo: false)
        .getDocuments()
        .then((QuerySnapshot qs) {
      WriteBatch batch = Firestore.instance.batch();

      qs.documents.forEach((DocumentSnapshot document) {
        batch.delete(document.reference);
      });

      batch.commit();
    });
    usersRef.document(this.uid).delete();
  }

  deleteAllVolunteerData() {
    tasksRef
        .where('volunteer', isEqualTo: this.uid)
        .where('isComplete', isEqualTo: false)
        .getDocuments()
        .then((QuerySnapshot qs) {
      WriteBatch batch = Firestore.instance.batch();
      qs.documents.forEach((DocumentSnapshot ds) {
        batch.delete(ds.reference);
      });

      batch.commit();
    });
    usersRef.document(this.uid).delete();
  }

  Future<DocumentSnapshot> getCitizenInformation() async {
    var ds =
        await Firestore.instance.collection('users').document(this.uid).get();
    return ds;
  }

  // Task List from QuerySnapshot
  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Task(
        taskId: doc.documentID,
        acknowledged: doc.data['acknowledged'] ?? false,
        byWhen: doc.data['byWhen'] ?? '',
        isComplete: doc.data['isComplete'] ?? false,
        issuedBy: doc.data['issuedBy'] ?? '',
        issuedByName: doc.data['issuedByName'] ?? '',
        issuedByPhoneNumber: doc.data['issuedByPhoneNumber'],
        issuedByAddress: doc.data['issuedByAddress'] ?? '',
        taskType: doc.data['taskType'] ?? '',
        task: doc.data['task'] ?? '',
        volunteer: doc.data['volunteer'] ?? '',
      );
    }).toList();
  }

  Stream<QuerySnapshot> get elderlyTaskStream {
    return tasksRef
        .where('issuedBy', isEqualTo: this.uid)
        .where('acknowledged', isEqualTo: false)
        .snapshots();
  }

  Stream<DocumentSnapshot> get userStream {
    return usersRef.document(this.uid).snapshots();
  }

  Stream<List<Task>> get volunteerTasksStream {
    return tasksRef
        .where('volunteer', isEqualTo: this.uid)
        .where('acknowledged', isEqualTo: false)
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  Stream<List<Task>> get allTasksStream {
    return tasksRef
        .where('isComplete', isEqualTo: false)
        .where('volunteer', isEqualTo: "")
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  Stream<List<Task>> get historyTasksStream {
    return tasksRef
        .where('volunteer', isEqualTo: this.uid)
        .where('isComplete', isEqualTo: true)
        .snapshots()
        .map(_taskListFromSnapshot);
  }
}
