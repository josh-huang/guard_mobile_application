import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/foundation.dart';

import 'package:intl/intl.dart';

class JobPerson {
  final String name;
  final String rank;
  final String personContact;
  final String personpref;
  final String assignedArea;
  final String personLoginId;

  final int noOfLeavesChosen;
  DateTime? plrdExpiryDate;
  List<DateTime?> leavesDate;
  List<DateTime?> worksDate;
  String? jsonId;
  String? authUserDocId;

  JobPerson({
    required this.name,
    required this.rank,
    required this.assignedArea,
    required this.noOfLeavesChosen,
    required this.leavesDate,
    required this.worksDate,
    required this.personContact,
    required this.personpref,
    required this.plrdExpiryDate,
    required this.personLoginId,
    this.jsonId,
    this.authUserDocId,
  });
}

class JobPeoples with ChangeNotifier {
  // Map<String, JobPerson> _peoples = {};

  // Map<String, JobPerson> get peoples {
  //   return {..._peoples};
  // }

  // int get peopleCount {
  //   return _peoples.length;
  // }

  List<JobPerson> _jobpeoples = [];

  List<JobPerson> get jobpeoples {
    return [..._jobpeoples];
  }

  // int get jobpeopleCount {
  //   return _jobpeoples.length;
  // }

  Map<String, List<JobPerson>> _peoplesPostP = {};

  Map<String, List<JobPerson>> get peoplesPostP {
    return {..._peoplesPostP};
  }

  int get peoplesCount {
    return _peoplesPostP.length;
  }

  int sameAreaCount(String assignedArea) {
    if (_peoplesPostP.containsKey(assignedArea)) {
      return _peoplesPostP[assignedArea]!.length;
    } else {
      return 0;
    }
  }

  List<JobPerson> sameAreapeoples(String assignedArea) {
    if (_peoplesPostP.containsKey(assignedArea)) {
      return _peoplesPostP[assignedArea]!.toList();
    }
    return _jobpeoples;
  }

  void addPerson(
    String areaName,
    String name,
    String rank,
    int noOfLeavesChosen,
    List<DateTime?> leavedates,
    List<DateTime?> workdates,
    String personContact,
    String personpref,
    DateTime? plrdexpiryDate,
    String personLoginId,
  ) {
    // if (_peoplesPostP.containsKey(areaName)) {

    //   // myMap.update(1, (list) => list..add(newValueToList),
    //   _peoplesPostP.update(
    //       areaName,
    //       (_jobpeoples) => _jobpeoples
    //         ..add(JobPerson(
    //           name: name,
    //           assignedArea: areaName,
    //           noOfLeavesChosen: noOfLeavesChosen,
    //           leavesDate: leavedates,
    //         )));
    // } else {
    //   _peoplesPostP.putIfAbsent(
    //       areaName,
    //       () => [
    //             JobPerson(
    //                 name: name,
    //                 assignedArea: areaName,
    //                 noOfLeavesChosen: noOfLeavesChosen,
    //                 leavesDate: leavedates)
    //           ]);
    // }

    _peoplesPostP.update(
      areaName,
      (_jobpeoples) => _jobpeoples
        ..add(JobPerson(
          name: name,
          rank: rank,
          assignedArea: areaName,
          noOfLeavesChosen: noOfLeavesChosen,
          leavesDate: leavedates,
          worksDate: workdates,
          personContact: personContact,
          personpref: personpref,
          plrdExpiryDate: plrdexpiryDate,
          personLoginId: personLoginId,
        )),
      ifAbsent: () => [
        JobPerson(
            name: name,
            rank: rank,
            assignedArea: areaName,
            noOfLeavesChosen: noOfLeavesChosen,
            leavesDate: leavedates,
            worksDate: workdates,
            personContact: personContact,
            personpref: personpref,
            plrdExpiryDate: plrdexpiryDate,
            personLoginId: personLoginId)
      ],
    );
    // _jobpeoples.add(JobPerson(
    //     name: name,
    //     assignedArea: areaName,
    //     noOfLeavesChosen: noOfLeavesChosen,
    //     leavesDate: leavedates));

    // _peoplesPostP.putIfAbsent(
    //     areaName,
    //     (_jobpeoples) => [_jobpeoples.add(JobPerson(
    //               name: name,
    //               assignedArea: areaName,
    //               noOfLeavesChosen: noOfLeavesChosen,
    //               leavesDate: leavedates);]);

    notifyListeners();
  }

  void removeJobs(String areaName) {
    _peoplesPostP.remove(areaName);
    notifyListeners();
  }

  String getSingleDate(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  String getMultiText(List<DateTime?> values) {
    CalendarDatePicker2Type datePickerType = CalendarDatePicker2Type.multi;
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values.map((v) {
              final String formatted = getSingleDate(v.toString());
              return formatted;
              // v.toString().replaceAll('00:00:00.000', '')
            }).join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  Map<String, dynamic> personmap(JobPerson instance) => {
        'AssignedArea': instance.assignedArea,
        'Name': instance.name,
        'NoofLeavesChosen': instance.noOfLeavesChosen,
      };
}
