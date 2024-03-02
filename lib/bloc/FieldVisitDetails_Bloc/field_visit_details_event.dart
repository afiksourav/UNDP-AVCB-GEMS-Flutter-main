part of 'field_visit_details_bloc.dart';

@immutable
abstract class FieldVisitDetailsEvent {}

class FieldVisitDetailsInitialEvent extends FieldVisitDetailsEvent {
  final int id;
  FieldVisitDetailsInitialEvent({required this.id});
}
