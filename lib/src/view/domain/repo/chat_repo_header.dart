
import '../../data/model/message_model.dart';
import '../../data/model/user_model.dart';

abstract class ChatRepoHeader{
  
  Future<void> sendMessage(String message,String receiverID,MessageModel? replyMessage);
  Map<String,Stream<List<MessageModel>>> getMessage(String receiverID,int limit);
  Future<void> deleteMessagee(String uid);
  Future<Map<String,List<MessageModel>>> getExistConversition();
  Future<Map<String,List<UserModel>>> getExistConversitonImage();
  Future<Map<String,List<UserModel>>> allUsers();
  String? currentUserId();
  Future<void> isOnlineStatus(bool status);
  Stream<List<UserModel>>? getUserStatus(String uid);
  Future<void> sendLocationMessage(String message,String receiverID,MessageModel? replyMessage);
  Future<Map<String,List<MessageModel?>>> getImageMessage(String receiverID);
  Future<Map<String,List<MessageModel?>>> getFileMessage(String receiverID);
  Future<Map<List<MessageModel>,List<int>>> searching(String receiverID,String search,);
  Future<String> deleteGroup(String groupUid);
  Future<int> lenghtOfData(String receiverID);
}
