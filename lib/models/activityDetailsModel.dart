// To parse this JSON data, do
//
//     final activityDetailsModel = activityDetailsModelFromJson(jsonString);

import 'dart:convert';

ActivityDetailsModel activityDetailsModelFromJson(String str) => ActivityDetailsModel.fromJson(json.decode(str));

String activityDetailsModelToJson(ActivityDetailsModel data) => json.encode(data.toJson());

class ActivityDetailsModel {
  List<Data> activityDetailsModel;
  int status;
  String message;

  ActivityDetailsModel({
    required this.activityDetailsModel,
    required this.status,
    required this.message,
  });

  factory ActivityDetailsModel.fromJson(Map<String, dynamic> json) => ActivityDetailsModel(
        activityDetailsModel: List.from(json["date"].map((x) => Data.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "date": List<dynamic>.from(activityDetailsModel.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class Data {
  int id;
  String title;
  ActivityType component;
  ActivityType locationLevel;
  ActivityType activityType;
  List<Division> divisions;

  Data({
    required this.id,
    required this.title,
    required this.component,
    required this.locationLevel,
    required this.activityType,
    required this.divisions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        component: ActivityType.fromJson(json["component"]),
        locationLevel: ActivityType.fromJson(json["location_level"]),
        activityType: ActivityType.fromJson(json["activity_type"]),
        divisions: List<Division>.from(json["divisions"].map((x) => Division.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "component": component.toJson(),
        "location_level": locationLevel.toJson(),
        "activity_type": activityType.toJson(),
        "divisions": List<dynamic>.from(divisions.map((x) => x.toJson())),
      };
}

class ActivityType {
  int id;
  String name;

  ActivityType({
    required this.id,
    required this.name,
  });

  factory ActivityType.fromJson(Map<String, dynamic> json) => ActivityType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Division {
  int id;
  String nameEn;

  Division({
    required this.id,
    required this.nameEn,
  });

  factory Division.fromJson(Map<String, dynamic> json) => Division(
        id: json["id"],
        nameEn: json["name_en"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_en": nameEn,
      };
}
