import '../../data/model/message_model.dart';

class MessageEntity{
  final String uid;
  final String senderID;
  final String receiverID;
  final String messsage;
  final String type;
  final String? timestamp;
  final String? fileType;
  final bool markAsRead;
  final bool isMine;
  final String chatRoomID;
  final MessageModel? replyMessage;

  MessageEntity({required this.senderID, required this.receiverID, required this.messsage, required this.type,required this.timestamp,required this.fileType,required this.markAsRead,required this.isMine,required this.chatRoomID,required this.uid,required this.replyMessage});
  
}