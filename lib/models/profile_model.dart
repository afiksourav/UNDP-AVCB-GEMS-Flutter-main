// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    Data ? data;
    String message;
    int status;

    ProfileModel({
         this.data,
        required this.message,
        required this.status,
    });

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "message": message,
        "status": status,
    };
}

class Data {
    int id;
    String name;
    String mobile;
    String email;
    String userName;

    Data({
        required this.id,
        required this.name,
        required this.mobile,
        required this.email,
        required this.userName,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        userName: json["user_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "email": email,
        "user_name": userName,
    };
}
