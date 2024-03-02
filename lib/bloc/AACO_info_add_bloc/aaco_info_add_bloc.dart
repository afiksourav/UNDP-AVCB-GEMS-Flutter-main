import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/area_model/all_district_model.dart';

part 'aaco_info_add_event.dart';
part 'aaco_info_add_state.dart';

class AacoInfoAddBloc extends Bloc<AacoInfoAddEvent, AacoInfoAddState> {
  AacoInfoAddBloc() : super(AacoInfoAddInitialState()) {
    on<AacoInfoAddInitialEvent>(aacoInfoAddInitialEvent);
    on<AacoUpazilaClickEvent>(aacoUpazilaClickEvent);
    on<AacoUnionClickEvent>(aacoUnionClickEvent);
  }
  List allupazila = [];
  AllDistrictModel? allDistrictModel;
  FutureOr<void> aacoInfoAddInitialEvent(AacoInfoAddInitialEvent event, Emitter<AacoInfoAddState> emit) async {
    emit(AacoInfoAddLoadingState());
// ignore_for_file: unused_local_variable
    allDistrictModel = await Repositores().allDistrictApi();
    print("api call allDistrict from bloc");
    if (allDistrictModel!.status == 200) {
      emit(AacoInfoAddSuccessState(district: allDistrictModel!.data));
    }
  }

  FutureOr<void> aacoUpazilaClickEvent(AacoUpazilaClickEvent event, Emitter<AacoInfoAddState> emit) async {
    int? id;
    id = event.id;
    print(" upazilaC blocccccccccccccccc id");
    print(id);
    Map upazilaApiResponse = await Repositores().upazilaApi(id!);
    if (upazilaApiResponse['status'] == 200) {
      allupazila = upazilaApiResponse['data'];
      emit(AacoInfoAddSuccessState(district: allDistrictModel!.data, upazila: allupazila));
    }
  }

  FutureOr<void> aacoUnionClickEvent(AacoUnionClickEvent event, Emitter<AacoInfoAddState> emit) async {
    int? id;
    id = event.id;
    print(" union blocccccccccccccccc id");
    print(id);
    Map unionApiResponse = await Repositores().unionApi(id!);
    if (unionApiResponse['status'] == 200) {
      emit(AacoInfoAddSuccessState(district: allDistrictModel!.data, upazila: allupazila, union: unionApiResponse['data']));
    }
  }
}
