import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/field_visit_model/FieldFindingCreateModel.dart';

part 'field_finding_create_event.dart';
part 'field_finding_create_state.dart';

class FieldFindingCreateBloc extends Bloc<FieldFindingCreateEvent, FieldFindingCreateState> {
  FieldFindingCreateBloc() : super(FieldFindingCreateInitialState()) {
    on<FieldFindingCreateInitialEvent>(fieldFindingCreateInitialEvent);
  }
  FieldFindingCreateModel? fieldFindingCreateModel;
  FutureOr<void> fieldFindingCreateInitialEvent(
      FieldFindingCreateInitialEvent event, Emitter<FieldFindingCreateState> emit) async {
    emit(FieldFindingCreateLoadingState());
    fieldFindingCreateModel = await Repositores().FiedFindingCreatesApi(event.id);
    if (fieldFindingCreateModel!.status == 200) {
      emit(FieldFindingCreateSuccessState(fieldCreateData: fieldFindingCreateModel!.data));
    }
  }
}
