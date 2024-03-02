import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/aacoListModel.dart';
import 'package:village_court_gems/view/AACO/aaco_info_add.dart';
import 'package:village_court_gems/view/AACO/aaco_info_edit.dart';
import 'package:village_court_gems/view/home/homepage.dart';

class AACO_Info extends StatefulWidget {
  static const pageName = 'AACO_Info';
  const AACO_Info({super.key});

  @override
  State<AACO_Info> createState() => _AACO_InfoState();
}

class _AACO_InfoState extends State<AACO_Info> {
  List<Datum> posts = [];
  int currentPage = 1;
  bool isLoading = false;
  AacoListModel? aacoListModel;
  String Recuitment_Status = '';
  String Availabillity_Status = '';
  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchPosts();
      }
    });
  }

  Future<void> _fetchPosts() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    var a = await Repositores().AacooListApi(currentPage);
    aacoListModel = a;
    // List response =aacoListModel;
    // print(a['data']['data']);
    setState(() {
      if (aacoListModel!.data.isNotEmpty) {
        posts.addAll(aacoListModel!.data);
      }

      print("accinfo list ");

      currentPage++;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Homepage.pageName);
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text("AACO Informations"),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                child: Row(children: <Widget>[
                  Expanded(
                    child: TextField(
                      // textInputAction: TextInputAction.next,
                      textAlignVertical: TextAlignVertical.center,
                      controller: searchController,
                      decoration: InputDecoration(
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),

                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(20),
                        // ),
                        hintText: 'Search',
                        prefixIcon: GestureDetector(
                            onTap: () async {
                              // final connectivityResult = await (Connectivity().checkConnectivity());
                              // if (connectivityResult == ConnectivityResult.mobile ||
                              //     connectivityResult == ConnectivityResult.wifi ||
                              //     connectivityResult == ConnectivityResult.ethernet) {
                              //   print("intenrt on");
                              //   keyword = searchController.text;
                              //   await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              //     return SearchQuestions(
                              //       keywords: keyword,
                              //     );
                              //   }));
                              // } else {
                              //   showDialogBox();
                              // }
                            },
                            child: Icon(Icons.search)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15), //Imp Line
                        // suffixIcon: GestureDetector(
                        //   onTap: () {},
                        //   child: Image.asset(
                        //     "assets/icon/Filter 5.jpg",
                        //     height: 18.h,
                        //     width: 16.w,
                        //     // fit: BoxFit.cover,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                ])),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index < posts.length) {
                    final post = posts[index];
                    if (post.recruitmentStatus == 1) {
                      Recuitment_Status = "YES";
                    } else {
                      Recuitment_Status = "NO";
                    }
                    if (post.accoAvailiablityStatus == 1) {
                      Availabillity_Status = "Yes";
                    } else {
                      Availabillity_Status = "NO";
                    }
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            print("ttttttttttttttttt");
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 202, 224, 224),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.r),
                                      bottomRight: Radius.circular(20.r),
                                      topLeft: Radius.circular(20.r),
                                      topRight: Radius.circular(20.r),
                                    )),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // IconButton(
                                        //   onPressed: () async {
                                        //     Map deleteResponse = await Repositores().AACOInfoDeleteAPi(post.id.toString());
                                        //     if (deleteResponse['status'] == 200) {
                                        //       setState(() {});
                                        //       await QuickAlert.show(
                                        //         context: context,
                                        //         type: QuickAlertType.success,
                                        //         text: "AACO Info Deleted Successfully!",
                                        //       );
                                        //       await Navigator.of(context).pushAndRemoveUntil(
                                        //           MaterialPageRoute(builder: (context) => AACO_Info()),
                                        //           (Route<dynamic> route) => false);
                                        //     } else {
                                        //       await QuickAlert.show(
                                        //         context: context,
                                        //         type: QuickAlertType.error,
                                        //         text: "Something went wrong please try again later",
                                        //       );
                                        //     }
                                        //   },
                                        //   icon: Container(
                                        //     padding: EdgeInsets.all(8), // Adjust padding as needed
                                        //     decoration: BoxDecoration(
                                        //         shape: BoxShape.circle, color: const Color.fromARGB(255, 243, 207, 207)),
                                        //     child: Icon(
                                        //       Icons.close_rounded,
                                        //       color: Colors.black, // Set the color of the icon as needed
                                        //     ),
                                        //   ),
                                        // ),

                                        // IconButton(
                                        //   onPressed: () async {
                                        //     await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                        //       return AACOInfoEditPage(
                                        //         id: post.id,
                                        //       );
                                        //     }));
                                        //   },
                                        //   icon: Container(
                                        //     padding: EdgeInsets.all(8), // Adjust padding as needed
                                        //     decoration: BoxDecoration(
                                        //       shape: BoxShape.circle,
                                        //       color: Colors.white,
                                        //     ),
                                        //     child: Icon(
                                        //       Icons.edit,
                                        //       color: Colors.black, // Set the color of the icon as needed
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 15.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              "District",
                                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(":")),
                                          Expanded(
                                            flex: 4,
                                            child: Text("${post.district}",
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
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 15.w,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              "Upazila",
                                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(":")),
                                          Expanded(
                                            flex: 4,
                                            child: Text("${post.upazila}",
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
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 15.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              "Union",
                                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(":")),
                                          Expanded(
                                            flex: 4,
                                            child: Text("${post.union}",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF1D2746),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 15.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              "Recuitment Status",
                                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(":")),
                                          Expanded(
                                            flex: 4,
                                            child: Text("${Recuitment_Status}",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF1D2746),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 15.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              "Availabillity Status",
                                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(":")),
                                          Expanded(
                                            flex: 4,
                                            child: Text("${Availabillity_Status}",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF1D2746),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 15.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              "Appointment Date",
                                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(":")),
                                          Expanded(
                                            flex: 4,
                                            child: Text("${post.apointmentDate}",
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF1D2746),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            top: 10,
                            right: 5,
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return AACOInfoEditPage(
                                    id: post.id,
                                  );
                                }));
                              },
                              child: Container(
                                padding: EdgeInsets.all(3), // Adjust padding as needed
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.black, // Set the color of the icon as needed
                                ),
                              ),
                            )),
                      ],
                    );
                  } else if (isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    //return SizedBox(height: 20, child: Center(child: Text("no data")));
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(AACO_Info_Add.pageName);
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
