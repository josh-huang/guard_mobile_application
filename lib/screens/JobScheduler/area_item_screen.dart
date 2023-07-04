import 'package:concorde_app/widgets/guards_same_area_acksItem.dart';
import 'package:concorde_app/widgets/passignment_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';

import '../../net/flutterfire.dart';
import '../../providers/guard_ack.dart';
import '../../providers/job_person.dart';
import '../../widgets/bgcolorwidget.dart';
import '../../widgets/currentdayAck_Item.dart';

class AreaScreen extends StatefulWidget {
  // const AreaScreen({super.key});
  final String areaName;
  final String? areaID;

  AreaScreen(this.areaName, this.areaID);
  static const routeName = '/area-screen';

  @override
  State<AreaScreen> createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> {
  final AuthService _auth = AuthService();
  // late Future<List<Map<String, dynamic>>> acksFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   acksFuture = getCurrentDateAreapeopleAcks();
  // }

  String getSingleDate(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  void currentDayAcks(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(
        builder: ((_) => CurrentDayAck(
              areaName: widget.areaName,
            ))));
  }

  @override
  Widget build(BuildContext context) {
    final peoplesData = Provider.of<JobPeoples>(context);
    // String date = DateTime.now().toString();
    // final fcurrentDate = getSingleDate(date);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.areaName),
        actions: [
          IconButton(
            onPressed: () => currentDayAcks(context),
            icon: const Icon(Icons.assignment_turned_in_rounded),
          )
        ],
      ),
      body: BGColor(
        child: StreamBuilder<List<JobPerson>>(
          stream: _auth.getAssignments(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return BGColor(
                  child: Center(
                child: Text(
                  '${snapshot.error}',
                ),
              ));
            } else if (snapshot.hasData) {
              final assignments = snapshot.data!;
              final areaPeoples = assignments.map((jobperson) {
                if (jobperson.assignedArea == widget.areaName) {
                  return jobperson;
                }
              }).toList();
              final List<JobPerson> filteredPeoples =
                  areaPeoples.whereType<JobPerson>().toList();
              if (filteredPeoples.isEmpty) {
                return BGColor(
                    child: Center(
                  child: Text(
                    'No people assigned to ${widget.areaName} yet.',
                  ),
                ));
              } else {
                return ListView.builder(
                    itemCount: filteredPeoples.length,
                    itemBuilder: (ctx, i) => PersonAssignmentItem(
                        pName: filteredPeoples[i].name,
                        pLoginId: filteredPeoples[i].personLoginId,
                        pContact: filteredPeoples[i].personContact,
                        pPrefs: filteredPeoples[i].personpref,
                        plrdExpiryDate: peoplesData.getSingleDate(
                            (filteredPeoples[i].plrdExpiryDate).toString()),
                        pLeaves: peoplesData
                            .getMultiText(filteredPeoples[i].leavesDate),
                        pWorks: peoplesData
                            .getMultiText(filteredPeoples[i].worksDate)));
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      //     BGColor(
      //   child: StreamBuilder<List<GuardAck>>(
      //       stream: _auth.getCurrentDateAcks(fcurrentDate),
      //       builder: (context, snapshot) {
      //         if (snapshot.hasError) {
      //           return BGColor(
      //               child: Center(
      //             child: Text(
      //               'No people assigned to ${widget.areaName} assignments .${snapshot.error}',
      //             ),
      //           ));
      //         } else if (snapshot.hasData) {
      //           final areapeopleAcks = snapshot.data!;

      //           // areapeopleAcks.forEach((areaperson) {
      //           //   if (areaperson.personShiftPref == 'AM' &&
      //           //       areaperson.guardAck == false) {
      //           //     _auth.updateMinusAMPeopleArea(widget.areaID);
      //           //   } else if (areaperson.personShiftPref == 'PM' &&
      //           //       areaperson.guardAck == false) {
      //           //     _auth.updateMinusPMPeopleArea(widget.areaID);
      //           //   }
      //           // });
      //           // final areaPeoples = areapeopleAcks.map((areaperson) {
      //           //   if (areaperson.== widget.areaName) {
      //           //     return jobperson;
      //           //   }
      //           // }).toList();
      //           // final List<JobPerson> filteredPeoples =
      //           //     areaPeoples.whereType<JobPerson>().toList();
      //           if (areapeopleAcks.isEmpty) {
      //             return BGColor(
      //                 child: Center(
      //               child: Text(
      //                 'No people assigned to ${widget.areaName} yet.',
      //               ),
      //             ));
      //           } else {
      //             return ListView.builder(
      //                 itemCount: areapeopleAcks.length,
      //                 itemBuilder: (ctx, i) => GuardsCurrentDateAck(
      //                       personIndex: i,
      //                       guardname: areapeopleAcks[i].guardname,
      //                       guardWorkDate: areapeopleAcks[i].guardWorkDate,
      //                       guardAck: areapeopleAcks[i].guardAck,
      //                       personShiftPref: areapeopleAcks[i].personShiftPref,
      //                     ));
      //           }
      //         }
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }),
      // ),
    );
  }
}
