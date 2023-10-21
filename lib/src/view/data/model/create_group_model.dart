import 'package:p_4/src/view/data/model/user_model.dart';

class CreateGroupModel {
  final List<dynamic> users;
  final String uid;
  final String name;
  final String timestamp;
  final String creater;
  final String? bio;
  final String? image;
  final bool isThere = false;

  CreateGroupModel({required this.uid,required this.name,required this.users,required this.timestamp,required this.image,required this.bio,required this.creater});

  factory CreateGroupModel.fromJson(Map<String,dynamic> json)=>CreateGroupModel(
    uid:json['uid'], 
    name:json['name'], 
    users: json['users'] , 
    image: json['image'], 
    timestamp:json['timestamp'],
    creater:json['creater'],
    bio:json['bio'],
    );

  Map<String,dynamic> toMap()=>{
    'users':users,
    'uid':uid,
    'name':name,
    'timestamp':timestamp,
    'image':image,
    'creater':creater,
    'bio':bio,
  };
}