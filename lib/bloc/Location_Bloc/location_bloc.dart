import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/locationModel.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitialState()) {
    on<LocationInitialEvent>(locationInitialEvent);
  }

  FutureOr<void> locationInitialEvent(LocationInitialEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoadingState());
    LocationModel? locationModel;
    Map? locationBody;

    locationBody = event.locationModel;
    print("bloc location  ${locationBody}");

    // Map locationBody = {
    //   "latitude": 22.08589095.toString(),
    //   "longitude": 90.22874768.toString(),
    // };
    // Map locationBody = {
    //   "latitude": 23.8127958.toString(),
    //   "longitude": 90.4288492.toString(),
    // };
    var locationApiResponse = await Repositores().LocationApi(locationBody);

    print("LocationApi details   by Bloc...............");
    if (locationApiResponse.status == 200) {
      print('afikkkkkkk');
    }

    locationModel = locationApiResponse;
    print("lllllllllllllll");
    print(locationModel.unions);
    emit(LocationSuccessState(
        division: locationModel.divisions!,
        district: locationModel.districts!,
        upazila: locationModel.upazilas!,
        union: locationModel.unions!));
    // emit(LocationSuccessState(division: locationModel.divisions!, district: district, upazila: upazila, union: union));
  }
}
