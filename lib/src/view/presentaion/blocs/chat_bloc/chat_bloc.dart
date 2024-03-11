
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/domain/usecase/chat_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatUseCase useCase;
  ChatBloc(this.useCase) : super(ChatInitialState()) {

      on<GetMessageEvent>((event, emit) async {
        emit(ChatLoadingState());

        try{
          Stream<List<MessageModel>>? model = useCase.getMessage(event.context, event.receiverId,event.limit);
          int lenght = await useCase.lenghtOfData(event.receiverId);
          await model!
            .forEach((element) {
              emit(ChatSuccessState(messages: element,limit: lenght));
            })
            .catchError((e)=> emit(ChatFailState(error:e.toString())));
          // model.

      }
      catch(e){log('$e');emit(ChatFailState(error:e.toString()));}

      });
      on<SendMessageEvent>((event, emit) async => await useCase.sendMessage(event.message, event.receiverId,event.replyMessage));
      on<SendLocationMessageEvent>((event, emit) async => await useCase.sendLocationMessage(event.message, event.receiverId,event.replyMessage));
      on<DeleteMessageEvent>((event, emit) async => await useCase.deleteMessage(event.uid));
      on<IsOnlineStatusEvent>((event, emit) async => await useCase.isOnlineStatus(event.status));
      on<DeleteChatRoomEvent>((event, emit) async => await useCase.deleteChatRoom(event.context, event.receiverID));

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

class MessagesBloc extends HydratedBloc<ChatEvent,MessagesState> {
  final ChatUseCase useCase;
  MessageClass msgClass = MessageClass();
  MessagesBloc(this.useCase):super(InitialMessageState()){
    

    on<GetMessageEvent>((event, emit)async {

      try{

        Stream<List<MessageModel>> model = msgClass.s(event.receiverId,event.limit);
        int lenght = await useCase.lenghtOfData(event.receiverId);

        await model.forEach((element) { emit(LoadedMessagesState(element, lenght)); })
        .catchError((e)=> emit(FailMessagesState(e.toString())));
        
      }
      catch(e){log('$e');emit(FailMessagesState(e.toString()));}
    });
    
    on<GetInitialMessageeEvent>((event, emit)async {
      emit(LoadingMessagesState());
      try{

        Stream<List<MessageModel>> model = msgClass.s(event.receiverId,20);
        int lenght = await useCase.lenghtOfData(event.receiverId);

        await model.forEach((element) { emit(LoadedMessagesState(element, lenght)); })
        .catchError((e)=> emit(FailMessagesState(e.toString())));
        
      }
      catch(e){log('$e');emit(FailMessagesState(e.toString()));}
    });

  }
  
  @override
  MessagesState fromJson(Map<String, dynamic> json){
    List<MessageModel>? model = json['value'] as List<MessageModel>?;
    return LoadedMessagesState(model!,null);
  }
  
  @override
  Map<String, dynamic>? toJson(MessagesState state) => {'value':state.model!.map((e) => e.toMap()).toList()};
}


class MessageClass {
  
  StreamController<List<MessageModel>> controller = StreamController.broadcast();
   
  Stream<List<MessageModel>> s (String receiverId,int limit) async* {
    final SupabaseClient supabase = Supabase.instance.client;
    String curretnUserID = supabase.auth.currentUser!.id;
    List<String> ids = [curretnUserID,receiverId];
    ids.sort();
    String chatRoomId = ids.join('_');  

    Stream<List<MessageModel>> messagesStream = 
      supabase
        .from('chat')
        .stream(primaryKey: ['id'])
        .eq('chatRoomId', chatRoomId)
        .limit(limit)
        .order('timestamp',ascending: true)
        .map((event) => event.map((e) => MessageModel.fromJson(e,curretnUserID)).toList())
        .handleError((error){log(error);})
        .asBroadcastStream();
    
    messagesStream.listen((event) { 
      controller.add(event.reversed.toList()); });
    
          
    yield* controller.stream;
  }

  Future<dynamic> disposeStream() async {
    await controller.close();
  }

}

// class MessagesBloc extends HydratedBloc<ChatEvent,MessagesState>{
//   final ChatUseCase useCase;
//   MessageClass msgClass = MessageClass();
//   MessagesBloc(this.useCase):super(LoadingMessagesState()){
//     on<GetMessageEvent>((event, emit)async {
//       try{
//         Stream<List<MessageModel>>? model = useCase.getMessage(event.context, event.receiverId,event.limit);
//         int lenght = await useCase.lenghtOfData(event.receiverId);
//         await model!
//           .forEach((element) {
//             emit(LoadedMessagesState(element,lenght));
//           })
//           .catchError((e)=> emit(FailMessagesState(e.toString())));
//       }
//       catch(e){log('$e');emit(FailMessagesState(e.toString()));}
//     });
//   }
//   @override
//   MessagesState fromJson(Map<String, dynamic> json){
//     List<MessageModel>? model = json['value'] as List<MessageModel>?;
//     return LoadedMessagesState(model!,null);
//   }
//   @override
//   Map<String, dynamic>? toJson(MessagesState state) => {'value': []};
// }
// class MessageClass {
//   StreamController<List<MessageModel>> controller = StreamController.broadcast();
//   Stream<List<MessageModel>> s () async* {
//     final SupabaseClient supabase = Supabase.instance.client;
//     String curretnUserID = supabase.auth.currentUser!.id;
//     List<String> ids = [curretnUserID,'805ab831-e198-44e6-b959-41bbc311de1b'];
//     ids.sort();
//     String chatRoomId = ids.join('_');  
//     Stream<List<MessageModel>> messagesStream = 
//       supabase
//         .from('chat')
//         .stream(primaryKey: ['id'])
//         .limit(15)
//         .order('timestamp')
//         .eq('chatRoomId', chatRoomId)
//         .map((event) => event.map((e) => MessageModel.fromJson(e,curretnUserID)).toList())
//         .handleError((error){log(error);})
//         .asBroadcastStream(); 
//     messagesStream.listen((event) { 
//       controller.add(event);
//     });       
//     yield* controller.stream;
//   }
//   void disposeStream()=> controller.close();
// }

