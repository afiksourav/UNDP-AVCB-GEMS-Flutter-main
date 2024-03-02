// To parse this JSON data, do
//
//     final activityListModel = activityListModelFromJson(jsonString);

import 'dart:convert';

ActivityListModel activityListModelFromJson(String str) => ActivityListModel.fromJson(json.decode(str));

String activityListModelToJson(ActivityListModel data) => json.encode(data.toJson());

class ActivityListModel {
  List<Datum> data;
  int status;
  String message;

  ActivityListModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory ActivityListModel.fromJson(Map<String, dynamic> json) => ActivityListModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class Datum {
  int id;
  int activityInfoSettingId;
  int locationId;
  String activityFromDate;
  String activityToDate;
  String activityVenue;
  int totalMale;
  int totalFemale;
  int totalParticipant;
  dynamic latitude;
  dynamic longitude;
  String remark;
  int createdBy;
  int updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  ActivityInfoSetting activityInfoSetting;

  Datum({
    required this.id,
    required this.activityInfoSettingId,
    required this.locationId,
    required this.activityFromDate,
    required this.activityToDate,
    required this.activityVenue,
    required this.totalMale,
    required this.totalFemale,
    required this.totalParticipant,
    required this.latitude,
    required this.longitude,
    required this.remark,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.activityInfoSetting,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        activityInfoSettingId: json["activity_info_setting_id"],
        locationId: json["location_id"],
        activityFromDate: json["activity_from_date"],
        activityToDate: json["activity_to_date"],
        activityVenue: json["activity_venue"],
        totalMale: json["total_male"],
        totalFemale: json["total_female"],
        totalParticipant: json["total_participant"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        remark: json["remark"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        activityInfoSetting: ActivityInfoSetting.fromJson(json["activity_info_setting"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "activity_info_setting_id": activityInfoSettingId,
        "location_id": locationId,
        "activity_from_date": activityFromDate,
        "activity_to_date": activityToDate,
        "activity_venue": activityVenue,
        "total_male": totalMale,
        "total_female": totalFemale,
        "total_participant": totalParticipant,
        "latitude": latitude,
        "longitude": longitude,
        "remark": remark,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "activity_info_setting": activityInfoSetting.toJson(),
      };
}

class ActivityInfoSetting {
  int id;
  String name;
  int activityTypeId;
  int componentId;
  int locationLevelId;
  String? venueName;
  String status;
  int createdBy;
  int updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  ActivityType locationLevel;
  ActivityType activityType;
  ActivityType component;

  ActivityInfoSetting({
    required this.id,
    required this.name,
    required this.activityTypeId,
    required this.componentId,
    required this.locationLevelId,
    required this.venueName,
    required this.status,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.locationLevel,
    required this.activityType,
    required this.component,
  });

  factory ActivityInfoSetting.fromJson(Map<String, dynamic> json) => ActivityInfoSetting(
        id: json["id"],
        name: json["name"],
        activityTypeId: json["activity_type_id"],
        componentId: json["component_id"],
        locationLevelId: json["location_level_id"],
        venueName: json["venue_name"],
        status: json["status"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        locationLevel: ActivityType.fromJson(json["location_level"]),
        activityType: ActivityType.fromJson(json["activity_type"]),
        component: ActivityType.fromJson(json["component"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "activity_type_id": activityTypeId,
        "component_id": componentId,
        "location_level_id": locationLevelId,
        "venue_name": venueName,
        "status": status,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "location_level": locationLevel.toJson(),
        "activity_type": activityType.toJson(),
        "component": component.toJson(),
      };
}

class ActivityType {
  String name;
  int id;

  ActivityType({
    required this.name,
    required this.id,
  });

  factory ActivityType.fromJson(Map<String, dynamic> json) => ActivityType(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
