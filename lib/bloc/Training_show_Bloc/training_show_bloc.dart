import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/traning_model.dart';

part 'training_show_event.dart';
part 'training_show_state.dart';

class TrainingShowBloc extends Bloc<TrainingShowEvent, TrainingShowState> {
  TrainingShowBloc() : super(TrainingShowInitialState()) {
    on<TrainingShowInitialEvent>(trainingDataInitialEvent);
  }

  FutureOr<void> trainingDataInitialEvent(TrainingShowInitialEvent event, Emitter<TrainingShowState> emit) async {
    emit(TrainingShowLoadingState());
    TrainingModel? trainingModel;
    var TrainingApiResponse = await Repositores().allTrainigsShowApi();

    trainingModel = TrainingApiResponse;
    print("aaaaaaaaaaaaaaaaaaaaaaa");
    print(trainingModel.data);

    emit(TrainingShowSuccessState(data: trainingModel.data));
  }
}
