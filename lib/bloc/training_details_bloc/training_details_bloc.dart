import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/traning_details_model.dart';

part 'training_details_event.dart';
part 'training_details_state.dart';

class TrainingDetailsBloc extends Bloc<TrainingDetailsEvent, TrainingDetailsState> {
  TrainingDetailsBloc() : super(TrainingDetailsInitialState()) {
    on<TrainingDetailsInitialEvent>(trainingDetailsInitialEvent);
  }

  FutureOr<void> trainingDetailsInitialEvent(TrainingDetailsInitialEvent event, Emitter<TrainingDetailsState> emit) async {
    emit(TrainingDetailsLoadingState());
    TrainingDetailsModels? trainingDetailsModels;
    var TrainingDetailsApiResponse = await Repositores().TrainigsDetailsAPi();
    print("Training details...............");
    print(TrainingDetailsApiResponse.data);
    trainingDetailsModels = TrainingDetailsApiResponse;
    emit(TrainingDetailsSuccessState(data1: trainingDetailsModels.data));
  }
}
