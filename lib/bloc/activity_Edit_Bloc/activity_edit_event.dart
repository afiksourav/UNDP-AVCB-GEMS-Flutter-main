part of 'activity_edit_bloc.dart';

@immutable
abstract class ActivityEditEvent {}

class ActivityInitialEditEvent extends ActivityEditEvent {
  String? id;
  ActivityInitialEditEvent({required this.id});
}

class ActivityClickEditEvent extends ActivityEditEvent {
  String? id;
  ActivityClickEditEvent({required this.id});
}

class DistrictClickActivityEditEvent extends ActivityEditEvent {
  int? id;
  DistrictClickActivityEditEvent({required this.id});
}

class UpazilaClickActivityEditEvent extends ActivityEditEvent {
  int? id;
  UpazilaClickActivityEditEvent({required this.id});
}

class UnionClickActivityEditEvent extends ActivityEditEvent {
  int? id;
  UnionClickActivityEditEvent({required this.id});
}
