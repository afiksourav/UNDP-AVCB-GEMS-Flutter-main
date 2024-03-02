import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/training_data_add_Bloc/training_data_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/new_TraningModel.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

import 'package:village_court_gems/view/home/homepage.dart';

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
  List minority_group_ids = [];

//  Participant Activation Controller
  List<TextEditingController> ParticipantActivationControllerMale = [];
  List<TextEditingController> ParticipantActivationControllerFemale = [];
  List<TextEditingController> totalParticipantActivationController = [];
  TextEditingController totalParticipantActivationControlleMale = TextEditingController();
  TextEditingController totalParticipantActivationControlleFemale = TextEditingController();
  TextEditingController totalParticipantActivationControlleMaleFemale = TextEditingController();
// Participant Activation Function
  void TotalParticipantActivation(int index) {
    int maleValue = int.tryParse(ParticipantActivationControllerMale[index].text) ?? 0;
    int femaleValue = int.tryParse(ParticipantActivationControllerFemale[index].text) ?? 0;

    int total = maleValue + femaleValue;
    totalParticipantActivationController[index].text = total.toString();
  }

  void TotalParticipantActivationMale_Female() {
    int totalMale = 0;
    int totalFemale = 0;
    for (int i = 0; i < ParticipantActivationControllerMale.length; i++) {
      int maleValue = int.tryParse(ParticipantActivationControllerMale[i].text) ?? 0;
      totalMale += maleValue;
    }
    totalParticipantActivationControlleMale.text = totalMale.toString();

    for (int i = 0; i < ParticipantActivationControllerFemale.length; i++) {
      int femaleValue = int.tryParse(ParticipantActivationControllerFemale[i].text) ?? 0;
      totalFemale += femaleValue;
    }
    totalParticipantActivationControlleFemale.text = totalFemale.toString();
  }

// participants Maintenance Area Controller
  List<TextEditingController> ParticipantMaintenanceControllerMale = [];
  List<TextEditingController> ParticipantMaintenanceControllerFemale = [];
  List<TextEditingController> totalParticipantMaintenanceController = [];
  TextEditingController totalParticipantMaintenanceControlleMale = TextEditingController();
  TextEditingController totalParticipantMaintenanceControlleFemale = TextEditingController();
  TextEditingController totalParticipantMaintenanceControlleMaleFemale = TextEditingController();

// Participant Maintenance Function
  void TotalParticipantMaintenance(int index) {
    int maleValue = int.tryParse(ParticipantMaintenanceControllerMale[index].text) ?? 0;
    int femaleValue = int.tryParse(ParticipantMaintenanceControllerFemale[index].text) ?? 0;

    int total = maleValue + femaleValue;
    totalParticipantMaintenanceController[index].text = total.toString();
  }

  void TotalParticipantMaintenanceMale_Female() {
    int totalMale = 0;
    int totalFemale = 0;
    for (int i = 0; i < ParticipantMaintenanceControllerMale.length; i++) {
      int maleValue = int.tryParse(ParticipantMaintenanceControllerMale[i].text) ?? 0;
      totalMale += maleValue;
    }
    totalParticipantMaintenanceControlleMale.text = totalMale.toString();

    for (int i = 0; i < ParticipantMaintenanceControllerFemale.length; i++) {
      int femaleValue = int.tryParse(ParticipantMaintenanceControllerFemale[i].text) ?? 0;
      totalFemale += femaleValue;
    }
    totalParticipantMaintenanceControlleFemale.text = totalFemale.toString();
  }

  // Minority Activation  Controller
  List<TextEditingController> MinorityActivationControllerMale = [];
  List<TextEditingController> MinorityActivationControllerFemale = [];
  List<TextEditingController> totalMinorityActivationController = [];
  TextEditingController totalMinorityActivationControlleMale = TextEditingController();
  TextEditingController totalMinorityActivationControlleFemale = TextEditingController();
  TextEditingController totalMinorityActivationControlleMaleFemale = TextEditingController();
