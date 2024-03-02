part of 'training_data_edit_bloc.dart';

@immutable
abstract class TrainingDataEditEvent {}

class TrainingDataEditInitialEvent extends TrainingDataEditEvent {
  int? id;
  TrainingDataEditInitialEvent({required this.id});
}

class DistrictClickEvent extends TrainingDataEditEvent {
  int? id;
  DistrictClickEvent({required this.id});
}

class UpazilaClickEvent extends TrainingDataEditEvent {
  int? id;
  UpazilaClickEvent({required this.id});
}

class UnionClickEvent extends TrainingDataEditEvent {
  int? id;
  UnionClickEvent({required this.id});
}
