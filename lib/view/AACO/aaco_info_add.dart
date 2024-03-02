import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/AACO_info_add_bloc/aaco_info_add_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/view/home/homepage.dart';

class AACO_Info_Add extends StatefulWidget {
  static const pageName = 'AACO_Info_Add';
  const AACO_Info_Add({super.key});

  @override
  State<AACO_Info_Add> createState() => _AACO_Info_AddState();
}

class _AACO_Info_AddState extends State<AACO_Info_Add> {
  final AacoInfoAddBloc aacoInfoAddBloc = AacoInfoAddBloc();
  @override
  // ignore: override_on_non_overriding_member
  String district_id = '';
  String union_id = '';
  String upazila_id = '';
  String recruitment_status = '0';
  String acco_availiablity_status = '0';
  String apointment_date = '';
  String? selectedDivision;
  String? selectedDistrict;
  String? selectedUpazila;
  String? selectedUion;
  bool isYesCheckedR = false;
  bool isNoCheckedR = true;
  bool isYesCheckedA = false;
  bool isNoCheckedA = true;
  bool _isLoading = false;
  DateTime? fromSelectedDate;
  TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> _formAACOKey = GlobalKey<FormState>();

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
        dateController.text = DateFormat('dd/MM/yyyy').format(fromSelectedDate!);
      });
    }
  }

  void initState() {
    aacoInfoAddBloc.add(AacoInfoAddInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add AACO Informations",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Form(
        key: _formAACOKey,
        child: Padding(
          padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "AACO Location Area :",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  )),
              SizedBox(
                height: 10,
              ),
              BlocConsumer<AacoInfoAddBloc, AacoInfoAddState>(
                  bloc: aacoInfoAddBloc,
                  listenWhen: (previous, current) => current is AacoInfoAddActionState,
                  buildWhen: (previous, current) => current is! AacoInfoAddActionState,
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is AacoInfoAddLoadingState) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is AacoInfoAddSuccessState) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 55.0.h,
                                width: 160.0.w,
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  value: selectedDistrict,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedDistrict = newValue!;
                                      selectedUpazila = null;

                                      for (var entry in state.district) {
                                        if (selectedDistrict == entry.nameEn) {
                                          district_id = entry.id.toString();
                                          aacoInfoAddBloc.add(AacoUpazilaClickEvent(id: entry.id));
                                        }
                                      }
                                    });
                                  },
                                  items: state.district.map<DropdownMenuItem<String>>((item) {
                                    return DropdownMenuItem<String>(
                                      value: item.nameEn,
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select District';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 55.0.h,
                                width: 160.0.w,
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  value: selectedUpazila,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedUpazila = newValue!;
                                      selectedUion = null;
                                      for (var entry in state.upazila!) {
                                        // print(entry['name_en']);
                                        // print("selectedUpazilaaaaaaaaaaaa ${entry['id']}");
                                        if (selectedUpazila == entry['name_en']) {
                                          print("selectedUpazilaaaaaaaaaaaa ${entry['id']}");
                                          upazila_id = entry['id'].toString();
                                          aacoInfoAddBloc.add(AacoUnionClickEvent(id: entry['id']));
                                        }
                                      }
                                    });
                                  },
                                  items: (state.upazila ?? []).map<DropdownMenuItem<String>>((item) {
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
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 55.0.h,
                              width: 160.0.w,
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: selectedUion,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedUion = newValue!;

                                    for (var entry in state.union!) {
                                      if (selectedUion == entry['name_en']) {
                                        union_id = entry['id'].toString();
                                        print("selected union ${entry['id']}");
                                        // union = entry['id'].toString();
                                      }
                                    }
                                  });
                                },
                                items: (state.union ?? []).map<DropdownMenuItem<String>>((item) {
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
                      );
                    }
                    return Container();
                  }),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Appointment Date :",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0.sp),
                    ),
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  SizedBox(
                    height: 50.0.h,
                    child: GestureDetector(
                      onTap: () => _fromSelectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                            readOnly: true,
                            controller: dateController,
                            decoration: const InputDecoration(
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
                  SizedBox(
                    height: 15.0.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Recuitment Status :",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0.sp),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Yes',
                        style: TextStyle(fontSize: 16.0.sp),
                      ),
                      Checkbox(
                        activeColor: const Color.fromARGB(255, 4, 68, 121),
                        value: isYesCheckedR,
                        onChanged: (value) {
                          setState(() {
                            isYesCheckedR = true;

                            /// isYesCheckedR = value ?? false;
                            // Uncheck "No" when "Yes" is checked
                            if (isYesCheckedR) {
                              isNoCheckedR = false;
                            }
                            if (isYesCheckedR == true) {
                              recruitment_status = "1";
                            }
                          });
                        },
                      ),
                      Text(
                        'No',
                        style: TextStyle(fontSize: 16.0.sp),
                      ),
                      Checkbox(
                        activeColor: const Color.fromARGB(255, 4, 68, 121),
                        value: isNoCheckedR,
                        onChanged: (value) {
                          setState(() {
                            isNoCheckedR = true;
                            // isNoCheckedR = value ?? false;
                            // Uncheck "Yes" when "No" is checked
                            if (isNoCheckedR) {
                              isYesCheckedR = false;
                            }
                            if (isNoCheckedR == true) {
                              recruitment_status = "0";
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "Availabillity Status :",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0.sp),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Yes',
                        style: TextStyle(fontSize: 16.0.sp),
                      ),
                      Checkbox(
                        activeColor: const Color.fromARGB(255, 4, 68, 121),
                        value: isYesCheckedA,
                        onChanged: (value) {
                          setState(() {
                            // isYesCheckedA = value ?? false;
                            isYesCheckedA = true;

                            if (isYesCheckedA) {
                              isNoCheckedA = false;
                            }
                            if (isYesCheckedA == true) {
                              acco_availiablity_status = '1';
                            }
                          });
                        },
                      ),
                      Text(
                        'No',
                        style: TextStyle(fontSize: 16.0.sp),
                      ),
                      Checkbox(
                        activeColor: const Color.fromARGB(255, 4, 68, 121),
                        value: isNoCheckedA,
                        onChanged: (value) {
                          setState(() {
                            // isNoCheckedA = value ?? false;
                            isNoCheckedA = true;
                            // Uncheck "Yes" when "No" is checked
                            if (isNoCheckedA) {
                              isYesCheckedA = false;
                            }
                            if (isNoCheckedA == true) {
                              acco_availiablity_status = '0';
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
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
                                backgroundColor: Color(0xFF69930C)),
                            onPressed: () async {
                              final connectivityResult = await (Connectivity().checkConnectivity());
                              if (connectivityResult == ConnectivityResult.mobile ||
                                  connectivityResult == ConnectivityResult.wifi ||
                                  connectivityResult == ConnectivityResult.ethernet) {
                                if (_formAACOKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  Map aacoBody = {
                                    "district_id": district_id,
                                    "upazila_id": upazila_id,
                                    "union_id": union_id,
                                    "apointment_date": dateController.text,
                                    "recruitment_status": recruitment_status,
                                    "acco_availiablity_status": acco_availiablity_status
                                  };
                                  print(aacoBody);
                                  Map aacoinfoSubmitResponse = await Repositores().AACOInfoSubmitAPi(
                                    jsonEncode(aacoBody),
                                  );
                                  if (aacoinfoSubmitResponse['status'] == 200) {
                                    await QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      text: "AACO Info Add Successfully!",
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
                                }
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
            ],
          ),
        ),
      ),
    );
  }
}
