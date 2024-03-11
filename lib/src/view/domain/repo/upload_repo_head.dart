import '../../data/model/message_model.dart';

abstract class UploadRepoHead{
  Future<void> uploadThings(dynamic thing,String receiverID,String type,String fakeType,String chatRoomId,MessageModel? replyMessage);
  Future<void> uploadMedia(String receiverId,String chatRoomId,MessageModel? replyMessage);
  Future<void> uploadFile(String receiverId,String chatRoomId, MessageModel? replyMessage);
  Future<void> uploadVoice(String receiverId,String path,String chatRoomId,MessageModel? replyMessage);
  Future<String?> downlaodFile(String data, String fileType,String fileUid);
  // Stream<Map<String?,String>> downloadVoice(String data,String fileType,String fileUid);
  Future<String?> downloadVoice(String data,String fileType,String fileUid);
  Future<String?> downloadVideo(String data,String fileType,String fileUid);
}