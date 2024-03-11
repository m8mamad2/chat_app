import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/model/create_group_model.dart';
import '../../../data/model/message_model.dart';
import '../../../data/model/user_model.dart';

abstract class GroupRepoHelperHeader{
  Future<void> createGroup1(BuildContext context,String name,String bio,List<UserModel> users,XFile? file,UserModel mySelf);
  Future<List<CreateGroupModel>?> groupsModel();
  Stream<List<MessageModel>> getGroupMessages(String groupUid);
  Future<void> sendGroupMessage(String message,String groupID,MessageModel replyMessage);
  Future<List<CreateGroupModel>> getExistGroup();
  Future<void> deleteGroup(BuildContext context,String uid);
  Future<void> leftGroup(BuildContext context,String groupUid);
  Future<int> lenghtOfData(String chatRoomId);
}