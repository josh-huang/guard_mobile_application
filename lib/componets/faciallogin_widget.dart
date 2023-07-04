import 'package:concorde_app/pages/SubmitAttendance/page/FaceRecognition/cameraAttendance.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../pages/SubmitAttendance/page/FaceRecognition/cameraRegister.dart';
import '../pages/SubmitAttendance/utils/local_db.dart';

class FacialLoginbutton extends StatefulWidget {
  const FacialLoginbutton({Key? key}) : super(key: key);

  @override
  State<FacialLoginbutton> createState() => _FacialLoginbuttonState();
}

class _FacialLoginbuttonState extends State<FacialLoginbutton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: () async {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: FaceScanScreenAttendance(),
                withNavBar: false, // OPTIONAL VALUE. True by default.
              );
            },

              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.teal,
                onSurface: Colors.grey,
              ),
              child: Text('Submit Attandance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }
}
