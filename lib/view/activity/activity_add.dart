import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/activity_bloc/activity_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/view/home/homepage.dart';

class ActivityUpdate extends StatefulWidget {
  static const pageName = 'activity_update';
  const ActivityUpdate({super.key});

  @override
  State<ActivityUpdate> createState() => _ActivityUpdateState();
}

class _ActivityUpdateState extends State<ActivityUpdate> {
  DateTime? selectedDate;
  String? selectedDivision;
  String? selectedDistrict;
  String? selectedUpazila;
  String? selectedUion;
  DateTime? fromSelectedDate;
  DateTime? toSelectedDate;

  //data submit variable
  String activity_info_setting_id = '';
  String location_id = '';
  String division = '';
  String district = '';
  String upazila = '';
  String union = '';
  String activity_from_date = '';
  String activity_to_date = '';
  List Activityalldata = [];
  bool _isLoading = false;

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController maleController = TextEditingController();
  TextEditingController femaleController = TextEditingController();
  TextEditingController totalmemberController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void updateTotal() {
    int maleCount = int.tryParse(maleController.text) ?? 0;
    int femaleCount = int.tryParse(femaleController.text) ?? 0;
    int total = maleCount + femaleCount;
    totalmemberController.text = total.toString();
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

  final ActivityBloc activityBloc = ActivityBloc();

  @override
  void initState() {
    activityBloc.add(ActivityInitialEvent());
    super.initState();
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
          title: const Text(
            "Activity Update",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              BlocConsumer<ActivityBloc, ActivityState>(
                bloc: activityBloc,
                listenWhen: (previous, current) => current is ActivityActionState,
                buildWhen: (previous, current) => current is! ActivityActionState,
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is ActivityLoadingState) {
                    return Container(
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is ActivitySuccessState) {
                    print("all activity");
                    print(state.ActivityDetailsData);
                    Activityalldata = state.ActivityDetailsData;

                    return Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2, right: 2),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            isDense: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                labelText: 'Select Activity'),
                            items: state.data
                                .map((activity) => DropdownMenuItem(
                                      child: Container(
                                        width: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(color: Colors.grey, width: 1),
                                          ),
                                        ),
                                        child: Text(
                                          activity.name,
                                        ),
                                      ),
                                      value: activity.id.toString(),
                                    ))
                                .toList(),
                            onChanged: (String? selectedValue) {
                              if (selectedValue != null) {
                                int selectedId = int.parse(selectedValue);
                                print("Selected Name: ${state.data.firstWhere((activity) => activity.id == selectedId).name}");
                                activity_info_setting_id = selectedId.toString();
                                print(activity_info_setting_id);
                                activityBloc.add(ActivityClickEvent(id: int.tryParse(selectedId.toString())));
                              }
                            },
                            hint: Text("Select Activity"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Select Activity';
                              }
                              return null;
                            },
                          ),
                        ),
                        ...List.generate(state.ActivityDetailsData.length, (index) {
                          location_id = state.ActivityDetailsData[index].locationLevel.id.toString();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      "Activity by Component",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "Activity Type",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        color: Colors.grey,
                                        child: Text(state.ActivityDetailsData[index].component.name)),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        color: Colors.grey,
                                        child: Text(state.ActivityDetailsData[index].activityType.name)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0.h,
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Activity Location Level",
                                    style: TextStyle(fontSize: 15),
                                  )),
                              SizedBox(
                                height: 5.0.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                        alignment: Alignment.center,
                                        width: 120.0.w,
                                        height: 30,
                                        color: Colors.grey,
                                        child: Text(state.ActivityDetailsData[index].locationLevel.name)),
                                  ),
                                  Expanded(flex: 1, child: SizedBox.shrink()),
                                  Expanded(flex: 6, child: SizedBox.shrink()),
                                ],
                              ),
                              SizedBox(
                                height: 5.0.h,
                              ),
                              Text(
                                "Field Visit Locaiton",
                                style: TextStyle(fontSize: 16.0.sp, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10.0.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 160.0.w,
                                    child: DropdownButtonFormField<String>(
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
                                          selectedUpazila = null;
                                          selectedUion = null;
                                          print(selectedDivision);
                                          for (var entry in state.ActivityDetailsData[index].divisions) {
                                            if (selectedDivision == entry.nameEn) {
                                              print("selectedDistricttttttttttttt${entry.id.runtimeType}");
                                              print(entry.id);
                                              division = entry.id.toString();
                                              activityBloc.add(DistrictClickEvent(id: entry.id));
                                            }
                                          }
                                          // trainingDataBloc
                                          //     .add(DistrictClickEvent(id: int.parse(selectedDivision.toString())));
                                        });
                                      },
                                      items: (state.ActivityDetailsData[index].divisions ?? [])
                                          .map<DropdownMenuItem<String>>((item) {
                                        return DropdownMenuItem<String>(
                                          value: item.nameEn,
                                          child: Text(item.nameEn),
                                        );
                                      }).toList(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select division';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: state.ActivityDetailsData[index].locationLevel.id == 2 ||
                                        state.ActivityDetailsData[index].locationLevel.id == 4 ||
                                        state.ActivityDetailsData[index].locationLevel.id == 3,
                                    child: SizedBox(
                                      width: 160.0.w,
                                      child: DropdownButtonFormField<String>(
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            labelText: 'Select District'),
                                        value: selectedDistrict,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedDistrict = newValue;
                                            selectedUpazila = null;
                                            selectedUion = null;

                                            print(selectedDistrict);
                                            for (var entry in state.district) {
                                              if (selectedDistrict == entry['name_en']) {
                                                district = entry['id'].toString();
                                                print("selectedDistricttttttttttttt${entry['id']} ${entry['name_en']}");
                                                activityBloc.add(UpazilaClickEvent(id: entry['id']));
                                              }
                                            }
                                          });
                                        },
                                        items: (state.district.isNotEmpty ? state.district : [])
                                            .map<DropdownMenuItem<String>>((item) {
                                          return DropdownMenuItem<String>(
                                            value: item['name_en'],
                                            child: Text(item['name_en']),
                                          );
                                        }).toList(),
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
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: state.ActivityDetailsData[index].locationLevel.id == 4 ||
                                        state.ActivityDetailsData[index].locationLevel.id == 3,
                                    child: SizedBox(
                                      height: 55.0.h,
                                      width: 160.0.w,
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            labelText: 'Select Upazila'),
                                        value: selectedUpazila,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedUpazila = newValue;
                                            selectedUion = null;

                                            for (var entry in state.upazila) {
                                              if (selectedUpazila == entry['name_en']) {
                                                upazila = entry['id'].toString();
                                                print("selecteUninonttttttttttttt${entry['id']} ${entry['name_bn']}");
                                                activityBloc.add(UnionClickEvent(id: entry['id']));
                                              }
                                            }
                                          });
                                        },
                                        items:
                                            (state.upazila.isNotEmpty ? state.upazila : []).map<DropdownMenuItem<String>>((item) {
                                          return DropdownMenuItem<String>(
                                            value: item['name_en'],
                                            child: Text(
                                              item['name_en'],
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                            ),
                                          );
                                        }).toList(),
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
                                    visible: state.ActivityDetailsData[index].locationLevel.id == 4,
                                    child: SizedBox(
                                      height: 55.0.h,
                                      width: 160.0.w,
                                      child: DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            labelText: 'Select Union'),
                                        value: selectedUion,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedUion = newValue;

                                            for (var entry in state.union) {
                                              if (selectedUion == entry['name_en']) {
                                                union = entry['id'].toString();
                                              }
                                            }
                                          });
                                        },
                                        items: (state.union.isNotEmpty ? state.union : []).map<DropdownMenuItem<String>>((item) {
                                          return DropdownMenuItem<String>(
                                            value: item['name_en'],
                                            child: Text(item['name_en']),
                                          );
                                        }).toList(),
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
                          );
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Activity Date :",
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
                      ],
                    );
                  }
                  return Container();
                },
              ),
              SizedBox(
                height: 10.0.h,
              ),
              Text(
                "Activity Venue :",
                style: TextStyle(fontSize: 16.0.sp, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0.h,
              ),
              TextFormField(
                maxLines: 1,
                controller: venueController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Sample Venue Name',
                    floatingLabelBehavior: FloatingLabelBehavior.always),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Venue Name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0.h,
              ),
              Text(
                "Participants",
                style: TextStyle(fontSize: 15.0.sp, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 40.0.h,
                    width: 60.0.w,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: maleController,
                      onChanged: (_) => updateTotal(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(),
                        labelText: 'Male',
                        labelStyle: TextStyle(fontSize: 12),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.blue, strokeAlign: 50),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40.0.h,
                    width: 60.0.w,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: femaleController,
                      onChanged: (_) => updateTotal(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(),
                        labelText: 'Female',
                        labelStyle: TextStyle(fontSize: 12),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.blue, strokeAlign: 50),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40.0.h,
                    width: 60.0.w,
                    child: TextFormField(
                      controller: totalmemberController,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Total',
                          labelStyle: TextStyle(fontSize: 12),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.blue, strokeAlign: 50),
                          ),
                          contentPadding: EdgeInsets.only(left: 10)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Empty';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0.h,
              ),
              SizedBox(
                height: 10.0.h,
              ),
              SizedBox(
                  height: 80.0.h,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Remarks (if any)',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                    controller: remarkController,
                    maxLines: 300, // Set to null for an unlimited number of lines

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Remarks Field';
                      }
                      return null;
                    },
                  )),
              SizedBox(
                height: 15.0.h,
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
                              backgroundColor: Color.fromARGB(255, 39, 172, 72),
                            ),
                            onPressed: () async {
                              final connectivityResult = await (Connectivity().checkConnectivity());
                              if (connectivityResult == ConnectivityResult.mobile ||
                                  connectivityResult == ConnectivityResult.wifi ||
                                  connectivityResult == ConnectivityResult.ethernet) {
                                if (_formKey.currentState!.validate()) {
                                  if (Activityalldata.isEmpty) {
                                    AllService().tost("Select Avtivity is required");
                                  } else if (fromDateController.text.isEmpty && toDateController.text.isEmpty) {
                                    AllService().tost('Date is required');
                                  } else {
                                    Map activityBody = {
                                      "activity_info_setting_id": activity_info_setting_id,
                                      "location_id": location_id,
                                      "division": division,
                                      "district": district,
                                      "upazila": upazila,
                                      "union": union,
                                      "activity_from_date": fromDateController.text,
                                      "activity_to_date": toDateController.text,
                                      "activity_venue": venueController.text,
                                      "total_male": maleController.text,
                                      "total_female": femaleController.text,
                                      "total_participant": totalmemberController.text,
                                      "remark": remarkController.text
                                    };
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    print(activityBody);
                                    Map activityData = await Repositores().ActivityDataSubmitApi(jsonEncode(activityBody));
                                    print("apiiiiiiiiiiiiii $activityData");
                                    if (activityData['status'] == 200) {
                                      await QuickAlert.show(
                                        context: context,
                                        type: QuickAlertType.success,
                                        text: "Activity Add Successfully !",
                                      );
                                      await Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(builder: (context) => Homepage()), (Route<dynamic> route) => false);
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
                                    // }
                                  }
                                  ;
                                }
                              } else {
                                AllService().internetCheckDialog(context);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
              SizedBox(
                height: 20,
              )
            ]),
          ),
        )));
  }
}
