// To parse this JSON data, do
//
//     final activityDetailsForEditModel = activityDetailsForEditModelFromJson(jsonString);

import 'dart:convert';

ActivityDetailsForEditModel activityDetailsForEditModelFromJson(String str) => ActivityDetailsForEditModel.fromJson(json.decode(str));

String activityDetailsForEditModelToJson(ActivityDetailsForEditModel data) => json.encode(data.toJson());

class ActivityDetailsForEditModel {
    int status;
    String message;
    List<ActivityDetailsData> data;
    Pagination ? pagination;

    ActivityDetailsForEditModel({
        required this.status,
        required this.message,
        required this.data,
         this.pagination,
    });

    factory ActivityDetailsForEditModel.fromJson(Map<String, dynamic> json) => ActivityDetailsForEditModel(
        status: json["status"],
        message: json["message"],
        data: List<ActivityDetailsData>.from(json["data"].map((x) => ActivityDetailsData.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pagination": pagination!.toJson(),
    };
}

class ActivityDetailsData {
    int id;
    String locationLevel;
    String fromDate;
    String toDate;
    String venue;
    int totalMale;
    int totalFemale;
    int totalParticipant;
    dynamic latitude;
    dynamic longitude;
    String remark;
    String createdBy;

    ActivityDetailsData({
        required this.id,
        required this.locationLevel,
        required this.fromDate,
        required this.toDate,
        required this.venue,
        required this.totalMale,
        required this.totalFemale,
        required this.totalParticipant,
        required this.latitude,
        required this.longitude,
        required this.remark,
        required this.createdBy,
    });

    factory ActivityDetailsData.fromJson(Map<String, dynamic> json) => ActivityDetailsData(
        id: json["id"],
        locationLevel: json["location_level"],
        fromDate: json["from_date"],
        toDate: json["to_date"],
        venue: json["venue"],
        totalMale: json["total_male"],
        totalFemale: json["total_female"],
        totalParticipant: json["total_participant"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        remark: json["remark"],
        createdBy: json["created_by"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "location_level": locationLevel,
        "from_date": fromDate,
        "to_date": toDate,
        "venue": venue,
        "total_male": totalMale,
        "total_female": totalFemale,
        "total_participant": totalParticipant,
        "latitude": latitude,
        "longitude": longitude,
        "remark": remark,
        "created_by": createdBy,
    };
}

class Pagination {
    int currentPage;
    String firstPageUrl;
    int from;
    int lastPage;
    String lastPageUrl;
    dynamic nextPageUrl;
    int perPage;
    dynamic prevPageUrl;
    int to;
    int total;

    Pagination({
        required this.currentPage,
        required this.firstPageUrl,
        required this.from,
        required this.lastPage,
        required this.lastPageUrl,
        required this.nextPageUrl,
        required this.perPage,
        required this.prevPageUrl,
        required this.to,
        required this.total,
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
