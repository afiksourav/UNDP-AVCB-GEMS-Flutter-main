import 'dart:convert';

AacoInfoEditModel aacoInfoEditModelFromJson(String str) => AacoInfoEditModel.fromJson(json.decode(str));

String aacoInfoEditModelToJson(AacoInfoEditModel data) => json.encode(data.toJson());

class AacoInfoEditModel {
  int status;
  String message;
  AacoInfoEditData? data;

  AacoInfoEditModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory AacoInfoEditModel.fromJson(Map<String, dynamic> json) => AacoInfoEditModel(
        status: json["status"],
        message: json["message"],
        data: AacoInfoEditData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
      };
}

class AacoInfoEditData {
  int id;
  int districtId;
  String district;
  int upazilaId;
  List<LocationListElement> upazilaLists;
  String upazila;
  int unionId;
  List<LocationListElement> unionLists;
  String union;
  String apointmentDate;
  int recruitmentStatus;
  int accoAvailiablityStatus;
  String createdBy;

  AacoInfoEditData({
    required this.id,
    required this.districtId,
    required this.district,
    required this.upazilaId,
    required this.upazilaLists,
    required this.upazila,
    required this.unionId,
    required this.unionLists,
    required this.union,
    required this.apointmentDate,
    required this.recruitmentStatus,
    required this.accoAvailiablityStatus,
    required this.createdBy,
  });

  factory AacoInfoEditData.fromJson(Map<String, dynamic> json) => AacoInfoEditData(
        id: json["id"],
        districtId: json["district_id"],
        district: json["district"],
        upazilaId: json["upazila_id"],
        upazilaLists: List<LocationListElement>.from(json["upazila_lists"].map((x) => LocationListElement.fromJson(x))),
        upazila: json["upazila"],
        unionId: json["union_id"],
        unionLists: List<LocationListElement>.from(json["union_lists"].map((x) => LocationListElement.fromJson(x))),
        union: json["union"],
        apointmentDate: json["apointment_date"],
        recruitmentStatus: json["recruitment_status"],
        accoAvailiablityStatus: json["acco_availiablity_status"],
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "district_id": districtId,
        "district": district,
        "upazila_id": upazilaId,
        "upazila_lists": List<dynamic>.from(upazilaLists.map((x) => x.toJson())),
        "upazila": upazila,
        "union_id": unionId,
        "union_lists": List<dynamic>.from(unionLists.map((x) => x.toJson())),
        "union": union,
        "apointment_date": apointmentDate,
        "recruitment_status": recruitmentStatus,
        "acco_availiablity_status": accoAvailiablityStatus,
        "created_by": createdBy,
      };
}

class LocationListElement {
  String nameEn;
  int id;

  LocationListElement({
    required this.nameEn,
    required this.id,
  });

  factory LocationListElement.fromJson(Map<String, dynamic> json) => LocationListElement(
        nameEn: json["name_en"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name_en": nameEn,
        "id": id,
      };
}
