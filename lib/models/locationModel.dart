// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  List<Union>? unions;
  List<Upazila>? upazilas;
  List<District>? districts;
  List<Division>? divisions;
  int? status;

  LocationModel({
    this.unions,
    this.upazilas,
    this.districts,
    this.divisions,
    this.status,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        unions: json["unions"] == [] ? [] : List<Union>.from(json["unions"].map((x) => Union.fromJson(x))),
        upazilas: json["upazilas"] == [] ? [] : List<Upazila>.from(json["upazilas"].map((x) => Upazila.fromJson(x))),
        districts: json["districts"] == [] ? [] : List<District>.from(json["districts"].map((x) => District.fromJson(x))),
        divisions: List<Division>.from(json["divisions"].map((x) => Division.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "unions": List<dynamic>.from(unions!.map((x) => x.toJson())),
        "upazilas": List<dynamic>.from(upazilas!.map((x) => x.toJson())),
        "districts": List<dynamic>.from(districts!.map((x) => x.toJson())),
        "divisions": List<dynamic>.from(divisions!.map((x) => x.toJson())),
        "status": status,
      };
}

class District {
  String? districtName;
  int? districtId;
  int? divisionId;

  District({
    this.districtName,
    this.districtId,
    this.divisionId,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        districtName: json["district_name"],
        districtId: json["district_id"],
        divisionId: json["division_id"],
      );

  Map<String, dynamic> toJson() => {
        "district_name": districtName,
        "district_id": districtId,
        "division_id": divisionId,
      };
}

class Division {
  int? divisionId;
  String? divisionName;

  Division({
    this.divisionId,
    this.divisionName,
  });

  factory Division.fromJson(Map<String, dynamic> json) => Division(
        divisionId: json["division_id"],
        divisionName: json["division_name"],
      );

  Map<String, dynamic> toJson() => {
        "division_id": divisionId,
        "division_name": divisionName,
      };
}

class Union {
  int? unionId;
  String? unionName;
  int? upazilaId;

  Union({
    this.unionId,
    this.unionName,
    this.upazilaId,
  });

  factory Union.fromJson(Map<String, dynamic> json) => Union(
        unionId: json["union_id"],
        unionName: json["union_name"],
        upazilaId: json["upazila_id"],
      );

  Map<String, dynamic> toJson() => {
        "union_id": unionId,
        "union_name": unionName,
        "upazila_id": upazilaId,
      };
}

class Upazila {
  String? upazilaName;
  int? upazilaId;
  int? districtId;

  Upazila({
    this.upazilaName,
    this.upazilaId,
    this.districtId,
  });

  factory Upazila.fromJson(Map<String, dynamic> json) => Upazila(
        upazilaName: json["upazila_name"],
        upazilaId: json["upazila_id"],
        districtId: json["district_id"],
      );

  Map<String, dynamic> toJson() => {
        "upazila_name": upazilaName,
        "upazila_id": upazilaId,
        "district_id": districtId,
      };
}
