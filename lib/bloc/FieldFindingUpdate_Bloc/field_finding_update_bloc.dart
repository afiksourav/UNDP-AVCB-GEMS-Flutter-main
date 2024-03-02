import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/field_visit_model/fieldVisitUpdateModel.dart';

part 'field_finding_update_event.dart';
part 'field_finding_update_state.dart';

class FieldFindingUpdateBloc extends Bloc<FieldFindingUpdateEvent, FieldFindingUpdateState> {
  FieldFindingUpdateBloc() : super(FieldFindingUpdateInitialState()) {
    on<FieldFindingUpdateInitialEvent>(fieldFindingUpdateInitialEvent);
  }
  FieldVisitUpdateModel? fieldVisitUpdateModel;
  FutureOr<void> fieldFindingUpdateInitialEvent(
      FieldFindingUpdateInitialEvent event, Emitter<FieldFindingUpdateState> emit) async {
    emit(FieldFindingUpdateLoadingState());
    fieldVisitUpdateModel = await Repositores().FiedFindingUpdateApi(event.id);
    emit(FieldFindingUpdateSuccessState(question: fieldVisitUpdateModel!.question));
  }
}
