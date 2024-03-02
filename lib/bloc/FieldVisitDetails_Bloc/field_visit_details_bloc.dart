import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/field_visit_model/field_visit_list_details_model.dart';

part 'field_visit_details_event.dart';
part 'field_visit_details_state.dart';

class FieldVisitDetailsBloc extends Bloc<FieldVisitDetailsEvent, FieldVisitDetailsState> {
  FieldVisitDetailsBloc() : super(FieldVisitDetailsInitialState()) {
    on<FieldVisitDetailsInitialEvent>(fieldVisitDetailsInitialEvent);
  }
  FieldVisitListDetailsModel? fieldVisitListDetailsModel;
  FutureOr<void> fieldVisitDetailsInitialEvent(FieldVisitDetailsInitialEvent event, Emitter<FieldVisitDetailsState> emit) async {
    emit(FieldVisitDetailsLoadingState());
    fieldVisitListDetailsModel = await Repositores().FiedVisitListDetailsApi(event.id.toString());
    if (fieldVisitListDetailsModel!.status == 200) {
      emit(FieldVisitDetailsSuccessState(
          visit: fieldVisitListDetailsModel!.visit, fieldFindings: fieldVisitListDetailsModel!.fieldFindings));
    }
  }
}
