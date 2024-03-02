import 'dart:convert';

NewTrainingModel newTrainingModelFromJson(String str) => NewTrainingModel.fromJson(json.decode(str));

String newTrainingModelToJson(NewTrainingModel data) => json.encode(data.toJson());

class NewTrainingModel {
  List<AllTrainingData> data;
  int status;
  String message;

  NewTrainingModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory NewTrainingModel.fromJson(Map<String, dynamic> json) => NewTrainingModel(
        data: List<AllTrainingData>.from(json["data"].map((x) => AllTrainingData.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class AllTrainingData {
  int id;
  String title;
  int count;
  Component component;
  Component locationLevel;
  Map<String, String> divisions;
  List<TrainingInfoParticipants> trainingInfoParticipantsActivation;
  List<TrainingInfoParticipants> trainingInfoParticipantsMaintenance;
  List<Component> minoritiesActivation;
  List<Component> minoritiesMaintenance;

  AllTrainingData({
    required this.id,
    required this.title,
    required this.count,
    required this.component,
    required this.locationLevel,
    required this.divisions,
    required this.trainingInfoParticipantsActivation,
    required this.trainingInfoParticipantsMaintenance,
    required this.minoritiesActivation,
    required this.minoritiesMaintenance,
  });

  factory AllTrainingData.fromJson(Map<String, dynamic> json) => AllTrainingData(
        id: json["id"],
        title: json["title"],
        count: json["count"],
        component: Component.fromJson(json["component"]),
        locationLevel: Component.fromJson(json["location_level"]),
        divisions: Map.from(json["divisions"]).map((k, v) => MapEntry<String, String>(k, v)),
        trainingInfoParticipantsActivation: List<TrainingInfoParticipants>.from(
            json["training_info_participants_activation"].map((x) => TrainingInfoParticipants.fromJson(x))),
        trainingInfoParticipantsMaintenance: List<TrainingInfoParticipants>.from(
            json["training_info_participants_maintenance"].map((x) => TrainingInfoParticipants.fromJson(x))),
        minoritiesActivation: List<Component>.from(json["minorities_activation"].map((x) => Component.fromJson(x))),
        minoritiesMaintenance: List<Component>.from(json["minorities_maintenance"].map((x) => Component.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "count": count,
        "component": component.toJson(),
        "location_level": locationLevel.toJson(),
        "divisions": Map.from(divisions).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "training_info_participants_activation": List<dynamic>.from(trainingInfoParticipantsActivation.map((x) => x.toJson())),
        "training_info_participants_maintenance": List<dynamic>.from(trainingInfoParticipantsMaintenance.map((x) => x.toJson())),
        "minorities_activation": List<dynamic>.from(minoritiesActivation.map((x) => x.toJson())),
        "minorities_maintenance": List<dynamic>.from(minoritiesMaintenance.map((x) => x.toJson())),
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
        "name": nameValues.reverse[name],
      };
}

enum Name { CAP_DEV, DISADVANTAGE_GROUPS, DISTRICT, ETHNIC_MINORITIES, M_E, UPAZILA }

final nameValues = EnumValues({
  "CapDev": Name.CAP_DEV,
  "Disadvantage Groups": Name.DISADVANTAGE_GROUPS,
  "District": Name.DISTRICT,
  "Ethnic Minorities": Name.ETHNIC_MINORITIES,
  "M&E": Name.M_E,
  "Upazila": Name.UPAZILA
});

class TrainingInfoParticipants {
  int id;
  int? serialId;
  String name;
  String check;

  TrainingInfoParticipants({
    required this.id,
    required this.serialId,
    required this.name,
    required this.check,
  });

  factory TrainingInfoParticipants.fromJson(Map<String, dynamic> json) =>
      TrainingInfoParticipants(id: json["id"], serialId: json["serial_id"], name: json["name"], check: json["check"]);

  Map<String, dynamic> toJson() => {"id": id, "serial_id": serialId, "name": name, "check": check};
}

enum Check { MAIN, OTHER }

final checkValues = EnumValues({"main": Check.MAIN, "other": Check.OTHER});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
