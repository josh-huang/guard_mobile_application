import 'package:flutter/material.dart';

class Submitbutton extends StatefulWidget {
  const Submitbutton({Key? key}) : super(key: key);

  @override
  State<Submitbutton> createState() => _SubmitbuttonState();
}

class _SubmitbuttonState extends State<Submitbutton> {
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
              child: Text('Submit'),
            ),
          ],
        ),
      ],
    );
  }
}
