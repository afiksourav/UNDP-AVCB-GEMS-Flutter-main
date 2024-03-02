// To parse this JSON data, do
//
//     final trainingDetailsModels = trainingDetailsModelsFromJson(jsonString);

import 'dart:convert';

TrainingDetailsModels trainingDetailsModelsFromJson(String str) => TrainingDetailsModels.fromJson(json.decode(str));

String trainingDetailsModelsToJson(TrainingDetailsModels data) => json.encode(data.toJson());

class TrainingDetailsModels {
  List<Datum> data;
  int status;
  String message;

  TrainingDetailsModels({
    required this.data,
    required this.status,
    required this.message,
  });

  factory TrainingDetailsModels.fromJson(Map<String, dynamic> json) => TrainingDetailsModels(
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
  LocationLevel locationLevel;
  String trainingVenue;
  String trainingToDate;
  String trainingFromDate;
  int totalMale;
  int totalFemale;
  int totalParticipant;
  dynamic latitude;
  String? longitude;
  String? remark;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        locationLevel: locationLevelValues.map[json["location_level"]]!,
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
        "location_level": locationLevelValues.reverse[locationLevel],
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

enum LocationLevel { DISTRICT, UNION, UPAZILA }

final locationLevelValues =
    EnumValues({"District": LocationLevel.DISTRICT, "Union": LocationLevel.UNION, "Upazila": LocationLevel.UPAZILA});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
