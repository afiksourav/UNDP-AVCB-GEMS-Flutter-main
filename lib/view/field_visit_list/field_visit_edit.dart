import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/FieldFindingUpdate_Bloc/field_finding_update_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/field_visit_model/fieldVisitUpdateModel.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/view/field_visit_list/field_visit_details.dart';
import 'package:village_court_gems/view/home/homepage.dart';

class FieldVisitEditPage extends StatefulWidget {
  final String id;
  FieldVisitEditPage({super.key, required this.id});

  @override
  State<FieldVisitEditPage> createState() => _FieldVisitEditPageState();
}

class _FieldVisitEditPageState extends State<FieldVisitEditPage> {
  final FieldFindingUpdateBloc fieldFindingUpdateBloc = FieldFindingUpdateBloc();
  List<Question> text = [];
  List all_text_id = [];
  int globalvalue = 0;
  bool _isLoading = false;
  List<List<TextEditingController>> textController = [];
  @override
  void initState() {
    fieldFindingUpdateBloc.add(FieldFindingUpdateInitialEvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        centerTitle: true,
        title: Text("Field Visit Update"),
      )),
      body: SingleChildScrollView(
        child: Column(children: [
          BlocConsumer<FieldFindingUpdateBloc, FieldFindingUpdateState>(
              bloc: fieldFindingUpdateBloc,
              listenWhen: (previous, current) => current is FieldFindingUpdateActionState,
              buildWhen: (previous, current) => current is! FieldFindingUpdateActionState,
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is FieldFindingUpdateLoadingState) {
                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is FieldFindingUpdateSuccessState) {
                  globalvalue++;
                  if (globalvalue == 1) {
                    state.question.forEach(
                      (element) {
                        if (element.type == 'text') {
                          text.add(element);
                          all_text_id.add(element.id.toString());
                        }
                      },
                    );
                    for (int i = 0; i < text.length; i++) {
                      List<TextEditingController> textControllerValue = [];
                      for (int j = 0; j < text[i].fieldSettingOptions.length; j++) {
                        textControllerValue.add(TextEditingController(
                          text: text[i].fieldSettingOptions[j].ansValue.toString(),
                        ));
                      }
                      textController.add(textControllerValue);
                    }
                  }

                  return Column(
                    children: [
                      ...List.generate(text.length, (textIndex) {
                        // textController
                        //     .add(List.generate(text[textIndex].fieldSettingOptions.length, (index) => TextEditingController()));

                        return ExpansionTile(
                          trailing: Icon(Icons.keyboard_arrow_down_outlined), // Icon for the leading position
                          title: Text(
                            text[textIndex].question,
                            style: TextStyle(fontSize: 12),
                          ),
                          children: [
                            ...List.generate(text[textIndex].fieldSettingOptions.length, (textAnswerIndex) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                                    child: SizedBox(
                                        height: 100.0.h,
                                        width: double.infinity,
                                        child: TextField(
                                          controller: textController[textIndex][textAnswerIndex],
                                          maxLines: 300,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: text[textIndex].fieldSettingOptions[textAnswerIndex].optionName,
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              );
                            }),
                            SizedBox(
                              height: 10.0.h,
                            ),
                          ],
                        );
                      }),
                      SizedBox(
                        height: 10,
                      ),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       print(all_text_id);
                      //       getTextControllerValues();
                      //       Map storeBody = {
                      //         "field_visit_id": widget.id.toString(),
                      //         "question_id": {
                      //           "text_": all_text_id,
                      //           "dropdown_": [],
                      //           "check_box_": [],
                      //           "radio_": [],
                      //           "number_": []
                      //         },
                      //         "textData": allTextValues,
                      //         "dropdownData": [],
                      //         "checkboxData": [],
                      //         "numberData": [],
                      //         "radioData": []
                      //       };
                      //       print(allTextValues.length);
                      //       print(jsonEncode(storeBody));
                      //     },
                      //     child: Text("aa")),
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
                                        // numberInputValue();
                                        getTextControllerValues();
                                        Map storeBody = {
                                          "field_visit_id": widget.id.toString(),
                                          "question_id": {
                                            "text_": all_text_id,
                                            "dropdown_": [],
                                            "check_box_": [],
                                            "radio_": [],
                                            "number_": []
                                          },
                                          "textData": allTextValues,
                                          "dropdownData": [],
                                          "checkboxData": [],
                                          "numberData": [],
                                          "radioData": []
                                        };

                                        print(jsonEncode(storeBody));

                                        setState(() {
                                          _isLoading = true;
                                        });
                                        Map fiedFindingSubmitResponse =
                                            await Repositores().FiedFindingUpdateSubmitApi(storeBody, widget.id);
                                        if (fiedFindingSubmitResponse['status'] == 200) {
                                          await QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.success,
                                            text: "Field finding stored successfully!",
                                          );
                                          // await Navigator.of(context).pushReplacement(
                                          //   MaterialPageRoute(
                                          //       builder: (context) => FieldVisitDetailsPage(
                                          //             id: widget.id,
                                          //           )),
                                          // );
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
                                          'Update',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                }
                return Container();
              })
        ]),
      ),
    );
  }

  //text input value
  List<String> allTextValues = [];
  void getTextControllerValues() {
    allTextValues.clear();
    for (int i = 0; i < text.length; i++) {
      for (int j = 0; j < text[i].fieldSettingOptions.length; j++) {
        allTextValues.add(textController[i][j].text);
      }
    }
    print(allTextValues);
  }
}
