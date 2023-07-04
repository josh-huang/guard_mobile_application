import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:provider/provider.dart';

import '../../net/flutterfire.dart';
import '../../providers/job_person.dart';
import '../../widgets/bgcolorwidget.dart';
import '../../widgets/passignment_item.dart';
import '../../widgets/person_item.dart';

class AssignmentItemScreen extends StatelessWidget {
  // const AssignmentItem({super.key});
  final String personName;

  final AuthService _auth = AuthService();

  AssignmentItemScreen({required this.personName});

  @override
  Widget build(BuildContext context) {
    // var pleaveDate = '';
    // var personCount = 0;
    // var pName;
    final peoplesData = Provider.of<JobPeoples>(context);

    // peoplesData.peoplesPostP.forEach(
    //   (key, value) {
    //     if (key == assignmentName) {
    //       for (var details in value) {
    //         print(details.noOfLeavesChosen);
    //         // personCount = value.length;
    //         // pName = details.name;
    //         // pleaveDate = peoplesData.getMultiText(details.leavesDate);
    //         // _buildpersonLeavesItem(pName, pleaveDate);
    //       }
    //     }
    //   },
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text(personName),
      ),
      body:
          // child: ListView.builder(
          //     itemCount: peoplesData.sameAreaCount(assignmentName),
          //     itemBuilder: (ctx, i) => PersonAssignmentItem(
          //           pName: peoplesData.peoplesPostP.values
          //               .toList()[i]
          //               .map((jobperson) {
          //             if (jobperson.assignedArea.contains(assignmentName)) {
          //               return jobperson.name;
          //             }
          //           }).toList()[i]!,
          //           pLeaves: peoplesData.peoplesPostP.values
          //               .toList()[i]
          //               .map((jobperson) {
          //             if (jobperson.assignedArea.contains(assignmentName)) {
          //               return peoplesData.getMultiText(jobperson.leavesDate);
          //             }
          //           }).toList()[i]!,
          //         ))
          // child: ListView.builder(
          //   itemCount: peoplesData.sameAreaCount(assignmentName),
          //   itemBuilder: (cxt, i) => PersonAssignmentItem(
          //     pName: peoplesData.sameAreapeoples(assignmentName)[i].name,
          //     pLeaves: peoplesData.getMultiText(
          //         peoplesData.sameAreapeoples(assignmentName)[i].leavesDate),
          //     pWorks: peoplesData.getMultiText(
          //         peoplesData.sameAreapeoples(assignmentName)[i].worksDate),
          //   ),
          // ),

          BGColor(
        child: StreamBuilder<List<JobPerson>>(
          stream: _auth.getAssignments(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'No assignment for ${personName} in database yet.${snapshot.error}',
              );
            } else if (snapshot.hasData) {
              final assignments = snapshot.data!;
              // final assignedP = assignments
              //     .firstWhere((jobperson) => jobperson.name == personName);
              final assignedP = _auth.personfromJson(assignments, personName);
              // return ListView.builder(
              //     itemCount: assignments.length,
              //     itemBuilder: (ctx, i) => PersonItem(
              //           name: assignments[i].name,
              //           assignedLocation: assignments[i].assignedArea,
              //           leaveDates: assignments[i].leavesDate,
              //         ));
              return PersonAssignmentItem(
                pName: assignedP.name,
                pLoginId: assignedP.personLoginId,
                pContact: assignedP.personContact,
                pPrefs: assignedP.personpref,
                plrdExpiryDate: peoplesData
                    .getSingleDate(assignedP.plrdExpiryDate.toString()),
                pLeaves: peoplesData.getMultiText(assignedP.leavesDate),
                pWorks: peoplesData.getMultiText(assignedP.worksDate),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
