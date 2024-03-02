import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:village_court_gems/bloc/Training_show_Bloc/training_show_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/view/Trainings/Trainings_info_Details.dart';
import 'package:village_court_gems/view/Trainings/training_data_add&update.dart';

class TrainingsPage extends StatefulWidget {
  static const pageName = 'Trainings_page';
  const TrainingsPage({super.key});

  @override
  State<TrainingsPage> createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TrainingsPage> {
  // Training? trainingData;
  // Future<void> _fetchAllTraings() async {
  //   var a = await Repositores().allTrainigsShowApi();
  //   trainingData = a;
  //   print("aaaaaaaaaaaaaaaaaaaaaaa");
  //   print(trainingData!.data);
  // }

  final TrainingShowBloc trainingShowBloc = TrainingShowBloc();
  @override
  void initState() {
    trainingShowBloc.add(TrainingShowInitialEvent());
    // TODO: implement initState
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
        title: Text(
          "Trainings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(children: [
        Row(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Training Info Settings",
                  style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        BlocConsumer<TrainingShowBloc, TrainingShowState>(
            bloc: trainingShowBloc,
            listenWhen: (previous, current) => current is TrainingShowActionState,
            buildWhen: (previous, current) => current is! TrainingShowActionState,
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is TrainingShowLoadingState) {
                return Container(
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (state is TrainingShowSuccessState) {
                print("yyyyyyyyyyyyyyyyyyyyyyyyy");
                //Training? trainingData;
                //state.data = trainingData;
                // Training trainingData1111 = state.data;
                // print(state.data);
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      print(state.data[index]);
                      return Padding(
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
                                    padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.0.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            "Training Name",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            )),
                                        Expanded(
                                          flex: 6,
                                          child: Text("${state.data[index].title}",
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
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
                                      left: 10.w,
                                      right: 10.w,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            "Component",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Text(":",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ))),
                                        Expanded(
                                          flex: 6,
                                          child: Text("${state.data[index].component.name}",
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 10.w,
                                      right: 10.w,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            "Total Count",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Text(":",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ))),
                                        Expanded(
                                          flex: 6,
                                          child: Text("${state.data[index].count}",
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                        return TrainingsInfoDetails(
                                          id: state.data[index].id.toString(),
                                        );
                                      }));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0.w),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(255, 54, 50, 50),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(5.r),
                                                bottomRight: Radius.circular(5.r),
                                                topLeft: Radius.circular(5.r),
                                                topRight: Radius.circular(5.r),
                                              ),
                                            ),
                                            child: Center(
                                                child: Text(
                                              "Details",
                                              style: TextStyle(color: Colors.white),
                                            )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
              return Container();
            })
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(TrainingDataPage.pageName);
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
