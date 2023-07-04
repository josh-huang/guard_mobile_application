import 'package:flutter/material.dart';
import 'package:concorde_app/componets/backicon_widget.dart';
import 'package:concorde_app/componets/backbutton_widget.dart';
import 'package:concorde_app/componets/submitbutton_widget.dart';


class LeaveApplication extends StatefulWidget {
  const LeaveApplication({Key? key}) : super(key: key);
  static const routeName = '/leave_application';

  @override
  State<LeaveApplication> createState() => _LeaveApplicationState();
}

class _LeaveApplicationState extends State<LeaveApplication> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _startController = TextEditingController();
  TextEditingController _endController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();

  Widget NameWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Name',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 50.0,
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Your Name',
            ),
          ),
        ),
      ],
    );
  }

  Widget IdWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('NRIC',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 50.0,
          child: TextField(
            controller: _idController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Your NRIC',
            ),
          ),
        ),
      ],
    );
  }

  Widget TypeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Type of leave',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 50.0,
          child: TextField(
            controller: _typeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter the type of your leave',
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget StartWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Start Date',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 50.0,
          child: TextField(
            controller: _startController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter the start date',
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget EndWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('End Date',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 50.0,
          child: TextField(
            controller: _endController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter the end date',
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget ReasonWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Reason For Leave',style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 50.0,
          child: TextField(
            controller: _reasonController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter the reason of your leave',
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Application'),
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
                BackIcon(),
                SizedBox(height: 20.0,),
                Text('Leave Application',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0,),
                NameWidget(),
                SizedBox(height: 10.0,),
                IdWidget(),
                SizedBox(height: 10.0,),
                TypeWidget(),
                SizedBox(height: 10.0,),
                StartWidget(),
                SizedBox(height: 10.0,),
                EndWidget(),
                SizedBox(height: 10.0,),
                ReasonWidget(),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Submitbutton(),
                    Backbutton(),
                  ],
                ),
              ],
            )
        ),
      ),

    );
  }
}
