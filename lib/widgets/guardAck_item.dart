import 'package:flutter/material.dart';

import '../net/flutterfire.dart';
import 'bgcolorwidget.dart';

class GuardAckItem extends StatefulWidget {
  // const GuardAck({super.key});

  final String userWorkDate;
  bool ack;
  final String? authDocId;
  // final String areaName;
  // final String personName;
  // final List<DateTime?> userWorkDates;

  GuardAckItem({
    required this.userWorkDate,
    required this.ack,
    required this.authDocId,
    // required this.areaName,
    // required this.personName,
    // required this.userWorkDates,
  });

  @override
  State<GuardAckItem> createState() => _GuardAckItemState();
}

class _GuardAckItemState extends State<GuardAckItem> {
  bool ackBtnActive = true;
  final AuthService _auth = AuthService();

  void forwardAck(String? authDocID, String userWorkDate) {
    _auth.updateNotAttendingAck(authDocID, userWorkDate);
  }

  Widget _buildackDateItem(String userWorkDate) {
    if (userWorkDate == '') {
      return BGColor(
        child: const Center(
            child: Text('User does not have Work Date scheduled today')),
      );
    } else {
      return Center(
        child: Card(
          shape: const RoundedRectangleBorder(
              side:
                  BorderSide(color: Color.fromRGBO(14, 160, 61, 0.4), width: 3),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          color: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    userWorkDate,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  // IconButton(
                  //     // onPressed: () => selectArea(context),
                  //     onPressed: () => {},
                  //     icon: const Icon(Icons.check,
                  //         size: 30, color: Colors.teal)),
                  IconButton(
                      // onPressed: () => selectArea(context),
                      onPressed: ackBtnActive
                          ? () {
                              forwardAck(widget.authDocId, userWorkDate);
                              setState(() {
                                ackBtnActive = false;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.close_rounded,
                          size: 30, color: Colors.red)),
                  // Container(
                  //     // spacing between it and its surroundings
                  //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  //     decoration: const ShapeDecoration(
                  //         shape: CircleBorder(
                  //             side: BorderSide(width: 2, color: Colors.amber))),
                  //     // spacing in the box amount value
                  //     padding: const EdgeInsets.all(10),
                  //     child: Column(children: [
                  //       const Text('AM'),
                  //       Text(
                  //         '${widget.amPeopleNeeded}',
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 15,
                  //             color: Theme.of(context).primaryColorDark),
                  //       ),
                  //     ])),
                  // Container(
                  //     // spacing between it and its surroundings
                  //     margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  //     decoration: const ShapeDecoration(
                  //         shape: CircleBorder(
                  //             side: BorderSide(width: 2, color: Colors.teal))),
                  //     // spacing in the box amount value
                  //     padding: const EdgeInsets.all(10),
                  //     child: Column(children: [
                  //       const Text('PM'),
                  //       Text(
                  //         '${widget.pmPeopleNeeded}',
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 15,
                  //             color: Theme.of(context).primaryColorDark),
                  //       ),
                  //     ])),
                ],
              )),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BGColor(child: _buildackDateItem(widget.userWorkDate));
  }
}
