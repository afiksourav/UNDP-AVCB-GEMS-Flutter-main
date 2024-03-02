// // To parse this JSON data, do
// //
// //     final allDistrictModel = allDistrictModelFromJson(jsonString);

// import 'dart:convert';

// AllDistrictModel allDistrictModelFromJson(String str) => AllDistrictModel.fromJson(json.decode(str));

// String allDistrictModelToJson(AllDistrictModel data) => json.encode(data.toJson());

// class AllDistrictModel {
//   List<DistrictData> data;
//   int status;
//   String message;

//   AllDistrictModel({
//     required this.data,
//     required this.status,
//     required this.message,
//   });

//   factory AllDistrictModel.fromJson(Map<String, dynamic> json) => AllDistrictModel(
//         data: List<DistrictData>.from(json["data"].map((x) => DistrictData.fromJson(x))),
//         status: json["status"],
//         message: json["message"],
//       );

//   Map<String, dynamic> toJson() => {
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//         "status": status,
//         "message": message,
//       };
// }

// class DistrictData {
//   int id;
//   int divisionId;
//   String nameBn;
//   String nameEn;
//   String? bbsCode;
//   String latitude;
//   String longitude;
//   dynamic oldLatitude;
//   dynamic oldLongitude;
//   int ngo;
//   String? url;
//   AtedAt createdAt;
//   AtedAt updatedAt;

//   DistrictData({
//     required this.id,
//     required this.divisionId,
//     required this.nameBn,
//     required this.nameEn,
//     required this.bbsCode,
//     required this.latitude,
//     required this.longitude,
//     required this.oldLatitude,
//     required this.oldLongitude,
//     required this.ngo,
//     required this.url,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory DistrictData.fromJson(Map<String, dynamic> json) => DistrictData(
//         id: json["id"],
//         divisionId: json["division_id"],
//         nameBn: json["name_bn"],
//         nameEn: json["name_en"],
//         bbsCode: json["bbs_code"],
//         latitude: json["latitude"],
//         longitude: json["longitude"],
//         oldLatitude: json["old_latitude"],
//         oldLongitude: json["old_longitude"],
//         ngo: json["ngo"],
//         url: json["url"],
//         createdAt: atedAtValues.map[json["created_at"]]!,
//         updatedAt: atedAtValues.map[json["updated_at"]]!,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "division_id": divisionId,
//         "name_bn": nameBn,
//         "name_en": nameEn,
//         "bbs_code": bbsCode,
//         "latitude": latitude,
//         "longitude": longitude,
//         "old_latitude": oldLatitude,
//         "old_longitude": oldLongitude,
//         "ngo": ngo,
//         "url": url,
//         "created_at": atedAtValues.reverse[createdAt],
//         "updated_at": atedAtValues.reverse[updatedAt],
//       };
// }

// enum AtedAt { THE_0000011130_T00_0000000000_Z }

// final atedAtValues = EnumValues({"-000001-11-30T00:00:00.000000Z": AtedAt.THE_0000011130_T00_0000000000_Z});

// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }

// To parse this JSON data, do
//
//     final allDistrictModel = allDistrictModelFromJson(jsonString);

import 'dart:convert';

AllDistrictModel allDistrictModelFromJson(String str) => AllDistrictModel.fromJson(json.decode(str));

String allDistrictModelToJson(AllDistrictModel data) => json.encode(data.toJson());

class AllDistrictModel {
  List<DistrictData> data;
  int status;
  String message;

  AllDistrictModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory AllDistrictModel.fromJson(Map<String, dynamic> json) => AllDistrictModel(
        data: List<DistrictData>.from(json["data"].map((x) => DistrictData.fromJson(x))),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "message": message,
      };
}

class DistrictData {
  int id;
  int divisionId;
  String nameBn;
  String nameEn;
  dynamic bbsCode;
  String latitude;
  String longitude;
  String? oldLatitude;
  String? oldLongitude;
  int ngo;
  dynamic url;
  AtedAt createdAt;
  dynamic updatedAt;

  DistrictData({
    required this.id,
    required this.divisionId,
    required this.nameBn,
    required this.nameEn,
    required this.bbsCode,
    required this.latitude,
    required this.longitude,
    required this.oldLatitude,
    required this.oldLongitude,
    required this.ngo,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DistrictData.fromJson(Map<String, dynamic> json) => DistrictData(
        id: json["id"],
        divisionId: json["division_id"],
        nameBn: json["name_bn"],
        nameEn: json["name_en"],
        bbsCode: json["bbs_code"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        oldLatitude: json["old_latitude"],
        oldLongitude: json["old_longitude"],
        ngo: json["ngo"],
        url: json["url"],
        createdAt: atedAtValues.map[json["created_at"]]!,
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "division_id": divisionId,
        "name_bn": nameBn,
        "name_en": nameEn,
        "bbs_code": bbsCode,
        "latitude": latitude,
        "longitude": longitude,
        "old_latitude": oldLatitude,
        "old_longitude": oldLongitude,
        "ngo": ngo,
        "url": url,
        "created_at": atedAtValues.reverse[createdAt],
        "updated_at": updatedAt,
      };
}

enum AtedAt { THE_0000011130_T00_0000000000_Z }

final atedAtValues = EnumValues({"-000001-11-30T00:00:00.000000Z": AtedAt.THE_0000011130_T00_0000000000_Z});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
