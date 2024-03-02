part of 'field_finding_update_bloc.dart';

@immutable
abstract class FieldFindingUpdateEvent {}

class FieldFindingUpdateInitialEvent extends FieldFindingUpdateEvent {
  final String id;
  FieldFindingUpdateInitialEvent({required this.id});
}
