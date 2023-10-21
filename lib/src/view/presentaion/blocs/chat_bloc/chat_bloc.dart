
import 'dart:developer';
import 'dart:convert' as convert;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/domain/usecase/chat_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatUseCase useCase;
  ChatBloc(this.useCase) : super(ChatInitialState()) {

      on<GetMessageEvent>((event, emit) async {
        emit(ChatLoadingState());

        try{
            Stream<List<MessageModel>>? messages =  useCase.getMessage(event.context,event.receiverId);
            emit(ChatSuccessState(messages: messages));}
        
        catch(e){ emit(ChatFailState(error: e.toString())); }

      });
      on<SendMessageEvent>((event, emit) async => await useCase.sendMessage(event.message, event.receiverId));
      on<SendLocationMessageEvent>((event, emit) async => await useCase.sendLocationMessage(event.message, event.receiverId));
      on<DeleteMessageEvent>((event, emit) async => await useCase.deleteMessage(event.uid));
      on<IsOnlineStatusEvent>((event, emit) async => await useCase.isOnlineStatus(event.status));
      
  }
}


class ExistConversitionBloc extends HydratedBloc<ChatEvent,ExistConversitionState>{
  final ChatUseCase useCase;
  ExistConversitionBloc(this.useCase) : super(LoadingExistConversitionState()){

    on<GetExistConversition>((event, emit)async {
      List<UserModel> getExistConvertsion = await useCase.getExistConversitonImage(event.context);
      emit(LoadedExistConversitionState(getExistConvertsion));
    });

  }
  
  @override
  ExistConversitionState? fromJson(Map<String, dynamic> json) {
      List<UserModel> data =  json['value'] as List<UserModel>;
      return LoadedExistConversitionState(data);
  }
  
  @override
  Map<String, dynamic>? toJson(ExistConversitionState state) {
    // String a = convert.jsonEncode(state.messageModel);//! to
    // final a = state.messageModel!.map((model) => model.toMap()).toList();
    return {'value' : <UserModel>[]};
  }
}


class AllUserBloc extends HydratedBloc<ChatEvent,AllUserState>{
  final ChatUseCase useCase;
  AllUserBloc(this.useCase):super(LoadingAllUserState()){

    on<GetAllUserEvent>((event, emit)async {
      try{
        List<UserModel> allUser = await useCase.getUsers(event.context);
        log('$allUser');
        emit(LoadedAllUserState(allUser));
      }
      catch(e){log('$e');}
    });

  }
  
  @override
  AllUserState fromJson(Map<String, dynamic> json){
    List<UserModel> model = json['value'] as List<UserModel>;
    return LoadedAllUserState(model);
  }
  
  @override
  Map<String, dynamic>? toJson(AllUserState state) => {'value':<UserModel>[]};
}


// ! hydrate
class MessagesBloc extends HydratedBloc<ChatEvent,MessagesState>{
  final ChatUseCase useCase;
  MessagesBloc(this.useCase):super(LoadingMessagesState()){

    on<GetMessageEvent>((event, emit)async {
      try{
        
        Stream<List<MessageModel>>? stream = useCase.getMessage(event.context,event.receiverId);
        List<MessageModel> messages = [];
        stream!.listen((event) {
          for(var i in event) messages.add(i);
        });
        log('in Bloc ===>$messages');
        emit(LoadedMessagesState(messages));
      }
      catch(e){log('$e');emit(FailMessagesState(e.toString()));}
    });

  }
  
  @override
  MessagesState fromJson(Map<String, dynamic> json){
    List<MessageModel> model = json['value'] as List<MessageModel>;
    return LoadedMessagesState(model);
  }
  
  @override
  Map<String, dynamic>? toJson(MessagesState state) => {'value':<UserModel>[]};
}



