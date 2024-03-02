import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  userToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('token');
    ;
    return stringValue;
  }

  Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

//Division
  Future<void> DivisionDataInsert(List DivisionData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String locationDataJson = jsonEncode(DivisionData);
    prefs.setString('DivisionlocationData', locationDataJson);
  }

  Future<List> getDivisionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locationDataJson = prefs.getString('DivisionlocationData');

    if (locationDataJson == null || locationDataJson.isEmpty) {
      // If the stored data is empty or null, return an empty list
      return [];
    }

    List storedLocationData = jsonDecode(locationDataJson);
    return storedLocationData;
  }

  Future<List> updateDivisionData(List<Map<String, dynamic>> updates) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List storedLocationData = await getDivisionData();

    // Apply updates to the stored data
    for (var update in updates) {
      int idToUpdate = update['id'];
      int indexToUpdate = storedLocationData.indexWhere((item) => item['id'] == idToUpdate);

      if (indexToUpdate != -1) {
        // Replace the item with the updated data
        storedLocationData[indexToUpdate] = update;
      }
    }

    // Save the modified list back to SharedPreferences
    prefs.setString('DivisionlocationData', jsonEncode(storedLocationData));

    // Return the updated list
    return storedLocationData;
  }

  // Future<void> updateDivisionData(int idToUpdate, Map<String, dynamic> newData) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   List storedLocationData = await getDivisionData();

  //   // Find the item with the specified id for update
  //   int indexToUpdate = storedLocationData.indexWhere((item) => item['id'] == idToUpdate);

  //   if (indexToUpdate != -1) {
  //     // Replace the item with the updated data
  //     storedLocationData[indexToUpdate] = newData;

  //     // Save the modified list back to SharedPreferences
  //     prefs.setString('DivisionlocationData', jsonEncode(storedLocationData));
  //   }
  // }

  //district
  Future<void> DistrictDataInsert(List DistrictData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String locationDataJson = jsonEncode(DistrictData);
    prefs.setString('DistrictlocationData', locationDataJson);
  }

  Future<List> getDistrictData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locationDataJson = prefs.getString('DistrictlocationData');
    if (locationDataJson == null || locationDataJson.isEmpty) {
      // If the stored data is empty or null, return an empty list
      return [];
    }
    List storedLocationData = jsonDecode(locationDataJson);
    return storedLocationData;
  }

  //upazila
  Future<void> UpazilaDataInsert(List UpazilaData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String locationDataJson = jsonEncode(UpazilaData);
    prefs.setString('UpazilalocationData', locationDataJson);
  }

  Future<List> getUpazilaData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locationDataJson = prefs.getString('UpazilalocationData');
    if (locationDataJson == null || locationDataJson.isEmpty) {
      // If the stored data is empty or null, return an empty list
      return [];
    }
    List storedLocationData = jsonDecode(locationDataJson);
    return storedLocationData;
  }

  //union
  Future<void> UnionDataInsert(List UnionData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String locationDataJson = jsonEncode(UnionData);
    prefs.setString('UnionLocationData', locationDataJson);
  }

  Future<List> getUnionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? locationDataJson = prefs.getString('UnionLocationData');
    if (locationDataJson == null || locationDataJson.isEmpty) {
      // If the stored data is empty or null, return an empty list
      return [];
    }
    List storedLocationData = jsonDecode(locationDataJson);
    return storedLocationData;
  }
}
