// To parse this JSON data, do
//
//     final trainingEditModel = trainingEditModelFromJson(jsonString);

import 'dart:convert';

TrainingEditModel trainingEditModelFromJson(String str) => TrainingEditModel.fromJson(json.decode(str));

String trainingEditModelToJson(TrainingEditModel data) => json.encode(data.toJson());

class TrainingEditModel {
  List<Datum> data;
  List<Participant> participant;
  dynamic participantOthers;
  int status;
  String message;

  TrainingEditModel(
      {required this.data,
      required this.participant,
      required this.participantOthers,
      required this.status,
      required this.message});

  factory TrainingEditModel.fromJson(Map<String, dynamic> json) => TrainingEditModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        participant: List<Participant>.from(json["participant"].map((x) => Participant.fromJson(x))),
        participantOthers: json["participant_others"],
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "participant": List<dynamic>.from(participant.map((x) => x.toJson())),
        "participant_others": participantOthers,
      };
}

class Datum {
  dynamic? id;
  int location_id;
  dynamic? trainingInfoSettingId;
  String? title;
  String? trainingFromDate;
  String? trainingToDate;
  String? trainingVenue;
  dynamic? totalMale;
  dynamic? totalFemale;
  dynamic? totalParticipant;
  String? latitude;
  String? longitude;
  String? remark;
  List<District>? divisions;
  List<District>? districts;
  List<District>? upazilas;
  List<Union>? unions;
  dynamic selectedDisId;
  dynamic selectedDivId;
  dynamic selectedUpaId;
  dynamic selectedUniId;

  Datum({
    this.id,
    required this.location_id,
    this.trainingInfoSettingId,
    this.title,
    this.trainingFromDate,
    this.trainingToDate,
    this.trainingVenue,
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        location_id: json["location_id"],
        trainingInfoSettingId: json["training_info_setting_id"],
        title: json["title"],
        trainingFromDate: json["training_from_date"],
        trainingToDate: json["training_to_date"],
        trainingVenue: json["training_venue"],
        totalMale: json["total_male"],
        totalFemale: json["total_female"],
        totalParticipant: json["total_participant"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        remark: json["remark"],
        divisions: List<District>.from(json["divisions"].map((x) => District.fromJson(x))),
        districts: List<District>.from(json["districts"].map((x) => District.fromJson(x))),
        upazilas: List<District>.from(json["upazilas"].map((x) => District.fromJson(x))),
        unions: List<Union>.from(json["unions"].map((x) => Union.fromJson(x))),
        selectedDisId: json["selected_dis_id"],
        selectedDivId: json["selected_div_id"],
        selectedUpaId: json["selected_upa_id"],
        selectedUniId: json["selected_uni_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "training_info_setting_id": trainingInfoSettingId,
        "title": title,
        "training_from_date": trainingFromDate,
        "training_to_date": trainingToDate,
        "training_venue": trainingVenue,
        "total_male": totalMale,
        "total_female": totalFemale,
        "total_participant": totalParticipant,
        "latitude": latitude,
        "longitude": longitude,
        "remark": remark,
        "divisions": List<dynamic>.from(divisions!.map((x) => x.toJson())),
        "districts": List<dynamic>.from(districts!.map((x) => x.toJson())),
        "upazilas": List<dynamic>.from(upazilas!.map((x) => x.toJson())),
        "unions": List<dynamic>.from(unions!.map((x) => x.toJson())),
        "selected_dis_id": selectedDisId,
        "selected_div_id": selectedDivId,
        "selected_upa_id": selectedUpaId,
        "selected_uni_id": selectedUniId,
      };
}

class District {
  int id;
  int? divisionId;
  String nameBn;
  String nameEn;
  dynamic bbsCode;
  String? latitude;
  String? longitude;
  int? ngo;
  dynamic url;
  dynamic createdAt;
  dynamic updatedAt;
  int? districtId;

  District({
    required this.id,
    this.divisionId,
    required this.nameBn,
    required this.nameEn,
    required this.bbsCode,
    required this.latitude,
    required this.longitude,
    this.ngo,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    this.districtId,
  });

  factory District.fromJson(Map<String, dynamic> json) => District(
        id: json["id"],
        divisionId: json["division_id"],
        nameBn: json["name_bn"],
        nameEn: json["name_en"],
        bbsCode: json["bbs_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        ngo: json["ngo"],
        url: json["url"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
        "ngo": ngo,
        "url": url,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "district_id": districtId,
      };
}

enum CreatedAtEnum { THE_0000011130_T00_0000000000_Z }

class Union {
  int? id;
  int? divisionId;
  int? districtId;
  int? upazilaId;
  String? nameBn;
  String nameEn;
  dynamic bbsCode;
  String? latitude;
  String? longitude;
  int? phase;
  int? isVcmisActivated;
  dynamic activatedAt;
  dynamic url;

  Union({
    this.id,
    this.divisionId,
    this.districtId,
    this.upazilaId,
    this.nameBn,
    required this.nameEn,
    this.bbsCode,
    this.latitude,
    this.longitude,
    this.phase,
    this.isVcmisActivated,
    required this.activatedAt,
    required this.url,
  });

  factory Union.fromJson(Map<String, dynamic> json) => Union(
        id: json["id"],
        divisionId: json["division_id"],
        districtId: json["district_id"],
        upazilaId: json["upazila_id"],
        nameBn: json["name_bn"],
        nameEn: json["name_en"],
        bbsCode: json["bbs_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        phase: json["phase"],
        isVcmisActivated: json["is_vcmis_activated"],
        activatedAt: json["activated_at"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "division_id": divisionId,
        "district_id": districtId,
        "upazila_id": upazilaId,
        "name_bn": nameBn,
        "name_en": nameEn,
        "bbs_code": bbsCode,
        "latitude": latitude,
        "longitude": longitude,
        "phase": phase,
        "is_vcmis_activated": isVcmisActivated,
        "activated_at": activatedAt,
        "url": url,
      };
}

class Participant {
  int? id;
  String name;
  List<ParticipantLevel> participantLevels;

  Participant({
    required this.id,
    required this.name,
    required this.participantLevels,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        id: json["id"],
        name: json["name"],
        participantLevels: List<ParticipantLevel>.from(json["participant_levels"].map((x) => ParticipantLevel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "participant_levels": List<dynamic>.from(participantLevels.map((x) => x.toJson())),
      };
}

class ParticipantLevel {
  int id;
  String participantLevelName;
  int male;
  int female;

  ParticipantLevel({
    required this.id,
    required this.participantLevelName,
    required this.male,
    required this.female,
  });

  factory ParticipantLevel.fromJson(Map<String, dynamic> json) => ParticipantLevel(
        id: json["id"],
        participantLevelName: json["participant_level_name"],
        male: json["male"],
        female: json["female"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "participant_level_name": participantLevelName,
        "male": male,
        "female": female,
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
