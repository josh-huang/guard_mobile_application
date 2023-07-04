import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../net/flutterfire.dart';
import '../../providers/areas.dart';
import '../../widgets/bgcolorwidget.dart';

class AddAreaScreen extends StatefulWidget {
  // pointer to a function call
  // final Function addArea;

  // AddAreaScreen(this.addArea);
  @override
  State<AddAreaScreen> createState() => _AddAreaScreenState();
}

class _AddAreaScreenState extends State<AddAreaScreen> {
  // const MyWidget({super.key});
  final AuthService _auth = AuthService();
  TextEditingController _areaField = TextEditingController();

  TextEditingController _peopleField = TextEditingController();
  TextEditingController _amField = TextEditingController();
  TextEditingController _pmField = TextEditingController();

  DateTime? _selectedDate;

  void _pDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  Widget buildArea() {
    return Column(
      children: [
        TextFormField(
          onFieldSubmitted: (_) => submitData(),
          controller: _areaField,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Add Area',
          ),
          // focusNode: _peopleFocusNode,
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget buildPeople() {
    return Column(
      children: [
        TextFormField(
          onFieldSubmitted: (_) => submitData(),
          controller: _peopleField,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'No of people needed',
          ),
          // focusNode: _peopleFocusNode,
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget buildamNoPeople() {
    return Column(
      children: [
        TextFormField(
          onFieldSubmitted: (_) => submitData(),
          controller: _amField,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'No of AM Peoples',
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget buildpmNoPeople() {
    return Column(
      children: [
        TextFormField(
          onFieldSubmitted: (_) => submitData(),
          controller: _pmField,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'No of PM Peoples',
          ),
        ),
      ],
    );
  }

  Widget buildDatePicker() {
    return Container(
      height: 70,
      child: Row(
        children: [
          Expanded(
            child: Text(
                _selectedDate == null
                    ? 'No date chosen!'
                    : 'Picked Date: ${DateFormat.yMd().format(_selectedDate as DateTime)}',
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
          ElevatedButton(
            onPressed: _pDatePicker,
            child: const Text('Choose Date',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          )
        ],
      ),
    );
  }

  void submitData() {
    final submitArea = Provider.of<Areas>(context, listen: false);
    final userArea = _areaField.text;
    final peopleNeeded = int.parse(_peopleField.text);
    final ampeopleNeeded = int.parse(_amField.text);
    final pmpeopleNeeded = int.parse(_pmField.text);

    if (userArea.isEmpty ||
        peopleNeeded <= 0 ||
        _selectedDate == null ||
        ampeopleNeeded <= 0 ||
        pmpeopleNeeded <= 0) {
      return;
    }
    submitArea.addArea(
        userArea, peopleNeeded, _selectedDate!, ampeopleNeeded, pmpeopleNeeded);
    _auth.addNewArea(
        userArea, peopleNeeded, _selectedDate, ampeopleNeeded, pmpeopleNeeded);
    // widget.addArea(userArea, peopleNeeded, _selectedDate);
    Navigator.of(context).pop();
    // print(_auth.getAreas());
  }

  // void addNewFields(BuildContext ctx) {
  Widget buildSubmitBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: submitData,
        child: const Text('Submit'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BGColor(
      child: Form(
          child: Column(
        children: [
          buildArea(),
          buildPeople(),
          buildamNoPeople(),
          buildpmNoPeople(),
          buildDatePicker(),
          buildSubmitBtn(),
          // Expanded(child: ListView.builder(itemBuilder: ,itemCount: ,))
        ],
      )),
    );
  }
}
