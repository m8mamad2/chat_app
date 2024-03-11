part of 'group_bloc.dart';

@immutable
class GroupEvent {}

class CreateGroupEvent1 extends GroupEvent{
  final BuildContext context;
  final String name;
  final String bio;
  final List<UserModel> users;
  final XFile? file;
  final UserModel mySelf;
  CreateGroupEvent1({required this.context,required this.name,required this.bio,required this.users,required this.file,required this.mySelf});
}

class GetGroupMessagesEvent extends GroupEvent{
  final String groupUid;
  final int limit;
  GetGroupMessagesEvent(this.groupUid,this.limit);
}

class GetInitialGroupMessageeEvent extends GroupEvent{
  final BuildContext context;
  final String receiverId;
  GetInitialGroupMessageeEvent({required this.context,required this.receiverId});
}


class SendGroupMessageEvent extends GroupEvent{
  final String message;
  final String groupUid;
  final MessageModel replyMessage;
  SendGroupMessageEvent({required this.message,required this.groupUid,required this.replyMessage});
}

class DeleteGroupEvent extends GroupEvent{
  final String groupUid;
  final BuildContext context;
  DeleteGroupEvent(this.context,this.groupUid);
}

class LeftGroupEvent extends GroupEvent{
  final BuildContext context;
  final String uid;
  LeftGroupEvent(this.context,this.uid);
}

class GetExsistGroups extends GroupEvent{}