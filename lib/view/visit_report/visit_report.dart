import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/Location_Bloc/location_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/view/field_visit_list/field-finding-create.dart';
import 'package:village_court_gems/view/home/homepage.dart';
import 'package:village_court_gems/view/visit_report/change_location.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class VisitReport extends StatefulWidget {
  static const pageName = 'VisitReport';
  const VisitReport({super.key});

  @override
  State<VisitReport> createState() => _VisitReportState();
}

class _VisitReportState extends State<VisitReport> {
  DateTime? selectedDate;
  Map locationdata = {};
  bool data = false;
  String? selectedDivision;
  String? selectedDistrict;
  String? selectedUpazila;
  String? selectedUion;
  String found = '';
  String division_id = '';
  String district_id = '';
  String union_id = '';
  String upazila_id = '';
  String? selectedOffice;
  TextEditingController dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now().toLocal()));
  TextEditingController visit_dateControler = TextEditingController();
  final GlobalKey<FormState> _formKeyVisitReport = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
      });
    }
  }

  late GoogleMapController mapController;
  LocationData? currentLocation;
  Location location = Location();
  Completer<GoogleMapController> mapControllerCompleter = Completer();

  bool isLoading = false; // Add this line to your state
  bool _isLoading = false;

  Future<void> initLocation() async {
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
        isLoading = false; // Set loading to false when location is obtained
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false; // Set loading to false in case of an error
      });
    }
  }

  final double mallLatitude = 23.8127951;
  final double mallLongitude = 90.4288529;
  double targetLatitude = 0.0;
  double targetLongitude = 0.0;
  int globalvalue = 0;

  bool isWithin2km = false;

  void calculateDistance() async {
    print("terget 1 $targetLatitude");
    print("terget 2 $targetLongitude");
    double distanceInMeters = await Geolocator.distanceBetween(
      mallLatitude,
      mallLongitude,
      targetLatitude,
      targetLongitude,
    );

    print("DIstance meter $distanceInMeters");

    double distanceInKm = distanceInMeters / 1000;
    print("DIstance km $distanceInKm");

    setState(() {
      isWithin2km = distanceInMeters < 1.00;
    });
  }

  void updateMap() async {
    if (mapControllerCompleter.isCompleted && currentLocation != null) {
      mapControllerCompleter.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                currentLocation!.latitude!,
                currentLocation!.longitude!,
              ),
              zoom: 14.0,
            ),
          ),
        );
      });

      setState(() {
        targetLatitude = currentLocation!.latitude!;
        targetLongitude = currentLocation!.longitude!;
      });

      print('Latitude: ${targetLatitude}, Longitude: ${targetLongitude}');
      // Additional logic here

      String token = await Helper().getUserToken();
      print(token);
      locationBloc.add(LocationInitialEvent(locationModel: {
        "latitude": targetLatitude.toString(),
        "longitude": targetLongitude.toString(),
      }));
    } else {
      print('Map controller is not completed');
    }
  }


