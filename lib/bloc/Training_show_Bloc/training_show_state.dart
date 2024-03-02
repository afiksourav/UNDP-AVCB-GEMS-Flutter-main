part of 'training_show_bloc.dart';

@immutable
abstract class TrainingShowState {}

abstract class TrainingShowActionState extends TrainingShowState {}

class TrainingShowInitialState extends TrainingShowState {}

class TrainingShowLoadingState extends TrainingShowState {}

class TrainingShowSuccessState extends TrainingShowState {
  List<Datum> data;
  TrainingShowSuccessState({
    required this.data,
  });
}
