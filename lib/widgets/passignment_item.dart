import 'package:flutter/material.dart';

class PersonAssignmentItem extends StatelessWidget {
  // const PersonAssignmentItem({super.key});
  final String pName;
  final String pLoginId;
  final String pContact;
  final String pPrefs;
  final String plrdExpiryDate;
  final String pLeaves;
  final String pWorks;

  PersonAssignmentItem({
    required this.pName,
    required this.pLeaves,
    required this.pWorks,
    required this.pContact,
    required this.pPrefs,
    required this.plrdExpiryDate,
    required this.pLoginId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white38, borderRadius: BorderRadius.circular(10)),
      // margin: const EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      // constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 2.0),
          Text(
            pName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Text(
            "LoginID: ${pLoginId}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Contact: ${pContact}",
            style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Preferences: ${pPrefs}",
            style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10.0),
          Text(
            "PLRD Expiry Date: ${plrdExpiryDate}",
            style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Leaves Dates: ${pLeaves}",
            style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Working Dates: ${pWorks}",
            style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
