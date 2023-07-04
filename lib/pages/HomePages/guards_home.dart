import 'package:concorde_app/pages/homePages/admin_home.dart';
import 'package:concorde_app/pages/LeaveApplication/leave_application.dart';
import 'package:concorde_app/pages/SubmitAttendance/page/submit_attendance.dart';
import 'package:concorde_app/pages/ViewAttendance/view_attendance.dart';
import 'package:concorde_app/pages/ViewSchedule/view_schedule.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:concorde_app/componets/signouticon_widget.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:concorde_app/pages/Notification/notification.dart';
import 'package:concorde_app/pages/Profile/profile.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../net/flutterfire.dart';
import '../../widgets/bgcolorwidget.dart';

class GuardsHome extends StatefulWidget {
  // const GuardsHome({Key? key}) : super(key: key);
  static const routeName = '/guards_home';

  final String? userEmail;
  final String? userUID;

  GuardsHome({this.userEmail, this.userUID});

  @override
  State<GuardsHome> createState() => _GuardsHomeState();
}

class _GuardsHomeState extends State<GuardsHome> {
  final AuthService _auth = AuthService();
  final user = FirebaseAuth.instance.currentUser!;
  String name = 'Guards1';

  final List<String> time_list = [
    'Good Morning',
    'Good Afternoon',
    'Good Evening'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guard Homepage'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: SafeArea(
        child: BGColor(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              Text(
                'Good Morning ${user.email}',
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomCard(
                      color: (Colors.teal[100])!,
                      borderRadius: 20.0,
                      hoverColor: Colors.indigo,
                      height: 150,
                      width: 150,
                      elevation: 10,
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: SubmitAttendance(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.lock_clock,
                            size: 50,
                          ),
                          Text(
                            'Submit Attendance',
                            style: TextStyle(),
                          ),
                        ],
                      )),
                  CustomCard(
                      color: (Colors.teal[100])!,
                      borderRadius: 20.0,
                      hoverColor: Colors.indigo,
                      height: 150,
                      width: 150,
                      elevation: 10,
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: ViewSchedule(userUID: widget.userUID),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.task,
                            size: 50,
                          ),
                          Text(
                            'View Schedule',
                            style: TextStyle(),
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CustomCard(
                      color: (Colors.teal[100])!,
                      borderRadius: 20.0,
                      hoverColor: Colors.indigo,
                      height: 150,
                      width: 150,
                      elevation: 10,
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: ViewAttendance(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.calendar_month,
                            size: 50,
                          ),
                          Text(
                            'View Attendance',
                            style: TextStyle(),
                          ),
                        ],
                      )),
                  CustomCard(
                      color: (Colors.teal[100])!,
                      borderRadius: 20.0,
                      hoverColor: Colors.indigo,
                      height: 150,
                      width: 150,
                      elevation: 10,
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: LeaveApplication(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.sick,
                            size: 50,
                          ),
                          Text(
                            'Leave Application',
                            style: TextStyle(),
                          ),
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
