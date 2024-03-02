// To parse this JSON data, do
//
//     final trainingModel = trainingModelFromJson(jsonString);

import 'dart:convert';

TrainingModel trainingModelFromJson(String str) => TrainingModel.fromJson(json.decode(str));

String trainingModelToJson(TrainingModel data) => json.encode(data.toJson());

class TrainingModel {
  List<Datum> data;
  int status;
  String message;

  TrainingModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) => TrainingModel(
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
  String title;
  int count;
  Component component;
  Component locationLevel;
  Map<String, String> divisions;
  List<TrainingInfoParticipant> trainingInfoParticipants;

  Datum({
    required this.id,
    required this.title,
    required this.count,
    required this.component,
    required this.locationLevel,
    required this.divisions,
    required this.trainingInfoParticipants,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        count: json["count"],
        component: Component.fromJson(json["component"]),
        locationLevel: Component.fromJson(json["location_level"]),
        divisions: Map.from(json["divisions"]).map((k, v) => MapEntry<String, String>(k, v)),
        trainingInfoParticipants: List<TrainingInfoParticipant>.from(
            json["training_info_participants"].map((x) => TrainingInfoParticipant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "count": count,
        "component": component.toJson(),
        "location_level": locationLevel.toJson(),
        "divisions": Map.from(divisions).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "training_info_participants": List<dynamic>.from(trainingInfoParticipants.map((x) => x.toJson())),
      };
}

class Component {
  int id;
  String name;

  Component({
    required this.id,
    required this.name,
  });

  factory Component.fromJson(Map<String, dynamic> json) => Component(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class TrainingInfoParticipant {
  int? id;
  String name;
  List<Component> participantLevels;

  TrainingInfoParticipant({
    required this.id,
    required this.name,
    required this.participantLevels,
  });

  factory TrainingInfoParticipant.fromJson(Map<String, dynamic> json) => TrainingInfoParticipant(
        id: json["id"],
        name: json["name"],
        participantLevels: List<Component>.from(json["participant_levels"].map((x) => Component.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "participant_levels": List<dynamic>.from(participantLevels.map((x) => x.toJson())),
      };
}
