part of 'aaco_info_add_bloc.dart';

@immutable
abstract class AacoInfoAddEvent {}

class AacoInfoAddInitialEvent extends AacoInfoAddEvent {}

class AacoUpazilaClickEvent extends AacoInfoAddEvent {
  final int? id;
  AacoUpazilaClickEvent({required this.id});
}

class AacoUnionClickEvent extends AacoInfoAddEvent {
  final int? id;
  AacoUnionClickEvent({required this.id});
}
