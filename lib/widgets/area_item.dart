import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../net/flutterfire.dart';
import '../providers/job_person.dart';
import '../screens/JobScheduler/area_item_screen.dart';
import 'bgdeleteItem.dart';

class AreaItem extends StatefulWidget {
  final String areaName;
  final int noOfPeopleNeed;
  int amPeopleNeeded;
  int pmPeopleNeeded;
  final DateTime date;
  final String? areaId;

  AreaItem({
    // required this.areaId,
    required this.areaName,
    required this.noOfPeopleNeed,
    required this.date,
    required this.amPeopleNeeded,
    required this.pmPeopleNeeded,
    this.areaId,
  });

  @override
  State<AreaItem> createState() => _AreaItemState();
}

class _AreaItemState extends State<AreaItem> {
  bool peopleCountNotMaxed = false;
  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   updatePeople();
  // }

  // const MyWidget({super.key});
  void selectArea(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(
        builder: ((_) => AreaScreen(widget.areaName, widget.areaId))));
  }

  // void updatePeople() {
  //   final areas = _firestore.collection('assignments').snapshots().map(
  //       (snapshot) => snapshot.docs
  //           .map((doc) => _auth.assignmentsfromJson(doc.id, doc.data()))
  //           .toList());
  //   areas.forEach((jobpersonlist) {
  //     jobpersonlist.forEach((jobperson) {
  //       if (jobperson.assignedArea == widget.areaName &&
  //           jobperson.personpref == 'AM') {
  //         _auth.updateMinusAMPeopleArea(widget.areaId,widget.);
  //       } else if (jobperson.assignedArea == widget.areaName &&
  //           jobperson.personpref == 'PM') {
  //         _auth.updateMinusPMPeopleArea(widget.areaId);
  //       }
  //     });
  //   });
  // }

  // StreamBuilder<List<JobPerson>>(
  //     stream: _auth.getAssignments(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return Text('Updating shifts people...${snapshot.error}');
  //       } else if (snapshot.hasData) {
  //         final assignments = snapshot.data!;
  //         assignments.forEach((jobperson) {
  //           if (jobperson.assignedArea == widget.areaName &&
  //               jobperson.personpref == 'AM') {
  //             //place setstate here
  //             // setState(() {
  //             //   widget.amPeopleNeeded -= 1;
  //             _auth.updateAMPeopleArea(widget.areaId);
  //             // });
  //           } else if (jobperson.assignedArea == widget.areaName &&
  //               jobperson.personpref == 'PM') {
  //             //place setstate here
  //             // setState(() {
  //             //   widget.pmPeopleNeeded -= 1;
  //             // });
  //             _auth.updatePMPeopleArea(widget.areaId);
  //           }
  //         });
  //       }
  //       return const Text('No shift updates');
  //     });
  @override
  Widget build(BuildContext context) {
    if (widget.amPeopleNeeded == 0 && widget.pmPeopleNeeded == 0) {
      setState(() {
        peopleCountNotMaxed = true;
      });
    }
    return Dismissible(
      key: ValueKey(widget.areaName),
      background: BGDeleteItem(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _auth.deleteArea(widget.areaId);
      },
      // child: Card(
      //   elevation: 5,
      //   margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      //   child: Padding(
      //       padding: const EdgeInsets.all(8),
      //       child: ListTile(
      //         leading: CircleAvatar(
      //             backgroundColor: Colors.teal.shade800,
      //             child: Text('${noOfPeopleNeed}'),
      //             foregroundColor: Colors.white),
      //         title: Text('Area : ${areaName}',
      //             style: const TextStyle(fontWeight: FontWeight.bold)),
      //         subtitle: Text(
      //           DateFormat.yMMMMd().format(date),
      //           style: const TextStyle(color: Colors.grey),
      //         ),
      //         trailing: IconButton(
      //             onPressed: () => selectArea(context),
      //             icon: const Icon(Icons.arrow_circle_right_outlined,
      //                 size: 30, color: Colors.teal)),
      //       )),
      // ),
      // return Card(
      child: Card(
        shape: peopleCountNotMaxed
            ? const RoundedRectangleBorder(
                side: BorderSide(
                    color: Color.fromRGBO(14, 160, 61, 0.4), width: 3),
                borderRadius: BorderRadius.all(Radius.circular(15)))
            : const RoundedRectangleBorder(
                side: BorderSide(
                    color: Color.fromRGBO(219, 44, 18, 0.8), width: 3),
                borderRadius: BorderRadius.all(Radius.circular(15))),
        color: Colors.white,
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Text(
                    widget.areaName,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              Container(
                  // spacing between it and its surroundings
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(
                          side: BorderSide(width: 2, color: Colors.amber))),
                  // spacing in the box amount value
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    const Text('AM'),
                    Text(
                      '${widget.amPeopleNeeded}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).primaryColorDark),
                    ),
                  ])),
              Container(
                  // spacing between it and its surroundings
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(
                          side: BorderSide(width: 2, color: Colors.teal))),
                  // spacing in the box amount value
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    const Text('PM'),
                    Text(
                      '${widget.pmPeopleNeeded}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).primaryColorDark),
                    ),
                  ])),
              IconButton(
                  onPressed: () => selectArea(context),
                  icon: const Icon(Icons.arrow_circle_right_outlined,
                      size: 30, color: Colors.teal)),
            ],
          ),
        ),
      ),
    );
  }
}
