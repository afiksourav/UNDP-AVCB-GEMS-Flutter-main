part of 'field_finding_create_bloc.dart';

@immutable
abstract class FieldFindingCreateState {}

abstract class FieldFindingCreateActionState extends FieldFindingCreateState {}

class FieldFindingCreateInitialState extends FieldFindingCreateState {}

class FieldFindingCreateLoadingState extends FieldFindingCreateState {}

class FieldFindingCreateSuccessState extends FieldFindingCreateState {
  List<FieldCreateData> fieldCreateData;
  FieldFindingCreateSuccessState({
    required this.fieldCreateData,
  });
}
