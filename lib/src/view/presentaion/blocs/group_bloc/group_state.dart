part of 'group_bloc.dart';

@immutable
class GroupState {}

class GroupInitialState extends GroupState {}

class GroupLoadingState extends GroupState {}

class GroupSuccessState extends GroupState {
  final Stream<List<MessageModel>>? messages;
  GroupSuccessState({this.messages});
}

class GroupFailState extends GroupState {
  final String error;
  GroupFailState(this.error);
}


abstract class ExistGroupState{
  final List<CreateGroupModel>? model;
  ExistGroupState(this.model);
}

class LoadingExistGroupState extends ExistGroupState{
  LoadingExistGroupState():super([]);
}

class LoadedExistGroupState extends ExistGroupState{
  final List<CreateGroupModel>? data;
  LoadedExistGroupState(this.data):super(data);

}
class ErrorExistGroupState extends ExistGroupState{
  final String error;
  ErrorExistGroupState(this.error):super([]);
}