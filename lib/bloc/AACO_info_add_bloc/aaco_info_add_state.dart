part of 'aaco_info_add_bloc.dart';

@immutable
abstract class AacoInfoAddState {}

abstract class AacoInfoAddActionState extends AacoInfoAddState {}

class AacoInfoAddInitialState extends AacoInfoAddState {}

class AacoInfoAddLoadingState extends AacoInfoAddState {}

class AacoInfoAddSuccessState extends AacoInfoAddState {
  List<DistrictData> district;
  List<dynamic>? upazila;
    List<dynamic>? union;
  AacoInfoAddSuccessState({required this.district, this.upazila, this.union});
}
