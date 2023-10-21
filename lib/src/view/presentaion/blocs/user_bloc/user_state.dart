part of 'user_bloc.dart';

@immutable
class UserState {}

class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserSuccessState extends UserState {
  final Stream<String?>? userPicture;
  final Stream<UserModel>? userModel;
  UserSuccessState({this.userPicture,this.userModel});
}

class UserFailState extends UserState {
  final String? fail;
  UserFailState(this.fail);
}



abstract class GetUserDataState{ 
  final UserModel? model;
  const GetUserDataState(this.model);
}

class LoadingUserDataState extends GetUserDataState{
  LoadingUserDataState():super(null);
}

class LoadedUserDataState extends GetUserDataState{
  LoadedUserDataState(UserModel model):super(model);
}
