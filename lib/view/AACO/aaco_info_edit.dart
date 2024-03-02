import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/AACO_Info_Edit_bloc/aaco_info_edit_bloc.dart';
import 'package:village_court_gems/bloc/AACO_info_add_bloc/aaco_info_add_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/aacoInfoEditModel.dart';
import 'package:village_court_gems/models/area_model/all_district_model.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/view/AACO/aaco_Info.dart';
import 'package:village_court_gems/view/home/homepage.dart';

class AACOInfoEditPage extends StatefulWidget {
  static const pageName = 'AACO_Info_Edit';
  final int? id;
  AACOInfoEditPage({super.key, this.id});

  @override
  State<AACOInfoEditPage> createState() => _AACOInfoEditPageState();
}

class _AACOInfoEditPageState extends State<AACOInfoEditPage> {
  DistrictData? oldDistrict;
  LocationListElement? oldupazila;
  LocationListElement? oldunion;
  String? selectedDistrict;
  String? selectedUpazila;
  String? selectedUion;
  String district_id = '';
  String union_id = '';
  String upazila_id = '';
  bool _isLoading = false;
  int g_updateDataValue = 0;
  DateTime? selectedDate;
  String recruitment_status = '';
  String acco_availiablity_status = '';
  String apointment_date = '';
  bool isYesCheckedR = false;
  bool isNoCheckedR = false;
  bool isYesCheckedA = false;
  bool isNoCheckedA = false;
  bool changeDistrict = false;
  bool changeUpazila = false;
  bool chnageUnion = false;

  TextEditingController dateController = TextEditingController();
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

