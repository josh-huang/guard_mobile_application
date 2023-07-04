import 'package:flutter/foundation.dart';

class JobItem {
  final String area;
  final int noOfLeavesChosen;
  final String person;
  final String jobId;

  JobItem(
      {required this.jobId,
      required this.area,
      required this.person,
      required this.noOfLeavesChosen});
}

class Jobs with ChangeNotifier {
  Map<String, JobItem> _jobs = {};

  Map<String, JobItem> get jobs {
    return {...jobs};
  }

  void addJob(String area, String person, int noOfLeavesChosen) {
    _jobs.putIfAbsent(
        area,
        () => JobItem(
            jobId: DateTime.now().toString(),
            area: area,
            person: person,
            noOfLeavesChosen: noOfLeavesChosen));
  }
}
