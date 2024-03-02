part of 'field_finding_update_bloc.dart';

@immutable
abstract class FieldFindingUpdateState {}

abstract class FieldFindingUpdateActionState extends FieldFindingUpdateState {}

class FieldFindingUpdateInitialState extends FieldFindingUpdateState {}

class FieldFindingUpdateLoadingState extends FieldFindingUpdateState {}

// ignore: must_be_immutable
class FieldFindingUpdateSuccessState extends FieldFindingUpdateState {
  List<Question> question;
  FieldFindingUpdateSuccessState({
    required this.question,
  });
}
