// To parse this JSON data, do
//
//     final fieldVisitListDetailsModel = fieldVisitListDetailsModelFromJson(jsonString);

import 'dart:convert';

FieldVisitListDetailsModel fieldVisitListDetailsModelFromJson(String str) =>
    FieldVisitListDetailsModel.fromJson(json.decode(str));

String fieldVisitListDetailsModelToJson(FieldVisitListDetailsModel data) => json.encode(data.toJson());

class FieldVisitListDetailsModel {
  int status;
  String message;
  List<Visit> visit;
  List<FieldFinding> fieldFindings;

  FieldVisitListDetailsModel({
    required this.status,
    required this.message,
    required this.visit,
    required this.fieldFindings,
  });

  factory FieldVisitListDetailsModel.fromJson(Map<String, dynamic> json) => FieldVisitListDetailsModel(
        status: json["status"],
        message: json["message"],
        visit: List<Visit>.from(json["visit"].map((x) => Visit.fromJson(x))),
        fieldFindings: List<FieldFinding>.from(json["field_findings"].map((x) => FieldFinding.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "visit": List<dynamic>.from(visit.map((x) => x.toJson())),
        "field_findings": List<dynamic>.from(fieldFindings.map((x) => x.toJson())),
      };
}

class FieldFinding {
  String question;
  int questionId;
  List<QuestionAnswer> questionAnswer;

  FieldFinding({
    required this.question,
    required this.questionId,
    required this.questionAnswer,
  });

  factory FieldFinding.fromJson(Map<String, dynamic> json) => FieldFinding(
        question: json["question"],
        questionId: json["question_id"],
        questionAnswer: List<QuestionAnswer>.from(json["question_answer"].map((x) => QuestionAnswer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "question_id": questionId,
        "question_answer": List<dynamic>.from(questionAnswer.map((x) => x.toJson())),
      };
}

class QuestionAnswer {
  String answer;

  QuestionAnswer({
    required this.answer,
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) => QuestionAnswer(
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "answer": answer,
      };
}

class Visit {
  int id;
  String visitor;
  String division;
  String district;
  String upazila;
  String union;
  String latitude;
  String longitude;
  String locationName;
  DateTime visitDate;
  String visitPurpose;
  String photo;

  Visit({
    required this.id,
    required this.visitor,
    required this.division,
    required this.district,
    required this.upazila,
    required this.union,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.visitDate,
    required this.visitPurpose,
    required this.photo,
  });

  factory Visit.fromJson(Map<String, dynamic> json) => Visit(
        id: json["id"],
        visitor: json["visitor"],
        division: json["division"],
        district: json["district"],
        upazila: json["upazila"],
        union: json["union"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        locationName: json["location_name"],
        visitDate: DateTime.parse(json["visit_date"]),
        visitPurpose: json["visit_purpose"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "visitor": visitor,
        "division": division,
        "district": district,
        "upazila": upazila,
        "union": union,
        "latitude": latitude,
        "longitude": longitude,
        "location_name": locationName,
        "visit_date":
            "${visitDate.year.toString().padLeft(4, '0')}-${visitDate.month.toString().padLeft(2, '0')}-${visitDate.day.toString().padLeft(2, '0')}",
        "visit_purpose": visitPurpose,
        "photo": photo,
      };
}
