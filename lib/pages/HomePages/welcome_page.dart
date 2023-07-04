import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:concorde_app/componets/signouticon_widget.dart';
import 'package:concorde_app/pages/NavBar/admin_nav_bar.dart';
import 'package:concorde_app/pages/NavBar/guards_nav_bar.dart';

import '../../net/flutterfire.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);
  static const routeName = '/welcome_page';

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final AuthService _auth = AuthService();
  String name = 'User1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resident HomePage'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              bool signedout = await _auth.signOut();
              if (signedout) {
                Navigator.of(context).pushNamed('/');
              }
            },
            icon: const Icon(Icons.logout),
          )
        ],
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
                SignOutIcon(),
                SizedBox(height: 20.0),
                Text(
                  'Welcome ${name}',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CustomCard(
                        color: (Colors.teal[100])!,
                        borderRadius: 20.0,
                        hoverColor: Colors.indigo,
                        height: 400,
                        width: 300,
                        elevation: 10,
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Notices',
                              style: TextStyle(fontSize: 50.0),
                            ),
                          ],
                        )),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choose the service',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomCard(
                        color: (Colors.teal[100])!,
                        borderRadius: 20.0,
                        hoverColor: Colors.indigo,
                        height: 50,
                        width: 300,
                        elevation: 10,
                        onTap: () {
                          Navigator.of(context).pushNamed(AdminNav.routeName);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Facility',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomCard(
                        color: (Colors.teal[100])!,
                        borderRadius: 20.0,
                        hoverColor: Colors.indigo,
                        height: 50,
                        width: 300,
                        elevation: 10,
                        onTap: () {
                          Navigator.of(context).pushNamed(GuardsNav.routeName);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Security',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