//Minority Activation Function
  void TotalMinorityActivation(int index) {
    int maleValue = int.tryParse(MinorityActivationControllerMale[index].text) ?? 0;
    int femaleValue = int.tryParse(MinorityActivationControllerFemale[index].text) ?? 0;

    int total = maleValue + femaleValue;
    totalMinorityActivationController[index].text = total.toString();
  }

  void TotalMinorityActivationMale_Female() {
    int totalMale = 0;
    int totalFemale = 0;
    for (int i = 0; i < MinorityActivationControllerMale.length; i++) {
      int maleValue = int.tryParse(MinorityActivationControllerMale[i].text) ?? 0;
      totalMale += maleValue;
    }
    totalMinorityActivationControlleMale.text = totalMale.toString();

    for (int i = 0; i < MinorityActivationControllerFemale.length; i++) {
      int femaleValue = int.tryParse(MinorityActivationControllerFemale[i].text) ?? 0;
      totalFemale += femaleValue;
    }
    totalMinorityActivationControlleFemale.text = totalFemale.toString();
  }

  // Minority Maintenance  Controller

  List<TextEditingController> MinorityMaintenanceControllerMale = [];
  List<TextEditingController> MinorityMaintenanceControllerFemale = [];
  List<TextEditingController> totalMinorityMaintenanceController = [];
  TextEditingController totalMinorityMaintenanceControlleMale = TextEditingController();
  TextEditingController totalMinorityMaintenanceControlleFemale = TextEditingController();
  TextEditingController totalMinorityMaintenanceControlleMaleFemale = TextEditingController();

