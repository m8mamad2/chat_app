import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/view/data/model/create_group_model.dart';
import '../../data/model/message_model.dart';
import '../../data/model/user_model.dart';

abstract class GroupRepoHeader{
  Future<String> createGroup(String name,String bio,List<UserModel> users,XFile? file,UserModel mySelf);
  Future<List<CreateGroupModel>?> groupsModel();
  Stream<List<MessageModel>> getGroupMessages(String groupUid);
  Future<void> sendGroupMessage(String message,String groupID,MessageModel replyMessage);
  Future<List<CreateGroupModel>> getExistGroup();
  Future<String> deleteGroup(String groupUid);
  Future<String> leftGroup(String groupUid);
}