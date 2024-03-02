import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/new_TraningModel.dart';
import 'package:village_court_gems/models/triningEditModel.dart';

part 'training_data_event.dart';
part 'training_data_state.dart';

class TrainingDataAddBlocBloc extends Bloc<TrainingDataBlocEvent, TrainingDataBlocState> {
  TrainingDataAddBlocBloc() : super(TrainingDataInitialState()) {
    on<TrainingDataInitialEvent>(trainingDataInitialEvent);
    on<DistrictClickEvent>(districtClickEvent);
    on<UpazilaClickEvent>(upazilaClickEvent);
    on<UnionClickEvent>(unionClickEvent);
  }
  List alldata = [];
  List allDistrict = [];
  List allupazila = [];
  List allunion = [];
  late NewTrainingModel newTrainingModel;
  FutureOr<void> trainingDataInitialEvent(TrainingDataInitialEvent event, Emitter<TrainingDataBlocState> emit) async {
    emit(TrainingDataLoadingState());
    newTrainingModel = await Repositores().allTrainigsInfoSettingApi();
    print("api call from bloc");
    if (newTrainingModel.status == 200) {
      emit(TrainingDataSuccessState(
        data: newTrainingModel.data,
        district: [],
        upazila: [],
        union: [],
      ));
    }
  }

  FutureOr<void> districtClickEvent(DistrictClickEvent event, Emitter<TrainingDataBlocState> emit) async {
    int? id;
    id = event.id;
    print("district blocccccccccccccccc id");
    print(id);
    Map districtApiResponse = await Repositores().districtApi(id!);
    if (districtApiResponse['status'] == 200) {
      allDistrict = districtApiResponse['data'];
      emit(TrainingDataSuccessState(
        data: newTrainingModel.data,
        district: districtApiResponse['data'],
        upazila: [],
        union: [],
      ));
    }
  }

  FutureOr<void> upazilaClickEvent(UpazilaClickEvent event, Emitter<TrainingDataBlocState> emit) async {
    int? id;
    id = event.id;
    print(" upazilaC blocccccccccccccccc id");
    print(id);
    Map upazilaApiResponse = await Repositores().upazilaApi(id!);
    if (upazilaApiResponse['status'] == 200) {
      allupazila = upazilaApiResponse['data'];
      emit(TrainingDataSuccessState(
        data: newTrainingModel.data,
        district: allDistrict,
        upazila: upazilaApiResponse['data'],
        union: [],
      ));
    }
  }

  FutureOr<void> unionClickEvent(UnionClickEvent event, Emitter<TrainingDataBlocState> emit) async {
    int? id;
    id = event.id;
    print(" union blocccccccccccccccc id");
    print(id);
    Map unionApiResponse = await Repositores().unionApi(id!);
    if (unionApiResponse['status'] == 200) {
      allunion = unionApiResponse['data'];
      emit(TrainingDataSuccessState(
          data: newTrainingModel.data, district: allDistrict, upazila: allupazila, union: unionApiResponse['data']));
    }
  }

  // FutureOr<void> trainingEditEvent(TrainingEditEvent event, Emitter<TrainingDataBlocState> emit) async {
  //   String? id;
  //   id = event.id;
  //   TrainingEditModel? trainingEditModel;
  //   var trainingEditApiResponse = await Repositores().TrainigsEditAPi(id!);
  //   trainingEditModel = trainingEditApiResponse;
  //   emit(TrainingDataSuccessState(
  //     data: alldata,
  //     district: allDistrict,
  //     upazila: allupazila,
  //     union: allunion,
  //     trainingEditdata: trainingEditModel.data,
  //   ));
  // }
}
