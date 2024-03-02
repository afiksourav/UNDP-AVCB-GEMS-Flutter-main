part of 'training_data_bloc.dart';

@immutable
abstract class TrainingDataBlocState {}

abstract class TrainingDataActionState extends TrainingDataBlocState {}

class TrainingDataInitialState extends TrainingDataBlocState {}

class TrainingDataLoadingState extends TrainingDataBlocState {}

class TrainingDataSuccessState extends TrainingDataBlocState {
  List<AllTrainingData> data = [];
  List district = [];
  List upazila = [];
  List union = [];

  TrainingDataSuccessState(
      {required this.data, required this.district, required this.upazila, required this.union});
}

// class DistrictSuccessState extends TrainingDataBlocState {
//   List district = [];
//   DistrictSuccessState({required this.district});
// }

class TrainingDataErrorState extends TrainingDataBlocState {}
