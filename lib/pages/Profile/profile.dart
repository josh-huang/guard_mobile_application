import 'package:flutter/material.dart';

class GetProfile extends StatefulWidget {
  const GetProfile({Key? key}) : super(key: key);
  static const routeName = '/profile';

  @override
  State<GetProfile> createState() => _GetProfileState();
}

class _GetProfileState extends State<GetProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
            )
        ),
      ),

    );
  }
}

