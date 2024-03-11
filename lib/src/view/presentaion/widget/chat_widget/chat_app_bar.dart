
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/view/data/repo/calling_repo_body.dart';
import 'package:p_4/src/view/data/repo/chat_repo_body.dart';
import 'package:p_4/src/view/domain/entity/message_entity.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/video_call_screen.dart';
import 'package:p_4/src/view/data/model/user_model.dart';

import '../../../data/model/message_model.dart';
import 'app_bar_info_screen.dart';



class ChatAppBar extends StatefulWidget implements PreferredSizeWidget{
  final UserModel data;
  final double height;
  final VoidCallback onPress;
  const ChatAppBar({super.key,required this.data,this.height = kToolbarHeight,required this.onPress});

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();
  
  @override
  Size get preferredSize => Size.fromHeight(height);
}
class _ChatAppBarState extends State<ChatAppBar> {
  @override
  Widget build(BuildContext context) {
    
    CallingRepoBody repo = CallingRepoBody();
    ChatRepoBody repo1 = ChatRepoBody();

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
      leading: IconButton(icon: Icon(Icons.arrow_back,color: theme(context).cardColor,),onPressed: ()=>context.navigationBack(context),),
      actions: [
        // IconButton(
        //   onPressed: ()async{

        //     String currentUserId = ChatRepoBody().currentUserId()!;
        //     List<String> ids = [currentUserId,widget.data.uid!];
        //     ids.sort();
        //     String chatRoomId = ids.join('_');

        //     String roomID = await repo.createRoom();
        //     context.navigation(context, VideoCallScreen(roomId: roomID,token: repo.token,));
        //     await repo.inviteToCall(widget.data.uid!, roomID, chatRoomId).then((value) => log('WOOOOOOW'));
            
        //   }, 
        //   icon: Icon(Icons.video_call,color: theme(context).cardColor,)),
        // IconButton(onPressed: widget.onPress,icon: Icon(Icons.search,color: theme(context).cardColor,))
      ], 
      title: InkWell(
        onTap: (){context.navigation(context, AppBarInfoScreen(data: widget.data,));},
        child: Row(
          children: [
            widget.data.image != null 
              ? CircleAvatar( radius: sizeW(context)*0.03, backgroundColor: theme(context).primaryColorDark ,backgroundImage: NetworkImage(widget.data.image!),)
              : CircleAvatar( radius: sizeW(context)*0.03, backgroundColor: theme(context).primaryColorDark ,child: Center(child: Text(widget.data.name![0].toUpperCase(),style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).backgroundColor) ,)),),
            sizeBoxW(sizeW(context)*0.013),
            Column(
              children: [
                Text(widget.data.name!,style: theme(context).textTheme.titleSmall!.copyWith(color: theme(context).cardColor,fontSize: sizeW(context)*0.02,fontFamily: 'header'),),
                sizeBoxW(sizeW(context)*0.013),
                StreamBuilder(
                stream: repo1.getUserStatus(widget.data.uid!),
                builder: (context, snapshot) {
                  TextStyle texttheme = theme(context).textTheme.bodySmall!;
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:return Text('offline',style: texttheme,);
                    default:
                    log(snapshot.data.toString());
                    return snapshot.data != null
                        ? Text(snapshot.data![0].inOnline! ? 'online' : 'offline',style: texttheme,)
                        :const Text('offline0');
                  }
                },),
              ],
            ),
          ],
        ),
      )
    );
  }
}