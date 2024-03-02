part of 'aaco_info_edit_bloc.dart';

@immutable
abstract class AacoInfoEditState {}

abstract class AacoInfoEditActionState extends AacoInfoEditState {}

class AacoInfoEditInitialState extends AacoInfoEditState {}

class AacoInfoEditLoadingState extends AacoInfoEditState {}

class AacoInfoEditSuccessState extends AacoInfoEditState {
  AacoInfoEditData data;
  List<DistrictData> district;
  List<dynamic>? upazila;
  List<dynamic>? union;
  AacoInfoEditSuccessState({required this.data, required this.district, this.upazila, this.union});
}
