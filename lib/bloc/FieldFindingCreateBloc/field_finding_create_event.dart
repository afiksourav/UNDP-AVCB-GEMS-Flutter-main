part of 'field_finding_create_bloc.dart';

@immutable
abstract class FieldFindingCreateEvent {}
class FieldFindingCreateInitialEvent extends FieldFindingCreateEvent {
  final String id;
  FieldFindingCreateInitialEvent({required this.id});
}
