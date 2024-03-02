part of 'activity_edit_bloc.dart';

@immutable
abstract class ActivityEditState {}

abstract class ActivityEditActionState extends ActivityEditState {}

class ActivityEditInitialState extends ActivityEditState {}

class ActivityEditLoadingState extends ActivityEditState {}

class ActivityEditSuccessState extends ActivityEditState {
  List<ActivityEditData> activityEditData;
  List<ActivityData> data;
  List<Data> ActivityDetailsData;
  List district = [];
  List upazila = [];
  List union = [];
  ActivityEditSuccessState(
      {required this.activityEditData,
      required this.data,
      required this.ActivityDetailsData,
      required this.district,
      required this.upazila,
      required this.union});
}
