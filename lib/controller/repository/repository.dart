import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:village_court_gems/controller/api_services/api_client.dart';
import 'package:village_court_gems/controller/global.dart';
import 'package:village_court_gems/models/ActivityDetailsForEditModel.dart';
import 'package:village_court_gems/models/TraningsInfoDetailsModel.dart';
import 'package:village_court_gems/models/aacoInfoEditModel.dart';
import 'package:village_court_gems/models/aacoListModel.dart';
import 'package:village_court_gems/models/activityEditModel.dart';
import 'package:village_court_gems/models/activityListModel.dart';
import 'package:village_court_gems/models/area_model/all_district_model.dart';
import 'package:village_court_gems/models/activityDetailsModel.dart';
import 'package:village_court_gems/models/avtivity._model.dart';
import 'package:village_court_gems/models/countModel.dart';
import 'package:village_court_gems/models/field_visit_model/FieldFindingCreateModel.dart';
import 'package:village_court_gems/models/field_visit_model/fieldVisitUpdateModel.dart';
import 'package:village_court_gems/models/field_visit_model/field_visit_list_details_model.dart';
import 'package:village_court_gems/models/field_visit_model/field_visit_list_model.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:village_court_gems/models/new_TraningModel.dart';
import 'package:village_court_gems/models/profile_model.dart';
import 'package:village_court_gems/models/traning_details_model.dart';
import 'package:village_court_gems/models/traning_model.dart';
import 'package:village_court_gems/models/triningEditModel.dart';

import 'package:village_court_gems/services/database/localDatabaseService.dart';

