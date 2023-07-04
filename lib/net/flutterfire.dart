import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import '../providers/areas.dart' show AreaItem;
import '../providers/face_attendance.dart';
import '../providers/guard_ack.dart';
import '../providers/guards_face.dart';
import '../providers/job_person.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Future<bool> signIn(String email, String password) async {
  //   try {
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     }
  //     return false;
  //   }
  // }

  Future<User?> signInUser(
    String email,
    String password,
  ) async {
    final UserCredential userCredential = await _auth.signInWithCredential(
      EmailAuthProvider.credential(
        email: email,
        password: password,
      ),
    );
    return userCredential.user;
  }

  // Future<bool> register(String email, String password) async {
  //   try {
  //     await _auth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       print('Password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('An account already exist for that email.');
  //     }
  //     return false;
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }

  void createNewGuardInFirestore(String loginId, Future<String?> authUserId,
      String type, String pwd) async {
    final User? user = currentUser;
    // final CollectionReference<Map<String, dynamic>> usersRef =
    //     _firestore.collection('users');
    // usersRef.doc(user?.uid).set({
    //   'id': user?.uid,
    //   'LoginID': loginId,
    //   'password': pwd,
    //   'displayName': user?.displayName,
    //   'photoUrl': user?.photoURL,
    //   'type': type,
    //   // 'timestamp': documentIdFromCurrentDate(),
    // });
    // if (user != null) {
    //   return user.uid;
    // } else {
    //   return 'User is not created in Authetication Firestore';
    // }
    final String? authUserID = await authUserId;
    final CollectionReference<Map<String, dynamic>> usersRef =
        _firestore.collection('users');
    usersRef.doc(authUserID).set({
      'id': authUserID,
      'LoginID': loginId,
      'password': pwd,
      'displayName': user?.displayName,
      'photoUrl': user?.photoURL,
      'type': type,
    });
  }

  @override
  Future<User?> createUser(
    String personLoginId,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: personLoginId + '@concorde.sg',
        password: password,
      );
      // _createNewGuardInFirestore(email);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('An account already exist for that email.');
      }
      // return false;
    } catch (e) {
      print(e.toString());
      // return false;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> getCurrentUser() async {
    try {
      var currentUser = _auth.currentUser;
      if (currentUser != null) {
        // print(currentUser.uid);
        return Future.value(currentUser.email);
      } else {
        return Future.value('User is not signed in');
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  void addNewArea(String area, int peopleNeeded, DateTime? dateCreated,
      int amPeopleNeeded, int pmPeopleNeeded) {
    _firestore.collection('areas').add({
      'area': area,
      'peopleNeeded': peopleNeeded,
      'dateCreated': dateCreated,
      'AMpeopleNeeded': amPeopleNeeded,
      'PMpeopleNeeded': pmPeopleNeeded,
    });
  }

  AreaItem areafromJson(String? areaId, Map<String, dynamic> json) {
    return AreaItem(
        areaName: json['area'],
        noOfPeopleNeeded: json['peopleNeeded'],
        date: datefromJson(json['dateCreated']),
        areaId: areaId,
        amPeopleNeeded: json['AMpeopleNeeded'],
        pmPeopleNeeded: json['PMpeopleNeeded']);
  }

  DateTime datefromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  Stream<List<AreaItem>> getAreas() {
    return _firestore.collection('areas').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => areafromJson(doc.id, doc.data())).toList());
  }

  void addNewJob(
    String name,
    String personLoginId,
    String? personAuthDocId,
    String rank,
    String assignedArea,
    int noOfLeavesChosen,
    List<DateTime?> leavesDate,
    List<DateTime?> worksDate,
    String personContact,
    String personpref,
    DateTime? plrdexpiryDate,
    List? imageArray,
  ) {
    _firestore.collection('assignments').add({
      'name': name,
      'LoginID': personLoginId,
      'AuthDocID': personAuthDocId,
      'contact': personContact,
      'rank': rank,
      'assignedLocation': assignedArea,
      'shiftPrefs': personpref,
      'noOfLeaves': noOfLeavesChosen,
      'PLRDExpiryDate': plrdexpiryDate,
      'LeavesDate': leavesDate,
      'WorksDate': worksDate,
      'imageArray': imageArray,
    });
  }

  JobPerson assignmentsfromJson(String? jsonid, Map<String, dynamic> json) {
    final jsonleavesDates = json['LeavesDate'];
    final jsonworkDates = json['WorksDate'];
    final plrdDate = datefromJson(json['PLRDExpiryDate']);

    final leavesDates = jsonleavesDates
        .map((leavedate) => leavedate.toDate())
        .toList()
        .cast<DateTime>();
    final workDates = jsonworkDates
        .map((workdate) => workdate.toDate())
        .toList()
        .cast<DateTime>();

    return JobPerson(
        name: json['name'],
        rank: json['rank'],
        personLoginId: json['LoginID'],
        personContact: json['contact'],
        personpref: json['shiftPrefs'],
        plrdExpiryDate: plrdDate,
        assignedArea: json['assignedLocation'],
        noOfLeavesChosen: json['noOfLeaves'],
        leavesDate: leavesDates,
        worksDate: workDates,
        jsonId: jsonid,
        authUserDocId: json['AuthDocID']);
  }

  JobPerson personfromJson(List<JobPerson> json, String personName) {
    // json.map((person) {
    //   return JobPerson(
    //     name: person.name,
    //     rank: person.rank,
    //     assignedArea: person.assignedArea,
    //     noOfLeavesChosen: person.noOfLeavesChosen,
    //     leavesDate: datesfromJson(person.leavesDate),
    //     worksDate: datesfromJson(person.worksDate),
    //   );
    // });
    final assignedP =
        json.firstWhere((jobperson) => jobperson.name == personName);

    return JobPerson(
        name: assignedP.name,
        personContact: assignedP.personContact,
        rank: assignedP.rank,
        personLoginId: assignedP.personLoginId,
        personpref: assignedP.personpref,
        assignedArea: assignedP.assignedArea,
        noOfLeavesChosen: assignedP.noOfLeavesChosen,
        plrdExpiryDate: assignedP.plrdExpiryDate,
        leavesDate: assignedP.leavesDate,
        worksDate: assignedP.worksDate);
  }

  Stream<List<JobPerson>> getAssignments() {
    return _firestore.collection('assignments').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => assignmentsfromJson(doc.id, doc.data()))
            .toList());
  }

  void deletePerson(String? jsonId, String? authUserDocId) {
    _firestore.collection('assignments').doc(jsonId).delete();
    // _firestore.collection('users').doc(authUserDocId).delete();
  }

  void deleteArea(String? areaId) {
    _firestore.collection('areas').doc(areaId).delete();
  }

  String getSingleDate(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  void updateMinusAMPeopleArea(String? areaId) async {
    // var prevAMPeople = 0;
    final newAMPeople =
        await _firestore.collection('areas').doc(areaId).get().then((doc) {
      final selectedArea =
          areafromJson(doc.id, doc.data() as Map<String, dynamic>);
      var prevAMPeople = selectedArea.amPeopleNeeded;
      if (prevAMPeople <= 0) {
        return 0;
      } else {
        var newaMPeople = prevAMPeople - 1;
        return newaMPeople;
      }
    });
    _firestore
        .collection('areas')
        .doc(areaId)
        .update({'AMpeopleNeeded': newAMPeople});
  }

  void updateMinusPMPeopleArea(String? areaId) async {
    final newPMPeople =
        await _firestore.collection('areas').doc(areaId).get().then((doc) {
      final selectedArea =
          areafromJson(doc.id, doc.data() as Map<String, dynamic>);
      var prevPMPeople = selectedArea.pmPeopleNeeded;
      if (prevPMPeople <= 0) {
        return 0;
      } else {
        var newpMPeople = prevPMPeople - 1;
        return newpMPeople;
      }
    });
    _firestore
        .collection('areas')
        .doc(areaId)
        .update({'PMpeopleNeeded': newPMPeople});
  }

  // JobPerson? getUserScheduledWorkDates(String? authUserId) {
  //   final User? user = currentUser;
  //   QuerySnapshot<Map<String, dynamic>> jsonassignments;
  //   List<JobPerson?> assignments = [];
  //   JobPerson? jobUser;
  //   final allData = _firestore.collection('assignments').snapshots().map(
  //       (snapshot) => snapshot.docs
  //           .map((doc) => assignmentsfromJson(doc.id, doc.data()))
  //           .toList());
  //   // _firestore.collection('assignments').get().then((snapshot) {
  //   //   jsonassignments = snapshot;
  //   // });
  //   allData.forEach((jobpersonlist) {
  //     for (var jobperson in jobpersonlist) {
  //       if (user?.uid == authUserId && authUserId == jobperson.authUserDocId) {
  //         jobUser = jobperson;
  //       }
  //     }
  //   });
  //   return jobUser;
  // }

  void createUserAcks(String? authUserId, List<DateTime?> userWorkDates,
      String areaName, String personName, String personShiftpref) {
    final User? user = currentUser;
    List<bool> boolList = [];
    Map<String, dynamic> ackMap = {};
    final nameMap = <String, dynamic>{
      'Name': '${personName}',
      'AuthDocID': '${authUserId}',
      'AssignedArea': areaName,
      'PersonShiftPref': personShiftpref
    };
    for (var date in userWorkDates) {
      boolList.add(true);
    }
    ackMap.addEntries(nameMap.entries);
    for (var i = 0; i < userWorkDates.length; i++) {
      String date = userWorkDates[i].toString();
      final fdate = getSingleDate(date);
      ackMap['${fdate}'] = boolList[i];
    }
    final CollectionReference<Map<String, dynamic>> areaAssignmentsRef =
        _firestore.collection('areaAssignments');

    areaAssignmentsRef.doc(authUserId).set(
          ackMap,
        );
    // areaAssignmentsRef.add(ackMap);
  }

  // Stream<List<String>> getAreaAssignments() {
  //   return _firestore.collection('areaAssignments').snapshots().map(
  //       (snapshot) => snapshot.docs
  //           .map((doc) => areaAssignmentsfromJson(doc.id, doc.data()))
  //           .toList());
  // }

  // String areaAssignmentsfromJson(String? jsonid, Map<String, dynamic> json) {
  //   final String authDocID = json['AuthDocID'];
  //   final personName = json['Name'];
  //   final currentDate = getSingleDate(DateTime.now().toString());

  // }

  Future<List<Map<String, dynamic>>> getAreaAssignment() async {
    // List<Map<String, dynamic>> areapersonitem = [];
    var query = _firestore.collection('areaAssignments');

    final postquery = await query.get();
    final areapersonList =
        postquery.docs.map((areaperson) => areaperson.data()).toList();
    return areapersonList;
  }

  void updateNotAttendingAck(String? authUserDocId, String userWorkDate) async {
    _firestore
        .collection('areaAssignments')
        .doc(authUserDocId)
        .update({'${userWorkDate}': false});
  }

  Future<int> addTestFacialRecognition(String? name, List? imageArray, String imageUrl) async {
    await _firestore
        .collection('faceRecognition')
        .doc(name).set({
      'name': name,
      'userArray' : imageArray.toString(),
      'imageUrl' : imageUrl,
    });
    return 0;
  }

  Future<int> addTestAttendance(String? name, List? imageArray, String location, String time, String imageUrl) async {
    await _firestore
        .collection('testAttendance')
        .doc('${name}_${location}_${time}').set({
      'name': name,
      'current_location' : location,
      'current_time' : time,
      'userArray' : imageArray.toString(),
      'imageUrl' : imageUrl,
    });
    return 0;
  }

  Stream<List<FacePerson>> getFace() => _firestore
      .collection('faceRecognition')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => FacePerson.fromJson(doc.data())).toList());


  Stream<List<FaceAttendance>> getFaceAttendanceStream() => _firestore
      .collection('testAttendance')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => FaceAttendance.fromJson(doc.data())).toList());


  Future<List<FacePerson>> getFaceAttendance() async {
    // List<Map<String, dynamic>> areapersonitem = [];
    var query = _firestore.collection('faceRecognition');

    final postquery = await query.get();
    final areapersonList =
    postquery.docs.map((doc) => FacePerson.fromJson(doc.data())).toList();
    return areapersonList;
  }

  /*Future<List<Map<String, dynamic>>> getFaceAttendance() async {
    // List<Map<String, dynamic>> areapersonitem = [];
    var query = _firestore.collection('faceRecognition');

    final postquery = await query.get();
    final areapersonList =
    postquery.docs.map((doc) => doc.data()).toList();
    return areapersonList;
  }*/

  GuardAck currentDateAcksfromJson(
      String? currentDate, Map<String, dynamic> json) {
    Map<String, dynamic> todayAckMap = {};
    String date = DateTime.now().toString();
    final todayDate = getSingleDate(date);
    json.forEach((key, value) {
      if (key == todayDate) {
        todayAckMap = {key: value};
      }
    });
    return GuardAck(
        guardname: json['Name'],
        guardWorkDate: todayAckMap.keys.first,
        guardAck: todayAckMap.values.first,
        personShiftPref: json['PersonShiftPref']);
  }

  Stream<List<GuardAck>> getCurrentDateAcks(String currentDate) {
    return _firestore.collection('areaAssignments').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => currentDateAcksfromJson(currentDate, doc.data()))
            .toList());
  }
}
