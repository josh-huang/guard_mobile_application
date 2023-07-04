import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import '../../net/flutterfire.dart';
import '../../providers/areas.dart' show AreaItem;
import '../../providers/job_person.dart';
import '../../widgets/bgcolorwidget.dart';
import '../../widgets/person_item.dart';

import 'add_people_screen.dart';
// import 'multi_datepicker_screen.dart';

class AssignmentsScreen extends StatefulWidget {
  // const MyWidget({super.key});

  static const routeName = '/people-screen';

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  // void _buildNewPerson(BuildContext ctx) {
  //   showModalBottomSheet(
  //       context: ctx,
  //       builder: (_) {
  //         return AddPersonScreen();
  //       });
  // }
  final AuthService _auth = AuthService();
  List<DateTime?> _multiDatePickerValueWithDefaultValue = [];

  void addPerson(BuildContext ctx) {
    Navigator.of(ctx)
        .push(MaterialPageRoute(builder: ((_) => AddPersonScreen())));
  }

  @override
  Widget build(BuildContext context) {
    final peoplesData = Provider.of<JobPeoples>(context);
    // for (var entry in peoplesData.peoplesPostP.entries) {
    //   print(entry.key);
    //   print(entry.value.length);
    // }
    // peoplesData.jobpeoples.forEach((person) {
    //   print('Area:${person.assignedArea}');
    //   print('Name:${person.name}');
    // });
    // print(peoplesData.peoplesPostP);
    // for (var entry in peoplesData.peoplesPostP.entries) {
    //   print('Area: ${entry.key}');
    //   final personObj = entry.value;
    //   personObj.forEach((person) {
    //     var pName = person.name;
    //     print('Name: ${pName}');
    //   });
    // }

    return Scaffold(
      appBar: AppBar(title: const Text('Assignments'), actions: [
        IconButton(
            onPressed: () => addPerson(context),
            icon: const Icon(Icons.person_add)),
      ]),
      body:

          // child: ListView.builder(
          //   itemCount: peoplesData.peopleCount,
          //   itemBuilder: (ctx, i) => PersonItem(
          //       name: peoplesData.peoples.values.toList()[i].name,
          //       assignedLocation:
          //           peoplesData.peoples.values.toList()[i].assignedArea,
          //       noOfleavesChosen:
          //           peoplesData.peoples.values.toList()[i].noOfLeavesChosen),
          // ),
          // child: ListView.builder(
          //   itemCount: peoplesData.peoplesCount,
          //   itemBuilder: (ctx, i) => PersonItem(
          //       totalPax: peoplesData.peoplesPostP.entries
          //           .map((entry) => entry.value.length)
          //           .toList()[i]
          //           .toString(),
          //       name: peoplesData.peoplesPostP.values
          //           .toList()[i]
          //           .map((jobperson) => jobperson.name)
          //           .toString(),
          //       assignedLocation: peoplesData.peoplesPostP.values
          //           .toList()[i]
          //           .map((jobperson) => jobperson.assignedArea)
          //           .toList()
          //           .toSet()
          //           .toString()
          //           .replaceAll(new RegExp(r"\p{P}", unicode: true), ""),
          //       leaveDates: _multiDatePickerValueWithDefaultValue),
          BGColor(
        child: StreamBuilder<List<JobPerson>>(
          stream: _auth.getAssignments(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return BGColor(
                  child: Center(
                child: Text(
                  'No assignments in database yet.${snapshot.error}',
                ),
              ));
            } else if (snapshot.hasData) {
              final assignments = snapshot.data!;
              // assignments.map((jobperson) => jobperson.assignedArea).toList();
              return ListView.builder(
                  itemCount: assignments.length,
                  itemBuilder: (ctx, i) => PersonItem(
                        name: assignments[i].name,
                        jsonId: assignments[i].jsonId,
                        authUserDocId: assignments[i].authUserDocId,
                        assignedLocation: assignments[i].assignedArea,
                        leaveDates: assignments[i].leavesDate,
                      ));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      // child: const Center(child: Text('Peoples')),
    );
  }
}
