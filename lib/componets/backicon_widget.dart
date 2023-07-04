import 'package:flutter/material.dart';

class BackIcon extends StatefulWidget {
  const BackIcon({Key? key}) : super(key: key);

  @override
  State<BackIcon> createState() => _BackIconState();
}

class _BackIconState extends State<BackIcon> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(context);
              },
              icon: Icon(Icons.arrow_back),
              iconSize: 30.0,
            ),
          ],
        ),
      ],
    );
  }
}
