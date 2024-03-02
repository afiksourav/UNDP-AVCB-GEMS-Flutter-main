import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/controller/global.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';

import 'package:village_court_gems/view/home/homepage.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;

class LoginPage extends StatefulWidget {
  static const pageName = 'login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // var phoneController = TextEditingController();
  // var passwordController = TextEditingController();
  var phoneController = TextEditingController(text: "01571522758");
  var passwordController = TextEditingController(text: "1234567890");
  bool _isLoading = false;
  bool ischeckbox = false;
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
          child: Column(
            children: [
              SizedBox(
                height: 120.0.h,
              ),
              // Container(
              //   height: 30,
              //   color: Colors.black,
              //   child: Switch(
              //     activeColor: Colors.amber,
              //     value: context.locale.toString() == 'en' ? true : false,
              //     onChanged: (bool value) {
              //       value ? context.setLocale(const Locale('en')) : context.setLocale(const Locale('bn'));
              //       //Refresh.refressLocalization();
              //     },
              //   ),
              // ),
              // Text(
              //   context.locale.toString() == 'en' ? 'English' : 'বাংলা',
              //   style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 105, 29, 29)),
              // ),
              SizedBox(height: 50, child: Image.asset("assets/icons/idsdp_logo.png")),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 35, right: 20),
                child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "GPS Based E-Monitoring System (GEMS)\n                              for \nActivating Village Courts in Bangladesh\n                  (Phase III) Project",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(
                height: 100.0.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50.0.h,
                      width: double.infinity,
                      child: TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.black), //<-- SEE HERE
                            ),
                            // hintStyle: TextStyle(color: Colors.blue),
                            hintText: "Phone Number"),
                      ),
                    ),
                    SizedBox(
                      height: 20.0.h,
                    ),
                    // SizedBox(
                    //   height: 45.0.h,
                    //   width: double.infinity,
                    //   child: TextField(
                    //     obscureText: true,
                    //     controller: passwordController,
                    //     decoration: const InputDecoration(
                    //         prefixIcon: Icon(Icons.lock),
                    //         enabledBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(width: 1, color: Colors.black),
                    //         ),
                    //         border: OutlineInputBorder(),
                    //         hintText: "Password"),
                    //   ),
                    // ),
                    SizedBox(
                      height: 50.0.h,
                      child: TextFormField(
                        obscureText: _obscureText,
                        controller: passwordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Password",
                          border: OutlineInputBorder(),
                          suffixIcon: _obscureText
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = false;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.visibility_off,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = true;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.remove_red_eye,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: ischeckbox,
                          onChanged: (bool? newValue) {
                            setState(() {
                              ischeckbox = newValue!;
                            });
                          },
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Remember me",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 4, 58, 53),
                                ))),
                      ],
                    )
                  ],
                ),
              ),
              // ElevatedButton(
              //     onPressed: () async {
              //       await Repositores().upazilaOflineApi();
              //     },
              //     child: Text("data")),
              SizedBox(
                height: 30.0.h,
              ),
              _isLoading
                  ? AllService.LoadingToast()
                  : Center(
                      child: SizedBox(
                        width: 330.w,
                        height: 50.h,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0.r),
                              ),
                              backgroundColor: Color(0xFF00A651),
                            ),
                            onPressed: () async {
                              final connectivityResult = await (Connectivity().checkConnectivity());
                              if (connectivityResult == ConnectivityResult.mobile ||
                                  connectivityResult == ConnectivityResult.wifi ||
                                  connectivityResult == ConnectivityResult.ethernet) {
                                setState(() {
                                  _isLoading = true;
                                });
                                //Pa$$w0rd!
                                Map login_api = await Repositores().loginAPi(phoneController.text, passwordController.text);
                                print("loginnnnnnnnnn $login_api");
                                if (login_api['message'].toString() == "OTP Verification") {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  return _showModalBottomSheet(context);
                                }
                                if (login_api['message'].toString() == 'Login Successfully') {
                                  print("login success");
                                  print("internet on");
                                  g_Token = login_api['data']['access_token'];
                                  await Helper().userToken(login_api['data']['access_token'].toString());
                                  await Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => Homepage()), (Route<dynamic> route) => false);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                } else {
                                  await QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    text: login_api['message'],
                                  );
                                  print("Faild Login ");

                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              } else {
                                AllService().internetCheckDialog(context);
                              }

                              // toast.Fluttertoast.showToast(
                              //   msg: "Login faild",
                              //   toastLength: toast.Toast.LENGTH_SHORT,
                              //   gravity: toast.ToastGravity.TOP,
                              //   timeInSecForIosWeb: 5,
                              //   backgroundColor: Colors.red,
                              //   textColor: Colors.white,
                              //   fontSize: 16.0,
                              // );

                              // _showModalBottomSheet(context);

                              // String a = await Helper().getUserToken();
                              // print(a);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login'.tr(),
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                    ),
              SizedBox(
                height: 30.0.h,
              ),
              Text(
                "Forgot Passowrd?",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              SizedBox(
                height: 100.0.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0.r),
                topRight: Radius.circular(25.0.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20.0.h,
                ),
                Text(
                  "Email Verification",
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30.h,
                ),
                const Text(
                  "6 Digit OTP Code has been sent to\n              Your Mobile No.",
                ),
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
                  child: OTPTextField(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: 50, // Adjust this value to set the box size
                    style: TextStyle(fontSize: 17),
                    fieldStyle: FieldStyle.box,
                    onCompleted: (pin) async {
                      print("Completed: " + pin);
                      Map otp = await Repositores().otp_Verification(pin);
                      if (otp['message'].toString() == 'OTP successfully Verified') {
                        print("rrrrrrrrrrr ${otp['data']['access_token']}");
                        g_Token = otp['data']['access_token'];
                        await Helper().userToken(otp['data']['access_token'].toString());
                        // ignore: use_build_context_synchronously
                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: "Account login Successful!",
                        );
                        await Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Homepage()), (Route<dynamic> route) => false);
                      } else {
                        await QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          text: "OTP Credential Wrong",
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: 330.w,
                  height: 50.h,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0.r),
                        ),
                        backgroundColor: Color(0xFF00A651),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(Homepage.pageName);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Verify",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 30.0.h,
                ),
                // const Text(
                //   "Resent",
                //   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
