import 'package:flutter/foundation.dart';

class AreaItem {
  // final String areaId;
  final String areaName;
  final int noOfPeopleNeeded;
  final DateTime date;
  // List? assignedPeople;
  String? areaId;
  final int amPeopleNeeded;
  final int pmPeopleNeeded;

  AreaItem({
    // required this.areaId,
    required this.areaName,
    required this.noOfPeopleNeeded,
    required this.date,
    required this.amPeopleNeeded,
    required this.pmPeopleNeeded,
    // this.assignedPeople,
    this.areaId,
  });
}

class Areas with ChangeNotifier {
  List<AreaItem> _areas = [
    // AreaItem(
    //   // areaId: DateTime.now().toString(),
    //   areaName: 'SUTD A',
    //   noOfPeopleNeeded: 3,
    //   date: DateTime.now(),
    // ),
    // AreaItem(
    //   // areaId: DateTime.now().toString(),
    //   areaName: 'SUTD B',
    //   noOfPeopleNeeded: 4,
    //   date: DateTime.now(),
    // ),
    // AreaItem(
    //   // areaId: DateTime.now().toString(),
    //   areaName: 'JEM',
    //   noOfPeopleNeeded: 4,
    //   date: DateTime.now(),
    // ),
  ];
  List<AreaItem> get areas {
    return [..._areas];
  }

  int get areaCount {
    return _areas.length;
  }

  void addArea(String areaName, int noOfPeopleNeeded, DateTime date,
      int amPeopleNeeded, int pmPeopleNeeded) {
    // add new entry
    _areas.add(AreaItem(
        areaName: areaName,
        noOfPeopleNeeded: noOfPeopleNeeded,
        date: date,
        amPeopleNeeded: amPeopleNeeded,
        pmPeopleNeeded: pmPeopleNeeded));

    notifyListeners();
  }

  // List<String> get areaNames {
  //   return _areas.where((areasNames) => areasNames.areaName != null).toList();
  // }

  Map<String, dynamic> jsonAreaNames(AreaItem instance) => {
        'AreaName': instance.areaName,
        'NumberPeopleNeeded': instance.noOfPeopleNeeded,
        'Date': instance.date,
        'AMPeopleNeeded': instance.amPeopleNeeded,
        'PMPeopleNeeded': instance.pmPeopleNeeded
      };
  AreaItem fromJson(Map<String, dynamic> json) {
    return AreaItem(
      areaName: json['area'],
      noOfPeopleNeeded: json['noOfPeopleNeeded'],
      date: json['dateCreated'],
      amPeopleNeeded: json['amPeopleNeeded'],
      pmPeopleNeeded: json['pmPeopleNeeded'],
    );
  }
}
