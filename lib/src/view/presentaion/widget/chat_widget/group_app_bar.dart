
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/view/data/model/create_group_model.dart';
import 'package:p_4/src/view/data/repo/calling_repo_body.dart';
import 'package:p_4/src/view/data/repo/chat_repo_body.dart';
import 'package:p_4/src/view/data/repo/group_repo_body.dart';
import 'package:p_4/src/view/domain/entity/message_entity.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/video_call_screen.dart';
import 'package:p_4/src/view/data/model/user_model.dart';

import '../../../data/model/message_model.dart';
import 'app_bar_group_info.dart';
import 'app_bar_info_screen.dart';



class GroupAppBar extends StatefulWidget implements PreferredSizeWidget{
  final CreateGroupModel data;
  final double height;
  final VoidCallback onPress;
  const GroupAppBar({super.key,required this.data,this.height = kToolbarHeight,
  required this.onPress,
  });

  @override
  State<GroupAppBar> createState() => _GroupAppBarState();
  
  @override
  Size get preferredSize => Size.fromHeight(height);
}
class _GroupAppBarState extends State<GroupAppBar> {
  @override
  Widget build(BuildContext context) {
    

    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: theme(context).backgroundColor,
      elevation: 0,
      foregroundColor: theme(context).backgroundColor,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          color: theme(context).primaryColorDark,
          height: sizeH(context)*0.002,
        ),
      ),
      toolbarHeight: sizeH(context)*0.16,
      leading: IconButton(icon:Icon(Icons.arrow_back,color: theme(context).cardColor,),onPressed: ()=>context.navigationBack(context),),
      actions: [
        IconButton(
          onPressed: ()async{

            // String currentUserId = ChatRepoBody().currentUserId()!;
            // List<String> ids = [currentUserId,widget.data.uid!];
            // ids.sort();
            // String chatRoomId = ids.join('_');

            // String roomID = await repo.createRoom();
            // context.navigation(context, VideoCallScreen(roomId: roomID,token: repo.token,));
            // await repo.inviteToCall(widget.data.uid!, roomID, chatRoomId).then((value) => log('WOOOOOOW'));
            
          }, 
          icon: Icon(Icons.video_call,color: theme(context).cardColor,)),
        IconButton(onPressed: widget.onPress,icon: Icon(Icons.search,color: theme(context).cardColor,)),
      ], 
      title: InkWell(
        onTap: (){
          List<UserModel> users = widget.data.users.map((e) => UserModel.fromJson(e)).toList();
          context.navigation(context, AppbarGroupInfoScreen(data: widget.data,));
        },
        child: Row(
          children: [
            widget.data.image != null && widget.data.image!.isNotEmpty
              ? CircleAvatar( radius: sizeW(context)*0.03,backgroundColor: theme(context).primaryColorDark ,backgroundImage: NetworkImage(widget.data.image!),)
              : CircleAvatar( radius: sizeW(context)*0.03,backgroundColor: theme(context).primaryColorDark ,child: Text(widget.data.name[0].toUpperCase(),style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).backgroundColor) ,),),
            //   ),
            sizeBoxW(sizeW(context)*0.013),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.data.name,style: theme(context).textTheme.titleSmall!.copyWith(color: theme(context).cardColor,fontSize: sizeW(context)*0.02,fontFamily: 'header'),),
                Text('${widget.data.users.length} members',style: theme(context).textTheme.bodySmall!,)
              ],
            ),
          ],
        ),
      )
    );
  }
}