abstract class UploadRepoHead{
  Future<void> uploadThings(dynamic thing,String receiverID,String type,String fakeType,String chatRoomId);
  Future<void> uploadMedia(String receiverId,String chatRoomId);
  Future<void> uploadFile(String receiverId,String chatRoomId);
  Future<void> uploadVoice(String receiverId,String path,String chatRoomId);
  Stream<String> downlaodFile(String data, String fileType,String fileUid);
  // Stream<Map<String?,String>> downloadVoice(String data,String fileType,String fileUid);
  Future<String?> downloadVoice(String data,String fileType,String fileUid);
  Future<String?> downloadVideo(String data,String fileType,String fileUid);
}