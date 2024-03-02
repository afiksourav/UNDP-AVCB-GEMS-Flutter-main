import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/activityDetailsModel.dart';
import 'package:village_court_gems/models/avtivity._model.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(ActivityInitialState()) {
    on<ActivityInitialEvent>(activityInitialEvent);
    on<ActivityClickEvent>(activityClickEvent);
    on<DistrictClickEvent>(districtClickEvent);
    on<UpazilaClickEvent>(upazilaClickEvent);
    on<UnionClickEvent>(unionClickEvent);
  }
  Activity? activityModel;
  ActivityDetailsModel? activityDetailsModel;
  List allDistrict = [];
  List allupazila = [];
  FutureOr<void> activityInitialEvent(ActivityInitialEvent event, Emitter<ActivityState> emit) async {
    emit(ActivityLoadingState());

    var activity = await Repositores().ActivityApi();
    activityModel = activity;
    emit(
      ActivitySuccessState(
        data: activityModel!.data,
        ActivityDetailsData: [],
        district: [],
        upazila: [],
        union: [],
      ),
    );
  }

  FutureOr<void> activityClickEvent(ActivityClickEvent event, Emitter<ActivityState> emit) async {
    int? id;
    id = event.id;
    print("Activity blocccccccccccccccc id $id");

    var activityDetails = await Repositores().ActivityDetailsApi(id.toString());
    activityDetailsModel = activityDetails;

    emit(
      ActivitySuccessState(
        data: activityModel!.data,
        ActivityDetailsData: activityDetailsModel!.activityDetailsModel,
        district: [],
        upazila: [],
        union: [],
      ),
    );
  }

  FutureOr<void> districtClickEvent(DistrictClickEvent event, Emitter<ActivityState> emit) async {
    int? id;
    id = event.id;
    print("district blocccccccccccccccc id $id");
    Map districtApiResponse = await Repositores().districtApi(int.parse(id!.toString()));
    if (districtApiResponse['status'] == 200) {
      allDistrict = districtApiResponse['data'];
      emit(
        ActivitySuccessState(
          data: activityModel!.data,
          ActivityDetailsData: activityDetailsModel!.activityDetailsModel,
          district: districtApiResponse['data'],
          upazila: [],
          union: [],
        ),
      );
    }
  }

  FutureOr<void> upazilaClickEvent(UpazilaClickEvent event, Emitter<ActivityState> emit) async {
    int? id;
    id = event.id;
    print(" upazilaC blocccccccccccccccc id");
    print(id);
    Map upazilaApiResponse = await Repositores().upazilaApi(int.parse(id!.toString()));
    if (upazilaApiResponse['status'] == 200) {
      allupazila = upazilaApiResponse['data'];
      emit(
        ActivitySuccessState(
          data: activityModel!.data,
          ActivityDetailsData: activityDetailsModel!.activityDetailsModel,
          district: allDistrict,
          upazila: upazilaApiResponse['data'],
          union: [],
        ),
      );
    }
  }

  FutureOr<void> unionClickEvent(UnionClickEvent event, Emitter<ActivityState> emit) async {
    int? id;
    id = event.id;
    print(" union blocccccccccccccccc id");
    print(id);
    Map unionApiResponse = await Repositores().unionApi(int.parse(id!.toString()));
    if (unionApiResponse['status'] == 200) {
      emit(
        ActivitySuccessState(
          data: activityModel!.data,
          ActivityDetailsData: activityDetailsModel!.activityDetailsModel,
          district: allDistrict,
          upazila: allupazila,
          union: unionApiResponse['data'],
        ),
      );
    }
  }
}
