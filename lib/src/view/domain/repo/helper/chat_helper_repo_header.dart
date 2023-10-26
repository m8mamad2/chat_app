

import 'package:flutter/material.dart';

import '../../../data/model/message_model.dart';
import '../../../data/model/user_model.dart';

abstract class ChatHelperRepoHeader{
  Future<void> sendMessage(String message,String receiverID,MessageModel? replyMessage);
  Stream<List<MessageModel>>? getMessage(BuildContext context,String receiverID,int limit);
  Future<void> deleteMessagee(String uid);
  Future<List<MessageModel>> getExistConversition(BuildContext context);
  Future<List<UserModel>> getExistConversitonImage(BuildContext context);
  Future<List<UserModel>> allUsers(BuildContext context);
  String? currentUserId();
  Future<void> isOnlineStatus(bool status);
  Stream<List<UserModel>>? getUserStatus(String uid);
  Future<void> sendLocationMessage(String message,String receiverID,MessageModel? replyMessage);
  Future<List<MessageModel?>> getImageMessage(BuildContext context,String receiverID);
  Future<List<MessageModel?>> getFileMessage(BuildContext context,String receiverID);
  Future<Map<List<MessageModel>,List<int>>> searching(String receiverID,String search,);
  Future<void> deleteGroup(BuildContext context,String groupUid);
  Future<int> lenghtOfData(String receiverID);
}