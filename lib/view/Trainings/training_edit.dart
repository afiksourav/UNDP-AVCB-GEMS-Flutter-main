import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/training_data_edit_bloc/training_data_edit_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:village_court_gems/models/triningEditModel.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/view/home/homepage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class TrainingEdit extends StatefulWidget {
  final int id;
  const TrainingEdit({super.key, required this.id});

  @override
  State<TrainingEdit> createState() => _TrainingEditState();
}

class _TrainingEditState extends State<TrainingEdit> {
  DateTime? fromSelectedDate;
  DateTime? toSelectedDate;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController trainingVenueController = TextEditingController();

  //List<TextEditingController> controllerTry =  List();
  Future<void> _fromSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromSelectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        fromSelectedDate = picked;
        // Format the date as "dd/MM/yyyy"
        fromDateController.text = DateFormat('dd/MM/yyyy').format(fromSelectedDate!);
      });
    }
  }

  Future<void> _toSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toSelectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        toSelectedDate = picked;
        // Format the date as "dd/MM/yyyy"

        toDateController.text = DateFormat('dd/MM/yyyy').format(toSelectedDate!);
      });
    }
  }

  Map? selectedValue;

  District? oldDivison;
  District? oldDistrict;
  District? oldupazila;
  dynamic? oldunion;
  String? selectedDivision;
  List oldVenue = [];
  List venue = [];
  String? selectedDistrict;
  String? selectedUpazila;
  String? selectedUion;
  var global = 0;
  var globalIndex = 0;
  List<String> maleInputValues = [];
  List<String> femaleInputValues = [];
  List<List<int>> maleValuesList = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> inputData = [];

