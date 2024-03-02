part of 'activity_bloc.dart';

@immutable
abstract class ActivityState {}

abstract class ActivityActionState extends ActivityState {}

class ActivityInitialState extends ActivityState {}

class ActivityLoadingState extends ActivityState {}

class ActivitySuccessState extends ActivityState {
  List<ActivityData> data;
  List<Data> ActivityDetailsData;
    List district = [];
  List upazila = [];
  List union = [];
  ActivitySuccessState({required this.data, required this.ActivityDetailsData, required this.district, required this.upazila, required this.union});
}
