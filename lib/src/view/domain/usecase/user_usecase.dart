import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/view/domain/repo/helper/user_helper_repo_head.dart';

import '../../data/model/user_model.dart';

class UserUsecase{
  final UserHelperRepoHeader repo;
  UserUsecase(this.repo);

  Future<void> updateUserInfo(BuildContext context,Map<String,dynamic> data)async => await repo.updateUserInfo(context,data);
  Future<void> userPicture(BuildContext context,XFile file)async => await repo.userPicture(context,file);
  Stream<String?> getUserPicture() => repo.getUserPicture();
  Stream<UserModel> getUserInfo() => repo.getUserInfo();
  Future<UserModel> getUserData()async => await repo.getUserData();
  Future<void> isInApp(BuildContext context,String phone,TextEditingController addMemberController) async => await repo.isInApp(context, phone, addMemberController);
}