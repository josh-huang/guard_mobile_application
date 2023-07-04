import 'package:concorde_app/componets/backattendance_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../net/flutterfire.dart';
import '../../../componets/faciallogin_widget.dart';

import '../utils/local_db.dart';

class FacialSuccess extends StatefulWidget {
  final String? name;

  const FacialSuccess({Key? key, this.name}) : super(key: key);

  @override
  State<FacialSuccess> createState() => _FacialSuccessState();
}

class _FacialSuccessState extends State<FacialSuccess> {
  final AuthService _auth = AuthService();
  final user = FirebaseAuth.instance.currentUser!;
  /*String name = 'Guards1';*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text("Hi ${widget.name}. Your attendance has been submitted.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40.0,),
              FacialLoginbutton(),
              SizedBox(height: 20.0,),
              BackAttendancebutton(),
            ],
          ),
        ),
      ),
    );

  }
}
