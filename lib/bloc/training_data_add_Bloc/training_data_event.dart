part of 'training_data_bloc.dart';

@immutable
abstract class TrainingDataBlocEvent {}

class TrainingDataInitialEvent extends TrainingDataBlocEvent {}

class DistrictClickEvent extends TrainingDataBlocEvent {
  int? id;
  DistrictClickEvent({required this.id});
}

class UpazilaClickEvent extends TrainingDataBlocEvent {
  int? id;
  UpazilaClickEvent({required this.id});
}

class UnionClickEvent extends TrainingDataBlocEvent {
  int? id;
  UnionClickEvent({required this.id});
}

class TrainingEditEvent extends TrainingDataBlocEvent {
  String? id;
  TrainingEditEvent({required this.id});
}
