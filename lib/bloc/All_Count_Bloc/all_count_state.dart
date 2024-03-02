part of 'all_count_bloc.dart';

@immutable
abstract class AllCountState {}

abstract class AllCountActionState extends AllCountState {}

class AllCountInitialState extends AllCountState {}

class AllCountLoadingState extends AllCountState {}

class AllCountSuccessState extends AllCountState {
  // int activityInfoCount;
  // int trainingInfoCount;
  // int fieldVisitCount;
  // int accoInfoCount;
  CountModel? countModel;

  // AllCountSuccessState(
  //     {required this.activityInfoCount,
  //     required this.trainingInfoCount,
  //     required this.fieldVisitCount,
  //     required this.accoInfoCount});
  AllCountSuccessState({required this.countModel});
}
