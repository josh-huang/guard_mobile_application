import 'package:flutter/material.dart';
import 'package:concorde_app/componets/backicon_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../net/flutterfire.dart';
import '../../providers/job_person.dart';
import '../../widgets/bgcolorwidget.dart';
import '../../widgets/guardAck_item.dart';

class ViewSchedule extends StatefulWidget {
  // const ViewSchedule({Key? key}) : super(key: key);
  final String? userUID;

  ViewSchedule({this.userUID});
  @override
  State<ViewSchedule> createState() => _ViewScheduleState();
}

class _ViewScheduleState extends State<ViewSchedule> {
  final AuthService _auth = AuthService();
  late Future<Map<String, dynamic>> scheduleFuture;

  @override
  void initState() {
    super.initState();
    scheduleFuture = getUserSchedule();
  }

  // Widget getUserSchedule(String? userUID) {
  //   return StreamBuilder(
  //       stream: _auth.getAssignments(),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           return BGColor(
  //               child: Center(
  //             child: Text(
  //               'User has not been created/ assigned any work dates. ${snapshot.error}',
  //             ),
  //           ));
  //         } else if (snapshot.hasData) {
  //           final assignments = snapshot.data!;
  //           final selectedUser = assignments.map((jobperson) {
  //             if (jobperson.authUserDocId == widget.userUID) {
  //               return jobperson;
  //             }
  //           }).toList();

  //           return ListView.builder(
  //               itemCount: selectedUser[0]!.worksDate.length,
  //               itemBuilder: (ctx, i) => GuardAckItem(
  //                     userWorkDate:
  //                         getDateString(selectedUser[0]!.worksDate[i]),
  //                     authDocId: selectedUser[0]!.authUserDocId,
  //                     areaName: selectedUser[0]!.assignedArea,
  //                     personName: selectedUser[0]!.name,
  //                     userWorkDates: selectedUser[0]!.worksDate,
  //                   ));
  //         }
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       });
  // }

  Future<Map<String, dynamic>> getUserSchedule() async {
    final assignmentsppl = await _auth.getAreaAssignment();
    String date = DateTime.now().toString();
    final todayDate = getSingleDate(date);
    Map<String, dynamic> todayDatemap = {'': false};
    assignmentsppl.forEach((maps) {
      maps.forEach((key, value) {
        if (key == todayDate) {
          todayDatemap = {key: value};
        }
      });
    });

    return todayDatemap;
    // for (var map in assignmentsppl) {
    //   if (map.containsKey(todayDate)) {
    //     todayDatemap = map;
    //   }
    // }
    // return todayDatemap;
  }

  String getSingleDate(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  // void filterAckItem() async {
  //   final assignmentsppl = await _auth.getAreaAssignment(widget.userUID);
  //   String date = DateTime.now().toString();
  //   final todayDate = getSingleDate(date);
  //   Map<String, dynamic> todayDatemap;
  //   for (var map in assignmentsppl) {
  //     if (map.containsKey(todayDate)) {
  //       todayDatemap = map;
  //     }
  //   }
  // }

  String getDateString(DateTime? values) {
    final peoplesData = Provider.of<JobPeoples>(context, listen: false);
    final String formatted = peoplesData.getSingleDate(values.toString());
    return formatted;
    // v.toString().replaceAll('00:00:00.000', '')
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Schedule'),
      ),
      body: SafeArea(
          child: BGColor(
              child: FutureBuilder<Map<String, dynamic>>(
                  future: scheduleFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GuardAckItem(
                        userWorkDate: snapshot.data!.keys.first,
                        ack: snapshot.data!.values.first,
                        authDocId: widget.userUID,
                      );
                    } else if (snapshot.hasError) {
                      return BGColor(child: Text('${snapshot.error}'));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }))),
    );
  }
}
