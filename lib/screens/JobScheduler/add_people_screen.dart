import 'package:concorde_app/componets/facialregister_widget.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../net/flutterfire.dart';
import '../../pages/SubmitAttendance/page/FaceRecognition/cameraRegister.dart';
import '../../providers/areas.dart';
import '../../providers/job_person.dart';
import '../../widgets/bgcolorwidget.dart';
import '../../pages/SubmitAttendance/page/FaceRecognition/mlServices.dart';

class AddPersonScreen extends StatefulWidget {
  // final List<AreaItem> areaList;

  // AddPersonScreen({required this.areaList});

  @override
  State<AddPersonScreen> createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  // const AddPersonScreen({super.key});
  TextEditingController _nameField = TextEditingController();
  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _contactField = TextEditingController();

  // String? get _contactError {
  //   final contactText = _contactField.text;
  //   if (contactText.length < 8 || contactText.length > 8) {
  //     return "It's not a valid SG phone number.";
  //   }
  //   return null;
  // }

  List<DateTime?> _multiDatePickerValueWithDefaultValue = [
    // DateTime(DateTime.now().year, DateTime.now().month, 1),
    // DateTime(DateTime.now().year, DateTime.now().month, 5),
    // DateTime(DateTime.now().year, DateTime.now().month, 14),
    // DateTime(DateTime.now().year, DateTime.now().month, 17),
    // DateTime(DateTime.now().year, DateTime.now().month, 25),
  ];
  List<DateTime?> _multiworkDatePicker = [];
  List<Map<String, String?>> areamap = [];

