import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/FieldFindingCreateBloc/field_finding_create_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/field_visit_model/FieldFindingCreateModel.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/view/home/homepage.dart';

class FieldFindingCreatePage extends StatefulWidget {
  final String id;
  FieldFindingCreatePage({super.key, required this.id});

  @override
  State<FieldFindingCreatePage> createState() => _FieldFindingCreatePageState();
}

class _FieldFindingCreatePageState extends State<FieldFindingCreatePage> {
  final FieldFindingCreateBloc fieldFindingCreateBloc = FieldFindingCreateBloc();
  @override
  void initState() {
    fieldFindingCreateBloc.add(FieldFindingCreateInitialEvent(id: widget.id));
    super.initState();
  }

  bool _isLoading = false;
  int globalvalue = 0;
  int globalStoreValue = 0;
  int globalStoreValue11 = 0;
  List<FieldCreateData> text = [];
  List<FieldCreateData> radio = [];
  List<FieldCreateData> checkbox = [];
  List<FieldCreateData> dropdown = [];
  List<FieldCreateData> number = [];

  List<List<TextEditingController>> textconroller = [];
  List<List<TextEditingController>> numberconroller = [];
  List<String>? selectedValue;
  List<List<bool>> isChecked = [];
  Map selectedDropdownValues = {};