// online off no
  final LocationBloc locationBloc = LocationBloc();
  List findUnion = [];
  List findUpazila = [];
  List findDistrict = [];
  List findDisivion = [];
  void calculateDistancetry(double targetLatitude, double targetLongitude) async {
    findUnion.clear();
    findUpazila.clear();
    findDistrict.clear();
    findDisivion.clear();

    List storeUnionData = await Helper().getUnionData();

    // List storeDistrictData = await Helper().getDistrictData();
    for (var all_union in storeUnionData) {
      if (all_union["latitude"] == null && all_union["longitude"] == null) {
        continue;
      }
      double mallLatitude = double.parse(all_union["latitude"]);
      double mallLongitude = double.parse(all_union["longitude"]);

      double distanceInMeters = await Geolocator.distanceBetween(
        mallLatitude,
        mallLongitude,
        targetLatitude,
        targetLongitude,
      );
      //print("miters    ${distanceInMeters}");

      print("${all_union["name_en"]} - Distance meter: $distanceInMeters");

      if (distanceInMeters < 2) {
        findUnion.add(all_union);
      }
    }
    print("${findUnion} is within 2 meters.${findUnion.length}");
    if (findUnion.isNotEmpty) {
      List storeUpazilaData = await Helper().getUpazilaData();
      List storeDistrictData = await Helper().getDistrictData();
      List storeDivisonData = await Helper().getDivisionData();
      findUnion.forEach((element) {
        storeUpazilaData.forEach((upazila) {
          if (element['upazila_id'] == upazila['id'] && findUpazila.isEmpty) {
            findUpazila.add(upazila);
          }
        });
        storeDistrictData.forEach((district) {
          if (element['district_id'] == district['id'] && findDistrict.isEmpty) {
            findDistrict.add(district);
          }
        });
        storeDivisonData.forEach((divison) {
          if (element['division_id'] == divison['id'] && findDisivion.isEmpty) {
            findDisivion.add(divison);
          }
        });
      });
    } else {
      //upazila cheking
      List storeUpazilaData = await Helper().getUpazilaData();
      for (var all_Upazila in storeUpazilaData) {
        if (all_Upazila["latitude"] == null && all_Upazila["longitude"] == null) {
          continue;
        }
        double mallLatitude = double.parse(all_Upazila["latitude"]);
        double mallLongitude = double.parse(all_Upazila["longitude"]);

        double distanceInMeters = await Geolocator.distanceBetween(
          mallLatitude,
          mallLongitude,
          targetLatitude,
          targetLongitude,
        );
        // print("miters    ${distanceInMeters}");

        print("${all_Upazila["name_en"]} - Distance meter: $distanceInMeters");

        if (distanceInMeters < 0.0) {
          findUpazila.add(all_Upazila);
        }
      }
    }
    if (findUpazila.isNotEmpty) {
      List storeDistrictData = await Helper().getDistrictData();
      List storeDivisonData = await Helper().getDivisionData();
      findUpazila.forEach((element) {
        storeDistrictData.forEach((district) {
          if (element['district_id'] == district['id'] && findDistrict.isEmpty) {
            findDistrict.add(district);
          }
        });
        storeDivisonData.forEach((divison) {
          if (element['division_id'] == divison['id'] && findDisivion.isEmpty) {
            findDisivion.add(divison);
          }
        });
      });
    } else {
      //all_District cheking
      List storeDistrictData = await Helper().getDistrictData();
      for (var all_District in storeDistrictData) {
        if (all_District["latitude"] == null && all_District["longitude"] == null) {
          continue;
        }
        double mallLatitude = double.parse(all_District["latitude"]);
        double mallLongitude = double.parse(all_District["longitude"]);

        double distanceInMeters = await Geolocator.distanceBetween(
          mallLatitude,
          mallLongitude,
          targetLatitude,
          targetLongitude,
        );
        // print("miters    ${distanceInMeters}");

        print("${all_District["name_en"]} - Distance meter: $distanceInMeters");

        if (distanceInMeters < 5) {
          findDistrict.add(all_District);
        }
      }
    }
    if (findDistrict.isNotEmpty) {
      List storeDivisonData = await Helper().getDivisionData();
      findDistrict.forEach((element) {
        storeDivisonData.forEach((divison) {
          if (element['division_id'] == divison['id'] && findDisivion.isEmpty) {
            findDisivion.add(divison);
          }
        });
      });
    }

    print("uuuuuuuuuuuuuuuuuuuu123u");
    print(findUpazila);
    print(findDistrict);
    print(findDisivion);
    if (findDisivion.isEmpty) {
      AllService().tost("Location Not Match");
    }
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
          "New Field Visit Report",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKeyVisitReport,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: SizedBox(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedOffice,
                    onChanged: (newValue) {
                      setState(() {
                        selectedOffice = newValue;
                        print(selectedOffice);
                      });
                    },
                    items: [
                      'DC/DDLG Office',
                      'UNO Office',
                      'UP Office',
                      'Other Office',
                    ].map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Select Office',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Select Office';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  width: 330.w,
                  height: 40.h,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0.r),
                        ),
                        backgroundColor: const Color.fromARGB(255, 14, 87, 109),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        // Initialize location
                        await initLocation();
                        updateMap();

                        // calculateDistancetry(targetLatitude, targetLongitude);

                        setState(() {
                          isLoading = false;
                        });
                      },
                      child: isLoading
                          ? CircularProgressIndicator() // Show the indicator when loading
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.location_disabled_sharp,
                                      color: Colors.white,
                                    )),
                                const Text(
                                  "Detect Current Location",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                ),
              ),
              // ElevatedButton(
              //     onPressed: () async {
              //       List storeUnionData = await Helper().getUnionData();
              //       print(storeUnionData);

              //     },
              //     child: Text("aaa")),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "My Location ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    Text(
                      'Latitude: ${targetLatitude}, Longitude: ${targetLongitude}',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: 150,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      mapControllerCompleter.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        targetLatitude,
                        targetLongitude,
                      ),
                      zoom: 14.0,
                    ),
                    markers: currentLocation != null
                        ? {
                            Marker(
                              markerId: MarkerId("MyLocation"),
                              position: LatLng(
                                targetLatitude,
                                targetLongitude,
                              ),
                              infoWindow: InfoWindow(title: "My Location"),
                            ),
                          }
                        : {},
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0.w, right: 20.0.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Field Visit Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.of(context).pushNamed(ChangeLocation.pageName);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 120.0.w,
                        height: 28.0.h,
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color.fromARGB(255, 177, 94, 88)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w),
                          child: Text(
                            "Change Location",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                    // SizedBox(
                    //   width: 150.w,
                    //   height: 30.h,
                    //   child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(7.0.r),
                    //           ),
                    //           backgroundColor: Color(0xFF69930C)),
                    //       onPressed: () async {},
                    //       child: const Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             'Change Location',
                    //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    //           ),
                    //         ],
                    //       )),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.0.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                child: Column(
                  children: [
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       width: 160.0.w,
                    //       child: DropdownButtonFormField<String>(
                    //         isExpanded: true,
                    //         value: selectedOffice,
                    //         onChanged: (newValue) {
                    //           setState(() {
                    //             selectedOffice = newValue;
                    //             print(selectedOffice);
                    //           });
                    //         },
                    //         items: [
                    //           'DC/DDLG Office',
                    //           'UNO Office',
                    //           'UP Office',
                    //           'Other Office',
                    //         ].map<DropdownMenuItem<String>>((item) {
                    //           return DropdownMenuItem<String>(
                    //             value: item,
                    //             child: Text(item),
                    //           );
                    //         }).toList(),
                    //         decoration: const InputDecoration(
                    //           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    //           border: OutlineInputBorder(
                    //             borderSide: BorderSide(color: Colors.black),
                    //           ),
                    //           labelText: 'Select Office',
                    //         ),
                    //         validator: (value) {
                    //           if (value == null || value.isEmpty) {
                    //             return 'Please Select Office';
                    //           }
                    //           return null;
                    //         },
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     SizedBox(
                    //       height: 42.0.h,
                    //       width: 160.0.w,
                    //       child: GestureDetector(
                    //         onTap: () => _selectDate(context),
                    //         child: AbsorbPointer(
                    //           child: TextField(
                    //             readOnly: true,
                    //             controller: dateController,
                    //             decoration: const InputDecoration(
                    //               enabledBorder: OutlineInputBorder(
                    //                 borderSide: BorderSide(width: 1, color: Colors.black),
                    //               ),
                    //               hintText: "Visit Date",
                    //               contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    //               suffixIcon: Icon(Icons.calendar_today),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),

                    // SizedBox(
                    //   height: 10,
                    // ),
                    Row(
                      children: [
                        Visibility(
                          visible: findDisivion.isNotEmpty,
                          child: SizedBox(
                            width: 160.0.w,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedDivision ?? (findDisivion.isNotEmpty == true ? findDisivion[0]['name_en'] : null),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedDivision = newValue!;
                                  print("divisionnnnnnnnnnnnnnnnnnn");
                                  print(selectedDivision);
                                  selectedDistrict = null;
                                });
                              },
                              items: (findDisivion ?? []).map<DropdownMenuItem<String>>((item) {
                                return DropdownMenuItem<String>(
                                  value: item['name_en'],
                                  child: Text(item['name_en'] ?? ''),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                labelText: 'Select Division',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: findDistrict.isNotEmpty,
                          child: SizedBox(
                            width: 160.0.w,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedDistrict ?? (findDistrict.isNotEmpty == true ? findDistrict[0]['name_en'] : null),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedDistrict = newValue!;
                                  print("divisionnnnnnnnnnnnnnnnnnn");
                                  print(selectedDistrict);
                                  selectedDistrict = null;
                                });
                              },
                              items: (findDistrict ?? []).map<DropdownMenuItem<String>>((item) {
                                return DropdownMenuItem<String>(
                                  value: item['name_en'],
                                  child: Text(item['name_en'] ?? ''),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                labelText: 'Select DIstrict',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Row(
                      children: [
                        Visibility(
                          visible: findUpazila.isNotEmpty,
                          child: SizedBox(
                            width: 160.0.w,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedUpazila ?? (findUpazila.isNotEmpty == true ? findUpazila[0]['name_en'] : null),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedUpazila = newValue!;
                                  print("divisionnnnnnnnnnnnnnnnnnn");
                                  print(selectedUpazila);
                                  selectedUpazila = null;
                                });
                              },
                              items: (findUpazila ?? []).map<DropdownMenuItem<String>>((item) {
                                return DropdownMenuItem<String>(
                                  value: item['name_en'],
                                  child: Text(item['name_en'] ?? ''),
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
                        SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: findUnion.isNotEmpty,
                          child: SizedBox(
                            width: 160.0.w,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedUion ?? (findUnion.isNotEmpty == true ? findUnion[0]['name_en'] : null),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedUion = newValue!;
                                  print("divisionnnnnnnnnnnnnnnnnnn");
                                  print(selectedUion);
                                  selectedUion = null;
                                });
                              },
                              items: (findUnion ?? []).map<DropdownMenuItem<String>>((item) {
                                return DropdownMenuItem<String>(
                                  value: item['name_en'],
                                  child: Text(item['name_en'] ?? ''),
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
                    // SizedBox(
                    //   height: 10,
                    // ),
                    BlocConsumer<LocationBloc, LocationState>(
                        bloc: locationBloc,
                        listenWhen: (previous, current) => current is LocationActionState,
                        buildWhen: (previous, current) => current is! LocationActionState,
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          if (state is LocationLoadingState) {
                            return Container(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (state is LocationSuccessState) {
                            globalvalue++;
                            if (globalvalue == 1) {
                              division_id = state.division.isEmpty ? "" : state.division[0].divisionId.toString();
                              district_id = state.district.isEmpty ? "" : state.district[0].districtId.toString();
                              if (state.upazila.isNotEmpty) {
                                upazila_id = state.upazila[0].upazilaId.toString();
                              }
                              if (state.union.isNotEmpty) {
                                union_id = state.union[0].unionId.toString();
                              }
                            }

                            // print("oooooooooooooooo${state.district[0].districtId}");

                            // if (state.upazila.isEmpty) {
                            //   print("afikkkkkkkkkkkkk");
                            // }
                            // upazila_id = state.upazila[0].upazilaId.toString();
                            // union_id = state.union[0].unionId.toString();
                            if (state.division.isEmpty) {
                              AllService().tost("Location not match");
                            }

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Visibility(
                                      visible: state.division.isNotEmpty,
                                      child: SizedBox(
                                        width: 160.0.w,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          value: selectedDivision ??
                                              (state.division?.isNotEmpty == true ? state.division![0].divisionName : null),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedDivision = newValue!;
                                              print("divisionnnnnnnnnnnnnnnnnnn");
                                              print(selectedDivision);
                                              selectedDistrict = null;
                                            });
                                          },
                                          items: (state.division ?? []).map<DropdownMenuItem<String>>((item) {
                                            return DropdownMenuItem<String>(
                                              value: item.divisionName,
                                              child: Text(item.divisionName! ?? ''),
                                            );
                                          }).toList(),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            labelText: 'Select Division',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Visibility(
                                      visible: state.district.isNotEmpty,
                                      child: SizedBox(
                                        width: 160.0.w,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          value: selectedDistrict ??
                                              (state.district?.isNotEmpty == true ? state.district![0].districtName : null),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedDistrict = newValue!;
                                              print(selectedDistrict);
                                              state.district.forEach((element) {
                                                if (selectedDistrict == element.districtName) {
                                                  setState(() {
                                                    district_id = element.districtId!.toString();
                                                  });
                                                }
                                              });
                                              selectedUpazila = null;
                                            });
                                          },
                                          items: (state.district ?? []).map<DropdownMenuItem<String>>((item) {
                                            return DropdownMenuItem<String>(
                                              value: item.districtName,
                                              child: Text(item.districtName ?? ''),
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
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Visibility(
                                      visible: state.upazila.isNotEmpty,
                                      child: SizedBox(
                                        width: 160.0.w,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          value: selectedUpazila ??
                                              (state.upazila?.isNotEmpty == true ? state.upazila![0].upazilaName : null),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedUpazila = newValue!;
                                              selectedUion = null;
                                              state.upazila.forEach((element) {
                                                if (selectedUpazila == element.upazilaName) {
                                                  setState(() {
                                                    upazila_id = element.upazilaId!.toString();
                                                  });
                                                }
                                              });
                                            });
                                          },
                                          items: (state.upazila ?? []).map<DropdownMenuItem<String>>((item) {
                                            return DropdownMenuItem<String>(
                                              value: item.upazilaName,
                                              child: Text(item.upazilaName ?? ''),
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
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Visibility(
                                      visible: state.union.isNotEmpty,
                                      child: SizedBox(
                                        width: 160.0.w,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          value: selectedUion ??
                                              (state.union?.isNotEmpty == true ? state.union![0].unionName : null),
                                          onChanged: (newValue) {
                                            setState(() {
                                              selectedUion = newValue!;
                                              state.union.forEach((element) {
                                                if (selectedUion == element.unionName) {
                                                  setState(() {
                                                    union_id = element.unionId!.toString();
                                                  });
                                                }
                                              });
                                            });
                                          },
                                          items: (state.union ?? []).map<DropdownMenuItem<String>>((item) {
                                            return DropdownMenuItem<String>(
                                              value: item.unionName,
                                              child: Text(item.unionName ?? ''),
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
                                SizedBox(
                                  height: 10,
                                ),

                                // SizedBox()
                              ],
                            );
                          }
                          return Container();
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 20.0.w),
                  child: SizedBox(
                    height: 50.0.h,
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          readOnly: true,
                          controller: dateController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.black),
                            ),
                            hintText: "Visit Date",
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: 15.0.h,
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 10.0.w, right: 20.0.w),
              //   child: SizedBox(
              //       height: 150.0.h,
              //       child: TextField(
              //         controller: visit_dateControler,
              //         maxLines: 300, // Set to null for an unlimited number of lines
              //         decoration: InputDecoration(
              //           floatingLabelBehavior: FloatingLabelBehavior.always,
              //           border: OutlineInputBorder(),
              //           hintText: 'Visit Purposesss',
              //         ),
              //       )),
              // ),
              Padding(
                padding: EdgeInsets.only(left: 10.0.w, right: 20.0.w),
                child: SizedBox(
                    height: 120.0.h,
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Visit Purposes',
                          floatingLabelBehavior: FloatingLabelBehavior.always),
                      controller: visit_dateControler,
                      maxLines: 3, // Set to null for an unlimited number of lines

                      validator: (value) {
                        if (value!.length > 255) {
                          return 'please enter less than 256 characters';
                        } else if (value.isEmpty) {
                          return 'Please Enter Visit Purposes';
                        }
                        return null;
                      },
                    )),
              ),
              SizedBox(
                height: 15.0.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0.w, right: 20.0.w),
                child: Row(
                  children: [
                    const Text("Field Photo"),
                    SizedBox(
                      width: 30.0.w,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await getImage(ImageSource.camera);

                        setState(() {});
                      },
                      child: Icon(
                        Icons.photo_camera,
                        size: 40,
                        color: Color.fromARGB(255, 3, 78, 71),
                      ),
                    ),
                    image == null ? Container() : SizedBox(height: 40, width: 40, child: Image.file(File(image!.path)))
                    // image(
                    //   // Adjust the radius as needed
                    //   backgroundImage: FileImage(File(image!.path)),
                    // ),
                  ],
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
                                backgroundColor: Color(0xFF69930C)),
                            onPressed: () async {
                              final connectivityResult = await (Connectivity().checkConnectivity());
                              if (connectivityResult == ConnectivityResult.mobile ||
                                  connectivityResult == ConnectivityResult.wifi ||
                                  connectivityResult == ConnectivityResult.ethernet) {
                                if (_formKeyVisitReport.currentState!.validate()) {
                                  if (targetLatitude == 0.0 && targetLongitude == 0.0) {
                                    return AllService().tost("Select Current Location");
                                  } else if (visit_dateControler.text.isEmpty) {
                                    return AllService().tost("Visit Purpose Input Required");
                                  } else if (image == null) {
                                    return AllService().tost("Upload Image Required");
                                  }
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  Map allReportData = {
                                    "divistion_id": division_id,
                                    "district_id": district_id,
                                    "upazila_id": upazila_id,
                                    "union_id": union_id,
                                    "latitude": targetLatitude,
                                    "longitude": targetLongitude,
                                    "visit_date": dateController.text,
                                    "visit_purpose": visit_dateControler.text,
                                    "office_type": selectedOffice
                                  };
                                  // print("ooooooooooooooooooooooooooooooooooooootttttt");
                                  print(allReportData);
                                  print(File(image!.path));

                                  File? compressedImage = await compressImage(image!.path);

                                  // if (compressedImage != null) {
                                  //   int compressedSize = await compressedImage.length();
                                  //   print('Compressed Image Size: ${compressedSize / 1024} KB');
                                  // } else {
                                  //   print('Image compression failed or original image size is already within the target range.');
                                  // }

                                  Map dataResponse = await Repositores().uploadDataAndImage(
                                      File(compressedImage!.path),
                                      division_id,
                                      district_id,
                                      upazila_id,
                                      union_id,
                                      targetLatitude.toString(),
                                      targetLongitude.toString(),
                                      dateController.text,
                                      visit_dateControler.text,
                                      selectedOffice.toString());
                                  print("ooooooooooooooooooooooooooooooooooooootttttt");
                                  print(dataResponse);

                                  if (dataResponse['status'] == 200) {
                                    await QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      text: "Visit Report Added successfully",
                                    );
                                    await Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return FieldFindingCreatePage(
                                            id: dataResponse['data']['id'].toString(),
                                          );
                                        },
                                      ),
                                    );
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } else {
                                    await QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      text: "Visit Report Add Faild",
                                    );
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              } else {
                                AllService().internetCheckDialog(context);
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Next',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                    ),
              SizedBox(
                height: 15.0.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  XFile? image;
  File? compressedImage;

  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

  //show popup dialog
  void PictureUploadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: Text('Please choose media to select'),
              content: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF078669)),
                      onPressed: () async {
                        await getImage(ImageSource.gallery);
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.image,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'From Gallery',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF078669)),
                      onPressed: () async {
                        await getImage(ImageSource.camera);
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'From Camera',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (image != null)
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 40, // Adjust the radius as needed
                            backgroundImage: FileImage(File(image!.path)),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     SizedBox(
                          //       width: 100.w,
                          //       child: ElevatedButton(
                          //         style: ElevatedButton.styleFrom(
                          //           backgroundColor: Color(0xFF078669),
                          //         ),
                          //         onPressed: () async {
                          //           compressedImage = await compressImage(image!.path);
                          //           print("aaaaaaaaaaaaaa");
                          //           print(compressedImage!.path);
                          //           // image = null;
                          //           // File? compressedImage = await compressImage(image!.path);

                          //           // if (compressedImage != null) {
                          //           //   print("aaaaaaaaaaaaaa");
                          //           //   print(compressedImage.path);
                          //           // } else {
                          //           //   print("Image compression failed");
                          //           // }
                          //           setState(() {});
                          //           Navigator.of(context).pop();
                          //         },
                          //         child: Text(
                          //           'Add',
                          //           style: TextStyle(color: Colors.white),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Uint8List? image123;

  // Future<File?> compressImage(String imagePath) async {
  //   try {
  //     File originalImage = File(imagePath);
  //     int originalSize = await originalImage.length();

  //     // Set your target size in KB
  //     int targetSizeKB = 380;

  //     int quality = 80; // Initial quality setting

  //     while (originalSize > targetSizeKB * 1024 && quality >= 10) {
  //       Uint8List? compressedImageBytes = await FlutterImageCompress.compressWithFile(
  //         imagePath,
  //         minHeight: 1920,
  //         minWidth: 1080,
  //         quality: quality,
  //       );

  //       if (compressedImageBytes == null) {
  //         // Handle the case where compression failed
  //         throw Exception("Image compression failed");
  //       }

  //       Directory tempDir = await getTemporaryDirectory();
  //       File compressedImage = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
  //       await compressedImage.writeAsBytes(compressedImageBytes.toList());

  //       int compressedSize = await compressedImage.length();

  //       print('Quality: $quality');
  //       print('Compressed Image Size: ${compressedSize / 1024} KB');

  //       if (compressedSize > targetSizeKB * 1024) {
  //         // Reduce quality for the next iteration
  //         quality -= 10;
  //       } else {
  //         // If compressed size is within the target range, return the compressed image
  //         return compressedImage;
  //       }
  //     }

  //     // If the loop completes and no suitable compressed image is found, return null
  //     return null;
  //   } catch (e) {
  //     print('Error compressing image: $e');
  //     return null;
  //   }
  // }

  Uint8List? image123;
  Future<File> compressImage(String imagePath) async {
    File originalImage = File(imagePath);
    int originalSize = await originalImage.length();

    Uint8List? compressedImageBytes = await FlutterImageCompress.compressWithFile(
      imagePath,
      minHeight: 1920,
      minWidth: 1080,
      quality: 90,
    );

    if (compressedImageBytes == null) {
      // Handle the case where compression failed
      // You might want to return the original image or show an error message
      throw Exception("Image compression failed");
    }

    Directory tempDir = await getTemporaryDirectory();
    File compressedImage = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await compressedImage.writeAsBytes(compressedImageBytes.toList());

    int compressedSize = await compressedImage.length();

    print('Original Image Size: ${originalSize / 1024} KB');
    print('Compressed Image Size: ${compressedSize / 1024} KB');

    return compressedImage;
  }
}
