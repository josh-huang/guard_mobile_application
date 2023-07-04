class GuardAck {
  final String guardname;
  final String guardWorkDate;
  final String personShiftPref;
  bool guardAck;

  GuardAck(
      {required this.guardname,
      required this.guardWorkDate,
      required this.guardAck,
      required this.personShiftPref});
}
