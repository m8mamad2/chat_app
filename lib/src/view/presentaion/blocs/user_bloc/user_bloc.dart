import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/domain/usecase/user_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserUsecase repo ; 
  UserBloc(this.repo) : super(UserInitialState()) {

    on<UpdateUserInfoEvent>((event, emit)async {
      emit(UserLoadingState());
      try{
        await repo.updateUserInfo(event.context,event.data);
        emit(UserSuccessState());
      }
      catch(e){ emit(UserFailState(e.toString())); }
    });
    on<UpdateUserPictureEvent>((event, emit)async {
      emit(UserLoadingState());
      try{
        await repo.userPicture(event.context,event.file);
        emit(UserSuccessState());
      }
      catch(e){ emit(UserFailState(e.toString())); }
    });
    on<GetUserDataEvent>((event, emit)async {
      emit(UserLoadingState());
      try{
        Stream<UserModel> userModel = repo.getUserInfo();
        Stream<String?> userPicture = repo.getUserPicture();
        emit(UserSuccessState(userModel: userModel,userPicture:userPicture ));
      }
      catch(e){ emit(UserFailState(e.toString())); }
    });
    on<UserIsInAppEvent>((event, emit)async {
      emit(UserLoadingState());
      try{
        await repo.isInApp(event.context, event.phone, event.addMemberController);
        emit(UserSuccessState());
      }
      catch(e){ emit(UserFailState(e.toString())); }
    });
    
  }
}


class GetUserData extends HydratedBloc<UserEvent,GetUserDataState>{
  final UserUsecase usecase;
  GetUserData(this.usecase) : super(LoadingUserDataState()){
    on<GetUserDataEvent>((event, emit) async {
      UserModel? data =await usecase.getUserData();
      emit(LoadedUserDataState(data));
    },);
  }

  @override
  LoadedUserDataState? fromJson(Map<String, dynamic> json) {
    UserModel? data = json['value'] as UserModel;
    return LoadedUserDataState(data);
  }
  
  @override
  Map<String, dynamic>? toJson(GetUserDataState state) {
    return { 'value' : null };
  }


}