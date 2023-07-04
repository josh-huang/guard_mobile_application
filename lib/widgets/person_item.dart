import 'package:concorde_app/widgets/bgdeleteItem.dart';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:provider/provider.dart';

import '../net/flutterfire.dart';
import '../providers/job_person.dart';
import '../screens/JobScheduler/assignment_item_screen.dart';

class PersonItem extends StatelessWidget {
  // const PersonItem({super.key});
  final String name;
  final String assignedLocation;
  // final String noOfleavesChosen;
  final List<DateTime?> leaveDates;
  final String? jsonId;
  final String? authUserDocId;
  final AuthService _auth = AuthService();

  PersonItem({
    required this.name,
    required this.assignedLocation,
    // required this.noOfleavesChosen,
    required this.leaveDates,
    required this.jsonId,
    required this.authUserDocId,
  });

  // String _getValueText(
  //   CalendarDatePicker2Type datePickerType,
  //   List<DateTime?> values,
  // ) {
  //   var valueText = (values.isNotEmpty ? values[0] : null)
  //       .toString()
  //       .replaceAll('00:00:00.000', '');

  //   if (datePickerType == CalendarDatePicker2Type.multi) {
  //     valueText = values.isNotEmpty
  //         ? values
  //             .map((v) => v.toString().replaceAll('00:00:00.000', ''))
  //             .join(', ')
  //         : 'null';
  //   } else if (datePickerType == CalendarDatePicker2Type.range) {
  //     if (values.isNotEmpty) {
  //       final startDate = values[0].toString().replaceAll('00:00:00.000', '');
  //       final endDate = values.length > 1
  //           ? values[1].toString().replaceAll('00:00:00.000', '')
  //           : 'null';
  //       valueText = '$startDate to $endDate';
  //     } else {
  //       return 'null';
  //     }
  //   }

  //   return valueText;
  // }

  final config = CalendarDatePicker2Config(
    calendarType: CalendarDatePicker2Type.multi,
  );

  void selectAssignment(BuildContext ctx) {
    Navigator.of(ctx).push(MaterialPageRoute(
        builder: ((_) => AssignmentItemScreen(
              personName: name,
            ))));
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(name),
      background: BGDeleteItem(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Provider.of<JobPeoples>(context, listen: false)
        //     .removeJobs(assignedLocation);
        _auth.deletePerson(jsonId, authUserDocId);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              title: Text('Name : ${name}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                'Assigned Location : ${assignedLocation}',
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                  onPressed: () => selectAssignment(context),
                  icon: const Icon(Icons.arrow_circle_right_outlined,
                      size: 30, color: Colors.teal)),
            )),
      ),
    );
  }
}
