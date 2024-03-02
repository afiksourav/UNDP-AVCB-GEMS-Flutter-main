part of 'aaco_info_edit_bloc.dart';

@immutable
abstract class AacoInfoEditEvent {}

class AacoInfoEditInitialEvent extends AacoInfoEditEvent {
  final int ?id;
  AacoInfoEditInitialEvent({required this.id});
}

class AacoInfoEditUpazilaClickEvent extends AacoInfoEditEvent {
  final int? id;
  AacoInfoEditUpazilaClickEvent({required this.id});
}

class AacoInfoEditUnionClickEvent extends AacoInfoEditEvent {
  final int? id;
  AacoInfoEditUnionClickEvent({required this.id});
}
