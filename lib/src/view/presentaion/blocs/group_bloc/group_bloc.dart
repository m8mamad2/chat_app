import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/domain/usecase/group_usecase.dart';

import '../../../data/model/create_group_model.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupUsecase usecase;
  GroupBloc(this.usecase) : super(GroupInitialState()) {
    
    on<CreateGroupEvent1>((event, emit) async {
      emit(GroupLoadingState());

      try{
        await usecase.createGroup1(event.context,event.name, event.bio,event.users, event.file,event.mySelf)
        .then((value) => emit(GroupSuccessState()));
      }
      catch(e){ 
        log(e.toString());
        emit(GroupFailState(e.toString())); }
    });
    on<GetGroupMessagesEvent>((event, emit) {
      emit(GroupLoadingState());

      try{
        Stream<List<MessageModel>> messages = usecase.getGroupMessages(event.groupUid);
        emit(GroupSuccessState(messages:messages));
      }
      catch(e){ emit(GroupFailState(e.toString())); }
    });
    on<SendGroupMessageEvent>((event, emit) async => await usecase.sendGroupMessage(event.message, event.groupUid)); 
    on<DeleteGroupEvent>((event, emit) async {
      emit(GroupLoadingState());
      try{
        await usecase.deleteGroup(event.context, event.groupUid);
        emit(GroupSuccessState());
      }
      catch(e){emit(GroupFailState(e.toString()));}
    });
    on<LeftGroupEvent>((event, emit) async => await usecase.leftGroup(event.context, event.uid)); 

  }
}

class ExistGroupBloc extends HydratedBloc<GroupEvent,ExistGroupState>{
  final GroupUsecase usecase;
  ExistGroupBloc(this.usecase):super(LoadingExistGroupState()){

    on<GetExsistGroups>((event, emit)async {
      try{
        List<CreateGroupModel> data = await usecase.getExistGroup();
        log('--> in Bloc$data');
        emit(LoadedExistGroupState(data));
      }
      catch(e){ emit(ErrorExistGroupState(e.toString()));}

    });

  }
  
  @override
  ExistGroupState fromJson(Map<String, dynamic> json) {
    List<CreateGroupModel> data = json['value'] as List<CreateGroupModel>;
    return LoadedExistGroupState(data);
  }
  
  @override
  Map<String, dynamic>? toJson(ExistGroupState state) => {'value':<CreateGroupModel>[]};


}
