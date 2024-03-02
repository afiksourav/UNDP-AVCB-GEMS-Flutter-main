part of 'change_location_bloc.dart';

@immutable
abstract class ChangeLocationEvent {}

class ChangeLocationInitialEvent extends ChangeLocationEvent {}

class DistrictClickEvent extends ChangeLocationEvent {
  final int? id;
  DistrictClickEvent({required this.id});
}

class UpazilaClickEvent extends ChangeLocationEvent {
  final int? id;
  UpazilaClickEvent({required this.id});
}

class UnionClickEvent extends ChangeLocationEvent {
  final int? id;
  UnionClickEvent({required this.id});
}
