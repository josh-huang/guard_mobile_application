import 'dart:convert';

class FaceAttendance {
  final String name;
  List imageArray;
  String currentLocation;
  String currentTime;
  String imageUrl;

  FaceAttendance({
    required this.name,
    required this.imageArray,
    required this.currentLocation,
    required this.currentTime,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    "name" : name,
    'userArray' : imageArray,
    'current_location' : currentLocation,
    'current_time' : currentTime,
    'imageUrl' : imageUrl,
  };

  static FaceAttendance fromJson(Map<String, dynamic> json) => FaceAttendance(
    name : json['name'],
    imageArray: jsonDecode(json['userArray']),
    currentLocation : json['current_location'],
    currentTime: json['current_time'],
    imageUrl : json['imageUrl'],
  );

}

