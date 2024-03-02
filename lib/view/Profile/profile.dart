import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:village_court_gems/bloc/Profile_Get_bloc/profile_get_bloc.dart';
import 'package:village_court_gems/view/home/homepage.dart';

class ProfilePage extends StatefulWidget {
  static const pageName = 'profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  final ProfileGetBloc profileGetBloc = ProfileGetBloc();
  @override
  void initState() {
    profileGetBloc.add(ProfileDataInitialEvent());
    super.initState();
  }

  //we can upload image from camera or from gallery based on parameter

  //show popup dialog

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<ProfileGetBloc, ProfileGetState>(
      bloc: profileGetBloc,
      listenWhen: (previous, current) => current is ProfileGetActionState,
      buildWhen: (previous, current) => current is! ProfileGetActionState,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is ProfileGetLoadingState) {
          return Container(
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProfileGetSuccessState) {
          return Column(
            children: [
              SizedBox(
                height: 300.h,
                child: Stack(children: [
                  Container(
                    height: 190.h,
                    width: 375.w,
                    decoration: BoxDecoration(
                      color: Color(0xFF0C617E),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.r),
                        bottomRight: Radius.circular(40.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(top: 3.h),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 4,
                                        offset: Offset(0, 1), // changes position of shadow
                                      ),
                                    ],
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(14.r),
                                      topRight: Radius.circular(14.r),
                                      bottomLeft: Radius.circular(14.r),
                                      bottomRight: Radius.circular(14.r),
                                    ),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                        color: Colors.black,
                                        onPressed: () async {
                                          await Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(builder: (context) => Homepage()),
                                              (Route<dynamic> route) => false);
                                        },
                                        icon: Icon(Icons.arrow_back)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: SizedBox.shrink(),
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "User Profile",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 170.h,
                    left: 30.w,
                    child: Container(
                      alignment: Alignment.center, // Center the contents horizontally and vertically
                      height: 120.h,
                      width: 310.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 5, child: SizedBox.shrink()),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "${state.data.name}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1D2746),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              "${state.data.email}",
                              style: TextStyle(
                                fontSize: 12.7.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6A737C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: 200.h,
                  //   left: 174.w,
                  //   child: GestureDetector(
                  //     onTap: () async {
                  //       //
                  //     },
                  //     child: Image.asset(
                  //       "assets/icon/Camera Icon.png",
                  //       //fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                ]),
              ),
              Container(
                height: 300.h,
                width: 320.w,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 247, 244, 244),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    )),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Personal Information",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1D2746),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            height: 47.h,
                            width: 47.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50.r),
                                  bottomRight: Radius.circular(0.r),
                                  topLeft: Radius.circular(0.r),
                                  topRight: Radius.circular(10.r),
                                ),
                                color: Color.fromARGB(255, 88, 104, 109)),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 25,
                                )),
                          ),

                          
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 25.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100.w,
                            child: Text(
                              " Name",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6A737C),
                              ),
                            ),
                          ),
                          Text(":"),
                          Container(
                            width: 130.w,
                            child: Text("${state.data.name}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF1D2746),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100.w,
                            child: Text(
                              "Mobile",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6A737C),
                              ),
                            ),
                          ),
                          Text(":"),
                          Container(
                            width: 130.w,
                            child: Text("${state.data.mobile}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF1D2746),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100.w,
                            child: Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6A737C),
                              ),
                            ),
                          ),
                          Text(":"),
                          Container(
                            width: 130.w,
                            child: Text("${state.data.email}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF1D2746),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Container();
      },
    ));
  }
}