//Minority Maintenance Function
  void TotalMinorityMaintenance(int index) {
    int maleValue = int.tryParse(MinorityMaintenanceControllerMale[index].text) ?? 0;
    int femaleValue = int.tryParse(MinorityMaintenanceControllerFemale[index].text) ?? 0;

    int total = maleValue + femaleValue;
    totalMinorityMaintenanceController[index].text = total.toString();
  }

  void TotalMinorityMaintenanceMale_Female() {
    int totalMale = 0;
    int totalFemale = 0;
    for (int i = 0; i < MinorityMaintenanceControllerMale.length; i++) {
      int maleValue = int.tryParse(MinorityMaintenanceControllerMale[i].text) ?? 0;
      totalMale += maleValue;
    }
    totalMinorityMaintenanceControlleMale.text = totalMale.toString();

    for (int i = 0; i < MinorityMaintenanceControllerFemale.length; i++) {
      int femaleValue = int.tryParse(MinorityMaintenanceControllerFemale[i].text) ?? 0;
      totalFemale += femaleValue;
    }
    totalMinorityMaintenanceControlleFemale.text = totalFemale.toString();
  }

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

  AllTrainingData? selectedValue;

  String? selectedDivision;
  List<AllTrainingData> venue = [];
  String? selectedDistrict;
  String? selectedUpazila;
  String? selectedUion;
  var global = 0;
  int globalIndexParticipantActivation = 0;
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
  String participant_other_id = '0';

  // int total_male = 0;
  // int total_female = 0;
  // int total_participant = 0;
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
                                    print("wwwwwwwwwwwwwwwwwww");
                                    venue.remove(selectedValue);
                                    // maleControllers.clear();
                                    // femaleController.clear();
                                    participant_level_id.clear();
                                    fromDateController.clear();
                                    toDateController.clear();
                                    //Participant Activation
                                    ParticipantActivationControllerMale.clear();
                                    ParticipantActivationControllerFemale.clear();
                                    totalParticipantActivationController.clear();
                                    totalParticipantActivationControlleMale.clear();
                                    totalParticipantActivationControlleFemale.clear();
                                    totalParticipantActivationControlleMaleFemale.clear();
                                    //Participant Maintenanc
                                    ParticipantMaintenanceControllerMale.clear();
                                    ParticipantMaintenanceControllerFemale.clear();
                                    totalParticipantMaintenanceController.clear();
                                    totalParticipantMaintenanceControlleMale.clear();
                                    totalParticipantMaintenanceControlleFemale.clear();
                                    totalParticipantMaintenanceControlleMaleFemale.clear();
                                    //Ethnic Activation
                                    MinorityActivationControllerMale.clear();
                                    MinorityActivationControllerFemale.clear();
                                    totalMinorityActivationController.clear();
                                    totalMinorityActivationControlleMale.clear();
                                    totalMinorityActivationControlleFemale.clear();
                                    totalMinorityActivationControlleMaleFemale.clear();
                                    //Ethnic Maintenance
                                    MinorityMaintenanceControllerMale.clear();
                                    MinorityMaintenanceControllerFemale.clear();
                                    totalMinorityMaintenanceController.clear();
                                    totalMinorityMaintenanceControlleMale.clear();
                                    totalMinorityMaintenanceControlleFemale.clear();
                                    totalMinorityMaintenanceControlleMaleFemale.clear();

                                    selectedDivision = null;
                                    selectedDistrict = null;
                                    selectedUpazila = null;
                                    selectedUpazila = null;

                                    remarkController.clear();
                                    trainingVenueController.clear();

                                    ParticipantActivationControllerMale.clear();
                                    ParticipantActivationControllerFemale.clear();
                                    totalParticipantActivationController.clear();

                                    location_id = '';

                                    participant_other_id = '0';
                                  }
                                  selectedValue = newValue;
                                  training_info_setting_id = selectedValue!.id.toString();
                                  print(training_info_setting_id.toString());
                                });
                                globalvalue = 0;
                                print("location idddddddd");
                                for (var i = 0; i < venue.length; i++) {
                                  location_id = venue[i].locationLevel.id.toString();
                                }
                              },
                              items: state.data.map<DropdownMenuItem<dynamic>>((AllTrainingData item) {
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
                                      child: Text(item.title)),
                                );
                              }).toList(),
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please select Venue';
                              //   }
                              //   return null;
                              // },
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

                                                // print(venue[0]['location_level']['id']);
                                                trainingDataBloc
                                                    .add(DistrictClickEvent(id: int.parse(selectedDivision.toString())));
                                              });
                                            },
                                            items: venue[0].divisions.entries.map<DropdownMenuItem<String>>(
                                              (entry) {
                                                return DropdownMenuItem<String>(
                                                  value: entry.key,
                                                  child: Text(entry.value),
                                                );
                                              },
                                            ).toList(),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Select division';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Visibility(
                                          visible: venue[0].locationLevel.id == 2 ||
                                              venue[0].locationLevel.id == 4 ||
                                              venue[0].locationLevel.id == 3,
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
                                          visible: venue[0].locationLevel.id == 4 || venue[0].locationLevel.id == 3,
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
                                          visible: venue[0].locationLevel.id == 4,
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

                          // Category of participants Activation Area
                          Column(
                            children: [
                              venue.isEmpty
                                  ? Container()
                                  : Column(
                                      children: [
                                        Container(
                                          color: Color.fromARGB(255, 3, 37, 110),
                                          height: 70,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 5, right: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Category of the participants",
                                                      style: TextStyle(color: Colors.white, fontSize: 11),
                                                    ),
                                                    Text(
                                                      "Activation Area",
                                                      style: TextStyle(color: Colors.white, fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(),
                                              Padding(
                                                padding: EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "Male",
                                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                                    ),
                                                    SizedBox(
                                                      width: 35,
                                                    ),
                                                    Text(
                                                      "female",
                                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                                    ),
                                                    SizedBox(
                                                      width: 35,
                                                    ),
                                                    Text(
                                                      "Total",
                                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ...List.generate(venue[0].trainingInfoParticipantsActivation.length,
                                            (participants_ActiveIndex) {
                                          if (venue[0].trainingInfoParticipantsActivation[participants_ActiveIndex].check ==
                                              'other') {
                                            participant_other_id = venue[0]
                                                .trainingInfoParticipantsActivation[participants_ActiveIndex]
                                                .id
                                                .toString();
                                          }
                                          if (venue[0].trainingInfoParticipantsActivation[participants_ActiveIndex].check ==
                                              'main') {
                                            String levelId = venue[0]
                                                .trainingInfoParticipantsActivation[participants_ActiveIndex]
                                                .id
                                                .toString();
                                            if (!participant_level_id.contains(levelId)) {
                                              participant_level_id.add(levelId);
                                            }
                                          }

                                          ParticipantActivationControllerMale.add(TextEditingController());
                                          ParticipantActivationControllerFemale.add(TextEditingController());
                                          totalParticipantActivationController.add(TextEditingController());

                                          return Row(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      venue[0].trainingInfoParticipantsActivation[participants_ActiveIndex].name,
                                                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 40,
                                                      child: TextField(
                                                        keyboardType: TextInputType.number,
                                                        controller: ParticipantActivationControllerMale[participants_ActiveIndex],
                                                        decoration: const InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(width: 1, color: Colors.grey),
                                                            ),
                                                            hintText: "M",
                                                            contentPadding: EdgeInsets.only(left: 25)),
                                                        onChanged: (value) {
                                                          TotalParticipantActivation(participants_ActiveIndex);
                                                          TotalParticipantActivationMale_Female();
                                                          int maleCount =
                                                              int.tryParse(totalParticipantActivationControlleMale.text) ?? 0;
                                                          int femaleCount =
                                                              int.tryParse(totalParticipantActivationControlleFemale.text) ?? 0;
                                                          int total = maleCount + femaleCount;
                                                          totalParticipantActivationControlleMaleFemale.text = total.toString();
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
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          keyboardType: TextInputType.number,
                                                          controller:
                                                              ParticipantActivationControllerFemale[participants_ActiveIndex],
                                                          decoration: const InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                                              ),
                                                              hintText: "F",
                                                              contentPadding: EdgeInsets.only(left: 25)),
                                                          onChanged: (value) {
                                                            TotalParticipantActivation(participants_ActiveIndex);
                                                            TotalParticipantActivationMale_Female();
                                                            int maleCount =
                                                                int.tryParse(totalParticipantActivationControlleMale.text) ?? 0;
                                                            int femaleCount =
                                                                int.tryParse(totalParticipantActivationControlleFemale.text) ?? 0;
                                                            int total = maleCount + femaleCount;
                                                            totalParticipantActivationControlleMaleFemale.text = total.toString();
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: 15.0.h,
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          readOnly: true,
                                                          keyboardType: TextInputType.number,
                                                          controller:
                                                              totalParticipantActivationController[participants_ActiveIndex],
                                                          decoration: const InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                                              ),
                                                              hintText: "T",
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                                height: 40.0.h,
                                                width: 100,
                                                child: TextFormField(
                                                  controller: totalParticipantActivationControlleMale,
                                                  decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.only(left: 40),
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Total Male ',
                                                      labelStyle: TextStyle(fontSize: 10),
                                                      floatingLabelBehavior: FloatingLabelBehavior.always),
                                                )),
                                            SizedBox(
                                                height: 40.0.h,
                                                width: 100,
                                                child: TextFormField(
                                                  onChanged: (value) {},
                                                  controller: totalParticipantActivationControlleFemale,
                                                  decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.only(left: 40),
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Total Female ',
                                                      labelStyle: TextStyle(fontSize: 10),
                                                      floatingLabelBehavior: FloatingLabelBehavior.always),
                                                )),
                                            SizedBox(
                                                height: 40.0.h,
                                                width: 100,
                                                child: TextFormField(
                                                  controller: totalParticipantActivationControlleMaleFemale,
                                                  decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.only(left: 40),
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Total participant',
                                                      labelStyle: TextStyle(fontSize: 10),
                                                      floatingLabelBehavior: FloatingLabelBehavior.always),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Category of participants Maintenance Area
                          venue.isEmpty
                              ? Container()
                              : Column(
                                  children: [
                                    Container(
                                      color: Color.fromARGB(255, 3, 37, 110),
                                      height: 70,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5, right: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Category of the participants",
                                                  style: TextStyle(color: Colors.white, fontSize: 11),
                                                ),
                                                Text(
                                                  "Maintenance Area",
                                                  style: TextStyle(color: Colors.white, fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Male",
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                ),
                                                Text(
                                                  "female",
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                ),
                                                Text(
                                                  "Total",
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ...List.generate(venue[0].trainingInfoParticipantsMaintenance.length, (Maintenance_Index) {
                                      ParticipantMaintenanceControllerMale.add(TextEditingController());
                                      ParticipantMaintenanceControllerFemale.add(TextEditingController());
                                      totalParticipantMaintenanceController.add(TextEditingController());

                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      venue[0].trainingInfoParticipantsMaintenance[Maintenance_Index].name,
                                                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 40,
                                                      child: TextField(
                                                        keyboardType: TextInputType.number,
                                                        controller: ParticipantMaintenanceControllerMale[Maintenance_Index],
                                                        decoration: const InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(width: 1, color: Colors.grey),
                                                            ),
                                                            hintText: "M",
                                                            contentPadding: EdgeInsets.only(left: 25)),
                                                        onChanged: (value) {
                                                          TotalParticipantMaintenance(Maintenance_Index);
                                                          TotalParticipantMaintenanceMale_Female();
                                                          int maleCount =
                                                              int.tryParse(totalParticipantMaintenanceControlleMale.text) ?? 0;
                                                          int femaleCount =
                                                              int.tryParse(totalParticipantMaintenanceControlleFemale.text) ?? 0;
                                                          int total = maleCount + femaleCount;
                                                          totalParticipantMaintenanceControlleMaleFemale.text = total.toString();
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
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          keyboardType: TextInputType.number,
                                                          controller: ParticipantMaintenanceControllerFemale[Maintenance_Index],
                                                          decoration: const InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                                              ),
                                                              hintText: "F",
                                                              contentPadding: EdgeInsets.only(left: 25)),
                                                          onChanged: (value) {
                                                            TotalParticipantMaintenance(Maintenance_Index);
                                                            TotalParticipantMaintenanceMale_Female();
                                                            int maleCount =
                                                                int.tryParse(totalParticipantMaintenanceControlleMale.text) ?? 0;
                                                            int femaleCount =
                                                                int.tryParse(totalParticipantMaintenanceControlleFemale.text) ??
                                                                    0;
                                                            int total = maleCount + femaleCount;
                                                            totalParticipantMaintenanceControlleMaleFemale.text =
                                                                total.toString();
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: 15.0.h,
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          keyboardType: TextInputType.number,
                                                          controller: totalParticipantMaintenanceController[Maintenance_Index],
                                                          decoration: const InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                                              ),
                                                              hintText: "T",
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
                                          ),
                                        ],
                                      );
                                    }),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            height: 40.0.h,
                                            width: 100,
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: totalParticipantMaintenanceControlleMale,
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 40),
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Total Male ',
                                                  labelStyle: TextStyle(fontSize: 10),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                                            )),
                                        SizedBox(
                                            height: 40.0.h,
                                            width: 100,
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: totalParticipantMaintenanceControlleFemale,
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 40),
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Total Female ',
                                                  labelStyle: TextStyle(fontSize: 10),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                                            )),
                                        SizedBox(
                                            height: 40.0.h,
                                            width: 100,
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: totalParticipantMaintenanceControlleMaleFemale,
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 40),
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Total participant',
                                                  labelStyle: TextStyle(fontSize: 10),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          //Ethnic Minority Activation Area
                          venue.isEmpty
                              ? Container()
                              : Column(
                                  children: [
                                    Container(
                                      color: Color.fromARGB(255, 3, 37, 110),
                                      height: 70,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5, right: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Ethnic Minority & Disadvantage Groups",
                                                  style: TextStyle(color: Colors.white, fontSize: 11),
                                                ),
                                                Text(
                                                  "Activation Area",
                                                  style: TextStyle(color: Colors.white, fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Male",
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                ),
                                                Text(
                                                  "female",
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                ),
                                                Text(
                                                  "Total",
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ...List.generate(venue[0].minoritiesActivation.length, (Ethnic_activeIndex) {
                                      String levelId = venue[0].minoritiesActivation[Ethnic_activeIndex].id.toString();
                                      if (!minority_group_ids.contains(levelId)) {
                                        minority_group_ids.add(levelId);
                                      }
                                      MinorityActivationControllerMale.add(TextEditingController());
                                      MinorityActivationControllerFemale.add(TextEditingController());
                                      totalMinorityActivationController.add(TextEditingController());

                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      venue[0].minoritiesActivation[Ethnic_activeIndex].name.toString(),
                                                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 40,
                                                      child: TextField(
                                                        keyboardType: TextInputType.number,
                                                        controller: MinorityActivationControllerMale[Ethnic_activeIndex],
                                                        decoration: const InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(width: 1, color: Colors.grey),
                                                            ),
                                                            hintText: "M",
                                                            contentPadding: EdgeInsets.only(left: 25)),
                                                        onChanged: (value) {
                                                          TotalMinorityActivation(Ethnic_activeIndex);
                                                          TotalMinorityActivationMale_Female();
                                                          int maleCount =
                                                              int.tryParse(totalMinorityActivationControlleMale.text) ?? 0;
                                                          int femaleCount =
                                                              int.tryParse(totalMinorityActivationControlleFemale.text) ?? 0;
                                                          int total = maleCount + femaleCount;
                                                          totalMinorityActivationControlleMaleFemale.text = total.toString();
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
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          keyboardType: TextInputType.number,
                                                          controller: MinorityActivationControllerFemale[Ethnic_activeIndex],
                                                          decoration: const InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                                              ),
                                                              hintText: "F",
                                                              contentPadding: EdgeInsets.only(left: 25)),
                                                          onChanged: (value) {
                                                            TotalMinorityActivation(Ethnic_activeIndex);
                                                            TotalMinorityActivationMale_Female();
                                                            int maleCount =
                                                                int.tryParse(totalMinorityActivationControlleMale.text) ?? 0;
                                                            int femaleCount =
                                                                int.tryParse(totalMinorityActivationControlleFemale.text) ?? 0;
                                                            int total = maleCount + femaleCount;
                                                            totalMinorityActivationControlleMaleFemale.text = total.toString();
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: 15.0.h,
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          readOnly: true,
                                                          keyboardType: TextInputType.number,
                                                          controller: totalMinorityActivationController[Ethnic_activeIndex],
                                                          decoration: const InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                                              ),
                                                              hintText: "T",
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
                                          ),
                                        ],
                                      );
                                    }),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            height: 40.0.h,
                                            width: 100,
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: totalMinorityActivationControlleMale,
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 40),
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Total Male ',
                                                  labelStyle: TextStyle(fontSize: 10),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                                            )),
                                        SizedBox(
                                            height: 40.0.h,
                                            width: 100,
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: totalMinorityActivationControlleFemale,
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 40),
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Total Female ',
                                                  labelStyle: TextStyle(fontSize: 10),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                                            )),
                                        SizedBox(
                                            height: 40.0.h,
                                            width: 100,
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: totalMinorityActivationControlleMaleFemale,
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 40),
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Total participant',
                                                  labelStyle: TextStyle(fontSize: 10),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          //Ethnic Minority Maintenance
                          venue.isEmpty
                              ? Container()
                              : Column(
                                  children: [
                                    Container(
                                      color: Color.fromARGB(255, 3, 37, 110),
                                      height: 70,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5, right: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Ethnic Minority & Disadvantage Groups",
                                                  style: TextStyle(color: Colors.white, fontSize: 11),
                                                ),
                                                Text(
                                                  "Maintenance Area",
                                                  style: TextStyle(color: Colors.white, fontSize: 11),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Male",
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                ),
                                                Text(
                                                  "female",
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                ),
                                                Text(
                                                  "Total",
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ...List.generate(venue[0].minoritiesMaintenance.length, (Ethnic_MaintenanceIndex) {
                                      MinorityMaintenanceControllerMale.add(TextEditingController());
                                      MinorityMaintenanceControllerFemale.add(TextEditingController());
                                      totalMinorityMaintenanceController.add(TextEditingController());
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      venue[0].minoritiesMaintenance[Ethnic_MaintenanceIndex].name,
                                                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 40,
                                                      child: TextField(
                                                        keyboardType: TextInputType.number,
                                                        controller: MinorityMaintenanceControllerMale[Ethnic_MaintenanceIndex],
                                                        decoration: const InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(width: 1, color: Colors.grey),
                                                            ),
                                                            hintText: "M",
                                                            contentPadding: EdgeInsets.only(left: 25)),
                                                        onChanged: (value) {
                                                          TotalMinorityMaintenance(Ethnic_MaintenanceIndex);
                                                          TotalMinorityMaintenanceMale_Female();
                                                          int maleCount =
                                                              int.tryParse(totalMinorityMaintenanceControlleMale.text) ?? 0;
                                                          int femaleCount =
                                                              int.tryParse(totalMinorityMaintenanceControlleFemale.text) ?? 0;
                                                          int total = maleCount + femaleCount;
                                                          totalMinorityMaintenanceControlleMaleFemale.text = total.toString();
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
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          keyboardType: TextInputType.number,
                                                          controller:
                                                              MinorityMaintenanceControllerFemale[Ethnic_MaintenanceIndex],
                                                          decoration: const InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                                              ),
                                                              hintText: "F",
                                                              contentPadding: EdgeInsets.only(left: 25)),
                                                          onChanged: (value) {
                                                            TotalMinorityMaintenance(Ethnic_MaintenanceIndex);
                                                            TotalMinorityMaintenanceMale_Female();
                                                            int maleCount =
                                                                int.tryParse(totalMinorityMaintenanceControlleMale.text) ?? 0;
                                                            int femaleCount =
                                                                int.tryParse(totalMinorityMaintenanceControlleFemale.text) ?? 0;
                                                            int total = maleCount + femaleCount;
                                                            totalMinorityMaintenanceControlleMaleFemale.text = total.toString();
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: 15.0.h,
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 40,
                                                        child: TextField(
                                                          readOnly: true,
                                                          keyboardType: TextInputType.number,
                                                          controller: totalMinorityMaintenanceController[Ethnic_MaintenanceIndex],
                                                          decoration: const InputDecoration(
                                                              border: OutlineInputBorder(),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(width: 1, color: Colors.grey),
                                                              ),
                                                              hintText: "T",
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
                                          ),
                                        ],
                                      );
                                    }),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            height: 40.0.h,
                                            width: 100,
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: totalMinorityMaintenanceControlleMale,
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 40),
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Total Male ',
                                                  labelStyle: TextStyle(fontSize: 10),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                                            )),
                                        SizedBox(
                                            height: 40.0.h,
                                            width: 100,
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: totalMinorityMaintenanceControlleFemale,
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 40),
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Total Female ',
                                                  labelStyle: TextStyle(fontSize: 10),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                                            )),
                                        SizedBox(
                                            height: 40.0.h,
                                            width: 100,
                                            child: TextFormField(
                                              readOnly: true,
                                              controller: totalMinorityMaintenanceControlleMaleFemale,
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(left: 40),
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Total participant',
                                                  labelStyle: TextStyle(fontSize: 10),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),

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
                                              getTextValuesActivationMaleFemale();
                                              getTextValuesMaintenanceMaleFemale();
                                              getTextValuesMinorityActivationMaleFemale();
                                              getTextValuesMinorityMaintenanceMaleFemale();
                                              print(a_male);
                                              int total_male = 0;
                                              int total_female = 0;
                                              int total_minority_male = 0;
                                              int total_minority_female = 0;
                                              int total_participant = 0;
                                              int total_minority_participant = 0;
                                              // print(totalParticipantActivationControlleMale.text)

                                              total_male = int.parse(totalParticipantActivationControlleMale.text) +
                                                  int.parse(totalParticipantMaintenanceControlleMale.text);

                                              total_female = int.parse(totalParticipantActivationControlleFemale.text) +
                                                  int.parse(totalParticipantMaintenanceControlleFemale.text);
                                              total_participant = total_male + total_female;

                                              print(
                                                  "TOTAL male ${total_male} total female ${total_female} all total ${total_participant}");
                                              total_minority_male = int.parse(totalMinorityActivationControlleMale.text) +
                                                  int.parse(totalMinorityMaintenanceControlleMale.text);
                                              total_minority_female = int.parse(totalMinorityActivationControlleFemale.text) +
                                                  int.parse(totalMinorityMaintenanceControlleFemale.text);
                                              total_minority_participant = total_minority_male + total_minority_female;

                                              print(
                                                  "TOTAL minority male ${total_minority_male} total minority female ${total_minority_female} all minority total ${total_minority_participant}");

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
                                                "a_male": a_male,
                                                "a_female": a_female,
                                                "a_total": a_total,
                                                "m_male": m_male,
                                                "m_female": m_female,
                                                "m_total": m_total,
                                                "minority_group_id": minority_group_ids,
                                                "minority_a_male": minority_a_male,
                                                "minority_a_female": minority_a_female,
                                                "minority_a_total": minority_a_total,
                                                "minority_m_male": minority_m_male,
                                                "minority_m_female": minority_m_female,
                                                "minority_m_total": minority_m_total,
                                                if (participant_other_id != '0') "participant_other_id": participant_other_id,
                                                if (participant_other_id != '0') "a_other_male": a_other_male,
                                                if (participant_other_id != '0') "a_other_female": a_other_female,
                                                if (participant_other_id != '0') "a_other_total": a_other_total.toString(),
                                                if (participant_other_id != '0') "m_other_male": m_other_male,
                                                if (participant_other_id != '0') "m_other_female": m_other_female,
                                                if (participant_other_id != '0') "m_other_total": m_other_total.toString(),
                                                "total_male": total_male,
                                                "total_female": total_female,
                                                "total_participant": total_participant,
                                                "total_minority_male": total_minority_male,
                                                "total_minority_female": total_minority_female,
                                                "total_minority_participant": total_minority_participant,
                                                "longitude": currentLocation?.latitude.toString() ?? '0.0',
                                                "latitude": currentLocation?.longitude.toString() ?? '0.0',
                                                "remark": remarkController.text
                                              };
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              print(jsonEncode(trainingBody));
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

