// To parse this JSON data, do
//
//     final fieldFindingCreateModel = fieldFindingCreateModelFromJson(jsonString);

import 'dart:convert';

FieldFindingCreateModel fieldFindingCreateModelFromJson(String str) => FieldFindingCreateModel.fromJson(json.decode(str));

String fieldFindingCreateModelToJson(FieldFindingCreateModel data) => json.encode(data.toJson());

class FieldFindingCreateModel {
    int status;
    String message;
    List<FieldCreateData> data;

    FieldFindingCreateModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory FieldFindingCreateModel.fromJson(Map<String, dynamic> json) => FieldFindingCreateModel(
        status: json["status"],
        message: json["message"],
        data: List<FieldCreateData>.from(json["data"].map((x) => FieldCreateData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class FieldCreateData {
    int id;
    String question;
    String type;
    int createdBy;
    int updatedBy;
    DateTime createdAt;
    DateTime updatedAt;
    int status;
    List<FieldSettingOption> fieldSettingOptions;

    FieldCreateData({
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

    factory FieldCreateData.fromJson(Map<String, dynamic> json) => FieldCreateData(
        id: json["id"],
        question: json["question"],
        type: json["type"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        status: json["status"],
        fieldSettingOptions: List<FieldSettingOption>.from(json["field_setting_options"].map((x) => FieldSettingOption.fromJson(x))),
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

    FieldSettingOption({
        required this.id,
        required this.fieldSettingId,
        required this.optionName,
        required this.slug,
        required this.createdAt,
        required this.updatedAt,
    });

    factory FieldSettingOption.fromJson(Map<String, dynamic> json) => FieldSettingOption(
        id: json["id"],
        fieldSettingId: json["field_setting_id"],
        optionName: json["option_name"],
        slug: json["slug"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "field_setting_id": fieldSettingId,
        "option_name": optionName,
        "slug": slug,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
