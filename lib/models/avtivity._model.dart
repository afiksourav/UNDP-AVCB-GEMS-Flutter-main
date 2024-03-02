// To parse this JSON data, do
//
//     final activity = activityFromJson(jsonString);

import 'dart:convert';

Activity activityFromJson(String str) => Activity.fromJson(json.decode(str));

String activityToJson(Activity data) => json.encode(data.toJson());

class Activity {
  List<ActivityData> data;
  int status;
  String message;

  Activity({
    required this.data,
    required this.status,
    required this.message,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        data: List<ActivityData>.from(json["data"].map((x) => ActivityData.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class ActivityData {
  int id;
  String name;
  int count;
  dynamic component;
  dynamic activityType;

  ActivityData({
    required this.id,
    required this.count,
    required this.name,
    required this.component,
    required this.activityType,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) => ActivityData(
        id: json["id"],
        count: json["count"],
        name: json["name"],
        component: json["component"],
        activityType: json["activity_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "count": count,
        "component": component,
        "activity_type": activityType,
      };
}
