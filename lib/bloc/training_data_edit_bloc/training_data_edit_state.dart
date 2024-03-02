part of 'training_data_edit_bloc.dart';

@immutable
abstract class TrainingDataEditState {}

abstract class TrainingDataEditActionState extends TrainingDataEditState {}
class TrainingDataEditInitialState extends TrainingDataEditState {}

class TrainingDataEditLoadingState extends TrainingDataEditState {}

class TrainingDataEditSuccessState extends TrainingDataEditState {
  List data = [];
  List district = [];
  List upazila = [];
  List union = [];
  List<Datum> trainingEditdata = [];
   List<Participant> participant = [];
  TrainingDataEditSuccessState(
      {required this.data, required this.district, required this.upazila, required this.union, required this.trainingEditdata,required this.participant});
}
