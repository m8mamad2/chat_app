// ignore_for_file: overridden_fields

import 'package:p_4/src/view/domain/entity/message_entity.dart';
import 'package:intl/intl.dart';

class MessageModel extends MessageEntity{
  @override
  final String uid;
  
  @override
  final String senderID;
  
  @override
  final String receiverID;
  
  @override
  final String messsage;
  
  @override
  final String type;
  
  @override
  final String timestamp;
  
  @override
  final String? fileType;
  
  @override
  final bool markAsRead;
  
  @override
  final bool isMine;

  @override
  final String chatRoomID;



  MessageModel({required this.senderID, required this.receiverID, required this.messsage, required this.type,required this.timestamp,required this.fileType,required this.markAsRead,required this.isMine,required this.chatRoomID,required this.uid
  })
    :super(
      uid: uid,
      fileType: fileType,
      senderID:senderID,
      receiverID:receiverID,
      messsage:messsage,
      type:type,
      timestamp:timestamp,
      markAsRead:markAsRead,
      isMine:isMine,
      chatRoomID: chatRoomID,
    );

  factory MessageModel.fromJson(Map<String,dynamic> json,String? curretnUser)=>MessageModel(
    uid: json['uid'],
    senderID: json['senderID'],
    receiverID: json['receiverID'], 
    messsage: json['messsage'], 
    type: json['type'], 
    timestamp: json['timestamp'], 
    fileType: json['fileType'], 
    markAsRead: json['markAsRead'], 
    isMine:  json['senderID'] == curretnUser,
    chatRoomID: json['chatRoomId'],
    );

  Map<String,dynamic> toMap()=> {
    'uid':uid,
    'senderID':senderID,
    'receiverID':receiverID,
    'messsage':messsage,
    'type':type,
    'timestamp':timestamp,
    'fileType':fileType,
    'markAsRead':markAsRead,
    'isMine':isMine,
    'chatRoomId':chatRoomID,
  }; 
  
  factory MessageModel.create(String uid ,String senderID,String receiverID,String messsage,String chatRoomID)=> MessageModel(
    uid: uid,
    senderID: senderID, 
    receiverID: receiverID, 
    messsage: messsage, 
    chatRoomID:chatRoomID,
    type: 'message', 
    timestamp: DateFormat.yMMMEd().format(DateTime.now()), 
    fileType: 'message', 
    markAsRead: false, 
    isMine: true,
    );

  factory MessageModel.forImage(String uid,String senderId,String receiverId,String chatRoomID,String fakeType)=> MessageModel(
    uid: uid,
    senderID: senderId, 
    receiverID: receiverId, 
    messsage: 'fakeImage', 
    type: fakeType, 
    timestamp: DateFormat.yMMMEd().format(DateTime.now()), 
    fileType: fakeType, 
    markAsRead: false, 
    isMine: true, 
    chatRoomID: chatRoomID, 
  );

  factory MessageModel.forGroup(String uid,String senderID,String messsage,String chatRoomID)=> MessageModel(
    uid: uid,
    senderID: senderID, 
    receiverID: 'groups', 
    messsage: messsage, 
    chatRoomID: chatRoomID, 
    type: 'message', 
    timestamp: DateFormat.yMMMEd().format(DateTime.now()), 
    fileType: 'message', 
    markAsRead: false, 
    isMine: true,
  
    );
}