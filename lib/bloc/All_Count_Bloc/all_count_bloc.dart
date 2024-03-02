import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/countModel.dart';

part 'all_count_event.dart';
part 'all_count_state.dart';

class AllCountBloc extends Bloc<AllCountEvent, AllCountState> {
  AllCountBloc() : super(AllCountInitialState()) {
    on<AllCountInitialEvent>(allCountInitialEvent);
  }
  CountModel? countModel;
  FutureOr<void> allCountInitialEvent(AllCountInitialEvent event, Emitter<AllCountState> emit) async {
    emit(AllCountLoadingState());
    countModel = await Repositores().countAPi();
    if (countModel!.status == 200) {
      print("form bloc");
      print(countModel!.accoInfoCount);
      emit(AllCountSuccessState(countModel: countModel));
    }
  }
}
