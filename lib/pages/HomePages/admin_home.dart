import 'package:concorde_app/providers/job_person.dart';
import 'package:concorde_app/screens/JobScheduler/jobscheduler_admin_screen.dart';
import 'package:concorde_app/widgets/bgcolorwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:concorde_app/componets/signouticon_widget.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:concorde_app/pages/Notification/notification.dart';
import 'package:concorde_app/pages/Profile/profile.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../net/flutterfire.dart';
import '../../providers/areas.dart';
import '../SubmitAttendance/page/submit_attendance.dart';

class AdminHome extends StatefulWidget {
  // const AdminHome({Key? key}) : super(key: key);
  static const routeName = '/admin_home';

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final AuthService _auth = AuthService();
  final user = FirebaseAuth.instance.currentUser!;
  String name = 'Admin1';

  final List<String> time_list = [
    'Good Morning',
    'Good Afternoon',
    'Good Evening'
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Areas(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin HomePage'),
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
                'Hi ${user.email}',
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
                          screen: JobScheduler(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 50,
                          ),
                          Text(
                            'Job Scheduling',
                            style: TextStyle(),
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
