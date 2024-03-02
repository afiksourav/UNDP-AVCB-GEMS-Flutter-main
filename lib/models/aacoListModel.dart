// To parse this JSON data, do
//
//     final aacoListModel = aacoListModelFromJson(jsonString);

import 'dart:convert';

AacoListModel aacoListModelFromJson(String str) => AacoListModel.fromJson(json.decode(str));

String aacoListModelToJson(AacoListModel data) => json.encode(data.toJson());

class AacoListModel {
  int status;
  String message;
  List<Datum> data;
  dynamic? search;
  Pagination? pagination;

  AacoListModel({
    required this.status,
    required this.message,
    required this.data,
    this.search,
    this.pagination,
  });

  factory AacoListModel.fromJson(Map<String, dynamic> json) => AacoListModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        search: json["search"],
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "search": search,
        "pagination": pagination!.toJson(),
      };
}

class Datum {
  int id;
  int districtId;
  String district;
  int upazilaId;
  String upazila;
  int unionId;
  String union;
  String apointmentDate;
  int recruitmentStatus;
  int accoAvailiablityStatus;
  String createdBy;

  Datum({
    required this.id,
    required this.districtId,
    required this.district,
    required this.upazilaId,
    required this.upazila,
    required this.unionId,
    required this.union,
    required this.apointmentDate,
    required this.recruitmentStatus,
    required this.accoAvailiablityStatus,
    required this.createdBy,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        districtId: json["district_id"],
        district: json["district"],
        upazilaId: json["upazila_id"],
        upazila: json["upazila"],
        unionId: json["union_id"],
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
        "upazila": upazila,
        "union_id": unionId,
        "union": union,
        "apointment_date": apointmentDate,
        "recruitment_status": recruitmentStatus,
        "acco_availiablity_status": accoAvailiablityStatus,
        "created_by": createdBy,
      };
}

class Pagination {
  int? currentPage;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  dynamic? nextPageUrl;
  int? perPage;
  dynamic? prevPageUrl;
  int? to;
  int? total;

  Pagination({
    this.currentPage,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["current_page"],
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}
