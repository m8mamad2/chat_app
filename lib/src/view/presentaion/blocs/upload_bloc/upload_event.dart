part of 'upload_bloc.dart';

@immutable
class UploadEvent {}


class UploadMediaEvent extends UploadEvent{
  final String receiverId;
  final String chatRoomId;
  final MessageModel? replyMessage;
  UploadMediaEvent(this.receiverId,this.chatRoomId,this.replyMessage);
}

class UploadFileEvent extends UploadEvent{
  final String receiverId;
  final String chatRoomId;
  final MessageModel? replyMessage;
  UploadFileEvent(this.receiverId,this.chatRoomId,this.replyMessage);
}

class UploadVoiceEvent extends UploadEvent{
  final String receiverId;
  final String path;
  final String chatRoomId;
  final MessageModel? replyMessage;
  UploadVoiceEvent(this.receiverId,this.path,this.chatRoomId,this.replyMessage);
}

class DownloadFileEvent extends UploadEvent{
  final String data;
  final String fileUid;
  final String fileType;
  DownloadFileEvent(this.data,this.fileType,this.fileUid,);
}

class DownloadVoiceEvent extends UploadEvent{
  final String data;
  final String fileUid;
  final String fileType;
  DownloadVoiceEvent(this.data,this.fileType,this.fileUid);
}
class DownloadVideoEvent extends UploadEvent{
  final String data;
  final String fileUid;
  final String fileType;
  DownloadVideoEvent(this.data,this.fileType,this.fileUid);
}
