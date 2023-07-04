import 'package:flutter/material.dart';

class Backbutton extends StatefulWidget {
  const Backbutton({Key? key}) : super(key: key);

  @override
  State<Backbutton> createState() => _BackbuttonState();
}

class _BackbuttonState extends State<Backbutton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: (){
              Navigator.of(context).pop(context);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.teal,
                onSurface: Colors.grey,
              ),
              child: Text('Back'),
            ),
          ],
        ),
      ],
    );
  }
}
