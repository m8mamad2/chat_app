import 'dart:async';
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
import 'package:supabase_flutter/supabase_flutter.dart';

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
    on<SendGroupMessageEvent>((event, emit) async => await usecase.sendGroupMessage(event.message, event.groupUid,event.replyMessage)); 
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

//! exist group conversition
class ExistGroupBloc extends HydratedBloc<GroupEvent,ExistGroupState>{
  final GroupUsecase usecase;
  ExistGroupBloc(this.usecase):super(LoadingExistGroupState()){

    on<GetExsistGroups>((event, emit)async {
      try{
        List<CreateGroupModel> data = await usecase.getExistGroup();
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

//! message of gropu
class GroupMessageBloc extends HydratedBloc<GroupEvent,GroupMessageState> {
  final GroupUsecase useCase;
  GroupMessageClass msgClass = GroupMessageClass();
  GroupMessageBloc(this.useCase):super(InitialGroupMessageState()){
    

    on<GetGroupMessagesEvent>((event, emit)async {

      try{

        Stream<List<MessageModel>> model = msgClass.s(event.groupUid,event.limit);
        int lenght = await useCase.lenghtOfData(event.groupUid);

        await model.forEach((element) { emit(LoadedGroupMessagesState(element, lenght)); })
        .catchError((e)=> emit(FailGroupMessagesState(e.toString())));
        
      }
      catch(e){log('$e');emit(FailGroupMessagesState(e.toString()));}
    });
    
    on<GetInitialGroupMessageeEvent>((event, emit)async {
      emit(LoadingGroupMessagesState());
      try{

        Stream<List<MessageModel>> model = msgClass.s(event.receiverId,20);
        int lenght = await useCase.lenghtOfData(event.receiverId);

        await model.forEach((element) { emit(LoadedGroupMessagesState(element, lenght)); })
        .catchError((e)=> emit(FailGroupMessagesState(e.toString())));
        
      }
      catch(e){log('$e');emit(FailGroupMessagesState(e.toString()));}
    });

  }
  
  @override
  GroupMessageState fromJson(Map<String, dynamic> json){
    List<MessageModel>? model = json['value'] as List<MessageModel>?;
    return LoadedGroupMessagesState(model!,null);
  }
  
  @override
  Map<String, dynamic>? toJson(GroupMessageState state) => {'value':state.model!.map((e) => e.toMap()).toList()};
}

//! repo
class GroupMessageClass {
  
  StreamController<List<MessageModel>> controller = StreamController.broadcast();
  Stream<List<MessageModel>> s (String groupUid,int limit) async* {

    final SupabaseClient supabase = Supabase.instance.client;
    String curretnUserID = supabase.auth.currentUser!.id;

    Stream<List<MessageModel>> messagesStream =  supabase.from('chat')
      .stream(primaryKey: ['id'])
      .eq('chatRoomId',groupUid)
      .limit(limit)
      .order('timestamp')
      .map((event) => event.map((e) => MessageModel.fromJson(e, curretnUserID)).toList())
      .handleError((err)=>log(err))
      .asBroadcastStream();
  
    
    messagesStream.listen((event) { 
      controller.add(event);
    });
    
          
    yield* controller.stream;
  }

}
