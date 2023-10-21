part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitialState extends ChatState{}

class ChatLoadingState extends ChatState{}

class ChatSuccessState extends ChatState{
  final Stream<List<MessageModel>>? messages;
  final List<dynamic>? getExistConversiton;
  final List<dynamic>? getAllUsers;
  ChatSuccessState({this.messages,this.getExistConversiton,this.getAllUsers});
}

class ChatFailState extends ChatState{
  final String error;
  ChatFailState({required this.error});
}


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


abstract class MessagesState{ 
  final List<MessageModel>? model;
  const MessagesState(this.model);
}

class LoadingMessagesState extends MessagesState{
  LoadingMessagesState():super([]);
}

class LoadedMessagesState extends MessagesState{
  LoadedMessagesState(List<MessageModel>? model):super(model);
}


class FailMessagesState extends MessagesState{
  final String error;
  FailMessagesState(this.error):super([]);
}