  DateTime? _plrdDate = DateTime.now();

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values.map((v) {
              final DateFormat displayFormater =
                  DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
              final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
              final DateTime displayDate = displayFormater.parse(v.toString());
              final String formatted = serverFormater.format(displayDate);
              return formatted;
              // v.toString().replaceAll('00:00:00.000', '');
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

  // Widget _plrdExpiryDatewithValue() {
  //   return Container(
  //     color: Colors.teal,
  //     height: 70,
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Text(
  //               _plrdDate == null
  //                   ? 'No date chosen!'
  //                   : 'Picked Date: ${DateFormat.yMd().format(_plrdDate as DateTime)}',
  //               style: const TextStyle(color: Colors.white, fontSize: 18)),
  //         ),
  //         ElevatedButton(
  //           onPressed: _pDatePicker,
  //           child: const Text('Choose Date',
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold, color: Colors.white)),
  //         )
  //       ],
  //     ),
  //   );
  // }
  Widget buildPictureButton() =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(56),
            /*backgroundColor: Colors.blueGrey,*/
            textStyle: TextStyle(fontSize: 20)
        ),
        child: Row(
          children: [
            Icon(Icons.camera_alt_outlined, size: 28,),
            const SizedBox(width: 16,),
            Text('Take Picture'),
          ],
        ),
        onPressed: () => PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: FaceScanScreenRegister(name : _nameField.text),
          withNavBar: false, // OPTIONAL VALUE. True by default.
        ),);

  Future<String?> _buildUserAccount(
      String personLoginID, String personLoginPwd, String personType) async {
    String authUserID = '';
    Future<String?> createdUserAuthID =
        _auth.createUser(personLoginID, personLoginPwd).then((createUser) {
      if (createUser != null) {
        return createUser.uid;
      }
    });
    // String? createdUserAuthID = '';
    // final createdUser = await _auth.createUser(personLoginID, personLoginPwd);
    // if (createdUser != null) {
    //   createdUserAuthID = createdUser.uid;
    // }

    // if need to change password in person profile, need to change in two places also
    _auth.createNewGuardInFirestore(
        personLoginID, createdUserAuthID, personType, personLoginPwd);

    return createdUserAuthID;
    // print(authUserID);
    // return authUserID;
  }

  void _pDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime(2052))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _plrdDate = pickedDate;
      });
    });
  }

  Widget _buildDefaultMultiDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.multi,
      selectedDayHighlightColor: Colors.teal.shade700,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const SizedBox(height: 2),
        // const Text('Multi Date Picker'),
        CalendarDatePicker2(
          config: config,
          initialValue: [],
          onValueChanged: (values) =>
              setState(() => _multiDatePickerValueWithDefaultValue = values),
        ),
        const SizedBox(height: 2),
        Wrap(
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _multiDatePickerValueWithDefaultValue,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ],
        ),
        const SizedBox(height: 2),
      ],
    );
  }

  Widget _workDateswithDefaultValues() {
    var leavesDatesinit = [..._multiDatePickerValueWithDefaultValue];
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.multi,
      selectedDayHighlightColor: Colors.teal.shade700,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // const SizedBox(height: 2),
        // const Text('Multi Date Picker'),
        CalendarDatePicker2(
          config: config,
          initialValue: leavesDatesinit,
          onValueChanged: (values) =>
              setState(() => _multiworkDatePicker = values),
        ),
        const SizedBox(height: 2),
        Wrap(
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _multiworkDatePicker,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ],
        ),
        const SizedBox(height: 2),
      ],
    );
  }

  Widget buildName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: TextFormField(
        onFieldSubmitted: (_) => submitData(),
        controller: _nameField,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal, width: 1)),
          hintText: 'Name',
        ),
        // focusNode: _peopleFocusNode,
      ),
    );
  }

  Widget buildContactNumber() {
    return Column(
      children: [
        TextFormField(
          onFieldSubmitted: (_) => submitData(),
          controller: _contactField,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Contact Number',
          ),

          // focusNode: _peopleFocusNode,
        ),
      ],
    );
  }

  String dropdownValue = 'SUTD A';
  Widget buildAssignedArea() {
    // final areasData = Provider.of<Areas>(context);
    // List<Map<String,String?>> areamap = [];
    return StreamBuilder<List<AreaItem>>(
      stream: _auth.getAreas(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'No area in database yet.${snapshot.error}',
          );
        } else if (snapshot.hasData) {
          final areas = snapshot.data!;
          areamap = areas.map((areaItem) {
            return {areaItem.areaName: areaItem.areaId};
          }).toList();
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: DropdownButtonFormField(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal, width: 1)),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide(width: 1)),
                  ),
                  value: dropdownValue,
                  onChanged: (value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: snapshot.data!.map((AreaItem area) {
                    return DropdownMenuItem(
                      value: area.areaName,
                      child: Text(area.areaName),
                    );
                  }).toList()
                  // .cast<String>(),
                  ));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    // areas.map((area) => _areaNames.add(area.areaName.toString()));
    // for (var area in areasData.areas) {
    //   areasData.jsonAreaNames(area).forEach((key, value) {
    //     if (key == 'AreaName') {
    //       _areaNames.add(value);
    //     }
    //   });
    // }
  }

  // Widget buildNoOfLeaves() {
  //   return Column(
  //     children: [
  //       TextFormField(
  //         onFieldSubmitted: (_) => submitData(),
  //         controller: _leavesField,
  //         keyboardType: TextInputType.number,
  //         decoration: const InputDecoration(
  //           border: OutlineInputBorder(),
  //           hintText: 'No of Leaves',
  //         ),
  //         // focusNode: _peopleFocusNode,
  //       ),
  //       const SizedBox(
  //         height: 10,
  //       )
  //     ],
  //   );
  // }

  String dropdownRank = 'SSO';
  final List<String> _rankChoices = ['SSO', 'SS', 'SO'];
  Widget buildRankChoice() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: DropdownButtonFormField(
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),
          ),
          value: dropdownRank,
          onChanged: (rank) {
            setState(() {
              dropdownRank = rank!;
            });
          },
          items: _rankChoices
              .map((rankchoice) => DropdownMenuItem(
                    child: Text(rankchoice),
                    value: rankchoice,
                  ))
              .toList(),
        ));
  }

  String dropdownprefs = 'AM';
  final List<String> _prefChoices = ['AM', 'PM'];
  Widget buildPrefChoice() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: DropdownButtonFormField(
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 1)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1)),
          ),
          value: dropdownprefs,
          onChanged: (pref) {
            setState(() {
              dropdownprefs = pref!;
            });
          },
          items: _prefChoices
              .map((prefchoice) => DropdownMenuItem(
                    child: Text(prefchoice),
                    value: prefchoice,
                  ))
              .toList(),
        ));
  }

  Widget multiDateBtn() {
    return ElevatedButton(
      onPressed: () => _buildMultiDate(context),
      child: const Text('Leaves Dates',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget multiWorkDateBtn() {
    return ElevatedButton(
      onPressed: () => _buildMultiWorkDate(context),
      child: const Text('Work Dates',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget prldexpiryDateBtn() {
    return ElevatedButton(
      onPressed: () => _pDatePicker(),
      child: const Text('PLRD Date',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  Widget plrdExpiryDate() {
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.single,
    );
    workDates = _multiworkDatePicker.length;

    final _convertedplrdDate = convertDateTimeDisplay(_plrdDate.toString());
    return Column(
      children: [
        Text(
          _convertedplrdDate,
          // overflow: TextOverflow.ellipsis,
          // maxLines: 3,
          // softWrap: false,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  int leavesDates = 0;
  Widget leavesDate() {
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.multi,
    );
    leavesDates = _multiDatePickerValueWithDefaultValue.length;
    return Column(
      children: [
        Text(
          _getValueText(
            config.calendarType,
            _multiDatePickerValueWithDefaultValue,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          softWrap: false,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'No of Leave dates: ${leavesDates}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
    // Text(
    //   _getValueText(
    //     config.calendarType,
    //     _multiDatePickerValueWithDefaultValue,
    //   ),
    //   overflow: TextOverflow.ellipsis,
    //   maxLines: 1,
    //   softWrap: false,
    // );
  }

  int workDates = 0;
  Widget workDate() {
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.multi,
    );
    workDates = _multiworkDatePicker.length;
    return Column(
      children: [
        Text(
          _getValueText(
            config.calendarType,
            _multiworkDatePicker,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          softWrap: false,
          style: const TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'No of Working Dates: ${workDates}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  void _buildMultiDate(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return _buildDefaultMultiDatePickerWithValue();
        });
  }

  void _buildMultiWorkDate(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return _workDateswithDefaultValues();
        });
  }

  Future<List?> getPredictedArray() async {
    List? imageArray = await getPredictedArray();
    return imageArray;
  }

  void submitData() async {
    final submitPerson = Provider.of<JobPeoples>(context, listen: false);
    final personName = _nameField.text.trim();
    final personContact = _contactField.text.trim();
    final personRank = dropdownRank;
    final personpref = dropdownprefs;
    final noOfleavesChosen = leavesDates;
    final assignedArea = dropdownValue;
    final plrdexpiryDate = _plrdDate;
    final leaveDates = _multiDatePickerValueWithDefaultValue;
    final workdates = _multiworkDatePicker;
    final personLoginID = personName + "g2022";
    const personLoginPwd = 'password';
    const personType = 'Guard';
    final imageArray = await getPredictedArray();

    if (personName.isEmpty ||
        noOfleavesChosen <= 0 ||
        assignedArea.isEmpty ||
        personContact.isEmpty) {
      return;
    }
    // submitPerson.addPerson(
    //   assignedArea,
    //   personName,
    //   personRank,
    //   noOfleavesChosen,
    //   leaveDates,
    //   workdates,
    //   personContact,
    //   personpref,
    //   plrdexpiryDate,

    // );
    Future<String?> authUserId =
        _buildUserAccount(personLoginID, personLoginPwd, personType);
    final String? authUserID = await authUserId;
    _auth.addNewJob(
        personName,
        personLoginID,
        authUserID,
        personRank,
        assignedArea,
        noOfleavesChosen,
        leaveDates,
        workdates,
        personContact,
        personpref,
        plrdexpiryDate,
        imageArray);
    _auth.createUserAcks(
        authUserID, workdates, assignedArea, personName, personpref);
    Navigator.of(context).pop();
    // updateAreapersonCount(areamap);
  }

  void updateAreapersonCount(
    List<Map<String, String?>> areaMap,
  ) {
    final assignedArea = dropdownValue;
    final personpref = dropdownprefs;
    areaMap.forEach((areaitem) {
      areaitem.forEach((key, value) {
        if (key == assignedArea && personpref == 'AM') {
          _auth.updateMinusAMPeopleArea(value);
        } else if (key == assignedArea && personpref == 'PM') {
          _auth.updateMinusPMPeopleArea(value);
        }
      });
    });
  }

  Widget buildSubmitBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: submitData,
        child: const Text('Submit'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add Person')),
        body: BGColor(
          child: Form(
              child: Column(
            children: [
              buildName(),
              buildContactNumber(),
              buildRankChoice(),
              buildPrefChoice(),
              buildAssignedArea(),
              buildPictureButton(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  prldexpiryDateBtn(),
                  multiDateBtn(),
                  multiWorkDateBtn(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'PLRD Expiry Date :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  plrdExpiryDate(),
                  const Text(
                    'Leave Dates:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leavesDate(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Work Dates:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  workDate(),
                ],
              ),
              buildSubmitBtn(),
              // Expanded(child: ListView.builder(itemBuilder: ,itemCount: ,))
            ],
          )),
        ));
  }
}