  //store variable
  List text_ = [];
  List number_ = [];
  List radio_ = [];
  List dropdown_ = [];
  List check_box_ = [];
  List textID = [];
  //
  List<String> textData = [];
  List<String> numberData = [];
  List<String> checkboxData = [];
  List<String> dropdownData = [];
  // List<List<String>> radio_1 = [];
  List<String>? dropdownDataList = [];
  List<String> try12 = [];
  final GlobalKey<FormState> _fieldformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // print("000000000000000000000000");
    // print(widget.id);
    return Scaffold(
      appBar: AppBar(
        // leading: GestureDetector(
        //     onTap: () async {
        //       await Navigator.of(context)
        //           .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Homepage()), (Route<dynamic> route) => false);
        //     },
        //     child: Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text("Field Findings Create"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _fieldformKey,
          child: Column(
            children: [
              BlocConsumer<FieldFindingCreateBloc, FieldFindingCreateState>(
                  bloc: fieldFindingCreateBloc,
                  listenWhen: (previous, current) => current is FieldFindingCreateActionState,
                  buildWhen: (previous, current) => current is! FieldFindingCreateActionState,
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    if (state is FieldFindingCreateLoadingState) {
                      return Container(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is FieldFindingCreateSuccessState) {
                      print("jjjjjjjjjjjjj");
                      print(state.fieldCreateData.length);
                      globalvalue++;
                      if (globalvalue == 1) {
                        state.fieldCreateData.forEach(
                          (element) {
                            if (element.type == 'text') {
                              text.add(element);
                              text_.add(element.id.toString());
                              textData = List.generate(text.length, (textIndex) => '');
                            } else if (element.type == 'radio') {
                              radio.add(element);
                              radio_.add(element.id.toString());
                              selectedValue = List.generate(radio.length, (radioIndex) => '');

                              // radio_1 = List.generate(radio.length, (index) => []);
                            } else if (element.type == 'check-box') {
                              checkbox.add(element);
                              check_box_.add(element.id.toString());

                              // checkboxData = List.generate(checkbox.length, (checkboxIndex) => '');
                              // checkbox.forEach((e) {
                              //   checkboxData = List.generate(e.fieldSettingOptions.length, (index) => '');
                              // });
                            } else if (element.type == 'drop-down') {
                              dropdown.add(element);
                              dropdown_.add(element.id.toString());
                              dropdownDataList = List.generate(dropdown.length, (dropdownIndex) => '');
                            } else if (element.type == 'number') {
                              number.add(element);
                              number_.add(element.id.toString());
                              numberData = List.generate(number.length, (numberIndex) => '');
                            }
                          },
                        );
                      }
                      // globalStoreValue++;
                      // if (globalStoreValue == 1) {
                      //   text_.add(text.first.id);
                      //   number_.add(number.first.id);
                      //   radio_.add(radio.first.id);
                      //   dropdown_.add(dropdown.first.id);
                      //   check_box_.add(checkbox.first.id);
                      // }

                      return Column(
                        children: [
                          // ElevatedButton(
                          //     onPressed: () {
                          //       textInputValue();
                          //       numberInputValue();
                          //       Map a = {
                          //         "field_visit_id": widget.id.toString(),
                          //         "question_id": {
                          //           "text_": text_,
                          //           "dropdown_": dropdown_,
                          //           "check_box_": check_box_,
                          //           "radio_": radio_,
                          //           "number_": number_
                          //         },
                          //         "textData": textData,
                          //         "dropdownData": dropdownDataList,
                          //         "checkboxData": checkboxData,
                          //         "numberData": numberData,
                          //         "radioData": selectedValue
                          //       };
                          //       print(jsonEncode(a));
                          //     },
                          //     child: Text("data")),
                          //   Text

                          ...List.generate(text.length, (textIndex) {
                            textconroller.add(
                                List.generate(text[textIndex].fieldSettingOptions.length, (index) => TextEditingController()));

                            return ExpansionTile(
                              // tilePadding: EdgeInsets.zero,
                              leading: Text("${textIndex + 1}"),
                              trailing: Icon(Icons.keyboard_arrow_down_outlined), // Icon for the leading position
                              title: Text(
                                text[textIndex].question,
                                style: TextStyle(fontSize: 12),
                              ),
                              children: [
                                ...List.generate(text[textIndex].fieldSettingOptions.length, (textOptionIndex) {
                                  return Padding(
                                    padding: EdgeInsets.all(10),
                                    child: SizedBox(
                                        height: 100.0.h,
                                        width: double.infinity,
                                        child: TextFormField(
                                          controller: textconroller[textIndex][textOptionIndex],
                                          maxLines: 300,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: text[textIndex].fieldSettingOptions[textOptionIndex].optionName,
                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                        )),
                                  );
                                })
                              ],
                            );
                          }),
                          //number
                          ...List.generate(number.length, (numberIndex) {
                            numberconroller.add(List.generate(
                                number[numberIndex].fieldSettingOptions.length, (index) => TextEditingController()));

                            return ExpansionTile(
                              trailing: Icon(Icons.keyboard_arrow_down_outlined), // Icon for the leading position
                              title: Text(
                                number[numberIndex].question,
                                style: TextStyle(fontSize: 12),
                              ),
                              children: [
                                ...List.generate(number[numberIndex].fieldSettingOptions.length, (numberOptionIndex) {
                                  return Padding(
                                    padding: EdgeInsets.all(10),
                                    child: SizedBox(
                                        height: 100.0.h,
                                        width: double.infinity,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: numberconroller[numberIndex][numberOptionIndex],
                                          maxLines: 300,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: number[numberIndex].fieldSettingOptions[numberOptionIndex].optionName,
                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a value';
                                            }
                                            // Add more custom validation rules if needed
                                            return null; // Return null if the input is valid
                                          },
                                        )),
                                  );
                                })
                              ],
                            );
                          }),
                          //Radio Button
                          ...List.generate(radio.length, (radioIndex) {
                            return ExpansionTile(
                              trailing: Icon(Icons.keyboard_arrow_down_outlined),
                              title: Text(
                                radio[radioIndex].question,
                                style: TextStyle(fontSize: 12),
                              ),
                              children: [
                                ...List.generate(radio[radioIndex].fieldSettingOptions.length, (radioOptionIndex) {
                                  return Row(
                                    children: [
                                      Radio(
                                        value: radio[radioIndex].fieldSettingOptions[radioOptionIndex].slug,
                                        groupValue: selectedValue![radioIndex],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValue![radioIndex] = value.toString();

                                            // radio[radioIndex].fieldSettingOptions.forEach((element) {
                                            //   if (element.optionName == selectedValue![radioIndex]) {
                                            //     print(element.id);
                                            //     print(element.slug);

                                            //       try12.add(element.slug);

                                            //   }
                                            // });
                                            // selectedValue![radioIndex] =
                                            //     radio[radioIndex].fieldSettingOptions[radioOptionIndex].slug;
                                          });
                                        },
                                      ),
                                      Text(radio[radioIndex].fieldSettingOptions[radioOptionIndex].optionName),
                                    ],
                                  );
                                })
                              ],
                            );
                          }),
                          //checkbox
                          ...List.generate(checkbox.length, (checkboxIndex) {
                            isChecked.add(List.generate(checkbox[checkboxIndex].fieldSettingOptions.length, (index) => false));
                            return ExpansionTile(
                              trailing: Icon(Icons.keyboard_arrow_down_outlined),
                              title: Text(
                                checkbox[checkboxIndex].question,
                                style: TextStyle(fontSize: 12),
                              ),
                              children: [
                                ...List.generate(checkbox[checkboxIndex].fieldSettingOptions.length, (checkboxOptionIndex) {
                                  return Row(
                                    children: [
                                      Checkbox(
                                        value: isChecked[checkboxIndex][checkboxOptionIndex],
                                        onChanged: (value) {
                                          setState(() {
                                            isChecked[checkboxIndex][checkboxOptionIndex] = value!;
                                          });
                                          if (value!) {
                                            // print(checkbox[checkboxIndex].fieldSettingOptions[checkboxOptionIndex].id);
                                            // print(checkbox[checkboxIndex].fieldSettingOptions[checkboxOptionIndex].slug);
                                            checkboxData
                                                .add(checkbox[checkboxIndex].fieldSettingOptions[checkboxOptionIndex].slug);
                                          } else {
                                            checkboxData
                                                .remove(checkbox[checkboxIndex].fieldSettingOptions[checkboxOptionIndex].slug);
                                          }
                                        },
                                      ),
                                      Text(checkbox[checkboxIndex].fieldSettingOptions[checkboxOptionIndex].optionName),
                                    ],
                                  );
                                })
                              ],
                            );
                          }),

                          ...List.generate(dropdown.length, (dropdownIndex) {
                            return ExpansionTile(
                              trailing: Icon(Icons.keyboard_arrow_down_outlined),
                              title: Text(
                                dropdown[dropdownIndex].question,
                                style: TextStyle(fontSize: 12),
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(15),
                                  child: DropdownButtonFormField<String>(
                                      value: selectedDropdownValues[dropdownIndex],
                                      items: dropdown[dropdownIndex]
                                          .fieldSettingOptions
                                          .map<DropdownMenuItem<String>>(
                                            (option) => DropdownMenuItem<String>(
                                              value: option.optionName,
                                              child: Text(option.optionName),
                                            ),
                                          )
                                          .toList(),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        labelText: '--Select Dropdown--',
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          // dropdownDataList![dropdownIndex] = value!;
                                          dropdownDataList![dropdownIndex] =
                                              dropdown[dropdownIndex].fieldSettingOptions[dropdownIndex].slug;
                                          // print(selectedDropdownValues[dropdownIndex]);
                                        });
                                      }),
                                )
                              ],
                            );
                          }),
                          SizedBox(
                            height: 15,
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
                                            if (_fieldformKey.currentState!.validate()) {
                                              textInputValue();
                                              numberInputValue();
                                              Map storeBody = {
                                                "field_visit_id": widget.id.toString(),
                                                "question_id": {
                                                  "text_": text_,
                                                  "dropdown_": dropdown_,
                                                  "check_box_": check_box_,
                                                  "radio_": radio_,
                                                  "number_": number_
                                                },
                                                "textData": textData,
                                                "dropdownData": dropdownDataList,
                                                "checkboxData": checkboxData,
                                                "numberData": numberData,
                                                "radioData": selectedValue
                                              };
                                              print(jsonEncode(storeBody));
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              Map fiedFindingSubmitResponse = await Repositores().FiedFindingSubmitApi(storeBody);
                                              if (fiedFindingSubmitResponse['status'] == 200) {
                                                await QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.success,
                                                  text: "Field finding stored successfully!",
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
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    }
                    return Container();
                  })
            ],
          ),
        ),
      ),
    );
  }

  List<String> selectedValuesQuestion = [];
  List<List<String>> selectedValuesOptions = [];
  //text input value
  void textInputValue() {
    // List<String> TextControllerValues = [];
    // for (List<TextEditingController> venueControllers in textconroller) {
    //   for (TextEditingController controller in venueControllers) {
    //     String inputValue = controller.text.trim();
    //     String intValue = inputValue.isEmpty ? '' : inputValue;
    //     TextControllerValues.add(intValue);
    //   }
    // }
    // textData = TextControllerValues.where((value) => value.isNotEmpty).toList();
    // print("Text values: $textData");

    //  new implement
    textData.clear();
    for (int i = 0; i < text.length; i++) {
      for (int j = 0; j < text[i].fieldSettingOptions.length; j++) {
        textData.add(textconroller[i][j].text);
      }
    }
  }

  //number input value
  void numberInputValue() {
    List<String> numberControllerValues = [];
    for (List<TextEditingController> venueControllers in numberconroller) {
      for (TextEditingController controller in venueControllers) {
        String inputValue = controller.text.trim();
        String intValue = inputValue.isEmpty ? '' : inputValue;
        numberControllerValues.add(intValue);
      }
    }

    numberData = numberControllerValues.where((value) => value.isNotEmpty).toList();

    print("mumber values  : $textData");
  }
}