//get all   Participants Activation value
  List<String> a_male = [];
  List<String> a_female = [];
  List<String> a_total = [];
  String a_other_male = '0';
  String a_other_female = '0';
  int a_other_total = 0;
  void getTextValuesActivationMaleFemale() {
    a_male.clear();
    a_female.clear();
    a_total.clear();

    for (int i = 0; i < venue[0].trainingInfoParticipantsActivation.length; i++) {
      //male
      if (venue[0].trainingInfoParticipantsActivation[i].check == 'other') {
        a_other_male = ParticipantActivationControllerMale[i].text.isEmpty ? "0" : ParticipantActivationControllerMale[i].text;
      } else {
        a_male.add(ParticipantActivationControllerMale[i].text.isEmpty ? "0" : ParticipantActivationControllerMale[i].text);
      }
      //female
      if (venue[0].trainingInfoParticipantsActivation[i].check == 'other') {
        a_other_female =
            ParticipantActivationControllerFemale[i].text.isEmpty ? "0" : ParticipantActivationControllerFemale[i].text;
      } else {
        a_female.add(ParticipantActivationControllerFemale[i].text.isEmpty ? "0" : ParticipantActivationControllerFemale[i].text);
      }
      //total
      a_total.add(totalParticipantActivationController[i].text.isEmpty ? "0" : totalParticipantActivationController[i].text);
      a_other_total = int.parse(a_other_male) + int.parse(a_other_female);
    }
  }

