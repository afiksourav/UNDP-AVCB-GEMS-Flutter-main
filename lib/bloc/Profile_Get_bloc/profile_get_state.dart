part of 'profile_get_bloc.dart';

@immutable
abstract class ProfileGetState {}

abstract class ProfileGetActionState extends ProfileGetState {}

class ProfileGetInitialState extends ProfileGetState {}

class ProfileGetLoadingState extends ProfileGetState {}

class ProfileGetSuccessState extends ProfileGetState {
  Data data;
  ProfileGetSuccessState({
    required this.data,
  });
}
