
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/core/common/bottom_shet_helper.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/data/model/create_group_model.dart';
import 'package:p_4/src/view/domain/repo/group_repo_head.dart';
import 'package:p_4/src/view/domain/repo/helper/group_helper_repo_heade.dart';

import '../../../../core/widget/auth_check.dart';
import '../../../presentaion/blocs/group_bloc/group_bloc.dart';

class GroupHelperRepoBody extends GroupRepoHelperHeader{ 
  final GroupRepoHeader repo;
  GroupHelperRepoBody(this.repo);

  @override
  Future<void> createGroup1(BuildContext context,String name,String bio ,List<UserModel> users, XFile? file,UserModel mySelf) async {
   return await repo.createGroup(name,bio,users, file,mySelf)
      .then((value) async{
        if(value == 'ok') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>const AuthCheckWidget(),));
          context.read<ExistGroupBloc>().add(GetExsistGroups());
        }
        else { await errorBottomShetHelper(context, value,(){context.navigationBack(context);});}
      });
  }

  @override
  Future<List<CreateGroupModel>> getExistGroup()async => await repo.getExistGroup();

  @override
  Stream<List<MessageModel>> getGroupMessages(String groupUid) => repo.getGroupMessages(groupUid);

  @override
  Future<List<CreateGroupModel>?> groupsModel() async => await repo.groupsModel();

  @override
  Future<void> sendGroupMessage(String message, String groupID,MessageModel replyMessage)async => await repo.sendGroupMessage(message, groupID,replyMessage);
  
  @override
  Future<void> deleteGroup(BuildContext context,String uid)async {
   return await repo.deleteGroup(uid).
      then((value)async {
        if(value == 'ok'){
          context.navigationBack(context);
          context.navigationBack(context);
          context.navigationBack(context);
          context.read<ExistGroupBloc>().add(GetExsistGroups());
        }
        else { await errorBottomShetHelper(context, value,(){context.navigationBack(context);}); }
      });
  }
  
  @override
  Future<void> leftGroup(BuildContext context,String groupUid)async {
   return await repo.leftGroup(groupUid).
      then((value)async {
        if(value == 'ok'){
          context.navigationBack(context);
          context.read<ExistGroupBloc>().add(GetExsistGroups());
        }
        else { await errorBottomShetHelper(context, value,(){context.navigationBack(context);}); }
      });
  }

}