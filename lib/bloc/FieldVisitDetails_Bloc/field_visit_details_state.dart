part of 'field_visit_details_bloc.dart';

@immutable
abstract class FieldVisitDetailsState {}

abstract class FieldVisitDetailsnActionState extends FieldVisitDetailsState {}

class FieldVisitDetailsInitialState extends FieldVisitDetailsState {}

class FieldVisitDetailsLoadingState extends FieldVisitDetailsState {}

class FieldVisitDetailsSuccessState extends FieldVisitDetailsState {
  List<Visit> visit;

  List<FieldFinding>? fieldFindings;

  FieldVisitDetailsSuccessState({required this.visit, this.fieldFindings});
}
