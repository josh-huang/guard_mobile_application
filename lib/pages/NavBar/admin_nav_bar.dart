import 'package:concorde_app/pages/Profile/profile.dart';
import 'package:concorde_app/screens/LoginRes/residents_guard_login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:concorde_app/pages/Notification/notification.dart';
import 'package:concorde_app/pages/LeaveApplication/leave_application.dart';

import '../HomePages/admin_home.dart';

class AdminNav extends StatelessWidget {
  // AdminNav({Key? key}) : super(key: key);
  static const routeName = '/init_admin';

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      AdminHome(),
      CameraPage(),
      GetProfile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.bell),
        title: ("Notification"),
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: CupertinoColors.black,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.profile_circled),
        title: ("Profile"),
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: CupertinoColors.black,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: (Colors.teal[100])!, // Default is Colors.white.
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset:
                true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardShows:
                true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(0.0),
              colorBehindNavBar: (Colors.teal[100])!,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: ItemAnimationProperties(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimation(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle
                .style1, // Choose the nav bar style with this property.
          );
        } else {
          return LoginUser();
        }
      },
    );
  }
}
