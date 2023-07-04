import 'dart:convert';

class FacePerson {
  final String name;
  List imageArray;
  String imageUrl;

  FacePerson({
    required this.name,
    required this.imageArray,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    "name" : name,
    'userArray' : imageArray,
    'imageUrl' : imageUrl,
  };

  static FacePerson fromJson(Map<String, dynamic> json) => FacePerson(
      name : json['name'],
      imageArray: jsonDecode(json['userArray']),
      imageUrl : json['imageUrl'],
  );

}

