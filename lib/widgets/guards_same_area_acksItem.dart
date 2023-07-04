import 'package:flutter/material.dart';

class GuardsCurrentDateAck extends StatelessWidget {
  // const GuardsCurrentDateAck({super.key});
  final int personIndex;
  final String guardname;
  final String guardWorkDate;
  bool guardAck;
  final String personShiftPref;

  GuardsCurrentDateAck(
      {required this.personIndex,
      required this.guardname,
      required this.guardWorkDate,
      required this.guardAck,
      required this.personShiftPref});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white38, borderRadius: BorderRadius.circular(10)),
      // margin: const EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      // constraints: const BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 2.0),
          Text(
            " #${personIndex} ${guardname} (${personShiftPref})",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Acknowledgement for ${guardWorkDate} : ${guardAck}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
