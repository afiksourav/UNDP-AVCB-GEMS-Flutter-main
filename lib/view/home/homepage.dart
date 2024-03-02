import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:village_court_gems/bloc/All_Count_Bloc/all_count_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';

import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';

import 'package:village_court_gems/view/Profile/profile.dart';
import 'package:village_court_gems/view/Trainings/Trainings.dart';

import 'package:village_court_gems/view/activity/activity.dart';
import 'package:village_court_gems/view/activity/try.dart';
import 'package:village_court_gems/view/credential/login_page.dart';
import 'package:village_court_gems/view/field_visit_list/field_visit_list.dart';
import 'package:village_court_gems/view/field_visit_list/field_visit_try.dart';
import 'package:village_court_gems/view/activity/activity_add.dart';
import 'package:village_court_gems/view/Trainings/training_data_add&update.dart';
import 'package:village_court_gems/view/AACO/aaco_Info.dart';
import 'package:village_court_gems/view/visit_report/visit_report.dart';

class Homepage extends StatefulWidget {
  static const pageName = 'home';
  Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool status = false;
  bool _isLoadingLogout = false;

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

        print("locationnnnnnnnnnnnnnnnnnnnn");

        print(currentLocation!.latitude);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  final AllCountBloc countBloc = AllCountBloc();
  @override
  void initState() {
    countBloc.add(AllCountInitialEvent());
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/icons/idsdp_logo.png',
                width: 30,
                height: 24,
              ),
            ),
          ],
        ),
        title: const Text(
          "GEMS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                // print("aaaaaaaa");
                // dynamic token = await Helper().getUserToken();
                // print(token);
              },
              icon: Image.asset(
                'assets/icons/Frame 5.png',
                width: 30,
                height: 24,
              )),
          IconButton(
            onPressed: () async {
              final connectivityResult = await (Connectivity().checkConnectivity());
              if (connectivityResult == ConnectivityResult.mobile ||
                  connectivityResult == ConnectivityResult.wifi ||
                  connectivityResult == ConnectivityResult.ethernet) {
                await Navigator.of(context).pushNamed(ProfilePage.pageName);
              } else {
                AllService().internetCheckDialog(context);
              }
            },
            icon: Image.asset(
              'assets/icons/Ellipse 1.png',
              width: 30,
              height: 24,
            ),
          ),
          _isLoadingLogout
              ? Center(
                  child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    backgroundColor: Color(0xFF078669),
                    strokeWidth: 6,
                  ),
                ))
              : IconButton(
                  onPressed: () async {
                    final connectivityResult = await (Connectivity().checkConnectivity());
                    if (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi ||
                        connectivityResult == ConnectivityResult.ethernet) {
                      setState(() {
                        _isLoadingLogout = true;
                      });
                      Map logoutRespose = await Repositores().LogoutAPi();
                      print(logoutRespose);

                      if (logoutRespose['status'] == 200) {
                        await Helper().deleteToken();
                        await Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
                        setState(() {
                          _isLoadingLogout = false;
                        });
                      }
                    } else {
                      AllService().internetCheckDialog(context);
                      setState(() {
                        _isLoadingLogout = false;
                      });
                    }
                  },
                  icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // ElevatedButton(
            //   onPressed: () async {
            //     Map a = await Repositores().trainingInfoSettingApi();
            //     print("aaaaaaaaaaaaaaaa");
            //     print(a['status']);
            //   },
            //   child: Text("data"),
            // ),
            // Text('Phone Number: $g_Token'),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dashboard",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            BlocConsumer<AllCountBloc, AllCountState>(
                bloc: countBloc,
                listenWhen: (previous, current) => current is AllCountActionState,
                buildWhen: (previous, current) => current is! AllCountActionState,
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is AllCountLoadingState) {
                    return Container(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  final connectivityResult = await (Connectivity().checkConnectivity());
                                  if (connectivityResult == ConnectivityResult.mobile ||
                                      connectivityResult == ConnectivityResult.wifi ||
                                      connectivityResult == ConnectivityResult.ethernet) {
                                    await Navigator.of(context).pushNamed(ActivityShow.pageName);
                                  } else {
                                    AllService().internetCheckDialog(context);
                                  }

                                  // var a = await Repositores().ActivityApi();
                                  // print(a);
                                },
                                child: Container(
                                  // width: 190,
                                  height: 70,
                                  color: Color(0xFF146318),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, left: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Activites",
                                                style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                              ),
                                              Text(
                                                "",
                                                style: TextStyle(color: Colors.white, fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                                            child: Image.asset(
                                              'assets/icons/Group 12.png',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(flex: 1, child: SizedBox.shrink()),
                            Expanded(
                              flex: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  final connectivityResult = await (Connectivity().checkConnectivity());
                                  if (connectivityResult == ConnectivityResult.mobile ||
                                      connectivityResult == ConnectivityResult.wifi ||
                                      connectivityResult == ConnectivityResult.ethernet) {
                                    await Navigator.of(context).pushNamed(TrainingsPage.pageName);
                                  } else {
                                    AllService().internetCheckDialog(context);
                                  }
                                },
                                child: Container(
                                  // width: 190,
                                  height: 70,
                                  color: Color(0xFF0C617E),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, left: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Trainings",
                                                style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                              ),
                                              Text(
                                                "",
                                                style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                                            child: Image.asset(
                                              'assets/icons/Trainings.png',
                                              // width: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                          children: [
                            Expanded(
                              flex: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  final connectivityResult = await (Connectivity().checkConnectivity());
                                  if (connectivityResult == ConnectivityResult.mobile ||
                                      connectivityResult == ConnectivityResult.wifi ||
                                      connectivityResult == ConnectivityResult.ethernet) {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return FieldVisitListPage();
                                        },
                                      ),
                                    );
                                  } else {
                                    AllService().internetCheckDialog(context);
                                  }
                                  // await Navigator.of(context).pushNamed(TrainingsDetailsPage.pageName);
                                },
                                child: Container(
                                  // width: 190,
                                  height: 70,
                                  color: Color(0xFF69930C),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, left: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Field Visits",
                                                style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                              ),
                                              Text(
                                                "",
                                                style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                                            child: Image.asset(
                                              'assets/icons/1320336-200.png',
                                              // width: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(flex: 1, child: SizedBox.shrink()),
                            Expanded(
                              flex: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  // await Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) {
                                  //       return MapSample();
                                  //     },
                                  //   ),
                                  // );
                                  await Navigator.of(context).pushNamed(AACO_Info.pageName);
                                },
                                child: Container(
                                  // width: 190,
                                  height: 70,
                                  color: Color(0xFFE26737),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, left: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "AACO",
                                                style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                              ),
                                              Text(
                                                "",
                                                style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                                            child: Image.asset(
                                              'assets/icons/Vector.png',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ));
                  } else if (state is AllCountSuccessState) {
                    print("rrrrrrrrrrrrrrrr");
                    print(state.countModel!.accoInfoCount);
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  final connectivityResult = await (Connectivity().checkConnectivity());
                                  if (connectivityResult == ConnectivityResult.mobile ||
                                      connectivityResult == ConnectivityResult.wifi ||
                                      connectivityResult == ConnectivityResult.ethernet) {
                                    await Navigator.of(context).pushNamed(ActivityShow.pageName);
                                  } else {
                                    AllService().internetCheckDialog(context);
                                  }

                                  // var a = await Repositores().ActivityApi();
                                  // print(a);
                                },
                                child: Container(
                                  // width: 190,
                                  height: 70,
                                  color: Color(0xFF146318),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, left: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Activites",
                                                style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                              ),
                                              Text(
                                                state.countModel!.activityInfoCount.toString(),
                                                style: TextStyle(color: Colors.white, fontSize: 18.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                                            child: Image.asset(
                                              'assets/icons/Group 12.png',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(flex: 1, child: SizedBox.shrink()),
                            Expanded(
                              flex: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  final connectivityResult = await (Connectivity().checkConnectivity());
                                  if (connectivityResult == ConnectivityResult.mobile ||
                                      connectivityResult == ConnectivityResult.wifi ||
                                      connectivityResult == ConnectivityResult.ethernet) {
                                    await Navigator.of(context).pushNamed(TrainingsPage.pageName);
                                  } else {
                                    AllService().internetCheckDialog(context);
                                  }
                                },
                                child: Container(
                                  // width: 190,
                                  height: 70,
                                  color: Color(0xFF0C617E),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, left: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Trainings",
                                                style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                              ),
                                              Text(
                                                state.countModel!.trainingInfoCount.toString(),
                                                style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                                            child: Image.asset(
                                              'assets/icons/Trainings.png',
                                              // width: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                          children: [
                            Expanded(
                              flex: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  final connectivityResult = await (Connectivity().checkConnectivity());
                                  if (connectivityResult == ConnectivityResult.mobile ||
                                      connectivityResult == ConnectivityResult.wifi ||
                                      connectivityResult == ConnectivityResult.ethernet) {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return FieldVisitListPage();
                                        },
                                      ),
                                    );
                                  } else {
                                    AllService().internetCheckDialog(context);
                                  }
                                  // await Navigator.of(context).pushNamed(TrainingsDetailsPage.pageName);
                                },
                                child: Container(
                                  // width: 190,
                                  height: 70,
                                  color: Color(0xFF69930C),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, left: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Field Visits",
                                                style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                              ),
                                              Text(
                                                state.countModel!.fieldVisitCount.toString(),
                                                style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                                            child: Image.asset(
                                              'assets/icons/1320336-200.png',
                                              // width: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(flex: 1, child: SizedBox.shrink()),
                            Expanded(
                              flex: 10,
                              child: GestureDetector(
                                onTap: () async {
                                  // await Navigator.of(context).push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) {
                                  //       return MapSample();
                                  //     },
                                  //   ),
                                  // );
                                  await Navigator.of(context).pushNamed(AACO_Info.pageName);
                                },
                                child: Container(
                                  // width: 190,
                                  height: 70,
                                  color: Color(0xFFE26737),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, left: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "AACO",
                                                style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                              ),
                                              Text(
                                                state.countModel!.accoInfoCount.toString(),
                                                style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                                            child: Image.asset(
                                              'assets/icons/Vector.png',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Container();
                }),

            // ElevatedButton(
            //     onPressed: () async {
            //       String a = await Helper().getUserToken();
            //       print(a);
            //     },
            //     child: Text("aa")),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: GestureDetector(
                    onTap: () async {
                      final connectivityResult = await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi ||
                          connectivityResult == ConnectivityResult.ethernet) {
                        print("internet on");
                        await Navigator.of(context).pushNamed(TrainingDataPage.pageName);
                      } else {
                        AllService().internetCheckDialog(context);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      // width: 190,
                      height: 70,
                      color: Color(0xFF00A651),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.0.w),
                              child: Text(
                                "Training Report",
                                style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                              child: Image.asset(
                                'assets/icons/5317268-200.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox.shrink()),
                Expanded(
                  flex: 10,
                  child: GestureDetector(
                    onTap: () async {
                      final connectivityResult = await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi ||
                          connectivityResult == ConnectivityResult.ethernet) {
                        await Navigator.of(context).pushNamed(ActivityUpdate.pageName);
                      } else {
                        AllService().internetCheckDialog(context);
                      }

                      //  await Navigator.of(context).pushNamed(VisitReport.pageName);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      // width: 190,
                      height: 70,
                      color: Color(0xFF00A651),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.0.w),
                              child: Text(
                                "Activity Report",
                                style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                              child: Image.asset(
                                'assets/icons/3860158-200.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                print("internet on");
                await Navigator.of(context).pushNamed(VisitReport.pageName);
              },
              child: Container(
                alignment: Alignment.center,
                // width: 190,
                height: 60,
                color: Color(0xFF00A651),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Field Visit Report",
                      style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Visits",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 5,
              child: Image.asset(
                'assets/icons/image 6.png',
                // width: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