//api data submit info
  String training_info_setting_id = '';
  String location_id = '';
  String division = '';
  String district = '';
  String upazila = '';
  String union = '';
  String training_from_date = '';
  String training_to_date = '';
  List participant_level_id = [];
  String participant_other_id = '';
  String other_male = '';

  String other_female = '';
  int total_male = 0;
  int total_female = 0;
  int total_participant = 0;
  int trylenth = 0;
  bool changeDivion = false;
  bool changeUpazila = false;
  bool chnageUnion = false;

  int globalvalue = 0;
  int g_updateDataValue = 0;
  //google lat long
  late GoogleMapController mapController;
  LocationData? currentLocation;
  Location location = Location();
  Completer<GoogleMapController> mapControllerCompleter = Completer();

  void initLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return; // Location service is still not enabled, handle accordingly
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return; // Permission not granted, handle accordingly
      }
    }

    try {
      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = userLocation;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  final TrainingDataEditBloc trainingDataEditBloc = TrainingDataEditBloc();
  @override
  void initState() {
    trainingDataEditBloc.add(TrainingDataEditInitialEvent(id: widget.id));
    initLocation();
    mapControllerCompleter.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentLocation?.latitude ?? 0.0,
              currentLocation?.longitude ?? 0.0,
            ),
            zoom: 14.0,
          ),
        ),
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<List<List<TextEditingController>>> maleControllers = [];
  List<List<List<TextEditingController>>> femaleControllers = [];
  List<List<TextEditingController>> maleVenueControllers = [];
  List<List<TextEditingController>> femaleVenueControllers = [];
  List<List<TextEditingController>> maleOldconroller = [];
  List<List<TextEditingController>> femaleOldconroller = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(
          "Training Data Edit",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
            child: Column(
              children: [
                BlocConsumer<TrainingDataEditBloc, TrainingDataEditState>(
                  bloc: trainingDataEditBloc,
                  listenWhen: (previous, current) => current is TrainingDataEditActionState,
                  buildWhen: (previous, current) => current is! TrainingDataEditActionState,
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is TrainingDataEditLoadingState) {
                      return Container(
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is TrainingDataEditSuccessState) {
                      print("displayyyyyyyyyyy");

                      List<DropdownMenuItem<String>> dropdownItems = [];
                      Set<String> uniqueValues = {};
                      for (var item in venue) {
                        for (var entry in item['divisions'].entries) {
                          String value = entry.key;
                          if (!uniqueValues.contains(value)) {
                            dropdownItems.add(DropdownMenuItem<String>(
                              value: value,
                              child: Text(entry.value),
                            ));
                            uniqueValues.add(value);
                          }
                        }
                      }
                      g_updateDataValue++;
                      if (g_updateDataValue == 1) {
                        if (state.data.isNotEmpty && state.trainingEditdata.isNotEmpty && state.trainingEditdata[0].title != '') {
                          state.data.forEach((element) {
                            state.trainingEditdata.forEach((e) {
                              var titleElement = element['title'].toString();
                              var titleE = e.title.toString();

                              if (titleElement != null && titleE != null && titleElement == titleE) {
                                //old venue load
                                oldVenue.add(e);
                                if (state.data.isNotEmpty && state.trainingEditdata[0].title != '') {
                                  Map brand =
                                      state.data.singleWhere((element) => element['title'] == state.trainingEditdata[0].title);
                                  selectedValue = brand;
                                  print("afikkkkkkkkkkk  $selectedValue");
                                }
                                //old Divison
                                if (state.data.isNotEmpty && state.trainingEditdata[0].divisions!.isNotEmpty) {
                                  var oldDiv = state.trainingEditdata[0].divisions!
                                      .singleWhere((element) => element.id == state.trainingEditdata[0].selectedDivId);
                                  oldDivison = oldDiv;
                                }
                                //old District
                                if (state.data.isNotEmpty && state.trainingEditdata[0].districts!.isNotEmpty) {
                                  var oldDis = state.trainingEditdata[0].districts!
                                      .singleWhere((element) => element.id == state.trainingEditdata[0].selectedDisId);
                                  oldDistrict = oldDis;
                                }
                                //old upazila
                                if (state.data.isNotEmpty && state.trainingEditdata[0].upazilas!.isNotEmpty) {
                                  var oldUpa = state.trainingEditdata[0].upazilas!
                                      .singleWhere((element) => element.id == state.trainingEditdata[0].selectedUpaId);
                                  oldupazila = oldUpa;
                                }
                                //old union
                                if (state.data.isNotEmpty && state.trainingEditdata[0].unions!.isNotEmpty) {
                                  var oldunionvalue = state.trainingEditdata[0].unions!
                                      .singleWhere((element) => element.id == state.trainingEditdata[0].selectedUniId);
                                  oldunion = oldunionvalue;
                                }
                                // old location all id
                                division = state.trainingEditdata[0].selectedDivId.toString().isEmpty
                                    ? ''
                                    : state.trainingEditdata[0].selectedDivId.toString();
                                district = state.trainingEditdata[0].selectedDisId.toString().isEmpty
                                    ? ''
                                    : state.trainingEditdata[0].selectedDisId.toString();
                                upazila = state.trainingEditdata[0].selectedUpaId.toString().isEmpty
                                    ? ''
                                    : state.trainingEditdata[0].selectedUpaId.toString();
                                union = state.trainingEditdata[0].selectedUniId.toString().isEmpty
                                    ? ''
                                    : state.trainingEditdata[0].selectedUniId.toString();

                                fromDateController.text = state.trainingEditdata[0].trainingFromDate!;
                                toDateController.text = state.trainingEditdata[0].trainingToDate!;

                                remarkController.text =
                                    state.trainingEditdata[0].remark == null ? '' : state.trainingEditdata[0].remark!;

                                trainingVenueController.text = state.trainingEditdata[0].trainingVenue!;
                                training_info_setting_id = state.trainingEditdata[0].trainingInfoSettingId.toString();
                                location_id = state.trainingEditdata[0].location_id.toString();
                              }
                            });
                          });
                        }
                        //old venue
                        for (int i = 0; i < state.participant.length; i++) {
                          List<TextEditingController> maleControllersForParticipant = [];
                          List<TextEditingController> femaleControllersForParticipant = [];

                          for (int j = 0; j < state.participant[i].participantLevels.length; j++) {
                            // Check if the participant level has data before adding controllers
                            if (state.participant[i].participantLevels[j].male != null &&
                                state.participant[i].participantLevels[j].female != null) {
                              // Add male controller
                              maleControllersForParticipant.add(TextEditingController(
                                text: state.participant[i].participantLevels[j].male.toString(),
                              ));

                              // Add female controller
                              femaleControllersForParticipant.add(TextEditingController(
                                text: state.participant[i].participantLevels[j].female.toString(),
                              ));
                            }
                          }

                          // Add the lists for the current participant to the main list
                          maleOldconroller.add(maleControllersForParticipant);
                          femaleOldconroller.add(femaleControllersForParticipant);
                        }
                      }
                      print("1111111111111111");
                      print(maleOldconroller.length);

                      return Column(children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        DropdownButtonFormField<dynamic>(
                          isExpanded: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              labelText: 'Select Training Name'),
                          value: selectedValue,
                          onChanged: (dynamic newValue) {
                            setState(() {
                              if (selectedValue != null && selectedValue != newValue) {
                                print("KKKKKKKKKK");
                                oldVenue.clear();
                                venue.clear();
                                maleControllers.clear();
                                femaleControllers.clear();
                                maleValues.clear();
                                feMaleValues.clear();
                                maleVenueControllers.clear();
                                femaleVenueControllers.clear();
                                location_id = '';
                                fromDateController.clear();
                                toDateController.clear();
                                division = '';
                                district = '';
                                upazila = '';
                                union = '';

                                participant_other_id = '0';
                              }

                              if (!venue.contains(newValue)) {
                                print("jjjjjjjj");
                                // Add new value to the list if it's not already present
                                venue.add(newValue);
                                oldDivison = null;
                                oldDistrict = null;
                                oldupazila = null;
                                oldunion = null;
                                remarkController.clear();

                                trainingVenueController.clear();
                                venue.forEach((training) {
                                  final participants = training['training_info_participants'] as List;
                                  final List<List<TextEditingController>> currentMaleControllers = [];
                                  final List<List<TextEditingController>> currentFemaleControllers = [];

                                  for (int i = 0; i < participants.length; i++) {
                                    List<TextEditingController> maleLevelControllers = [];
                                    List<TextEditingController> femaleLevelControllers = [];

                                    maleLevelControllers.addAll(
                                      List.generate(
                                        participants[i]["participant_levels"]!.length,
                                        (levelIndex) => TextEditingController(),
                                      ),
                                    );

                                    femaleLevelControllers.addAll(
                                      List.generate(
                                        participants[i]["participant_levels"]!.length,
                                        (levelIndex) => TextEditingController(),
                                      ),
                                    );

                                    currentMaleControllers.add(maleLevelControllers);
                                    currentFemaleControllers.add(femaleLevelControllers);
                                  }

                                  maleControllers.add(currentMaleControllers);
                                  femaleControllers.add(currentFemaleControllers);
                                });
                              }

                              selectedValue = newValue;
                              training_info_setting_id = selectedValue!['id'].toString();
                              print(training_info_setting_id.toString());
                            });

                            for (var i = 0; i < venue.length; i++) {
                              location_id = venue[i]['location_level']['id'].toString();
                              print(venue[i]['location_level']['id']);
                            }
                          },
                          items: state.data.map<DropdownMenuItem<dynamic>>((dynamic item) {
                            return DropdownMenuItem<dynamic>(
                              value: item,
                              child: Text(item['title'].toString()),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Field Visit Location :",
                            style: TextStyle(fontSize: 16.0.sp, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        oldVenue.isEmpty
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 55.0.h,
                                        width: 160.0.w,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black),
                                              ),
                                              labelText: 'Select division'),
                                          value: selectedDivision,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedDivision = newValue;
                                              selectedDistrict = null;
                                              print("qqqqqqqqqqqqqqqqqqqqqqqqq");
                                              division = selectedDivision.toString();
                                              print(division);

                                              print(venue[0]['location_level']['id']);
                                              trainingDataEditBloc
                                                  .add(DistrictClickEvent(id: int.parse(selectedDivision.toString())));
                                            });
                                          },
                                          items: dropdownItems,
                                        ),
                                      ),
                                      Visibility(
                                        visible: venue[0]['location_level']['id'] == 2 ||
                                            venue[0]['location_level']['id'] == 4 ||
                                            venue[0]['location_level']['id'] == 3,
                                        child: SizedBox(
                                          height: 55.0.h,
                                          width: 160.0.w,
                                          child: DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            value: selectedDistrict,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedDistrict = newValue!;
                                                for (var entry in state.district) {
                                                  if (selectedDistrict == entry['name_en']) {
                                                    print("selectedDistricttttttttttttt${entry['id'].runtimeType}");
                                                    district = entry['id'].toString();
                                                    trainingDataEditBloc.add(UpazilaClickEvent(id: entry['id']));
                                                  }
                                                }
                                                selectedUpazila = null;
                                              });
                                            },
                                            items: state.district.map<DropdownMenuItem<String>>((item) {
                                              return DropdownMenuItem<String>(
                                                value: item['name_en'],
                                                child: Text(item['name_en']),
                                              );
                                            }).toList(),
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black),
                                              ),
                                              labelText: 'Select District',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Visibility(
                                        visible: venue[0]['location_level']['id'] == 4 || venue[0]['location_level']['id'] == 3,
                                        child: SizedBox(
                                          height: 55.0.h,
                                          width: 160.0.w,
                                          child: DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            value: selectedUpazila,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedUpazila = newValue!;
                                                for (var entry in state.upazila) {
                                                  print(entry['name_en']);
                                                  print("selectedUpazilaaaaaaaaaaaa ${entry['id']}");
                                                  if (selectedUpazila == entry['name_en']) {
                                                    print("selectedUpazilaaaaaaaaaaaa ${entry['id']}");
                                                    upazila = entry['id'].toString();
                                                    trainingDataEditBloc.add(UnionClickEvent(id: entry['id']));
                                                  }
                                                }
                                                selectedUion = null;
                                              });
                                            },
                                            items: state.upazila.map<DropdownMenuItem<String>>((item) {
                                              return DropdownMenuItem<String>(
                                                value: item['name_en'],
                                                child: Text(item['name_en']),
                                              );
                                            }).toList(),
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black),
                                              ),
                                              labelText: 'Select Upazila',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: venue[0]['location_level']['id'] == 4,
                                        child: SizedBox(
                                          height: 55.0.h,
                                          width: 160.0.w,
                                          child: DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            value: selectedUion,
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedUion = newValue!;

                                                for (var entry in state.union) {
                                                  if (selectedUion == entry['name_en']) {
                                                    union = entry['id'].toString();
                                                    print("selected union ${entry['id']}");
                                                    // union = entry['id'].toString();
                                                  }
                                                }
                                              });
                                            },
                                            items: state.union.map<DropdownMenuItem<String>>((item) {
                                              return DropdownMenuItem<String>(
                                                value: item['name_en'],
                                                child: Text(item['name_en']),
                                              );
                                            }).toList(),
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black),
                                              ),
                                              labelText: 'Select Union',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 55.0.h,
                                        width: 160.0.w,
                                        child: DropdownButtonFormField<District>(
                                          isExpanded: true,
                                          decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.black),
                                              ),
                                              labelText: 'Select division'),
                                          value: oldDivison,
                                          onChanged: (District? newValue) {
                                            setState(() {
                                              selectedDivision = newValue!.id.toString();
                                              selectedDistrict = null;
                                              oldDistrict = null;
                                              changeDivion = true;
                                              division = selectedDivision.toString();

                                              trainingDataEditBloc
                                                  .add(DistrictClickEvent(id: int.parse(selectedDivision.toString())));
                                            });
                                          },
                                          items: state.trainingEditdata[0].divisions!
                                              .map<DropdownMenuItem<District>>((District item) {
                                            return DropdownMenuItem<District>(
                                              value: item,
                                              child: Text(item.nameEn),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      state.trainingEditdata[0].districts!.isEmpty
                                          ? Container()
                                          : changeDivion == true
                                              ? SizedBox(
                                                  height: 55.0.h,
                                                  width: 160.0.w,
                                                  child: DropdownButtonFormField<String>(
                                                    isExpanded: true,
                                                    value: selectedDistrict,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        changeUpazila = true;
                                                        selectedDistrict = newValue!;
                                                        for (var entry in state.district) {
                                                          if (selectedDistrict == entry['name_en']) {
                                                            print("selectedDistricttttttttttttt${entry['id'].runtimeType}");
                                                            district = entry['id'].toString();
                                                            trainingDataEditBloc.add(UpazilaClickEvent(id: entry['id']));
                                                          }
                                                        }
                                                        selectedUpazila = null;
                                                      });
                                                    },
                                                    items: state.district.map<DropdownMenuItem<String>>((item) {
                                                      return DropdownMenuItem<String>(
                                                        value: item['name_en'],
                                                        child: Text(item['name_en']),
                                                      );
                                                    }).toList(),
                                                    decoration: const InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black),
                                                      ),
                                                      labelText: 'Select District',
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 55.0.h,
                                                  width: 160.0.w,
                                                  child: DropdownButtonFormField<District>(
                                                    isExpanded: true,
                                                    value: oldDistrict,
                                                    onChanged: (District? newValue) {
                                                      setState(() {
                                                        selectedDistrict = newValue!.id.toString();
                                                        district = selectedDistrict.toString();
                                                        trainingDataEditBloc
                                                            .add(UpazilaClickEvent(id: int.parse(selectedDistrict.toString())));
                                                        selectedUpazila = null;
                                                      });
                                                    },
                                                    items: state.trainingEditdata[0].districts!
                                                        .map<DropdownMenuItem<District>>((item) {
                                                      return DropdownMenuItem<District>(
                                                        value: item,
                                                        child: Text(item.nameEn),
                                                      );
                                                    }).toList(),
                                                    decoration: const InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black),
                                                      ),
                                                      labelText: 'Select District',
                                                    ),
                                                  ),
                                                ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      state.trainingEditdata[0].upazilas!.isEmpty
                                          ? Container()
                                          : changeUpazila == true
                                              ? SizedBox(
                                                  height: 55.0.h,
                                                  width: 160.0.w,
                                                  child: DropdownButtonFormField<String>(
                                                    isExpanded: true,
                                                    value: selectedUpazila,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        chnageUnion = true;
                                                        selectedUpazila = newValue!;
                                                        for (var entry in state.upazila) {
                                                          print(entry['name_en']);
                                                          print("selectedUpazilaaaaaaaaaaaa ${entry['id']}");
                                                          if (selectedUpazila == entry['name_en']) {
                                                            print("selectedUpazilaaaaaaaaaaaa ${entry['id']}");
                                                            upazila = entry['id'].toString();
                                                            trainingDataEditBloc.add(UnionClickEvent(id: entry['id']));
                                                          }
                                                        }
                                                        selectedUion = null;
                                                      });
                                                    },
                                                    items: state.upazila.map<DropdownMenuItem<String>>((item) {
                                                      return DropdownMenuItem<String>(
                                                        value: item['name_en'],
                                                        child: Text(item['name_en']),
                                                      );
                                                    }).toList(),
                                                    decoration: const InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black),
                                                      ),
                                                      labelText: 'Select Upazila',
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 55.0.h,
                                                  width: 160.0.w,
                                                  child: DropdownButtonFormField<District>(
                                                    isExpanded: true,
                                                    value: oldupazila,
                                                    onChanged: (District? newValue) {
                                                      setState(() {
                                                        selectedUpazila = newValue!.id.toString();
                                                        upazila = selectedUpazila.toString();
                                                        print("a999999999999999$selectedUpazila");

                                                        trainingDataEditBloc
                                                            .add(UnionClickEvent(id: int.tryParse(selectedUpazila!)));
                                                        selectedUion = null;
                                                      });
                                                    },
                                                    items: state.trainingEditdata[0].upazilas!
                                                        .map<DropdownMenuItem<District>>((item) {
                                                      return DropdownMenuItem<District>(
                                                        value: item,
                                                        child: Text(item.nameEn),
                                                      );
                                                    }).toList(),
                                                    decoration: const InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black),
                                                      ),
                                                      labelText: 'Select Upazila',
                                                    ),
                                                  ),
                                                ),
                                      state.trainingEditdata[0].unions!.isEmpty
                                          ? Container()
                                          : chnageUnion == true
                                              ? SizedBox(
                                                  height: 55.0.h,
                                                  width: 160.0.w,
                                                  child: DropdownButtonFormField<String>(
                                                    isExpanded: true,
                                                    value: selectedUion,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedUion = newValue!;

                                                        for (var entry in state.union) {
                                                          if (selectedUion == entry['name_en']) {
                                                            union = entry['id'].toString();
                                                            print("selected union ${entry['id']}");
                                                            // union = entry['id'].toString();
                                                          }
                                                        }
                                                      });
                                                    },
                                                    items: state.union.map<DropdownMenuItem<String>>((item) {
                                                      return DropdownMenuItem<String>(
                                                        value: item['name_en'],
                                                        child: Text(item['name_en']),
                                                      );
                                                    }).toList(),
                                                    decoration: const InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black),
                                                      ),
                                                      labelText: 'Select Union',
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 55.0.h,
                                                  width: 160.0.w,
                                                  child: DropdownButtonFormField<Union>(
                                                    isExpanded: true,
                                                    value: oldunion,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        selectedUion = newValue!.id.toString();
                                                        union = selectedUion.toString();
                                                      });
                                                    },
                                                    items: state.trainingEditdata[0].unions!.map<DropdownMenuItem<Union>>((item) {
                                                      return DropdownMenuItem<Union>(
                                                        value: item,
                                                        child: Text(item.nameEn),
                                                      );
                                                    }).toList(),
                                                    decoration: const InputDecoration(
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                      border: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.black),
                                                      ),
                                                      labelText: 'Select Union',
                                                    ),
                                                  ),
                                                ),
                                    ],
                                  ),
                                ],
                              ),
                        // SizedBox(
                        //   height: 10.0.h,
                        // ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Training Date",
                            style: TextStyle(fontSize: 16.0.sp, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 5.0.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: GestureDetector(
                                onTap: () => _fromSelectDate(context),
                                child: AbsorbPointer(
                                  child: SizedBox(
                                    height: 50,
                                    child: TextField(
                                      readOnly: true,
                                      controller: fromDateController,
                                      decoration: const InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1, color: Colors.black),
                                        ),
                                        hintText: "dd/mm/yyyy",
                                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(flex: 1, child: Text("To")),
                            Expanded(
                              flex: 5,
                              child: GestureDetector(
                                onTap: () => _toSelectDate(context),
                                child: AbsorbPointer(
                                  child: SizedBox(
                                    height: 50,
                                    child: TextField(
                                      readOnly: true,
                                      controller: toDateController,
                                      decoration: const InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1, color: Colors.black),
                                        ),
                                        hintText: "dd/mm/yyyy",
                                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),

                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            "Participant Count",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(flex: 7, child: Text("")),
                            Expanded(
                                flex: 3,
                                child: Text(
                                  "Male",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Expanded(flex: 3, child: Text("Female", style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                        oldVenue.isNotEmpty
                            ? Column(
                                children: [
                                  ListTile(
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(state.participant.length, (participantIndex) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${state.participant[participantIndex].name}",
                                              style: TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            ...List.generate(state.participant[participantIndex].participantLevels.length,
                                                (participantLevelsIndex) {
                                              String levelId = state
                                                  .participant[participantIndex].participantLevels[participantLevelsIndex].id
                                                  .toString();
                                              if (state.participant[participantIndex].name.toString() == 'others') {
                                                participant_other_id = levelId.toString();
                                              }
                                              if (!participant_level_id.contains(levelId)) {
                                                participant_level_id.add(levelId);
                                              }
                                              return Row(
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Expanded(
                                                    flex: 8,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${state.participant[participantIndex].participantLevels[participantLevelsIndex].participantLevelName}",
                                                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 40,
                                                          child: TextField(
                                                            keyboardType: TextInputType.number,
                                                            controller: maleOldconroller[participantIndex]
                                                                [participantLevelsIndex],
                                                            decoration: const InputDecoration(
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(width: 1, color: Colors.grey),
                                                                ),
                                                                hintText: "M",
                                                                contentPadding: EdgeInsets.only(left: 25)),
                                                            onChanged: (value) {},
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15.0.h,
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 40,
                                                          child: TextField(
                                                            keyboardType: TextInputType.number,
                                                            controller: femaleOldconroller[participantIndex]
                                                                [participantLevelsIndex],
                                                            decoration: const InputDecoration(
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(width: 1, color: Colors.grey),
                                                                ),
                                                                hintText: "F",
                                                                contentPadding: EdgeInsets.only(left: 25)),
                                                            onChanged: (value) {
                                                              // Handle the male input change here if needed
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15.0.h,
                                                  ),
                                                ],
                                              );
                                            })
                                          ],
                                        );
                                      }),
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                children: List.generate(venue.length, (index) {
                                  final training = venue[index];
                                  final participants = training['training_info_participants'] as List;
                                  globalvalue++;
                                  // // Initialize controllers for the current venue
                                  if (globalvalue == 1) {
                                    print("globvallllllllllll valueeeeeeeee");
                                    maleValues.clear();
                                    feMaleValues.clear();
                                    List<List<TextEditingController>> maleVenueControllers = [];
                                    List<List<TextEditingController>> femaleVenueControllers = [];
                                    for (int i = 0; i < participants.length; i++) {
                                      maleVenueControllers.add(
                                        List.generate(
                                          participants[i]["participant_levels"]!.length,
                                          (levelIndex) => TextEditingController(),
                                        ),
                                      );

                                      femaleVenueControllers.add(
                                        List.generate(
                                          participants[i]["participant_levels"]!.length,
                                          (levelIndex) => TextEditingController(),
                                        ),
                                      );
                                    }
                                    maleControllers.add(maleVenueControllers);
                                    femaleControllers.add(femaleVenueControllers);
                                  }

                                  return ListTile(
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(participants.length, (participantIndex) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${participants[participantIndex]['name']}",
                                              style: TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            ...List.generate(participants[participantIndex]["participant_levels"]!.length,
                                                (levelIndex) {
                                              String levelId = participants[participantIndex]["participant_levels"][levelIndex]
                                                      ['id']
                                                  .toString();

                                              if (participants[participantIndex]["participant_levels"][levelIndex]['name'] ==
                                                  'Other') {
                                                participant_other_id = levelId.toString();
                                              }

                                              if (!participant_level_id.contains(levelId)) {
                                                participant_level_id.add(levelId);
                                              }

                                              return Row(
                                                children: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Expanded(
                                                    flex: 8,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${participants[participantIndex]["participant_levels"][levelIndex]['name']}",
                                                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 40,
                                                          child: TextField(
                                                            keyboardType: TextInputType.number,
                                                            controller: maleControllers[index][participantIndex][levelIndex],
                                                            decoration: const InputDecoration(
                                                                enabledBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(width: 1, color: Colors.grey),
                                                                ),
                                                                hintText: "M",
                                                                contentPadding: EdgeInsets.only(left: 25)),
                                                            onChanged: (value) {
                                                              print(value);
                                                              print(participants[participantIndex]["participant_levels"]
                                                                  [levelIndex]['id']);
                                                              // Handle the male input change here if needed
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15.0.h,
                                                  ),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 40,
                                                            child: TextField(
                                                              keyboardType: TextInputType.number,
                                                              controller: femaleControllers[index][participantIndex][levelIndex],
                                                              decoration: const InputDecoration(
                                                                  enabledBorder: OutlineInputBorder(
                                                                    borderSide: BorderSide(width: 1, color: Colors.grey),
                                                                  ),
                                                                  hintText: "F",
                                                                  contentPadding: EdgeInsets.only(left: 25)),
                                                              onChanged: (value) {},
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      )),
                                                ],
                                              );
                                            }),
                                          ],
                                        );
                                      }),
                                    ),
                                  );
                                }),
                              ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                          child: TextField(
                            controller: remarkController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Remarks',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                          child: TextField(
                            controller: trainingVenueController,
                            maxLines: 1,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Training Venue',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        _isLoading
                            ? Center(child: AllService.LoadingToast())
                            : Center(
                                child: SizedBox(
                                  width: 330.w,
                                  height: 50.h,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(7.0.r),
                                        ),
                                        backgroundColor: Color.fromARGB(255, 22, 131, 26),
                                      ),
                                      onPressed: () async {
                                        final connectivityResult = await (Connectivity().checkConnectivity());
                                        if (connectivityResult == ConnectivityResult.mobile ||
                                            connectivityResult == ConnectivityResult.wifi ||
                                            connectivityResult == ConnectivityResult.ethernet) {
                                          if (fromDateController.text.isEmpty && toDateController.text.isEmpty) {
                                            tost('Date is required');
                                          } else if (remarkController.text.isEmpty) {
                                            tost('remark field required');
                                          } else if (trainingVenueController.text.isEmpty) {
                                            tost("Training Venue is required");
                                          } else if (oldVenue.isNotEmpty) {
                                            oldMaleValuesList();
                                            oldFemaleValuesList();
                                          } else {
                                            printMaleValuesList();
                                            printFeMaleValuesList();
                                          }

                                          Map trainingBody = {
                                            "training_info_setting_id": training_info_setting_id,
                                            "location_id": location_id,
                                            "division": division,
                                            "district": district,
                                            "upazila": upazila,
                                            "union": union,
                                            "training_from_date": fromDateController.text,
                                            "training_to_date": toDateController.text,
                                            "training_venue": trainingVenueController.text,
                                            "participant_level_id": participant_level_id,
                                            "male": maleValues,
                                            "female": feMaleValues,
                                            "participant_other_id": participant_other_id,
                                            "other_male": other_male,
                                            "other_female": other_female,
                                            "longitude": currentLocation?.latitude.toString() ?? '0.0',
                                            "latitude": currentLocation?.longitude.toString() ?? '0.0',
                                            "total_male": total_male.toString(),
                                            "total_female": total_female.toString(),
                                            "total_participant": (total_male + total_female).toString(),
                                            "remark": remarkController.text
                                          };

                                          print("all training : $trainingBody");
                                          setState(() {
                                            _isLoading = true;
                                          });

                                          Map a = await Repositores()
                                              .TrainigsEditSubmitAPi(jsonEncode(trainingBody), widget.id.toString());
                                          if (a['status'] == 201) {
                                            await QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.success,
                                              text: "Training Updated Successfully!",
                                            );
                                            await Navigator.of(context).pushAndRemoveUntil(
                                                MaterialPageRoute(builder: (context) => Homepage()),
                                                (Route<dynamic> route) => false);
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          } else {
                                            await QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.error,
                                              text: "Something went wrong please try again later",
                                            );
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                        } else {
                                          AllService().internetCheckDialog(context);
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      },
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Submit',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                      ]);
                    }

                    return Container();
                  },
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                SizedBox(
                  height: 10.0.h,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0.h,
          ),
        ]),
      ),
    );
  }

  void tost(String text) {
    toast.Fluttertoast.showToast(
      msg: text,
      toastLength: toast.Toast.LENGTH_SHORT,
      gravity: toast.ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  List<String> maleValues = [];
  List<String> feMaleValues = [];
  //old male value
  void oldMaleValuesList() {
    maleValues.clear();
    total_male = 0;
    for (List<TextEditingController> maleControllersForParticipant in maleOldconroller) {
      for (TextEditingController maleController in maleControllersForParticipant) {
        maleValues.add(maleController.text);
        int maleValue = int.tryParse(maleController.text) ?? 0;
        total_male += maleValue;
      }
    }
    if (participant_other_id.isNotEmpty) {
      other_male = maleValues.last;
    } else {
      other_male = '0';
    }

    print("All Male Input Values: ${maleValues} $total_male ");
  }

  void oldFemaleValuesList() {
    feMaleValues.clear();
    total_female = 0;
    for (List<TextEditingController> femaleControllersForParticipant in femaleOldconroller) {
      for (TextEditingController femaleController in femaleControllersForParticipant) {
        feMaleValues.add(femaleController.text);
        int femaleValue = int.tryParse(femaleController.text) ?? 0;
        total_female += femaleValue;
      }
    }
    if (participant_other_id.isNotEmpty) {
      other_female = feMaleValues.last.toString();
      print("hhhhhhhhhhhhhhh $other_female");
    } else {
      other_female = '0';
    }

    print("All female Input Values: ${feMaleValues} $total_female ");
  }

// new male value
  void printMaleValuesList() {
    maleValues.clear();
    for (List<List<TextEditingController>> venueControllers in maleControllers) {
      for (List<TextEditingController> levelControllers in venueControllers) {
        for (TextEditingController controller in levelControllers) {
          String inputValue = controller.text.trim();
          String intValue = inputValue.isEmpty ? '0' : inputValue;
          maleValues.add(intValue);
        }
      }
    }
    if (participant_other_id.isNotEmpty) {
      other_male = maleValues.last;
    } else {
      other_male = '0';
    }

    List<int> maleIntegers = maleValues.map((value) => int.tryParse(value) ?? 0).toList();
    total_male = maleIntegers.fold(0, (previousValue, element) => previousValue + element);
    print("All Male Input Values: ${maleValues} and $total_male  ");
  }

  void printFeMaleValuesList() {
    feMaleValues.clear();
    for (List<List<TextEditingController>> venueControllers in femaleControllers) {
      for (List<TextEditingController> levelControllers in venueControllers) {
        for (TextEditingController controller in levelControllers) {
          String inputValue = controller.text.trim();
          String intValue = inputValue.isEmpty ? '0' : inputValue;
          feMaleValues.add(intValue);
        }
      }
    }
    List<int> femaleIntegers = feMaleValues.map((value) => int.tryParse(value) ?? 0).toList();
    total_female = femaleIntegers.fold(0, (previousValue, element) => previousValue + element);
    print("All Female Input Values: ${feMaleValues} and $total_female  ");

    if (participant_other_id.isNotEmpty) {
      other_female = feMaleValues.last.toString();
      print("hhhhhhhhhhhhhhh $other_female");
    } else {
      other_female = '0';
    }
  }
}

int globalIndex = 0;
