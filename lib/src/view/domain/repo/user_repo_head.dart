import 'package:image_picker/image_picker.dart';

import '../../data/model/user_model.dart';

abstract class UserRepoHead{
   Future<String> updateUserInfo(Map<String,dynamic> data);
   Future<String> userPicture(XFile file);
   Stream<String?> getUserPicture();
   Stream<UserModel> getUserInfo();
   Future<UserModel> getUserData();
   Future<Map<String,UserModel?>> isInApp(String phone);
}