  final AacoInfoEditBloc aacoInfoEditBloc = AacoInfoEditBloc();
  @override
  void initState() {
    aacoInfoEditBloc.add(AacoInfoEditInitialEvent(id: widget.id));
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
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text("AACO Information Edit"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            BlocConsumer<AacoInfoEditBloc, AacoInfoEditState>(
                bloc: aacoInfoEditBloc,
                listenWhen: (previous, current) => current is AacoInfoEditActionState,
                buildWhen: (previous, current) => current is! AacoInfoEditActionState,
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is AacoInfoEditLoadingState) {
                    print("loading..........................");
                    return Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    );
                  } else if (state is AacoInfoEditSuccessState) {
                    g_updateDataValue++;
                    if (g_updateDataValue == 1) {
                      var oldDis = state.district.singleWhere((element) => element.id == state.data.districtId);
                      oldDistrict = oldDis;
                      district_id = oldDistrict!.id.toString();
                      print(oldDistrict!.nameEn);

                      //oldupazila
                      var oldUpa = state.data.upazilaLists.singleWhere((element) => element.id == state.data.upazilaId);
                      oldupazila = oldUpa;
                      upazila_id = oldupazila!.id.toString();
                      print(oldupazila!.nameEn);
                      //old union
                      var oldUni = state.data.unionLists.singleWhere((element) => element.id == state.data.unionId);
                      oldunion = oldUni;
                      union_id = oldunion!.id.toString();
                      print(oldunion!.nameEn);
                      //old date
                      dateController.text = state.data.apointmentDate;
                      //old recruitment_status
                      if (state.data.recruitmentStatus == 1) {
                        isYesCheckedR = true;
                        recruitment_status = '1';
                      } else {
                        isNoCheckedR = true;
                        recruitment_status = '0';
                      }
                      //old acco_availiablity_status
                      if (state.data.accoAvailiablityStatus == 1) {
                        isYesCheckedA = true;
                        acco_availiablity_status = '1';
                      } else {
                        isNoCheckedA = true;
                        acco_availiablity_status = '0';
                      }
                    }

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
                              child: DropdownButtonFormField<DistrictData>(
                                isExpanded: true,
                                value: oldDistrict,
                                onChanged: (DistrictData? newValue) {
                                  setState(() {
                                    selectedDistrict = newValue!.id.toString();
                                    print("eeeeeeeeee $selectedDistrict");
                                    district_id = selectedDistrict.toString();
                                    print("eeeeeeeeee $selectedDistrict   $district_id");
                                    selectedDistrict = null;
                                    selectedUpazila = null;
                                    selectedUion = null;

                                    aacoInfoEditBloc.add(AacoInfoEditUpazilaClickEvent(id: int.tryParse(district_id)));
                                    changeDistrict = true;
                                    changeUpazila = true;
                                    // district = selectedDistrict.toString();
                                    // trainingDataEditBloc
                                    //     .add(UpazilaClickEvent(id: int.parse(selectedDistrict.toString())));
                                    // selectedUpazila = null;
                                  });
                                },
                                items: state.district.map<DropdownMenuItem<DistrictData>>((item) {
                                  return DropdownMenuItem<DistrictData>(
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
                            changeDistrict == true
                                ? SizedBox(
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
                                            if (selectedUpazila == entry['name_en']) {
                                              print("selectedUpazilaaaaaaaaaaaa ${entry['id']}");
                                              upazila_id = entry['id'].toString();
                                              aacoInfoEditBloc.add(AacoInfoEditUnionClickEvent(id: int.tryParse(upazila_id)));
                                              changeUpazila = true;
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
                                    ),
                                  )
                                : SizedBox(
                                    height: 55.0.h,
                                    width: 160.0.w,
                                    child: DropdownButtonFormField<LocationListElement>(
                                      isExpanded: true,
                                      value: oldupazila,
                                      onChanged: (LocationListElement? newValue) {
                                        setState(() {
                                          selectedUpazila = newValue!.id.toString();
                                          // print(object)
                                          upazila_id = selectedUpazila.toString();
                                          changeUpazila = true;
                                          selectedUion = null;
                                          // upazila = selectedUpazila.toString();
                                          // print("a999999999999999$selectedUpazila");
                                          aacoInfoEditBloc.add(AacoInfoEditUnionClickEvent(id: int.tryParse(upazila_id)));
                                          // trainingDataEditBloc
                                          //     .add(UnionClickEvent(id: int.tryParse(selectedUpazila!)));
                                          // selectedUion = null;
                                        });
                                      },
                                      items: state.data.upazilaLists.map<DropdownMenuItem<LocationListElement>>((item) {
                                        return DropdownMenuItem<LocationListElement>(
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
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        changeUpazila == true
                            ? Container(
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
                                  ),
                                ),
                              )
                            : Container(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  height: 55.0.h,
                                  width: 160.0.w,
                                  child: DropdownButtonFormField<LocationListElement>(
                                    isExpanded: true,
                                    value: oldunion,
                                    onChanged: (LocationListElement? newValue) {
                                      setState(() {
                                        selectedUion = newValue!.id.toString();
                                        union_id = selectedUion.toString();
                                        // union = selectedUion.toString();
                                      });
                                    },
                                    items: state.data.unionLists.map<DropdownMenuItem<LocationListElement>>((item) {
                                      return DropdownMenuItem<LocationListElement>(
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
                              ),
                        SizedBox(
                          height: 5.0.h,
                        ),
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
                          height: 10,
                        ),
                        SizedBox(
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
                                  hintText: "Date",
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0.h,
                        ),
                        Column(
                          children: [
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
                                      // isYesCheckedR = value ?? false;
                                      isYesCheckedR = true;
                                      print(isYesCheckedR);
                                      // // Uncheck "No" when "Yes" is checked
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
                                      //isNoCheckedR = value ?? false;
                                      isNoCheckedR = true;
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
                                      //isNoCheckedA = value ?? false;
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
                      ],
                    );
                  }
                  return Container();
                }),
            SizedBox(
              height: 15.0.h,
            ),
            // _isLoading
            //     ? Center(child: AllService.LoadingToast())
            //     :
            Center(
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
                        Map aacoinfoSubmitResponse =
                            await Repositores().AACOInfoEditDataSubmitAPi(jsonEncode(aacoBody), widget.id.toString());
                        if (aacoinfoSubmitResponse['status'] == 200) {
                          await QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: "AACO Info updated Successfully!",
                          );
                          await Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => AACO_Info()), (Route<dynamic> route) => false);
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
    );
  }
}
