import 'package:flutter/material.dart';

import '../../net/flutterfire.dart';

class ResidentsWelcome extends StatelessWidget {
  final AuthService _auth = AuthService();
  static const routeName = '/resident-welcome';
  // const ResidentsWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Residents Homepage'),
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
      body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.teal,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Column(children: [Text('Residents Homepage')])),
    );
  }
}
