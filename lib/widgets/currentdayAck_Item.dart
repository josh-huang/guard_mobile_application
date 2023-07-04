import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../net/flutterfire.dart';
import '../providers/guard_ack.dart';
import 'bgcolorwidget.dart';
import 'guards_same_area_acksItem.dart';

class CurrentDayAck extends StatelessWidget {
  // const CurrentDayAck({super.key});
  final AuthService _auth = AuthService();
  final String areaName;

  CurrentDayAck({required this.areaName});

  String getSingleDate(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    String date = DateTime.now().toString();
    final fcurrentDate = getSingleDate(date);
    return Scaffold(
      appBar: AppBar(title: const Text('Current Day Acknowledgements')),
      body: BGColor(
        child: StreamBuilder<List<GuardAck>>(
            stream: _auth.getCurrentDateAcks(fcurrentDate),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return BGColor(
                    child: Center(
                  child: Text(
                    'No people assigned to ${areaName} assignments .${snapshot.error}',
                  ),
                ));
              } else if (snapshot.hasData) {
                final areapeopleAcks = snapshot.data!;

                // areapeopleAcks.forEach((areaperson) {
                //   if (areaperson.personShiftPref == 'AM' &&
                //       areaperson.guardAck == false) {
                //     _auth.updateMinusAMPeopleArea(widget.areaID);
                //   } else if (areaperson.personShiftPref == 'PM' &&
                //       areaperson.guardAck == false) {
                //     _auth.updateMinusPMPeopleArea(widget.areaID);
                //   }
                // });
                // final areaPeoples = areapeopleAcks.map((areaperson) {
                //   if (areaperson.== widget.areaName) {
                //     return jobperson;
                //   }
                // }).toList();
                // final List<JobPerson> filteredPeoples =
                //     areaPeoples.whereType<JobPerson>().toList();
                if (areapeopleAcks.isEmpty) {
                  return BGColor(
                      child: Center(
                    child: Text(
                      'No people assigned to ${areaName} yet.',
                    ),
                  ));
                } else {
                  return ListView.builder(
                      itemCount: areapeopleAcks.length,
                      itemBuilder: (ctx, i) => GuardsCurrentDateAck(
                            personIndex: i,
                            guardname: areapeopleAcks[i].guardname,
                            guardWorkDate: areapeopleAcks[i].guardWorkDate,
                            guardAck: areapeopleAcks[i].guardAck,
                            personShiftPref: areapeopleAcks[i].personShiftPref,
                          ));
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
