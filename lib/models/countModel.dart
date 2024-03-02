// To parse this JSON data, do
//
//     final countModel = countModelFromJson(jsonString);

import 'dart:convert';

CountModel countModelFromJson(String str) => CountModel.fromJson(json.decode(str));

String countModelToJson(CountModel data) => json.encode(data.toJson());

class CountModel {
  int status;
  String message;
  int activityInfoCount;
  int trainingInfoCount;
  int fieldVisitCount;
  int accoInfoCount;

  CountModel({
    required this.status,
    required this.message,
    required this.activityInfoCount,
    required this.trainingInfoCount,
    required this.fieldVisitCount,
    required this.accoInfoCount,
  });

  factory CountModel.fromJson(Map<String, dynamic> json) => CountModel(
        status: json["status"],
        message: json["message"],
        activityInfoCount: json["activity_info_count"],
        trainingInfoCount: json["training_info_count"],
        fieldVisitCount: json["field_visit_count"],
        accoInfoCount: json["acco_info_count"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "activity_info_count": activityInfoCount,
        "training_info_count": trainingInfoCount,
        "field_visit_count": fieldVisitCount,
        "acco_info_count": accoInfoCount,
      };
}
