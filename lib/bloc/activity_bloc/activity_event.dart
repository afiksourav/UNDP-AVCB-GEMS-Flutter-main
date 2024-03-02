part of 'activity_bloc.dart';

@immutable
abstract class ActivityEvent {}

class ActivityInitialEvent extends ActivityEvent {}

class ActivityClickEvent extends ActivityEvent {
  int? id;
  ActivityClickEvent({required this.id});
}

class DistrictClickEvent extends ActivityEvent {
  int? id;
  DistrictClickEvent({required this.id});
}

class UpazilaClickEvent extends ActivityEvent {
  int? id;
  UpazilaClickEvent({required this.id});
}
class UnionClickEvent extends ActivityEvent {
  int? id;
  UnionClickEvent({required this.id});
}
