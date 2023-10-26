import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/core/common/bottom_shet_helper.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/view/domain/repo/chat_repo_header.dart';
import 'package:p_4/src/view/domain/repo/helper/chat_helper_repo_header.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';

import '../../model/message_model.dart';
import '../../model/user_model.dart';

class ChatHelperRepoBody extends ChatHelperRepoHeader{
  ChatRepoHeader repo;
  ChatHelperRepoBody(this.repo);

  @override
  Stream<List<UserModel>>? getUserStatus(String uid)=> repo.getUserStatus(uid);
  
  @override
  Future<int> lenghtOfData(String receiverID)async => await repo.lenghtOfData(receiverID);

  @override
  Stream<List<MessageModel>>? getMessage(BuildContext context,String receiverID,int limit)async* {
    final data = repo.getMessage(receiverID,limit);
    String isOk = data.keys.last;
    
    int lenghtOfData = await repo.lenghtOfData(receiverID);
    int finalLenght = lenghtOfData <= 15 ? lenghtOfData : limit ;

    if (isOk == 'ok'){
      yield* repo.getMessage(receiverID,limit).values.last;}
    
    else {
    // ignore: use_build_context_synchronously
      errorBottomShetHelper(context, isOk, () {context.navigationBack(context);}); }
  }

  @override
  Future<List<MessageModel>> getExistConversition(BuildContext context)async{
    return await repo.getExistConversition()
      .then((value) async {
        final state = value.keys.last;
        return state == 'ok' 
          ? value.values.last
          : await errorBottomShetHelper(context, state , (){
              // context.read<ChatBloc>().add(GetExistConversition());
              context.navigationBack(context);
          });
      });
  }
  
  @override
  Future<List<UserModel>> getExistConversitonImage(BuildContext context)async{
   return await repo.getExistConversitonImage()
      .then((value) async {
        final state = value.keys.last;
        return state == 'ok' 
          ? value.values.last
          : await errorBottomShetHelper(context, state , (){
              context.read<ChatBloc>().add(GetExistConversition(context));
              context.navigationBack(context);
          });
      });
  }
  
  @override
  Future<List<UserModel>> allUsers(BuildContext context)async{
    return await repo.allUsers()
      .then((value) async {
        
        Map<String,List<UserModel>> data = value;
        final state = data.keys.last;
        
        return state == 'ok' ? data.values.last :await errorBottomShetHelper(context, state, () {
          context.navigationBack(context);
          // context.read<AllUserBloc>().add(GetAllUserEvent());
         });
      });
  }
  
  @override
  String? currentUserId()=> repo.currentUserId();
  
  @override
  Future<List<MessageModel?>> getImageMessage(BuildContext context,String receiverID)async{
    return await repo.getImageMessage(receiverID)
      .then((value) async {
        
        Map<String,List<MessageModel?>> data = value;
        final state = data.keys.last;

        return state == 'ok' ? data.values.last : await errorBottomShetHelper(context, state, () { 
          context.navigationBack(context);
        });

      });
  }
  
  @override
  Future<List<MessageModel?>> getFileMessage(BuildContext context,String receiverID)async{
    return await repo.getFileMessage(receiverID)
      .then((value) async {
        Map<String,List<MessageModel?>> data = value;
        final state = data.keys.last;

        return state == 'ok' ? data.values.last : await errorBottomShetHelper(context, state, () {context.navigationBack(context) ;});
      });
  }
  
  @override
  Future<Map<List<MessageModel>,List<int>>> searching(String receiverID,String search,)async => await repo.searching(receiverID, search);
  
  @override
  Future<void> deleteGroup(BuildContext context,String groupUid)async{
    return await repo.deleteGroup(groupUid)
      .then((value) async {
        return value == 'ok' ? value : await errorBottomShetHelper(context, value, () {
          context.navigationBack(context);
         });
      });
  }

  @override
  Future<void> deleteMessagee(String uid) async => await repo.deleteMessagee(uid);
  
  @override
  Future<void> sendMessage(String message,String receiverID,MessageModel? replyMessage)async => await repo.sendMessage(message, receiverID,replyMessage);
  
  @override
  Future<void> isOnlineStatus(bool status)async => await repo.isOnlineStatus(status);

  @override
  Future<void> sendLocationMessage(String message,String receiverID,MessageModel? replyMessage)async => await repo.sendLocationMessage(message, receiverID,replyMessage);
  
}