import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/activityDetailsModel.dart';
import 'package:village_court_gems/models/activityEditModel.dart';
import 'package:village_court_gems/models/avtivity._model.dart';

part 'activity_edit_event.dart';
part 'activity_edit_state.dart';

class ActivityEditBloc extends Bloc<ActivityEditEvent, ActivityEditState> {
  ActivityEditBloc() : super(ActivityEditInitialState()) {
    on<ActivityInitialEditEvent>(activityInitialEditEvent);
    on<ActivityClickEditEvent>(activityClickEditEvent);
    on<DistrictClickActivityEditEvent>(districtClickEvent);
    on<UpazilaClickActivityEditEvent>(upazilaClickEvent);
    on<UnionClickActivityEditEvent>(unionClickEvent);
  }
  Activity? activityModel;
  ActivityEditModel? activityEditModel;
  ActivityDetailsModel? activityDetailsModel;
  List allDistrict = [];
  List allupazila = [];
  FutureOr<void> activityInitialEditEvent(ActivityInitialEditEvent event, Emitter<ActivityEditState> emit) async {
    emit(ActivityEditLoadingState());
    activityModel = await Repositores().ActivityApi();
    if (activityModel!.status == 200) {
      activityEditModel = await Repositores().ActivityDataEditApi(event.id!);
      if (activityEditModel!.status == 200) {
        emit(ActivityEditSuccessState(
          activityEditData: activityEditModel!.activityEditData,
          data: activityModel!.data,
          ActivityDetailsData: [],
          district: [],
          upazila: [],
          union: [],
        ));
      }
    }
  }

  FutureOr<void> activityClickEditEvent(ActivityClickEditEvent event, Emitter<ActivityEditState> emit) async {
    activityDetailsModel = await Repositores().ActivityDetailsApi(event.id!);
    if (activityDetailsModel!.status == 200) {
      emit(ActivityEditSuccessState(
        activityEditData: activityEditModel!.activityEditData,
        data: activityModel!.data,
        ActivityDetailsData: activityDetailsModel!.activityDetailsModel,
        district: [],
        upazila: [],
        union: [],
      ));
    }
  }

  FutureOr<void> districtClickEvent(DistrictClickActivityEditEvent event, Emitter<ActivityEditState> emit) async {
    int? id;
    id = event.id;
    print("district blocccccccccccccccc id ${id}");
    Map districtApiResponse = await Repositores().districtApi(int.parse(id!.toString()));
    if (districtApiResponse['status'] == 200) {
      allDistrict = districtApiResponse['data'];
      emit(ActivityEditSuccessState(
        activityEditData: activityEditModel!.activityEditData,
        data: activityModel!.data,
        ActivityDetailsData: activityDetailsModel == null ? [] : activityDetailsModel!.activityDetailsModel,
        district: allDistrict,
        upazila: [],
        union: [],
      ));
    }
  }

  FutureOr<void> upazilaClickEvent(UpazilaClickActivityEditEvent event, Emitter<ActivityEditState> emit) async {
    int? id;
    id = event.id;
    print(" upazilaC blocccccccccccccccc id");
    print(id);
    Map upazilaApiResponse = await Repositores().upazilaApi(int.parse(id!.toString()));
    if (upazilaApiResponse['status'] == 200) {
      allupazila = upazilaApiResponse['data'];
      emit(ActivityEditSuccessState(
        activityEditData: activityEditModel!.activityEditData,
        data: activityModel!.data,
        ActivityDetailsData: activityDetailsModel == null ? [] : activityDetailsModel!.activityDetailsModel,
        district: allDistrict,
        upazila: allupazila,
        union: [],
      ));
    }
  }

  FutureOr<void> unionClickEvent(UnionClickActivityEditEvent event, Emitter<ActivityEditState> emit) async {
    int? id;
    id = event.id;
    print(" union blocccccccccccccccc id");
    print(id);
    Map unionApiResponse = await Repositores().unionApi(int.parse(id!.toString()));
    if (unionApiResponse['status'] == 200) {
      emit(ActivityEditSuccessState(
        activityEditData: activityEditModel!.activityEditData,
        data: activityModel!.data,
        ActivityDetailsData: activityDetailsModel == null ? [] : activityDetailsModel!.activityDetailsModel,
        district: allDistrict,
        upazila: allupazila,
        union: unionApiResponse['data'],
      ));
    }
  }
}
