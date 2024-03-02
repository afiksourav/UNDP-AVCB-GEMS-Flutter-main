import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/training_data_add_Bloc/training_data_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/view/home/homepage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class TrainingDataPage extends StatefulWidget {
  static const pageName = 'Training_add';
  const TrainingDataPage({super.key});

  @override
  State<TrainingDataPage> createState() => _TrainingDataPageState();
}

class _TrainingDataPageState extends State<TrainingDataPage> {
  DateTime? fromSelectedDate;
  DateTime? toSelectedDate;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController trainingVenueController = TextEditingController();
  final GlobalKey<FormState> _TrainingformKey = GlobalKey<FormState>();

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

  Map<String, dynamic>? selectedValue;
  List<List<List<TextEditingController>>> maleControllers = [];
  List<List<List<TextEditingController>>> femaleController = [];

  String? selectedDivision;
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

  int globalvalue = 0;
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

  final TrainingDataAddBlocBloc trainingDataBloc = TrainingDataAddBlocBloc();
  @override
  void initState() {
    trainingDataBloc.add(TrainingDataInitialEvent());
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
          "Training data add/update",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _TrainingformKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
              child: Column(
                children: [
                  BlocConsumer<TrainingDataAddBlocBloc, TrainingDataBlocState>(
                    bloc: trainingDataBloc,
                    listenWhen: (previous, current) => current is TrainingDataActionState,
                    buildWhen: (previous, current) => current is! TrainingDataActionState,
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      if (state is TrainingDataLoadingState) {
                        return Container(
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is TrainingDataSuccessState) {
                        print("displayyyyyyyyyyy");
                        // print(state.data[0]['training_info_participants'][0]['name']);
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
                        return Column(children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 2, right: 2),
                            child: DropdownButtonFormField<dynamic>(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  labelText: 'Select Training Name'),
                              value: selectedValue,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  if (!venue.contains(newValue)) {
                                    // Add new value to the list if it's not already present
                                    venue.add(newValue);
                                  }
                                  // Remove old value from the list
                                  if (selectedValue != null && selectedValue != newValue) {
                                    venue.remove(selectedValue);
                                    maleControllers.clear();
                                    femaleController.clear();
                                    maleValues.clear();
                                    feMaleValues.clear();
                                    location_id = '';

                                    participant_other_id = '0';
                                  }
                                  selectedValue = newValue;
                                  training_info_setting_id = selectedValue!['id'].toString();
                                  print(training_info_setting_id.toString());
                                });
                                globalvalue = 0;
                                print("location idddddddd");
                                for (var i = 0; i < venue.length; i++) {
                                  location_id = venue[i]['location_level']['id'].toString();
                                  print(venue[i]['location_level']['id']);
                                }
                              },
                              items: state.data.map<DropdownMenuItem<dynamic>>((dynamic item) {
                                return DropdownMenuItem<dynamic>(
                                  value: item,
                                  child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: Colors.grey, width: 1),
                                        ),
                                      ),
                                      child: Text(item['title'].toString())),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select Venue';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.0.h,
                          ),
                          venue.isEmpty
                              ? Container()
                              : Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Field Visit Location :",
                                    style: TextStyle(fontSize: 16.0.sp, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                          // Text(
                          //   'Latitude: ${currentLocation?.latitude ?? 0.0}, Longitude: ${currentLocation?.longitude ?? 0.0}',
                          //   style: TextStyle(fontSize: 16.0),
                          // ),
                          SizedBox(
                            height: 10.0.h,
                          ),
                          venue.isEmpty
                              ? Container()
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
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

                                                print(venue[0]['location_level']['id']);
                                                trainingDataBloc
                                                    .add(DistrictClickEvent(id: int.parse(selectedDivision.toString())));
                                              });
                                            },
                                            items: dropdownItems,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Please select division';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Visibility(
                                          visible: venue[0]['location_level']['id'] == 2 ||
                                              venue[0]['location_level']['id'] == 4 ||
                                              venue[0]['location_level']['id'] == 3,
                                          child: SizedBox(
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
                                                      trainingDataBloc.add(UpazilaClickEvent(id: entry['id']));
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
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please select District';
                                                }
                                                return null;
                                              },
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
                                                      trainingDataBloc.add(UnionClickEvent(id: entry['id']));
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
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please select Upazila';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: venue[0]['location_level']['id'] == 4,
                                          child: SizedBox(
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
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please select Union';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 10.0.h,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Training Date :",
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
                                      height: 40,
                                      child: TextFormField(
                                          readOnly: true,
                                          controller: fromDateController,
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1, color: Colors.black),
                                            ),
                                            hintText: "dd/mm/yyyy",
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                            // hintStyle: TextStyle(c),
                                            suffixIcon: Icon(Icons.calendar_today),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please Select Date';
                                            }
                                            return null;
                                          }),
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
                                      height: 40,
                                      child: TextFormField(
                                          readOnly: true,
                                          controller: toDateController,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1, color: Colors.black),
                                            ),
                                            hintText: "dd/mm/yyyy",
                                            suffixIcon: Icon(Icons.calendar_today),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please Select Date';
                                            }
                                            return null;
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0.h,
                          ),

                          venue.isEmpty
                              ? Container()
                              : Container(
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
                          venue.isEmpty
                              ? Container()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(flex: 5, child: Text("")),
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Male",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        )),
                                    Expanded(flex: 2, child: Text("Female", style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                ),
                          ...List.generate(venue.length, (index) {
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
                              femaleController.add(femaleVenueControllers);
                            }
                            return ListTile(
                              //title: Text(training['title']),
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
                                        String levelId =
                                            participants[participantIndex]["participant_levels"][levelIndex]['id'].toString();

                                        if (participants[participantIndex]["participant_levels"][levelIndex]['name'] == 'Other') {
                                          participant_other_id = levelId.toString();
                                        }

                                        if (!participant_level_id.contains(levelId)) {
                                          participant_level_id.add(levelId);
                                        }
                                        //print(participants[participantIndex]["participant_levels"][levelIndex]['id']);
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
                                                        print(participants[participantIndex]["participant_levels"][levelIndex]
                                                            ['id']);
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
                                                        controller: femaleController[index][participantIndex][levelIndex],
                                                        decoration: const InputDecoration(
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(width: 1, color: Colors.grey),
                                                            ),
                                                            hintText: "F",
                                                            contentPadding: EdgeInsets.only(left: 25)),
                                                        onChanged: (value) {
                                                          // Handle the female input change here if needed
                                                        },
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

                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                            child: TextFormField(
                              controller: remarkController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Remarks',
                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Remarks Field';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.0.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                            child: TextFormField(
                              controller: trainingVenueController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Training Venue',
                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Training Venue Field';
                                }
                                return null;
                              },
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
                                            if (_TrainingformKey.currentState!.validate()) {
                                              printMaleValuesList();
                                              printFeMaleValuesList();
                                              print(location_id);
                                              print(upazila);
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
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              print(trainingBody);
                                              Map a = await Repositores().trainingInfoSubmit(jsonEncode(trainingBody));
                                              if (a['status'] == 201) {
                                                await QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.success,
                                                  text: "Training Add Successfully!",
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

  List<String> feMaleValues = [];
  void printFeMaleValuesList() {
    feMaleValues.clear();
    for (List<List<TextEditingController>> venueControllers in femaleController) {
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

  // List<String> female = [];
  // List male = [];

  // void maleAllDataInput() {
  //   // Clear the existing values before adding new ones
  //   print("aaaaaaaarrrrrrrrr");
  //   print(maleControllers.length);
  //   male.clear();
  //   for (int i = 0; i < maleControllers.length; i++) {
  //     for (int j = 0; j < maleControllers[i].length; j++) {
  //       for (int k = 0; k < maleControllers[i][j].length; k++) {
  //         String maleInputValue = maleControllers[i][j][k].text.trim();
  //         int intValue = maleInputValue.isEmpty ? 0 : int.parse(maleInputValue);
  //         male.add(intValue);
  //       }
  //     }
  //   }
  //   print("WWWWWWWWWWWWWW ${male}");
  // String maleInputValue = '';
  // for (int i = 0; i < maleControllers.length; i++) {

  // String maleInputValue = maleControllers[i].map((e) => e.first).first.text;

  // }
  // print("yyyyyyyyyyyyyyyyyyyyyy");
  // print(male.length);
  // if (participant_other_id.isNotEmpty) {
  //   other_male = male.last;
  // } else {
  //   other_male = '0';
  // }

  // List<int> maleIntegers = male.map((value) => int.tryParse(value) ?? 0).toList();
  // total_male = maleIntegers.fold(0, (previousValue, element) => previousValue + element);

  // print("All Male Input Values: ${male} and $total_male  ${maleControllers.length}");
  // }

  // void femaleAllDataInput() {
  //   female.clear();

  //   for (int i = 0; i < femaleController.length; i++) {
  //     for (int j = 0; j < femaleController[i].length; j++) {
  //       for (int k = 0; k < femaleController[i][j].length; k++) {
  //         String femaleInputValue = femaleController[i][j][k].text.trim();

  //         female.add(femaleInputValue.isEmpty ? '0' : femaleInputValue);
  //       }
  //     }
  //   }
  //   if (participant_other_id.isNotEmpty) {
  //     other_female = female.last;
  //   } else {
  //     other_female = '0';
  //   }

  //   List<int> maleIntegers = female.map((value) => int.tryParse(value) ?? 0).toList();
  //   total_female = maleIntegers.fold(0, (previousValue, element) => previousValue + element);

  //   print("All female Input Values: $female  and $total_female ");
  // }
}

int globalIndex = 0;
