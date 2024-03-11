import 'package:p_4/src/view/domain/repo/upload_repo_head.dart';

import '../../data/model/message_model.dart';

class UploadUseCaes{
  final UploadRepoHead repo;
  UploadUseCaes(this.repo);

  Future<void> uploadMedia(String receiverId,String chatRoomId,MessageModel? replyMessage)async => await repo.uploadMedia(receiverId, chatRoomId,replyMessage);
  Future<void> uploadFile(String receiverId,String chatRoomId ,MessageModel? replyMessage)async => await repo.uploadFile(receiverId, chatRoomId,replyMessage);
  Future<void> uploadVoice(String receiverId,String path,String chatRoomId,MessageModel? replyMessage)async => await repo.uploadVoice(receiverId, path, chatRoomId, replyMessage);
  Future<String?> downloadFile(String data,String fileType,String fileUid)  async => await repo.downlaodFile(data, fileType,fileUid);
  Future<String?> downloadVoice(dynamic data,String fileType,String fileUid)async => await repo.downloadVoice(data, fileType,fileUid);
  Future<String?> downloadVideo(dynamic data,String fileType,String fileUid)async => await repo.downloadVideo(data, fileType,fileUid);
  // Stream<Map<String?,String>> downloadVoice(dynamic data,String fileType,String fileUid)async* {yield* repo.downloadVoice(data, fileType,fileUid);}
}