part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitialState extends ChatState{}

class ChatLoadingState extends ChatState{}

class ChatSuccessState extends ChatState{
  final List<MessageModel>? messages;
  final int? limit;
  final List<dynamic>? getExistConversiton;
  final List<dynamic>? getAllUsers;
  ChatSuccessState({this.messages,this.limit,this.getExistConversiton,this.getAllUsers});
}

class ChatFailState extends ChatState{
  final String error;
  ChatFailState({required this.error});
}


//! exist Converisiton
abstract class ExistConversitionState{ 
  final List<UserModel>? model;
  const ExistConversitionState(this.model);
}
class LoadingExistConversitionState extends ExistConversitionState{
  LoadingExistConversitionState():super([]);
}
class LoadedExistConversitionState extends ExistConversitionState{
  LoadedExistConversitionState(List<UserModel>? model):super(model);
}


//! All user
abstract class AllUserState{ 
  final List<UserModel>? model;
  const AllUserState(this.model);
}
class LoadingAllUserState extends AllUserState{
  LoadingAllUserState():super([]);
}
class LoadedAllUserState extends AllUserState{
  LoadedAllUserState(List<UserModel>? model):super(model);
}


//! messages
abstract class MessagesState{ 
  final List<MessageModel>? model;
  const MessagesState(this.model);
}
class InitialMessageState extends MessagesState{
  InitialMessageState():super([]);
}
class LoadingMessagesState extends MessagesState{
  LoadingMessagesState():super([]);
}
class LoadedMessagesState extends MessagesState{
  int? limit;
  LoadedMessagesState(List<MessageModel> model,this.limit):super(model);
}
class FailMessagesState extends MessagesState{
  final String error;
  FailMessagesState(this.error):super([]);
}

