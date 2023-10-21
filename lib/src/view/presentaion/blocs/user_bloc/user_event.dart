part of 'user_bloc.dart';

@immutable
class UserEvent {}

class UpdateUserInfoEvent extends UserEvent{
  final BuildContext context;
  final Map<String,dynamic> data;
  UpdateUserInfoEvent(this.context,this.data);
}

class UpdateUserPictureEvent extends UserEvent{
  final BuildContext context;
  final XFile file;
  UpdateUserPictureEvent(this.context,this.file);
}

class UserIsInAppEvent extends UserEvent{
  final BuildContext context;
  final String phone;
  final TextEditingController addMemberController;
  UserIsInAppEvent(this.context,this.phone,this.addMemberController,);
}

class GetUserDataEvent extends UserEvent{}