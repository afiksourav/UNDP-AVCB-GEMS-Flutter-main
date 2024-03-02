import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';

part 'change_location_event.dart';
part 'change_location_state.dart';

class ChangeLocationBloc extends Bloc<ChangeLocationEvent, ChangeLocationState> {
  ChangeLocationBloc() : super(ChangeLocationInitialState()) {
    on<ChangeLocationInitialEvent>(changeLocationInitialEvent);
    on<DistrictClickEvent>(districtClickEvent);
    on<UpazilaClickEvent>(upazilaClickEvent);
    on<UnionClickEvent>(unionClickEvent);
  }
  List allDivision = [];
  List allDistrict = [];
  List allupazila = [];
  List allUnion = [];
  FutureOr<void> changeLocationInitialEvent(ChangeLocationInitialEvent event, Emitter<ChangeLocationState> emit) async {
    emit(ChangeLocationLoadingState());

    // Map devisionApiResponse = await Repositores().divisionApi();
    // print("from blocccccccccccc ${devisionApiResponse['data']}");
    // allDivision = devisionApiResponse['data'];
    /// emit(ChangeLocationSuccessState(division: devisionApiResponse['data'], district: [], upazila: [], union: []));
    List storeDivisionData = await Helper().getDivisionData();
    allDivision = storeDivisionData;
    emit(ChangeLocationSuccessState(division: storeDivisionData, district: [], upazila: [], union: []));
  }

  FutureOr<void> districtClickEvent(DistrictClickEvent event, Emitter<ChangeLocationState> emit) async {
    int? id;
    id = event.id;
    print("district blocccccccccccccccc id");
    print(id);
    allDistrict.clear();
    // Map districtApiResponse = await Repositores().districtApi(id!);
    // if (districtApiResponse['status'] == 200) {
    //   allDistrict = districtApiResponse['data'];
    //   emit(ChangeLocationSuccessState(division: allDivision, district: districtApiResponse['data'], upazila: [], union: []));
    // }
    List storeDistrictData = await Helper().getDistrictData();
    storeDistrictData.forEach((element) {
      if (element['division_id'] == id) {
        allDistrict.add(element);
      }
    });

    emit(ChangeLocationSuccessState(division: allDivision, district: allDistrict, upazila: [], union: []));
  }

  FutureOr<void> upazilaClickEvent(UpazilaClickEvent event, Emitter<ChangeLocationState> emit) async {
    int? id;
    id = event.id;
    print(" upazilaC blocccccccccccccccc id");
    print(id);
    allupazila.clear();
    // Map upazilaApiResponse = await Repositores().upazilaApi(id!);
    // if (upazilaApiResponse['status'] == 200) {
    //   allupazila = upazilaApiResponse['data'];
    //   emit(ChangeLocationSuccessState(
    //       division: allDivision, district: allDistrict, upazila: upazilaApiResponse['data'], union: []));
    // }
    List storeUpazilaData = await Helper().getUpazilaData();
    storeUpazilaData.forEach(
      (element) {
        if (element['district_id'] == id) {
          allupazila.add(element);
        }
      },
    );
    emit(ChangeLocationSuccessState(division: allDivision, district: allDistrict, upazila: allupazila, union: []));
  }

  FutureOr<void> unionClickEvent(UnionClickEvent event, Emitter<ChangeLocationState> emit) async {
    int? id;
    id = event.id;
    print(" union blocccccccccccccccc id");
    print(id);
    allUnion.clear();
    // Map unionApiResponse = await Repositores().unionApi(id!);
    // if (unionApiResponse['status'] == 200) {
    //   emit(ChangeLocationSuccessState(
    //       division: allDivision, district: allDistrict, upazila: allupazila, union: unionApiResponse['data']));
    // }
    List storeUnionData = await Helper().getUnionData();
    print("aaaaaaaaaaaaaaaaaaaa  5555555");
    print(storeUnionData);
    storeUnionData.forEach(
      (element) {
        if (element['upazila_id'] == id) {
          allUnion.add(element);
        }
      },
    );
    print(allUnion);
    emit(ChangeLocationSuccessState(division: allDivision, district: allDistrict, upazila: allupazila, union: allUnion));
  }
}
