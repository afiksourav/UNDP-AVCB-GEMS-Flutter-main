import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:village_court_gems/bloc/FieldVisitDetails_Bloc/field_visit_details_bloc.dart';
import 'package:village_court_gems/view/field_visit_list/field-finding-create.dart';
import 'package:village_court_gems/view/field_visit_list/field_visit_edit.dart';

class FieldVisitDetailsPage extends StatefulWidget {
  String? id;
  FieldVisitDetailsPage({super.key, this.id});

  @override
  State<FieldVisitDetailsPage> createState() => _FieldVisitDetailsPageState();
}

class _FieldVisitDetailsPageState extends State<FieldVisitDetailsPage> {
  late GoogleMapController mapController;

  List<List<TextEditingController>> FieldVisitDetailsConroller = [];

  final FieldVisitDetailsBloc fieldVisitDetailsBloc = FieldVisitDetailsBloc();
  @override
  void initState() {
    fieldVisitDetailsBloc.add(FieldVisitDetailsInitialEvent(id: int.parse(widget.id.toString())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double targetLatitude = 23.8128157;
    double targetLongitude = 90.4288459;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Field Visit Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocConsumer<FieldVisitDetailsBloc, FieldVisitDetailsState>(
                bloc: fieldVisitDetailsBloc,
                listenWhen: (previous, current) => current is FieldVisitDetailsnActionState,
                buildWhen: (previous, current) => current is! FieldVisitDetailsnActionState,
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is FieldVisitDetailsLoadingState) {
                    return Container(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is FieldVisitDetailsSuccessState) {
                    print("kkkkkkkkkkkkkkkkkkkkkkk");
                    print(state.visit[0].photo);

                    for (int i = 0; i < state.fieldFindings!.length; i++) {
                      List<TextEditingController> maleControllersForParticipant = [];
                      List<TextEditingController> femaleControllersForParticipant = [];

                      for (int j = 0; j < state.fieldFindings![i].questionAnswer.length; j++) {
                        // Check if the participant level has data before adding controllers
                        if (state.fieldFindings![i].questionAnswer[j].answer != null) {
                          // Add male controller
                          maleControllersForParticipant.add(TextEditingController(
                            text: state.fieldFindings![i].questionAnswer[j].answer.toString(),
                          ));
                        }
                      }

                      // Add the lists for the current participant to the main list
                      FieldVisitDetailsConroller.add(maleControllersForParticipant);
                    }
                    return Column(
                      children: [
                        // Text(
                        //   state.visit[0].id.toString(),
                        // ),
                        // GestureDetector(
                        //   onTap: () async {
                        //     await Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (context) {
                        //           return FieldFindingCreatePage(
                        //             id: state.visit[0].id.toString(),
                        //           );
                        //         },
                        //       ),
                        //     );
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.all(8),
                        //     decoration: BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: Colors.white,
                        //     ),
                        //     child: Icon(
                        //       Icons.create_new_folder,
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // ),
                        Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 235, 229, 229),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8.r),
                                        bottomRight: Radius.circular(8.r),
                                        topLeft: Radius.circular(8.r),
                                        topRight: Radius.circular(8.r),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(1, 1.0), //(x,y)
                                            blurRadius: 3.0,
                                            spreadRadius: 0.2),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  "Division",
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                              Expanded(
                                                flex: 4,
                                                child: Text("${state.visit[0].division}",
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  "District",
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 4,
                                                  child: Text("${state.visit[0].district}",
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight: FontWeight.w400,
                                                        color: Colors.black,
                                                      ))),
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                                        //   child: Row(
                                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //     children: [
                                        //       Expanded(
                                        //         flex: 4,
                                        //         child: Text(
                                        //           "District Name",
                                        //           style: TextStyle(
                                        //             fontSize: 15.sp,
                                        //             fontWeight: FontWeight.w400,
                                        //             color: Colors.black,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       Expanded(
                                        //           flex: 2,
                                        //           child: Text(
                                        //             ":",
                                        //             style: TextStyle(
                                        //               fontWeight: FontWeight.bold,
                                        //               color: Colors.black,
                                        //             ),
                                        //           )),
                                        //       Expanded(
                                        //         flex: 6,
                                        //         child: Text("${state.visit[0].district}",
                                        //             style: TextStyle(
                                        //               fontSize: 15.sp,
                                        //               fontWeight: FontWeight.w400,
                                        //               color: Colors.black,
                                        //             )),
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),

                                        Padding(
                                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  "Upazila",
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                              Expanded(
                                                flex: 4,
                                                child: Text("${state.visit[0].upazila}",
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  "Union",
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                              Expanded(
                                                flex: 4,
                                                child: Text("${state.visit[0].union}",
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black,
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                                        //   child: Row(
                                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //     children: [
                                        //       Expanded(
                                        //         flex: 4,
                                        //         child: Text(
                                        //           "Union Name",
                                        //           style: TextStyle(
                                        //             fontSize: 15.sp,
                                        //             fontWeight: FontWeight.w400,
                                        //             color: Colors.black,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       Expanded(
                                        //           flex: 2,
                                        //           child: Text(
                                        //             ":",
                                        //             style: TextStyle(
                                        //               fontWeight: FontWeight.bold,
                                        //               color: Colors.black,
                                        //             ),
                                        //           )),
                                        //       Expanded(
                                        //         flex: 6,
                                        //         child: Text("${state.visit[0].union}",
                                        //             style: TextStyle(
                                        //               fontSize: 15.sp,
                                        //               fontWeight: FontWeight.w400,
                                        //               color: Colors.black,
                                        //             )),
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                                        //   child: Row(
                                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //     children: [
                                        //       Expanded(
                                        //         flex: 4,
                                        //         child: Text(
                                        //           "Latitude",
                                        //           style: TextStyle(
                                        //             fontSize: 15.sp,
                                        //             fontWeight: FontWeight.w400,
                                        //             color: Colors.black,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       Expanded(
                                        //           flex: 2,
                                        //           child: Text(
                                        //             ":",
                                        //             style: TextStyle(
                                        //               fontWeight: FontWeight.bold,
                                        //               color: Colors.black,
                                        //             ),
                                        //           )),
                                        //       Expanded(
                                        //         flex: 6,
                                        //         child: Text("${state.visit[0].latitude}",
                                        //             style: TextStyle(
                                        //               fontSize: 15.sp,
                                        //               fontWeight: FontWeight.w400,
                                        //               color: Colors.black,
                                        //             )),
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                                        //   child: Row(
                                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //     children: [
                                        //       Expanded(
                                        //         flex: 4,
                                        //         child: Text(
                                        //           "Longitude",
                                        //           style: TextStyle(
                                        //             fontSize: 15.sp,
                                        //             fontWeight: FontWeight.w400,
                                        //             color: Colors.black,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       Expanded(
                                        //           flex: 2,
                                        //           child: Text(
                                        //             ":",
                                        //             style: TextStyle(
                                        //               fontWeight: FontWeight.bold,
                                        //               color: Colors.black,
                                        //             ),
                                        //           )),
                                        //       Expanded(
                                        //         flex: 6,
                                        //         child: Text("${state.visit[0].latitude}",
                                        //             style: TextStyle(
                                        //               fontSize: 15.sp,
                                        //               fontWeight: FontWeight.w400,
                                        //               color: Colors.black,
                                        //             )),
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                  "Visit Date",
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                              Expanded(
                                                flex: 4,
                                                child: Text(
                                                    "${state.visit[0].visitDate.year}/${state.visit[0].visitDate.month}/${state.visit[0].visitDate.day}",
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.black,
                                                    )),
                                              ),
                                              Expanded(flex: 4, child: SizedBox.shrink()),
                                              Expanded(flex: 1, child: SizedBox.shrink()),
                                              Expanded(flex: 4, child: SizedBox.shrink()),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  "Photo",
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 6,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _showImageDialog(
                                                          context, "http://118.179.149.36:83/${state.visit[0].photo}");
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(right: 120),
                                                      child: SizedBox(
                                                          height: 80,
                                                          child:
                                                              Image.network("http://118.179.149.36:83/${state.visit[0].photo}")),
                                                    ),
                                                  )

                                                  //     CachedNetworkImage(
                                                  //   imageUrl: 'http://118.179.149.36:83/${state.visit[0].photo}',

                                                  //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                  //       Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                                  //   //  errorWidget: (context, url, error) => const Image(image: AssetImage("assets/images/default_image.png")),
                                                  // )
                                                  )
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  await Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return FieldVisitEditPage(
                                                          id: state.visit[0].id.toString(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  await Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return FieldFindingCreatePage(
                                                          id: state.visit[0].id.toString(),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                  ),
                                                  child: Icon(
                                                    Icons.create_new_folder,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0.h,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Latitude: ${state.visit[0].latitude}, Longitude: ${state.visit[0].longitude}',
                              style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
                            ),
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
                              onMapCreated: (controller) {
                                setState(() {
                                  mapController = controller;
                                });
                                mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                      target: LatLng(
                                        double.parse(state.visit[0].latitude),
                                        double.parse(state.visit[0].longitude),
                                      ),
                                      zoom: 14.0,
                                    ),
                                  ),
                                );
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  double.parse(state.visit[0].latitude),
                                  double.parse(state.visit[0].longitude),
                                ),
                                zoom: 14.0,
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId('target_location'),
                                  position: LatLng(
                                    double.parse(state.visit[0].latitude),
                                    double.parse(state.visit[0].longitude),
                                  ),
                                  infoWindow: InfoWindow(title: 'Target Location'),
                                ),
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        state.fieldFindings!.isEmpty
                            ? Container()
                            : Column(
                                children: [
                                  ...List.generate(state.fieldFindings!.length, (index) {
                                    return Column(
                                      children: [
                                        ExpansionTile(
                                          trailing: Icon(Icons.keyboard_arrow_down_outlined), // Icon for the leading position
                                          title: Text(
                                            state.fieldFindings![index].question,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          children: [
                                            ...List.generate(state.fieldFindings![index].questionAnswer.length, (AnswerIndex) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                                                    child: SizedBox(
                                                        height: 100.0.h,
                                                        width: double.infinity,
                                                        child: TextField(
                                                          readOnly: true,
                                                          controller: FieldVisitDetailsConroller[index][AnswerIndex],
                                                          maxLines: 300, // Set to null for an unlimited number of lines
                                                          decoration: InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            hintText:
                                                                state.fieldFindings![index].questionAnswer[AnswerIndex].answer,
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
                                        ),
                                        SizedBox(
                                          height: 30,
                                        )
                                      ],
                                    );
                                  }),
                                ],
                              )
                      ],
                    );
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl),
              // Add other widgets or buttons as needed
            ],
          ),
        );
      },
    );
  }
}
