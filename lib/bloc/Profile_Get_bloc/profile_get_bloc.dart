import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/profile_model.dart';

part 'profile_get_event.dart';
part 'profile_get_state.dart';

class ProfileGetBloc extends Bloc<ProfileGetEvent, ProfileGetState> {
  ProfileGetBloc() : super(ProfileGetInitialState()) {
    on<ProfileDataInitialEvent>(profileDataInitialEvent);
  }

  FutureOr<void> profileDataInitialEvent(ProfileDataInitialEvent event, Emitter<ProfileGetState> emit) async {
    emit(ProfileGetLoadingState());
    ProfileModel? profilemodel;
    var a = await Repositores().GetProfileApi();
    print("profile get from bloc");
    profilemodel = a;
    print(profilemodel.data!.email);
    emit(ProfileGetSuccessState(data: profilemodel.data!));
  }
}
