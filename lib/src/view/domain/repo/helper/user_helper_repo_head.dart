import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/model/user_model.dart';

abstract class UserHelperRepoHeader{
  Future<void> updateUserInfo(BuildContext context,Map<String,dynamic> data);
  Future<void> userPicture(BuildContext context,XFile file);
  Stream<String?> getUserPicture();
  Stream<UserModel> getUserInfo();
  Future<UserModel> getUserData();
  Future<void> isInApp(BuildContext context,String phone,TextEditingController _addMemberController);
}