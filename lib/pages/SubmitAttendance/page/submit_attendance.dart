import 'dart:io';
import 'package:concorde_app/providers/guard_ack.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as logDev;

import 'package:concorde_app/pages/SubmitAttendance/utils/local_db.dart';
import 'package:concorde_app/pages/SubmitAttendance/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:concorde_app/componets/backicon_widget.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../componets/faciallogin_widget.dart';
import '../../../componets/facialregister_widget.dart';
import '../../../net/flutterfire.dart';
import '../../../providers/face_attendance.dart';
import '../../../providers/guards_face.dart';

class SubmitAttendance extends StatefulWidget {
  const SubmitAttendance({Key? key}) : super(key: key);
  static const routeName = '/submit_attendance';

  @override
  State<SubmitAttendance> createState() => _SubmitAttendanceState();
}

class _SubmitAttendanceState extends State<SubmitAttendance> {
  File? image;
  String imageUrl = '';
  DateTime now = DateTime.now();
  late String date = DateFormat('yyyy-MM-dd kk:mm').format(now);
  late String guardOnDuty = 'Sam, Dave, Ryan';
  late String location = 'AMK Hub';

  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<FacePerson> personRecord = _auth.getFace() as List<FacePerson>;
  late List<String> personName;
  late List<String> personWorking;
  late List<GuardAck> personDate = _auth.getCurrentDateAcks('22') as List<GuardAck>;
  late Map<String, dynamic> personTime;
  late List<Map<String, dynamic>> personAttendace = _auth.getAreaAssignment() as List<Map<String, dynamic>>;


  /*final user = FirebaseAuth.instance.currentUser!;
  late var userRef = _auth.getFace();*/


  /*_auth.getFace().forEach((FacePerson face) {
      print('id: ${face.name}, title: ${face.imageUrl}');
  });*/
  /*late var face_user = userRef[0];
  userRef.getDocuments().then((snapshot) {
      snapshot.documents.forEach((doc) {
      print(doc.data);
      });
    });*/

  void addPerson() {
    for (var i=0; i<personRecord.length; i++){
      personName.add(personRecord[i].name);
    }
  }

  void guardSchedule(){
    for (var i=0; i<personDate.length; i++) {
      personTime[personDate[i].guardname] = personDate[i].guardWorkDate;
    }
  }

  void workingPeople(){
    personTime.forEach((k,v) =>
    {
      if (v == "09-12-2022"){
        personWorking.add(k)
      }
    });
  }

  @override
  void initState() {
    printIfDebug(LocalDB.getUser().name);
    personWorking=['1','2'];
    addPerson();
    guardSchedule();
    workingPeople();
    super.initState();
  }

/*  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTempory = File(image.path);
      this.image = imageTempory;
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }*/

  /*Future uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    //Check Permissions
    // await Permission.photos.request();
    //
    // var permissionStatus = await Permission.photos.status;

    // if (await Permission.photos.request().isGranted){
      //Select Image
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    var file = File(image!.path);

    if (image != null){
      //Upload to Firebase
      var snapshot = await _firebaseStorage.ref()
          .child('guards_pic/${user.email}')
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
      showDialog(
          context: context,
          builder: (context) =>
          const AlertDialog(content: Text('Picture has been successfully uploaded. ')));
    } else {
      showDialog(
          context: context,
          builder: (context) =>
          const AlertDialog(content: Text('Upload Failed. ')));
    }
  //   } else {
  //     print('Permission not granted. Try Again with permission access');
  //   }
  }*/

/*  Widget buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(56),
            primary: Colors.white,
            onPrimary: Colors.black,
            textStyle: TextStyle(fontSize: 20)
          ),
          child: Row(
            children: [
              Icon(icon, size: 28,),
              const SizedBox(width: 16,),
              Text(title),
            ],
          ),
          onPressed: onClicked,);*/
  /*List<String> getCurrent*/

  Widget buildUser (FacePerson face) => Expanded(
      child: Text('Current Time : ${face.name}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
  ));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Attendance'),
      ),
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.teal,
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Attendance Taking', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                SizedBox(height: 20.0,),
                Text('Current Location : ${location}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 20.0,),
                Text('Current Time : ${date}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 20.0,),
                Text('Guards On Duty : ${personWorking}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 20.0,),
                Text('Attendance Submitted : ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 20.0,),
                StreamBuilder(
                  stream: _auth.getFace(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError){
                      return Text('Something went wrong ');
                    }
                    else if (snapshot.hasData){
                      final users = snapshot.data!;
                      return Row(
                        children: users.map(buildUser).toList());
                    } else {
                        return Center(child: CircularProgressIndicator(),);
                    }
                  }),
                /*StreamBuilder(
                    stream: _firestore.collection('faceRecognition').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError){
                        return Text('Something went wrong ');
                      }
                      else if (snapshot.hasData){
                        final users = snapshot.data!;
                        return Row(
                            children: snapshot.data!.documents.map((document){

                            }).toList());
                      } else {
                        return Center(child: CircularProgressIndicator(),);
                      }
                    }),*/
                FacialLoginbutton(),
                SizedBox(height: 20.0,),
                /*buildButton(
                    title: 'Submit Attendance',
                    icon: Icons.camera_alt_outlined,
                    onClicked: () => uploadImage()),*/
              ],
            ),
          ),
        ),
      );

  }
}
