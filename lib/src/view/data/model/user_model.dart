// ignore_for_file: overridden_fields

import 'package:p_4/src/view/domain/entity/user_entity.dart';

class UserModel extends UserEntity{
  @override
  final int? id;
  
  @override
  final String? uid;
  
  @override
  final String? phone;

  @override
  final String? email;

  @override
  final String? groupUid;

  @override
  final String? info;

  @override
  final bool? inOnline;

  @override
  final String? timestamp;

  @override
  final String? image;

  @override
  final String? name;
  
  UserModel({ this.id, this.uid, this.phone,this.groupUid,this.inOnline,this.timestamp,this.image,this.name,this.email,this.info}) : 
  super(id: id,uid: uid,email: email,phone: phone,groupUid: groupUid,inOnline: inOnline,timestamp: timestamp,image: image,name: name,info: info);

  factory UserModel.fromJson(Map<String,dynamic> json)=> UserModel(
    id: json['id'], 
    uid: json['uid'], 
    phone: json['phone'],
    email: json['email'],
    groupUid: json['groupUid'],
    inOnline:json['inOnline'],
    timestamp: json['timestamp'],
    image:json['image'],
    name:json['name'],
    info: json['info']);
  
  Map<String,dynamic> toMap()=>{
    'id':id,
    'uid':uid,
    'phone':phone,
    'email':email,
    'groupUid':groupUid,
    'inOnline':inOnline,
    'timestamp':timestamp,
    'image':image,
    'name':name,
    'info':info
  };

}

// DateFormat.yMMMEd().format(DateTime.now())