import 'dart:developer';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/view/data/model/create_group_model.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/domain/repo/group_repo_head.dart';
import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../model/user_model.dart';

class GroupRepoBody extends GroupRepoHeader{
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<String> createGroup(String name,String? bio,List<UserModel> users,XFile? file,UserModel mySelf)async{

    try{
      String? imageUrl;

         //* add myself to group
      String currentUser = supabase.auth.currentSession!.user.id;
      users.add(mySelf);
      
      
      //* convert users to map
      List<Map<String,dynamic>> map = users.map((e) => e.toMap()).toList();
      
      //* upload image
      if(file != null){
        final byte = await file.readAsBytes();
        final fileExt = file.path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        await supabase.storage.from('user').uploadBinary(fileName, byte);
        final String getUrl = await supabase.storage.from('user').createSignedUrl(fileName, 60 * 60 * 24 * 365 * 10);
        imageUrl = getUrl;}
      else{imageUrl == null;}

      CreateGroupModel data = CreateGroupModel(
        uid: const Uuid().v1(), 
        name: name, 
        users: map, 
        timestamp: DateFormat.yMMMEd().format(DateTime.now()),
        image: imageUrl,
        creater: currentUser,
        bio: bio
        );
      
      await supabase.from('groups').insert(data.toMap()).then((value) => print('--->>>>>>>>SUCESS')).catchError((e)=>print('-->>>>Error $e'));
      return 'ok';

    }
    on PostgrestException catch(e){log('in Group Created Metod $e');return e.toString();}
    catch(e){log('in Group Created Metod $e') ;return e.toString();;}
 
  }
  
  @override
  Future<List<CreateGroupModel>?> groupsModel()async => await supabase.from('groups').select<PostgrestList>().then((value) => value.map((e) => CreateGroupModel.fromJson(e)).toList());
  
  @override
  Stream<List<MessageModel>> getGroupMessages(String groupUid) {
    String currentUser = supabase.auth.currentUser!.id;
    return supabase.from('chat')
      .stream(primaryKey: ['id'])
      .order('timestamp')
      .eq('chatRoomId',groupUid)
      .map((event) => event.map((e) => MessageModel.fromJson(e, currentUser)).toList());
  }
  
  @override
  Future<void> sendGroupMessage(String message,String groupID,MessageModel? replyMessage)async{

    try{String currentUser = supabase.auth.currentUser!.id;
      String uid = const Uuid().v4();

      MessageModel messageModel = MessageModel.forGroup(
        uid, 
        currentUser, 
        message, 
        groupID,
        replyMessage);

      return supabase.from('chat').insert(messageModel.toMap());
    }
    on PostgrestException catch(e){log('in Group Created Metod $e');}
    catch(e){
      log('Send Message ---->>>> $e');
    }
  }

  @override
  Future<List<CreateGroupModel>> getExistGroup()async{

    // List<UserModel> data = [];
    // final String currentUser = supabase.auth.currentSession!.user.id.substring(0,5);
    // final res = 
    //   await supabase.from('groups')
    //   .select<PostgrestList>('users')
    //   .then((value) => value.map((e) {return e['users'];}).toList());
    // for(var i in res){
    //   for(var j in i){
    //     UserModel userModel = UserModel.fromJson(j);
    //     if(userModel.uid == currentUser) data.add(userModel);
    //   }
    // }
    List<CreateGroupModel> groups = [];
    final String currentUser = supabase.auth.currentSession!.user.id;
    final List<CreateGroupModel> groupModel = await supabase.from('groups').select<PostgrestList>().then((value) => value.map((e) => CreateGroupModel.fromJson(e)).toList());

    for(var grpModel in groupModel){
      List<UserModel> userModels = grpModel.users.map((e) => UserModel.fromJson(e)).toList();
      for(var j in userModels){
        if(j.uid == currentUser)groups.add(grpModel);
      }
    }

    return groups;
  }

  @override
  Future<String> deleteGroup(String groupUid)async{
    try{
      await supabase.from('groups').delete().eq('uid', groupUid);
      return 'ok';
    }
    catch(e){ log('in Delte Group ===> $e');return e.toString();}
  }

  @override
  Future<String> leftGroup(String groupUid)async{
    try{
      String currenUser = supabase.auth.currentUser!.id;
      CreateGroupModel groupModel = await supabase.from('groups').select<PostgrestList>().eq('uid', groupUid).then((value) => CreateGroupModel.fromJson(value[0]));
      List<UserModel> usersGroup  = groupModel.users.map((e) => UserModel.fromJson(e)).toList();
      usersGroup.removeWhere((element) => element.uid == currenUser);
      List<Map<String,dynamic>> userDeletedGroup = usersGroup.map((e) => e.toMap()).toList();
      await supabase.from('groups').update({'users':userDeletedGroup}).eq('uid', groupUid);
      return 'ok';
    }
    catch(e){
      log('-----> in LeftGroup$e');
      return e.toString();
    }
  }
} 

//  [
//   [
//     {id: null, uid: 0b744, email: null, groupUid: null, inOnline: null, timestamp: null, image: null, name: null},
//     {id: null, uid: ab0b8, email: null, groupUid: null, inOnline: null, timestamp: null, image: null, name: null}, 
//     {id: null, uid: bc36e, email: null, groupUid: null, inOnline: null, timestamp: null, image: null, name: null}, 
//     {id: null, uid: b38c8, email: null, groupUid: null, inOnline: null, timestamp: null, image: null, name: null}, 
//     {id: null, uid: 2d1ad, email: , groupUid: null, inOnline: null, timestamp: null, image: null, name: null}
//   ]
// ]