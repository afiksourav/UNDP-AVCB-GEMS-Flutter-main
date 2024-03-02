// To parse this JSON data, do
//
//     final fieldVisitUpdateModel = fieldVisitUpdateModelFromJson(jsonString);

import 'dart:convert';

FieldVisitUpdateModel fieldVisitUpdateModelFromJson(String str) => FieldVisitUpdateModel.fromJson(json.decode(str));

String fieldVisitUpdateModelToJson(FieldVisitUpdateModel data) => json.encode(data.toJson());

class FieldVisitUpdateModel {
  int status;
  String message;
  List<Question> question;
  String data;

  FieldVisitUpdateModel({
    required this.status,
    required this.message,
    required this.question,
    required this.data,
  });

  factory FieldVisitUpdateModel.fromJson(Map<String, dynamic> json) => FieldVisitUpdateModel(
        status: json["status"],
        message: json["message"],
        question: List<Question>.from(json["question"].map((x) => Question.fromJson(x))),
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "question": List<dynamic>.from(question.map((x) => x.toJson())),
        "data": data,
      };
}

class Question {
  int id;
  String question;
  String type;
  int createdBy;
  int updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int status;
  List<FieldSettingOption> fieldSettingOptions;

  Question({
    required this.id,
    required this.question,
    required this.type,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.fieldSettingOptions,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        question: json["question"],
        type: json["type"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        status: json["status"],
        fieldSettingOptions:
            List<FieldSettingOption>.from(json["field_setting_options"].map((x) => FieldSettingOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "type": type,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "status": status,
        "field_setting_options": List<dynamic>.from(fieldSettingOptions.map((x) => x.toJson())),
      };
}

class FieldSettingOption {
  int id;
  int fieldSettingId;
  String optionName;
  String slug;
  DateTime createdAt;
  DateTime updatedAt;
  String? ansValue;

  FieldSettingOption({
    required this.id,
    required this.fieldSettingId,
    required this.optionName,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.ansValue,
  });

  factory FieldSettingOption.fromJson(Map<String, dynamic> json) => FieldSettingOption(
        id: json["id"],
        fieldSettingId: json["field_setting_id"],
        optionName: json["option_name"],
        slug: json["slug"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        ansValue: json["ans_value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "field_setting_id": fieldSettingId,
        "option_name": optionName,
        "slug": slug,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "ans_value": ansValue,
      };
}
