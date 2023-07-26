import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:concorde_app/pages/SubmitAttendance/page/FaceRecognition/cameraAttendance.dart';
import 'package:concorde_app/pages/SubmitAttendance/page/FaceRecognition/cameraRegister.dart';
import 'package:concorde_app/pages/SubmitAttendance/utils/local_db.dart';
import 'package:concorde_app/pages/homePages/admin_home.dart';
import 'package:concorde_app/providers/job_person.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:concorde_app/pages/homePages/guards_home.dart';
import 'package:concorde_app/pages/SubmitAttendance/page/submit_attendance.dart';
import 'package:concorde_app/pages/ViewAttendance/view_attendance.dart';
import 'package:concorde_app/pages/LeaveApplication/leave_application.dart';
import 'package:concorde_app/pages/Notification/notification.dart';
import 'package:concorde_app/pages/Profile/profile.dart';
import 'package:concorde_app/pages/NavBar/guards_nav_bar.dart';
import 'package:concorde_app/pages/NavBar/admin_nav_bar.dart';
import 'package:concorde_app/pages/HomePages/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:concorde_app/net/login_info.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import './widgets/Splash.dart';
// import 'screens/LoginRes/guards_login_screen.dart';
import 'providers/areas.dart';
import 'providers/jobs.dart';
import 'screens/JobScheduler/assignments_screen.dart';
import 'screens/LoginRes/residents_forgotten_pwd_screen.dart';
import 'screens/LoginRes/residents_guard_login_screen.dart';
import 'screens/LoginRes/residents_registration_screen.dart';
import 'screens/JobScheduler/jobscheduler_admin_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  camerasOne = await availableCameras();
  await Hive.initFlutter();
  await HiveBoxes.initialize();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Areas(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => JobPeoples(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // initialRoute: WelcomePage.routeName,
        home: Splash(),
        theme: ThemeData(
            primarySwatch: Colors.teal,
            popupMenuTheme: ThemeData.light().popupMenuTheme.copyWith(
                color: Colors.teal.shade300,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                textStyle: const TextStyle(color: Colors.white)),
            textTheme: ThemeData.light().textTheme.copyWith(
                  button: const TextStyle(color: Colors.white),
                ),
            // scaffoldBackgroundColor: Colors.teal.shade400
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Color.fromARGB(205, 242, 237, 237),
            ),
            errorColor: Colors.red.shade300),
        routes: {
          Registration.routeName: (ctx) => Registration(),
          // Login.routeName: (ctx) => Login(),
          LoginUser.routeName: (ctx) => LoginUser(),
          ForgotPwd.routeName: (ctx) => ForgotPwd(),
          JobScheduler.routeName: (ctx) => JobScheduler(),
          WelcomePage.routeName: (context) => WelcomePage(),
          GuardsNav.routeName: (context) => GuardsNav(),
          GuardsHome.routeName: (context) => GuardsHome(),
          AdminHome.routeName: (context) => AdminHome(),
          SubmitAttendance.routeName: (context) => SubmitAttendance(),
          ViewAttendance.routeName: (context) => ViewAttendance(),
          LeaveApplication.routeName: (context) => LeaveApplication(),
          CameraPage.routeName: (context) => CameraPage(),
          GetProfile.routeName: (context) => GetProfile(),
          AssignmentsScreen.routeName: (ctx) => AssignmentsScreen(),
          FaceScanScreenRegister.routeName: (ctx) => FaceScanScreenRegister(),
          FaceScanScreenAttendance.routeName: (ctx) => FaceScanScreenAttendance(),
        },
      ),
    );
  }
}



// FutureBuilder(
//           future: _fbApp,
//           builder: (context, snapshot){
//             if (snapshot.hasError){
//               print('You have an error! ${snapshot.error.toString()}');
//               return Text('Something went wrong!');
//             } else if (snapshot.hasData){
//               return WelcomePage();
//             } else{
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),