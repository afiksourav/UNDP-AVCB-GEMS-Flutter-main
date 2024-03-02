part of 'training_details_bloc.dart';

@immutable
abstract class TrainingDetailsState {}

abstract class TrainingDetailsActionState extends TrainingDetailsState {}

class TrainingDetailsInitialState extends TrainingDetailsState {}

class TrainingDetailsLoadingState extends TrainingDetailsState {}

class TrainingDetailsSuccessState extends TrainingDetailsState {
  List<Datum> data1;
  TrainingDetailsSuccessState({
    required this.data1,
  });
}
