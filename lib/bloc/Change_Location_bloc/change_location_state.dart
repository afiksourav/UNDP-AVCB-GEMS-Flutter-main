part of 'change_location_bloc.dart';

@immutable
abstract class ChangeLocationState {}

abstract class ChangeLocationActionState extends ChangeLocationState {}

class ChangeLocationInitialState extends ChangeLocationState {}

class ChangeLocationLoadingState extends ChangeLocationState {}

class ChangeLocationSuccessState extends ChangeLocationState {
  List<dynamic> division;
  List<dynamic> district;
  List<dynamic> upazila;
  List<dynamic >union;
  
  ChangeLocationSuccessState({required this.division,required this.district,required this.upazila, required this.union});

}
