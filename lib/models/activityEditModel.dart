// To parse this JSON data, do
//
//     final activityEditModel = activityEditModelFromJson(jsonString);

import 'dart:convert';

ActivityEditModel activityEditModelFromJson(String str) => ActivityEditModel.fromJson(json.decode(str));

String activityEditModelToJson(ActivityEditModel data) => json.encode(data.toJson());

class ActivityEditModel {
  List<ActivityEditData> activityEditData;
  int status;
  String message;

  ActivityEditModel({
    required this.activityEditData,
    required this.status,
    required this.message,
  });

  factory ActivityEditModel.fromJson(Map<String, dynamic> json) => ActivityEditModel(
        activityEditData: List<ActivityEditData>.from(json["data"].map((x) => ActivityEditData.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(activityEditData.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class ActivityEditData {
  int? id;
  dynamic? locationId;
  String? location_level;
  dynamic? activityInfoSettingId;
  String? component;
  dynamic? componentId;
  dynamic? activityTypeId;
  String? activityTypeName;
  String? title;
  String? activityFromDate;
  String? activityToDate;
  String? activityVenue;
  dynamic? totalMale;
  dynamic? totalFemale;
  dynamic? totalParticipant;
  dynamic? latitude;
  dynamic? longitude;
  String? remark;
  List<AllDivision>? divisions;
  List<Dis_Upa_Uni>? districts;
  List<Dis_Upa_Uni>? upazilas;
  List<Dis_Upa_Uni>? unions;
  dynamic? selectedDisId;
  dynamic? selectedDivId;
  dynamic? selectedUpaId;
  dynamic? selectedUniId;

  ActivityEditData({
    this.id,
    this.locationId,
    this.location_level,
    this.activityInfoSettingId,
    this.component,
    this.componentId,
    this.activityTypeId,
    this.activityTypeName,
    this.title,
    this.activityFromDate,
    this.activityToDate,
    this.activityVenue,
    this.totalMale,
    this.totalFemale,
    this.totalParticipant,
    this.latitude,
    this.longitude,
    this.remark,
    this.divisions,
    this.districts,
    this.upazilas,
    this.unions,
    this.selectedDisId,
    this.selectedDivId,
    this.selectedUpaId,
    this.selectedUniId,
  });

  factory ActivityEditData.fromJson(Map<String, dynamic> json) => ActivityEditData(
        id: json["id"],
        locationId: json["location_id"],
        location_level: json["location_level"],
        activityInfoSettingId: json["activity_info_setting_id"],
        component: json["component"],
        componentId: json["component_id"],
        activityTypeId: json["activity_type_id"],
        activityTypeName: json["activity_type_name"],
        title: json["title"],
        activityFromDate: json["activity_from_date"],
        activityToDate: json["activity_to_date"],
        activityVenue: json["activity_venue"],
        totalMale: json["total_male"],
        totalFemale: json["total_female"],
        totalParticipant: json["total_participant"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        remark: json["remark"],
        divisions: List<AllDivision>.from(json["divisions"].map((x) => AllDivision.fromJson(x))),
        districts: List<Dis_Upa_Uni>.from(json["districts"].map((x) => Dis_Upa_Uni.fromJson(x))),
        upazilas: List<Dis_Upa_Uni>.from(json["upazilas"].map((x) => Dis_Upa_Uni.fromJson(x))),
        unions: List<Dis_Upa_Uni>.from(json["unions"].map((x) => Dis_Upa_Uni.fromJson(x))),
        selectedDisId: json["selected_dis_id"],
        selectedDivId: json["selected_div_id"],
        selectedUpaId: json["selected_upa_id"],
        selectedUniId: json["selected_uni_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location_id": locationId,
        "location_level": location_level,
        "activity_info_setting_id": activityInfoSettingId,
        "component": component,
        "component_id": componentId,
        "activity_type_id": activityTypeId,
        "activity_type_name": activityTypeName,
        "title": title,
        "activity_from_date": activityFromDate,
        "activity_to_date": activityToDate,
        "activity_venue": activityVenue,
        "total_male": totalMale,
        "total_female": totalFemale,
        "total_participant": totalParticipant,
        "latitude": latitude,
        "longitude": longitude,
        "remark": remark,
        "divisions": List<dynamic>.from(divisions!.map((x) => x.toJson())),
        "districts": List<dynamic>.from(districts!.map((x) => x.toJson())),
        "upazilas": List<dynamic>.from(upazilas!.map((x) => x.toJson())),
        "unions": List<dynamic>.from(unions!.map((x) => x)),
        "selected_dis_id": selectedDisId,
        "selected_div_id": selectedDivId,
        "selected_upa_id": selectedUpaId,
        "selected_uni_id": selectedUniId,
      };
}

class Dis_Upa_Uni {
  int? id;
  int? divisionId;
  String? nameBn;
  String? nameEn;
  dynamic? bbsCode;
  String? latitude;
  String? longitude;
  dynamic? oldLatitude;
  dynamic? oldLongitude;
  int? ngo;
  dynamic? url;
  AtedAt? createdAt;
  AtedAt? updatedAt;
  int? districtId;

  Dis_Upa_Uni({
    this.id,
    this.divisionId,
    this.nameBn,
    this.nameEn,
    this.bbsCode,
    this.latitude,
    this.longitude,
    this.oldLatitude,
    this.oldLongitude,
    this.ngo,
    this.url,
    this.createdAt,
    this.updatedAt,
    this.districtId,
  });

  factory Dis_Upa_Uni.fromJson(Map<String, dynamic> json) => Dis_Upa_Uni(
        id: json["id"],
        divisionId: json["division_id"],
        nameBn: json["name_bn"],
        nameEn: json["name_en"],
        bbsCode: json["bbs_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        oldLatitude: json["old_latitude"],
        oldLongitude: json["old_longitude"],
        ngo: json["ngo"],
        url: json["url"],
        createdAt: atedAtValues.map[json["created_at"]]!,
        updatedAt: atedAtValues.map[json["updated_at"]]!,
        districtId: json["district_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "division_id": divisionId,
        "name_bn": nameBn,
        "name_en": nameEn,
        "bbs_code": bbsCode,
        "latitude": latitude,
        "longitude": longitude,
        "old_latitude": oldLatitude,
        "old_longitude": oldLongitude,
        "ngo": ngo,
        "url": url,
        "created_at": atedAtValues.reverse[createdAt],
        "updated_at": atedAtValues.reverse[updatedAt],
        "district_id": districtId,
      };
}

enum AtedAt { THE_0000011130_T00_0000000000_Z }

final atedAtValues = EnumValues({"-000001-11-30T00:00:00.000000Z": AtedAt.THE_0000011130_T00_0000000000_Z});

class AllDivision {
  int id;
  String nameBn;
  String nameEn;
  dynamic bbsCode;
  dynamic latitude;
  dynamic longitude;
  dynamic url;
  DateTime? createdAt;
  DateTime? updatedAt;

  AllDivision({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.bbsCode,
    required this.latitude,
    required this.longitude,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AllDivision.fromJson(Map<String, dynamic> json) => AllDivision(
        id: json["id"],
        nameBn: json["name_bn"],
        nameEn: json["name_en"],
        bbsCode: json["bbs_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        url: json["url"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_bn": nameBn,
        "name_en": nameEn,
        "bbs_code": bbsCode,
        "latitude": latitude,
        "longitude": longitude,
        "url": url,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
