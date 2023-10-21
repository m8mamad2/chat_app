// ignore_for_file: overridden_fields

part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}


class GetMessageEvent extends ChatEvent{
  final BuildContext context;
  final String receiverId;
  GetMessageEvent({required this.context,required this.receiverId});
}

class SendMessageEvent extends ChatEvent{
  final String message;
  final String receiverId;
  SendMessageEvent({required this.receiverId,required this.message,});
}

class SendLocationMessageEvent extends ChatEvent{
  final String message;
  final String receiverId;
  SendLocationMessageEvent({required this.receiverId,required this.message,});
}


class DeleteMessageEvent extends ChatEvent{
  final String uid;
  DeleteMessageEvent(this.uid);
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