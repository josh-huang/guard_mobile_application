class UserLocal {
  static const String nameKey = "user_name";
  static const String arrayKey = "user_array";

  String? name;
  List? array;

  UserLocal({this.name, this.array});

  factory UserLocal.fromJson(Map<dynamic,dynamic> json) => UserLocal(
      name: json[nameKey],
      array: json[arrayKey],
    );

  Map<String, dynamic> toJson() => {
      nameKey: name,
      arrayKey: array,
    };
}