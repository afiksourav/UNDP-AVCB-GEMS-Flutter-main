

import 'dart:convert';

TrainingInfoDetailsModel trainingInfoDetailsModelFromJson(String str) => TrainingInfoDetailsModel.fromJson(json.decode(str));

String trainingInfoDetailsModelToJson(TrainingInfoDetailsModel data) => json.encode(data.toJson());

class TrainingInfoDetailsModel {
    int status;
    String message;
    List<TrainingDetailsData> data;
    Pagination? pagination;

    TrainingInfoDetailsModel({
        required this.status,
        required this.message,
        required this.data,
         this.pagination,
    });

    factory TrainingInfoDetailsModel.fromJson(Map<String, dynamic> json) => TrainingInfoDetailsModel(
        status: json["status"],
        message: json["message"],
        data: List<TrainingDetailsData>.from(json["data"].map((x) => TrainingDetailsData.fromJson(x))),
        pagination: Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pagination": pagination!.toJson(),
    };
}

class TrainingDetailsData {
    int id;
    String locationLevel;
    String trainingVenue;
    String trainingToDate;
    String trainingFromDate;
    int totalMale;
    int totalFemale;
    int totalParticipant;
    dynamic latitude;
    String? longitude;
    String? remark;

    TrainingDetailsData({
        required this.id,
        required this.locationLevel,
        required this.trainingVenue,
        required this.trainingToDate,
        required this.trainingFromDate,
        required this.totalMale,
        required this.totalFemale,
        required this.totalParticipant,
        required this.latitude,
        required this.longitude,
        required this.remark,
    });

    factory TrainingDetailsData.fromJson(Map<String, dynamic> json) => TrainingDetailsData(
        id: json["id"],
        locationLevel: json["location_level"],
        trainingVenue: json["training_venue"],
        trainingToDate: json["training_to_date"],
        trainingFromDate: json["training_from_date"],
        totalMale: json["total_male"],
        totalFemale: json["total_female"],
        totalParticipant: json["total_participant"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        remark: json["remark"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "location_level": locationLevel,
        "training_venue": trainingVenue,
        "training_to_date": trainingToDate,
        "training_from_date": trainingFromDate,
        "total_male": totalMale,
        "total_female": totalFemale,
        "total_participant": totalParticipant,
        "latitude": latitude,
        "longitude": longitude,
        "remark": remark,
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
