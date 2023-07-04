import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../net/flutterfire.dart';
import '../../providers/areas.dart';
import '../../widgets/area_item.dart' as ai;
import '../../widgets/bgcolorwidget.dart';
import 'add_area_screen.dart';
import 'add_people_screen.dart';
import 'assignments_screen.dart';

enum SchedulerOptions { createJob, addNewArea, addNewPeople }

class JobScheduler extends StatefulWidget {
  static const routeName = '/job-scheduler';

  @override
  State<JobScheduler> createState() => _JobSchedulerState();
}

class _JobSchedulerState extends State<JobScheduler> {
  // final _peopleFocusNode = FocusNode();

  final AuthService _auth = AuthService();
  List<AreaItem> areas = [];

  // void _addNewArea(
  //     String areaName, int noOfPeopleNeed, DateTime chosenDate) {
  //   final newArea = AreaItem(
  //       // areaId: DateTime.now().toString(),
  //       areaName: areaName,
  //       noOfPeopleNeeded: noOfPeopleNeed,
  //       date: chosenDate);
  //   // setState(() {
  //   //   _areaList.add(newArea);
  //   // });
  // }

  void _buildNewArea(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return AddAreaScreen();
        });
  }

  // void _buildNewPerson(BuildContext ctx) {
  //   showModalBottomSheet(
  //       context: ctx,
  //       builder: (_) {
  //         return AddPersonScreen();
  //       });
  // }

  void peoplesJob(BuildContext ctx) {
    Navigator.of(ctx)
        .push(MaterialPageRoute(builder: ((_) => AssignmentsScreen())));
  }

  @override
  Widget build(BuildContext context) {
    // final areasData = Provider.of<Areas>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Scheduler'),
        actions: [
          IconButton(
              onPressed: () => peoplesJob(context),
              icon: const Icon(Icons.people)),
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: SchedulerOptions.addNewArea,
                      child: Text(
                        'Add Area',
                      ),
                    ),
                    // const PopupMenuItem(
                    //   value: SchedulerOptions.addNewPeople,
                    //   child: Text(
                    //     'Add People',
                    //   ),
                    // ),
                  ],
              onSelected: (SchedulerOptions value) {
                if (value == SchedulerOptions.addNewArea) {
                  _buildNewArea(context);
                } else if (value == SchedulerOptions.addNewPeople) {
                  //
                } else if (value == SchedulerOptions.createJob) {
                  //
                }
              }),
          IconButton(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BGColor(
        child: StreamBuilder<List<AreaItem>>(
          stream: _auth.getAreas(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return BGColor(
                  child: Center(
                child: Text(
                  'No areas in database yet.${snapshot.error}',
                ),
              ));
            } else if (snapshot.hasData) {
              areas = snapshot.data!;
              return ListView.builder(
                  itemCount: areas.length,
                  itemBuilder: (ctx, i) => ai.AreaItem(
                        // areaId: areasData.areas[i].areaId,
                        areaName: areas[i].areaName,
                        noOfPeopleNeed: areas[i].noOfPeopleNeeded,
                        date: areas[i].date,
                        amPeopleNeeded: areas[i].amPeopleNeeded,
                        pmPeopleNeeded: areas[i].pmPeopleNeeded,
                        areaId: areas[i].areaId,
                      ));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
