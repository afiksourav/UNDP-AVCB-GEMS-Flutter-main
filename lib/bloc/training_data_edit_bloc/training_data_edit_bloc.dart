import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/triningEditModel.dart';

part 'training_data_edit_event.dart';
part 'training_data_edit_state.dart';

class TrainingDataEditBloc extends Bloc<TrainingDataEditEvent, TrainingDataEditState> {
  TrainingDataEditBloc() : super(TrainingDataEditInitialState()) {
    on<TrainingDataEditInitialEvent>(trainingDataEditInitialEvent);
    on<DistrictClickEvent>(districtClickEvent);
    on<UpazilaClickEvent>(upazilaClickEvent);
    on<UnionClickEvent>(unionClickEvent);
  }
  List alldata = [];
  List allDistrict = [];
  List allupazila = [];
  List allunion = [];
  List EditData = [];
  TrainingEditModel? trainingEditModel;

  FutureOr<void> trainingDataEditInitialEvent(TrainingDataEditInitialEvent event, Emitter<TrainingDataEditState> emit) async {
    int? id;
    id = event.id;
    emit(TrainingDataEditLoadingState());
     Map TrainingApiResponse ={};
  //  Map TrainingApiResponse = await Repositores().trainingInfoSettingApi();
    var TrainingDataEditApiResponse = await Repositores().TrainigsEditAPi(id!);
    print("api call from bloc");

    trainingEditModel = TrainingDataEditApiResponse;

    if (TrainingApiResponse['status'] == 200) {
      alldata = TrainingApiResponse['data'];
      if (trainingEditModel!.status == 200) {
        emit(TrainingDataEditSuccessState(
            data: alldata,
            district: [],
            upazila: [],
            union: [],
            trainingEditdata: trainingEditModel!.data,
            participant: trainingEditModel!.participant));
      }
    }
  }

  FutureOr<void> districtClickEvent(DistrictClickEvent event, Emitter<TrainingDataEditState> emit) async {
    int? id;
    id = event.id;
    print("district blocccccccccccccccc id");
    print(id);
    Map districtApiResponse = await Repositores().districtApi(id!);
    if (districtApiResponse['status'] == 200) {
      allDistrict = districtApiResponse['data'];
      emit(TrainingDataEditSuccessState(
          data: alldata,
          district: districtApiResponse['data'],
          upazila: [],
          union: [],
          trainingEditdata: trainingEditModel!.data,
          participant: trainingEditModel!.participant));
    }
  }

  FutureOr<void> upazilaClickEvent(UpazilaClickEvent event, Emitter<TrainingDataEditState> emit) async {
    int? id;
    id = event.id;
    print(" upazilaC blocccccccccccccccc id");
    print(id);
    Map upazilaApiResponse = await Repositores().upazilaApi(id!);
    if (upazilaApiResponse['status'] == 200) {
      allupazila = upazilaApiResponse['data'];
      emit(TrainingDataEditSuccessState(
          data: alldata,
          district: allDistrict,
          upazila: allupazila,
          union: [],
          trainingEditdata: trainingEditModel!.data,
          participant: trainingEditModel!.participant));
    }
  }

  FutureOr<void> unionClickEvent(UnionClickEvent event, Emitter<TrainingDataEditState> emit) async {
    int? id;
    id = event.id;
    print(" union blocccccccccccccccc id");
    print(id);
    Map unionApiResponse = await Repositores().unionApi(id!);
    if (unionApiResponse['status'] == 200) {
      allunion = unionApiResponse['data'];
      emit(TrainingDataEditSuccessState(
          data: alldata,
          district: allDistrict,
          upazila: allupazila,
          union: allunion,
          trainingEditdata: trainingEditModel!.data,
          participant: trainingEditModel!.participant));
    }
  }
}
