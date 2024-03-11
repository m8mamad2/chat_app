// ignore_for_file: overridden_fields

part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class GetMessageEvent extends ChatEvent{
  final BuildContext context;
  final String receiverId;
  final int limit;
  GetMessageEvent({required this.context,required this.receiverId,required this.limit});
}

class GetInitialMessageeEvent extends ChatEvent{
  final BuildContext context;
  final String receiverId;
  GetInitialMessageeEvent({required this.context,required this.receiverId});
}

class SendMessageEvent extends ChatEvent{
  final String message;
  final String receiverId;
  final MessageModel? replyMessage;
  SendMessageEvent({required this.receiverId,required this.message,required this.replyMessage});
}

class SendLocationMessageEvent extends ChatEvent{
  final String message;
  final String receiverId;
  final MessageModel? replyMessage;
  SendLocationMessageEvent({required this.receiverId,required this.message,required this.replyMessage});
}


class DeleteMessageEvent extends ChatEvent{
  final String uid;
  DeleteMessageEvent(this.uid);
}

class DeleteChatRoomEvent extends ChatEvent{
  final String receiverID;
  final BuildContext context;
  DeleteChatRoomEvent(this.context,this.receiverID);
}

class GetAllUserEvent extends ChatEvent{
  final BuildContext context;
  GetAllUserEvent(this.context);
}

class IsOnlineStatusEvent extends ChatEvent{
  final bool status;
  IsOnlineStatusEvent(this.status);
}

class GetExistConversition extends ChatEvent{
  final BuildContext context;
  GetExistConversition(this.context);
}


// @immutable
// abstract class MessageEvent {}
// class InitialMessageEvent extends MessageEvent{}

// class GetMessageeEvent extends InitialMessageEvent{
//   final BuildContext context;
//   final String receiverId;
//   final int limit;
//   GetMessageeEvent({required this.context,required this.receiverId,required this.limit});
// }

// class GetInitialMessageeEvent extends InitialMessageEvent{
//   final BuildContext context;
//   final String receiverId;
//   final int limit;
//   GetInitialMessageeEvent({required this.context,required this.receiverId,required this.limit});
// }

// class DisposeGetMessageEvent extends InitialMessageEvent{}