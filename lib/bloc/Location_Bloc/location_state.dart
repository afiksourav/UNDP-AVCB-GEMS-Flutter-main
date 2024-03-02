part of 'location_bloc.dart';

@immutable
abstract class LocationState {}

abstract class LocationActionState extends LocationState {}

class LocationInitialState extends LocationState {}

class LocationLoadingState extends LocationState {}

class LocationSuccessState extends LocationState {
  List<Division> division;
  List<District> district;
  List<Upazila> upazila;
  List<Union> union;
  LocationSuccessState({required this.division, required this.district, required this.upazila, required this.union});
}