class Repositores {
  Future<Map> loginAPi(String mobile, String password) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/login?mobile=$mobile&password=$password");
    final headers = {'Content-Type': 'application/json'};
    Map<String, String> body = {
      "mobile": mobile,
      "password": password,
    };
    print(body);
    try {
      final Response response = await http.post(url, headers: headers, body: jsonEncode(body));
      print("status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('loginAPi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  // logout
  Future<Map> LogoutAPi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/logout");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: {});
      print("LogoutAPi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('LogoutAPi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('LogoutAPi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<ProfileModel> GetProfileApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/profile");
    String token = await Helper().getUserToken();
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("GetProfileApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('GetProfileApi repopose');
        print(jsonDecode(response.body));
        return ProfileModel.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return ProfileModel(
      message: '',
      status: 0,
    );
  }

  Future<Map> otp_Verification(String otp) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/otp?otp=$otp");

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_Token',
    };

    Map<String, String> body = {"otp": otp};
    print(body);
    try {
      final Response response = await http.post(url, headers: headers, body: jsonEncode(body));
      print("otp_Verification status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('otp_Verification repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<NewTrainingModel> allTrainigsInfoSettingApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training-info-setting");
    String token = await Helper().getUserToken();
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final Response response = await http.get(url, headers: headers);
      print("trainingInfoSettingApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('trainingInfoSettingApi repopose');
        print(jsonDecode(response.body));
        return NewTrainingModel.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return NewTrainingModel(data: [], status: 2, message: '');
  }


  Future<Map> divisionApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/division");
    //String a = "18|Lh1LWJJflj1FmVi2N6gdr7zNn0J8kl9Wri9CFakX52d1ae52";
    // String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("districtApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('districtApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> districtApi(int id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/division-wise-district/$id");
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("districtApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('districtApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> districtOfflineApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/districts");
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";

    final headers = {
      'Accept': 'application/json',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("districtOfflineApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('districtOfflineApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> upazilaApi(int id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/district-wise-upazila/$id");
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("upazilatApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('upazilatApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> upazilaOflineApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/upazilas");

    final headers = {'Accept': 'application/json'};
    try {
      final Response response = await http.get(url, headers: headers);
      print("upazilaOflineApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('upazilaOflineApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> unionApi(int id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/upazila-wise-union/$id");
    //  String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("unionApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('unionApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> unionOflineApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/unions");
    //  String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";

    final headers = {'Accept': 'application/json'};
    try {
      final Response response = await http.get(url, headers: headers);
      print("unionOflineApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('unionOflineApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> trainingInfoSubmit(dynamic trainingBody) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training");
    String token = await Helper().getUserToken();
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final Response response = await http.post(url, headers: headers, body: trainingBody);
      print("trainingInfoSubmit status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('trainingInfoSubmit repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<TrainingModel> allTrainigsShowApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training-info-setting");
    String token = await Helper().getUserToken();
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final Response response = await http.get(url, headers: headers);
      print("trainingInfoSettingApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('trainingInfoSettingApi repopose');
        print(jsonDecode(response.body));
        return TrainingModel.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return TrainingModel(data: [], status: 2, message: '');
  }

  Future<TrainingDetailsModels> TrainigsDetailsAPi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training");
    String token = await Helper().getUserToken();
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final Response response = await http.get(url, headers: headers);
    print("TrainigsDetailsAPi status Code");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('TrainigsDetailsAPi repopose');
      print(jsonDecode(response.body));
      return TrainingDetailsModels.fromJson(json.decode(response.body));
    } else {
      print('Error: ${response.reasonPhrase}');
    }

    return TrainingDetailsModels(data: [], status: 1, message: "");
  }

  Future<Activity> ActivityApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/activity-info-setting");
    String token = await Helper().getUserToken();
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    //http://127.0.0.1:8000/api/activity
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("ActivityApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ActivityApi repopose');
        print(jsonDecode(response.body));
        return Activity.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return Activity(data: [], status: 1, message: "");
  }

  // Future<ActivityListModel> ActivityDetailsList() async {
  //   final url = Uri.parse("${APIClients.BASE_URL}api/activity");
  //   String token = await Helper().getUserToken();
  //   // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
  //   final headers = {
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };

  //   final Response response = await http.get(url, headers: headers);
  //   print("ActivityDetailsList status Code");
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     print('ActivityDetailsList repopose');
  //     print(jsonDecode(response.body));
  //     return ActivityListModel.fromJson(json.decode(response.body));
  //   } else {
  //     print('Error: ${response.reasonPhrase}');
  //   }

  //   return ActivityListModel(data: [], status: 0, message: "");
  // }

  Future<ActivityDetailsModel> ActivityDetailsApi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/activity-info-setting-generate/$id");
    String token = await Helper().getUserToken();
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("ActivityDetailsApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ActivityDetailsApi repopose');
        print(jsonDecode(response.body));
        return ActivityDetailsModel.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return ActivityDetailsModel(activityDetailsModel: [], status: 1, message: "");
  }

  Future<ActivityDetailsForEditModel> ActivityDetailsForEditApi(String id, String currentPage) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/activity-info-wise-activity/$id?page=$currentPage");
    String token = await Helper().getUserToken();
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("ActivityDetailsForEditApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ActivityDetailsForEditApi repopose');
        print(jsonDecode(response.body));
        return ActivityDetailsForEditModel.fromJson(json.decode(response.body));
      } else {
        print('ActivityDetailsForEditApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return ActivityDetailsForEditModel(status: 0, message: '', data: []);
  }

  Future<Map> ActivityDataSubmitApi(dynamic activityBody) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/activity");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: activityBody);
      print("ActivityDataSubmitApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ActivityDataSubmitApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<ActivityEditModel> ActivityDataEditApi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/activity-edit/$id");
    String token = await Helper().getUserToken();
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final Response response = await http.get(url, headers: headers);
    print("ActivityDataEditApi status Code");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('ActivityDataEditApi repopose');
      print(jsonDecode(response.body));
      return ActivityEditModel.fromJson(json.decode(response.body));
    } else {
      print('ActivityDataEditApi Error: ${response.reasonPhrase}');
    }

    return ActivityEditModel(status: 0, message: '', activityEditData: []);
  }

  Future<Map> ActivityDataEditSubmitApi(dynamic activityEditData, String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/activity-update/$id");
    // String token = await Helper().getUserToken();
    //   String token = '18|Lh1LWJJflj1FmVi2N6gdr7zNn0J8kl9Wri9CFakX52d1ae52';
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: activityEditData);
      print("ActivityDataEditSubmitApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ActivityDataEditSubmitApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('ActivityDataEditSubmitApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<LocationModel> LocationApi(dynamic locationBody) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/location");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: locationBody);
      print("LocationApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('LocationApi repopose');
        print(jsonDecode(response.body));
        return LocationModel.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return LocationModel(unions: [], upazilas: [], districts: [], divisions: [], status: 0);
  }

