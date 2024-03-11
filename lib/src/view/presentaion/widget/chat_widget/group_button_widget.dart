
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/is_english.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/upload_bloc/upload_bloc.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/location_send.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../../../config/theme/theme.dart';
import '../../../data/model/message_model.dart';
import '../../../data/repo/group_repo_body.dart';
import 'chat_emoji_picker.dart';

class GroupButtonsWidget extends StatefulWidget {
  final ScrollController scrollController;
  final String groupUid;
  bool isEmojiSelected;
  TextEditingController controller;
  FocusNode focusNode;
  MessageModel? replayMessage;
  VoidCallback onCancelReply;
  GroupButtonsWidget({super.key,required this.scrollController,required this.groupUid,required this.isEmojiSelected,required this.controller,required this.focusNode,required this.replayMessage,required this.onCancelReply
});

  @override
  State<GroupButtonsWidget> createState() => _GroupButtonsWidgetState();
}
class _GroupButtonsWidgetState extends State<GroupButtonsWidget> {

  Widget oneItemBottomShet(IconData icon,String title,VoidCallback event)=> Padding(
    padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.015),
    child: GestureDetector(
      onTap: event,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
              radius: sizeW(context)*0.04,
              backgroundColor: theme(context).primaryColorDark,
              child: Icon(icon,color: theme(context).backgroundColor,),
          ),
          sizeBoxH(sizeH(context)*0.015),
          Text(title.tr(),style: TextStyle(color: theme(context).primaryColorDark),)
        ],
      ),
    ),
  );
  
  late bool isEmojiSelected;
  final FocusNode focusNode = FocusNode();
  bool isSendButton = false;
  late List kBottomShetEvent;

  @override
  void initState() {
    super.initState();
    isEmojiSelected = widget.isEmojiSelected;
    kBottomShetEvent = [
     ()=> context.read<UploadBloc>().add(UploadMediaEvent(widget.groupUid, widget.groupUid,null)),
     ()=> context.read<UploadBloc>().add(UploadFileEvent( widget.groupUid, widget.groupUid,null)),
     ()=> context.navigation(context, LocationSendWidget(receiverId: widget.groupUid,isGroup: true,)),
    ];
  }

  @override
  void dispose() {
    audioRecord.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final bool isReply = widget.replayMessage != null ;
   return Column(
     children: [

       //* button
      isRecording 
          ? Container(
            width: sizeW(context),
            height: sizeH(context)*0.15,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: theme(context).primaryColorDark,width: sizeW(context)*0.001)),
              color: theme(context).backgroundColor,
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: sizeW(context)*0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_result,style: TextStyle(color: theme(context).cardColor),),
                  IconButton(
                    onPressed: () async {setState(()=> isRecording = false);await stopRecording(widget.groupUid);}, 
                    icon: Icon(Icons.stop,color: theme(context).cardColor,))
                ],
              ),
            ),
          )
          : Column(
            children: [
              isReply 
                ? Container(
                  height: sizeH(context)*0.13,
                  width: sizeW(context),
                  color: theme(context).cardColor.withOpacity(0.1),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(Icons.keyboard_arrow_right_rounded),
                      ),
                      Text(widget.replayMessage!.messsage),
                      const Spacer(),
                      IconButton(onPressed: (){
                        widget.onCancelReply();
                      }, icon: const Icon(Icons.close))
                    ],
                  ),
                )
                : const SizedBox.shrink(),
              Container(
                width: sizeW(context),
                height: sizeH(context)*0.15,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: theme(context).primaryColorDark,width: sizeW(context)*0.001)),
                  color: theme(context).backgroundColor,
                ),
                child: Row(
                children: [
                  IconButton(
                    onPressed: ()async {
                      FocusScope.of(context).unfocus();
                      isEmojiSelected = !isEmojiSelected;
                      setState(() { });  
                    },
                    icon:Icon(isEmojiSelected ? Icons.keyboard : Icons.emoji_emotions,color: theme(context).cardColor,)),
                  Expanded(
                    child:TextFormField(
                      focusNode: focusNode,
                      controller: widget.controller, 
                      onChanged: (value) => widget.controller.text.isNotEmpty || widget.controller.text != '' ? setState(() => isSendButton = true) : setState(() => isSendButton = false),
                      onTap: () {
                        isEmojiSelected ? setState(() => isEmojiSelected = !isEmojiSelected,) : null;
                        
                        if(widget.scrollController.hasClients)widget.scrollController.jumpTo(widget.scrollController.position.minScrollExtent);
                        // Timer(const Duration(milliseconds: 500),()=>scrollController.jumpTo(scrollController.position.maxScrollExtent));
                      },
                      decoration:  InputDecoration( border: InputBorder.none,hintText: 'Enter message'.tr(),hintStyle: TextStyle(color: theme(context).cardColor) ),
                      )),
                  isSendButton 
                    ? IconButton(onPressed: ()async{
                        GroupRepoBody repo = GroupRepoBody();
                        if(widget.controller.text.isNotEmpty) {
                          await repo.sendGroupMessage(widget.controller.text, widget.groupUid,widget.replayMessage);
                          if(widget.scrollController.hasClients) widget.scrollController.jumpTo(widget.scrollController.position.minScrollExtent);
                          widget.controller.clear();
                          setState(()=>isSendButton = false);
                          widget.onCancelReply();
                        }
                      }, 
                        icon: Icon(Icons.send,color: theme(context).cardColor))
                    : Row(children: [
                        IconButton(
                          onPressed: ()=> showBottomSheet(
                            context: context, 
                            builder: (context) => Container(
                              width: sizeW(context),
                              height: sizeH(context)*0.4,
                              padding: EdgeInsets.only(
                                left:isEnglish(context) ? sizeW(context)*0.08: 0 ,
                                right:isEnglish(context) ? 0 : sizeW(context)*0.08 ,
                                
                                ),
                              decoration: BoxDecoration(
                                color:  theme(context).backgroundColor,
                                border: Border(top: BorderSide(color: theme(context).primaryColorDark,width: sizeW(context)*0.002)),
                              ),
                              child:ListView.builder(
                                itemCount: 3,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => oneItemBottomShet(kBottomShetIcon[index],kBottomShetTitle[index],kBottomShetEvent[index]),)
                          ),
                        ),
                        icon:Icon(Icons.perm_media_outlined,color: theme(context).cardColor,)),
                        IconButton(onPressed: ()async {
                          await startRecording();
                          setState(() => isRecording = true );
                        }, 
                        icon: Icon(Icons.mic,color: theme(context).cardColor)),
                      ],)
                  ],
                ),
              ),
            ],
          ),

      if(isEmojiSelected) ChatEmojiPickerWidget(controller: widget.controller)
                
     ],
   );
  }








  //! recording voice
  final Stopwatch stopwatch = Stopwatch();
  final AudioRecorder audioRecord = AudioRecorder();
  bool isRecording = false;
  late final Timer _timer;
  String _result = '00:00';
  
  //! methos for recording and playing voide
  Future<void> startRecording()async{
    try{
      if(await audioRecord.hasPermission()){
        String path = await getDir();
        await audioRecord.start( RecordConfig(),path: path);
        start();
      }
    }
    catch(e){ print('----Recordign Start Error : $e');}
  }
  
  Future<void> stopRecording(String receiverId,)async{
    try{
      String? path = await audioRecord.stop();
      stop();
      // await repo.uploadVoice(receiverId, path!).then((value) => print('_____AFter uplaod VOice'));
      context.read<UploadBloc>().add(UploadVoiceEvent(receiverId,path!,widget.groupUid,null));
    }
    catch(e){ print('in Stop VOice Error = $e');}
  }
  
  Future<String> getDir()async{
    final Directory? dir = await getExternalStorageDirectory();
    final String path = '${dir!.path}/${const Uuid().v1()}.m4a';
    return path;
  }
  
  start(){
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      setState(() {
        _result = '${stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
      });
    });
    stopwatch.start();
  }
  
  stop(){
    _timer.cancel();
    stopwatch.stop();
    stopwatch.reset();
  }

}

List<IconData> kBottomShetIcon = [Icons.perm_media_outlined,Icons.file_copy_outlined,Icons.location_on_outlined];
List<String> kBottomShetTitle  = ['Media','Files','Location'];
// IconButton(onPressed: ()async => context.read<UploadBloc>().add(UploadMediaEvent(widget.receiverId,widget.chatRoomId)), icon:const Icon(Icons.image,color: Colors.white)),
// IconButton(onPressed: ()async => context.read<UploadBloc>().add(UploadFileEvent(widget.receiverId,widget.chatRoomId)), icon: const Icon(Icons.file_copy,color: Colors.white)),
                    

