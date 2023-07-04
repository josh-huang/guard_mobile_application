import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../pages/SubmitAttendance/page/FaceRecognition/cameraRegister.dart';

class FacialRegisterbutton extends StatefulWidget {
  const FacialRegisterbutton({Key? key}) : super(key: key);

  @override
  State<FacialRegisterbutton> createState() => _FacialRegisterbuttonState();
}

class _FacialRegisterbuttonState extends State<FacialRegisterbutton> {
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
                screen: FaceScanScreenRegister(),
                withNavBar: false, // OPTIONAL VALUE. True by default.
              );
            },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.teal,
                onSurface: Colors.grey,
              ),
              child: Text('Face Register'),
            ),
          ],
        ),
      ],
    );
  }
}
