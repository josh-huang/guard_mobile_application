import 'package:flutter/material.dart';
import 'package:concorde_app/componets/backicon_widget.dart';

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({Key? key}) : super(key: key);
  static const routeName = '/view_attendance';

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Attendance'),
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
                BackIcon(),
                SizedBox(height: 20.0,),
                Text('View Attendance',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            )
        ),
      ),

    );
  }
}
