// To parse this JSON data, do
//
//     final fieldVisitListModel = fieldVisitListModelFromJson(jsonString);

import 'dart:convert';

FieldVisitListModel fieldVisitListModelFromJson(String str) => FieldVisitListModel.fromJson(json.decode(str));

String fieldVisitListModelToJson(FieldVisitListModel data) => json.encode(data.toJson());

class FieldVisitListModel {
  int status;
  String message;
  List<FieldVisitData> data;
  Pagination? pagination;

  FieldVisitListModel({
    required this.status,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory FieldVisitListModel.fromJson(Map<String, dynamic> json) => FieldVisitListModel(
        status: json["status"],
        message: json["message"],
        data: List<FieldVisitData>.from(json["data"].map((x) => FieldVisitData.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pagination": pagination!.toJson(),
      };
}

class FieldVisitData {
  int id;
  String division;
  String district;
  String upazila;
  String union;
  String latitude;
  String longitude;
  String createdAt;
  DateTime visitDate;

  FieldVisitData({
    required this.id,
    required this.division,
    required this.district,
    required this.upazila,
    required this.union,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.visitDate,
  });

  factory FieldVisitData.fromJson(Map<String, dynamic> json) => FieldVisitData(
        id: json["id"],
        division: json["division"],
        district: json["district"],
        upazila: json["upazila"],
        union: json["union"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: json["created_at"],
        visitDate: DateTime.parse(json["visit_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "division": division,
        "district": district,
        "upazila": upazila,
        "union": union,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt,
        "visit_date":
            "${visitDate.year.toString().padLeft(4, '0')}-${visitDate.month.toString().padLeft(2, '0')}-${visitDate.day.toString().padLeft(2, '0')}",
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