  Future<Map> uploadDataAndImage(File imageFile, String division_id, String district_id, String upazila_id, String union_id,
      String latitude, String longitude, String visit_date, String visit_purpose, String office_type) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/store-field-visit");
    String token = await Helper().getUserToken();

    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Add the image file to the request
    request.files.add(await http.MultipartFile.fromPath('photos', imageFile.path));
    print("kkkkkkkkkkk");
    print(token);

    // Add the JSON data as fields in the request
    request.fields['division_id'] = division_id.toString();
    request.fields['district_id'] = district_id.toString();
    request.fields['upazila_id'] = upazila_id.toString();
    request.fields['union_id'] = union_id.toString();
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    request.fields['location_name'] = 'dhaka raw';
    request.fields['visit_date'] = visit_date;
    request.fields['visit_purpose'] = visit_purpose;
    request.fields['office_type'] = office_type;
    request.fields['status'] = '';

    // Set headers
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    try {
      var response = await request.send();
      print('Response Headers: ${response.headers}');
      print('Response Status Code: ${response.statusCode}');

      // Read the response
      http.Response responseStream = await http.Response.fromStream(response);
      print("arrrrrrrr${jsonDecode(responseStream.body)}");
      // Parse the response body
      Map<String, dynamic> responseBody = jsonDecode(responseStream.body);

      // Handle the response
      if (response.statusCode == 200) {
        print('photo and all data upload successfully');
        return responseBody;
      } else {
        print('Upload failed with status: ${response.statusCode}');
        return responseBody;
      }
    } catch (error) {
      print('Error uploading: $error');
      return {};
    }
  }

  Future<Map> ChangeLocationSubmitApi(dynamic changeLocationData) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/store-change-location");
    // String token = await Helper().getUserToken();
    //   String token = '18|Lh1LWJJflj1FmVi2N6gdr7zNn0J8kl9Wri9CFakX52d1ae52';
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: changeLocationData);
      print("ChangeLocationSubmitApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ChangeLocationSubmitApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<TrainingEditModel> TrainigsEditAPi(var id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training/$id");
    String token = await Helper().getUserToken();
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final Response response = await http.get(url, headers: headers);
    print("TrainigsEditAPi status Code");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('TrainigsEditAPi repopose');
      print(jsonDecode(response.body));
      return TrainingEditModel.fromJson(json.decode(response.body));
    } else {
      print('Error: ${response.reasonPhrase}');
    }

    return TrainingEditModel(data: [], participant: [], participantOthers: null, status: 0, message: '');
  }

  Future<Map> TrainigsEditSubmitAPi(dynamic trainingBody, String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: trainingBody);
      print("TrainigsEditSubmitAPi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('TrainigsEditSubmitAPi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('TrainigsEditSubmitAPi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<AacoListModel> AacooListApi(int currentPage) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations?page=$currentPage");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final Response response = await http.get(url, headers: headers);
    print("AacooListApi status Code");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('AacooListApi repopose');
      print(jsonDecode(response.body));
      return AacoListModel.fromJson(json.decode(response.body));
    } else {
      print('Error: ${response.reasonPhrase}');
    }

    return AacoListModel(
      status: 0,
      message: '',
      data: [],
      search: null,
    );
  }

  Future<AllDistrictModel> allDistrictApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/districts");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("allDistrictApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('allDistrictApi repopose');
        print(jsonDecode(response.body));
        return AllDistrictModel.fromJson(json.decode(response.body));
      } else {
        print('allDistrictApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return AllDistrictModel(data: [], status: 0, message: '');
  }

  Future<Map> AACOInfoSubmitAPi(dynamic aacoInfoBody) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: aacoInfoBody);
      print("AACOInfoSubmitAPi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('AACOInfoSubmitAPi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('AACOInfoSubmitAPi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<AacoInfoEditModel> AACOInfoEditApi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("AACOInfoEditApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('AACOInfoEditApi repopose');
        print(jsonDecode(response.body));
        return AacoInfoEditModel.fromJson(json.decode(response.body));
      } else {
        print('AACOInfoEditApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return AacoInfoEditModel(status: 0, message: '');
  }

  Future<Map> AACOInfoEditDataSubmitAPi(dynamic EditDataaacoInfoBody, String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: EditDataaacoInfoBody);
      print("AACOInfoEditDataSubmitAPi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('AACOInfoEditDataSubmitAPi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('AACOInfoEditDataSubmitAPi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> AACOInfoDeleteAPi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.delete(
        url,
        headers: headers,
      );
      print("AACOInfoDeleteAPi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('AACOInfoDeleteAPi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('AACOInfoDeleteAPi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<TrainingInfoDetailsModel> TrainingsInfoDetailsApi(int currentPage, String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training-info-wise-training-list/$id?page=$currentPage");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("TrainingsInfoDetailsApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('TrainingsInfoDetailsApi repopose');
        print(jsonDecode(response.body));
        return TrainingInfoDetailsModel.fromJson(json.decode(response.body));
      } else {
        print('TrainingsInfoDetailsApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return TrainingInfoDetailsModel(status: 0, message: '', data: []);
  }

  //field visit api
  Future<FieldVisitListModel> FiedVisitListApi(String current_page) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-visit-lists?page=$current_page");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("FiedVisitListApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('FiedVisitListApi repopose');
        // log(jsonDecode(response.body).toString());
        print(jsonDecode(response.body));
        return FieldVisitListModel.fromJson(json.decode(response.body));
      } else {
        print('FiedVisitListApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return FieldVisitListModel(
      status: 0,
      message: '',
      data: [],
    );
  }

  Future<FieldVisitListDetailsModel> FiedVisitListDetailsApi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-visit-list/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("FiedVisitListDetailsApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('FiedVisitListDetailsApi repopose');
        // log(jsonDecode(response.body).toString());
        print(jsonDecode(response.body));
        return FieldVisitListDetailsModel.fromJson(json.decode(response.body));
      } else {
        print('FiedVisitListDetailsApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return FieldVisitListDetailsModel(status: 0, message: '', visit: [], fieldFindings: []);
  }

  Future<FieldFindingCreateModel> FiedFindingCreatesApi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-finding-create/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("FiedFindingCreatesApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('FiedFindingCreatesApi repopose');
        log(jsonDecode(response.body).toString());
        // print(jsonDecode(response.body));
        return FieldFindingCreateModel.fromJson(json.decode(response.body));
      } else {
        print('FiedFindingCreatesApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return FieldFindingCreateModel(status: 0, message: '', data: []);
  }

  Future<Map> FiedFindingSubmitApi(dynamic storeBody) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-finding-store");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: jsonEncode(storeBody));
      print("FiedFindingSubmitApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('FiedFindingSubmitApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('FiedFindingSubmitApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<CountModel> countAPi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/count");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(
        url,
        headers: headers,
      );
      print("coutAPi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('coutAPi repopose');
        print(jsonDecode(response.body));
        return CountModel.fromJson(json.decode(response.body));
      } else {
        print('coutAPi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return CountModel(status: 0, message: '', activityInfoCount: 0, trainingInfoCount: 0, fieldVisitCount: 0, accoInfoCount: 0);
  }

  Future<FieldVisitUpdateModel> FiedFindingUpdateApi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-finding-edit/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("FiedFindingUpdateApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('FiedFindingUpdateApi repopose');
        // log(jsonDecode(response.body).toString());
        print(jsonDecode(response.body));
        return FieldVisitUpdateModel.fromJson(json.decode(response.body));
      } else {
        print('FiedFindingUpdateApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return FieldVisitUpdateModel(status: 0, message: '', question: [], data: '');
  }

  Future<Map> FiedFindingUpdateSubmitApi(dynamic storeBody, String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-finding-update/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: jsonEncode(storeBody));
      print("FiedFindingUpdateSubmitApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('FiedFindingUpdateSubmitApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('FiedFindingUpdateSubmitApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }
}
