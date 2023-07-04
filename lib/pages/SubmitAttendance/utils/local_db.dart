import 'package:concorde_app/pages/SubmitAttendance/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static const userDetails = "user_details";

  static Box userDetailsBox() => Hive.box(userDetails);

  static initialize() async {
    await Hive.openBox(userDetails);
  }

  static clearAllBox() async {
    await HiveBoxes.userDetailsBox().clear();
  }
}

class LocalDB {
  static UserLocal getUser() => UserLocal.fromJson(HiveBoxes.userDetailsBox().toMap());

  static String getUserName() =>
      HiveBoxes.userDetailsBox().toMap()[UserLocal.nameKey];

  static String getUserArray() =>
      HiveBoxes.userDetailsBox().toMap()[UserLocal.arrayKey];

  static setUserDetails(UserLocal user) =>
      HiveBoxes.userDetailsBox().putAll(user.toJson());
}

