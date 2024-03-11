import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/view/domain/repo/helper/group_helper_repo_heade.dart';

import '../../data/model/create_group_model.dart';
import '../../data/model/message_model.dart';
import '../../data/model/user_model.dart';

class GroupUsecase{
  final GroupRepoHelperHeader repo;
  GroupUsecase(this.repo);

  Future<void> createGroup1(BuildContext context,String name,String bio,List<UserModel> users,XFile? file,UserModel mySelf) async => await repo.createGroup1(context,name,bio ,users, file,mySelf);
  Future<List<CreateGroupModel>?> groupsModel() async =>await repo.groupsModel();
  Stream<List<MessageModel>> getGroupMessages(String groupUid) => repo.getGroupMessages(groupUid);
  Future<void> sendGroupMessage(String message,String groupID,MessageModel replyMessage) async =>await repo.sendGroupMessage(message, groupID,replyMessage);
  Future<List<CreateGroupModel>> getExistGroup() async => await repo.getExistGroup();
  Future<void> deleteGroup(BuildContext context,String groupUid)async => await repo.deleteGroup(context, groupUid);
  Future<void> leftGroup(BuildContext context,String uid)async => await repo.leftGroup(context, uid);
  Future<int> lenghtOfData(String chatRoomId) async => await repo.lenghtOfData(chatRoomId);
}