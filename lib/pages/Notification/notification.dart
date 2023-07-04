import 'package:concorde_app/pages/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class GetNotification extends StatefulWidget {
  const GetNotification({Key? key}) : super(key: key);
  static const routeName = '/notification';

  @override
  State<GetNotification> createState() => _GetNotificationState();
}

class _GetNotificationState extends State<GetNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
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
            children: <Widget>[
            ],
          ),
        ),
      ),


    );
  }
}