//get all   Participants Maintenance value
  List<String> m_male = [];
  List<String> m_female = [];
  List<String> m_total = [];
  String m_other_male = '0';
  String m_other_female = '0';
  int m_other_total = 0;
  void getTextValuesMaintenanceMaleFemale() {
    m_male.clear();
    m_female.clear();
    m_total.clear();

    for (int i = 0; i < venue[0].trainingInfoParticipantsMaintenance.length; i++) {
      //male
      if (venue[0].trainingInfoParticipantsMaintenance[i].check == 'other') {
        m_other_male = ParticipantMaintenanceControllerMale[i].text.isEmpty ? "0" : ParticipantMaintenanceControllerMale[i].text;
      } else {
        m_male.add(ParticipantMaintenanceControllerMale[i].text.isEmpty ? "0" : ParticipantMaintenanceControllerMale[i].text);
      }
      //female
      if (venue[0].trainingInfoParticipantsMaintenance[i].check == 'other') {
        m_other_female =
            ParticipantMaintenanceControllerFemale[i].text.isEmpty ? "0" : ParticipantMaintenanceControllerFemale[i].text;
      } else {
        m_female
            .add(ParticipantMaintenanceControllerFemale[i].text.isEmpty ? "0" : ParticipantMaintenanceControllerFemale[i].text);
      }
      //total
      m_total.add(totalParticipantMaintenanceController[i].text.isEmpty ? "0" : totalParticipantMaintenanceController[i].text);
      m_other_total = int.parse(m_other_male) + int.parse(m_other_female);
    }
  }

  //get all   minority   Activation value
  List<String> minority_a_male = [];
  List<String> minority_a_female = [];
  List<String> minority_a_total = [];

  void getTextValuesMinorityActivationMaleFemale() {
    minority_a_male.clear();
    minority_a_female.clear();
    minority_a_total.clear();

    for (int i = 0; i < venue[0].minoritiesActivation.length; i++) {
      //male

      minority_a_male.add(MinorityActivationControllerMale[i].text.isEmpty ? "0" : MinorityActivationControllerMale[i].text);

      //female

      minority_a_female
          .add(MinorityActivationControllerFemale[i].text.isEmpty ? "0" : MinorityActivationControllerFemale[i].text);

      //total
      minority_a_total.add(totalMinorityActivationController[i].text.isEmpty ? "0" : totalMinorityActivationController[i].text);
    }
  }

  //get all   minority   Maintenance value
  List<String> minority_m_male = [];
  List<String> minority_m_female = [];
  List<String> minority_m_total = [];

  void getTextValuesMinorityMaintenanceMaleFemale() {
    minority_m_male.clear();
    minority_m_female.clear();
    minority_m_total.clear();

    for (int i = 0; i < venue[0].minoritiesMaintenance.length; i++) {
      //male

      minority_m_male.add(MinorityMaintenanceControllerMale[i].text.isEmpty ? "0" : MinorityMaintenanceControllerMale[i].text);

      //female

      minority_m_female
          .add(MinorityMaintenanceControllerFemale[i].text.isEmpty ? "0" : MinorityMaintenanceControllerFemale[i].text);

      //total
      minority_m_total.add(totalMinorityMaintenanceController[i].text.isEmpty ? "0" : totalMinorityMaintenanceController[i].text);
    }
  }
}
