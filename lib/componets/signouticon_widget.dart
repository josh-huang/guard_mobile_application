import 'package:flutter/material.dart';

class SignOutIcon extends StatefulWidget {
  const SignOutIcon({Key? key}) : super(key: key);

  @override
  State<SignOutIcon> createState() => _SignOutIconState();
}

class _SignOutIconState extends State<SignOutIcon> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.logout),
              iconSize: 30.0,
            ),
          ],
        ),
      ],
    );
  }
}
