import 'package:p_4/src/view/domain/repo/upload_repo_head.dart';

class UploadUseCaes{
  final UploadRepoHead repo;
  UploadUseCaes(this.repo);

  Future<void> uploadMedia(String receiverId,String chatRoomId)async => await repo.uploadMedia(receiverId, chatRoomId);
  Future<void> uploadFile(String receiverId,String chatRoomId)async => await repo.uploadFile(receiverId, chatRoomId);
  Future<void> uploadVoice(String receiverId,String path,String chatRoomId)async => await repo.uploadVoice(receiverId, path, chatRoomId);
  Stream<String> downloadFile(String data,String fileType,String fileUid)async* {yield* repo.downlaodFile(data, fileType,fileUid);}
  Future<String?> downloadVoice(dynamic data,String fileType,String fileUid)async => await repo.downloadVoice(data, fileType,fileUid);
  Future<String?> downloadVideo(dynamic data,String fileType,String fileUid)async => await repo.downloadVideo(data, fileType,fileUid);
  // Stream<Map<String?,String>> downloadVoice(dynamic data,String fileType,String fileUid)async* {yield* repo.downloadVoice(data, fileType,fileUid);}
}