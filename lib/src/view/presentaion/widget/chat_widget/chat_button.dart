
// ignore_for_file: use_build_context_synchronously


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/is_english.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/upload_bloc/upload_bloc.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/location_send.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import 'chat_emoji_picker.dart';

// ignore: must_be_immutable
class ChatButtonsWidget extends StatefulWidget {
  final ScrollController scrollController;
  final String receiverId;
  final String chatRoomId;
  bool isEmojiSelected;
  TextEditingController controller;
  FocusNode focusNode;
  MessageModel? replayMessage;
  VoidCallback onCancelReply;
  ChatButtonsWidget({super.key,required this.scrollController,required this.receiverId,required this.chatRoomId,required this.isEmojiSelected,required this.controller,required this.focusNode,required this.replayMessage,required this.onCancelReply});

  @override
  State<ChatButtonsWidget> createState() => _ChatButtonsWidgetState();
}
class _ChatButtonsWidgetState extends State<ChatButtonsWidget> {

  Widget oneItemBottomShet(IconData icon,String title,VoidCallback event)=> Padding(
    padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.015),
    child: GestureDetector(
      onTap:()=> event(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
              radius: sizeW(context)*0.04,
              backgroundColor: theme(context).primaryColorDark,
              child: Icon(icon,color: theme(context).scaffoldBackgroundColor,),
          ),
          sizeBoxH(sizeH(context)*0.015),
          Text(title.tr(),style:  TextStyle(color: theme(context).primaryColorDark),)
        ],
      ),
    ),
  );
  
  late bool isEmojiSelected;
  bool isSendButton = false;
  late List kBottomShetEvent;

  @override
  void initState() {
    super.initState();
    isEmojiSelected = widget.isEmojiSelected;
    kBottomShetEvent = [
     () { context.read<UploadBloc>().add(UploadMediaEvent(widget.receiverId, widget.chatRoomId,null));context.navigationBack(context);},
     () { context.read<UploadBloc>().add(UploadFileEvent(widget.receiverId, widget.chatRoomId,null));context.navigationBack(context);},
     () { context.navigation(context, LocationSendWidget(receiverId: widget.receiverId,isGroup: false,));},
    ];
  }

  @override
  void dispose() {
    audioRecord.dispose();
    widget.focusNode.dispose();
    // _
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
              color: theme(context).scaffoldBackgroundColor,
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: sizeW(context)*0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_result,style: TextStyle(color: theme(context).cardColor),),
                  IconButton(
                    onPressed: () async {setState(()=> isRecording = false);await stopRecording(widget.receiverId);}, 
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
                      Text(
                        widget.replayMessage!.type == 'message'
                          ? 
                            widget.replayMessage!.messsage.length > 40
                              ? '${widget.replayMessage!.messsage.substring(0,40)} ...'
                              : widget.replayMessage!.messsage
                          : widget.replayMessage!.type
                        ),

                      const Spacer(),
                      IconButton(
                        onPressed: ()=> widget.onCancelReply() , 
                        icon: const Icon(Icons.close))
                    ],
                  ),
                )
                : const SizedBox.shrink(),
              
              Container(
                width: sizeW(context),
                height: sizeH(context)*0.15,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: theme(context).primaryColorDark,width: sizeW(context)*0.001)),
                  color: theme(context).scaffoldBackgroundColor,
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
                  
                  //? TextField
                  Expanded(
                    child:TextFormField(
                      focusNode: widget.focusNode,
                      controller: widget.controller, 
                      onChanged: (value) => widget.controller.text.isNotEmpty || widget.controller.text != '' ? setState(() => isSendButton = true) : setState(() => isSendButton = false),
                      onTap: () {
                        isEmojiSelected ? setState(() => isEmojiSelected = !isEmojiSelected,) : null;
                        widget.scrollController.jumpTo(widget.scrollController.position.minScrollExtent);
                      },
                      decoration: InputDecoration( border: InputBorder.none,hintText: 'Enter message'.tr(),hintStyle: TextStyle(color: theme(context).cardColor) ),
                      )),
                  isSendButton 

                    //? sendButton
                    ? IconButton(onPressed: ()async{
                        if(widget.controller.text.isNotEmpty) {
                          context.read<ChatBloc>().add(SendMessageEvent(receiverId: widget.receiverId, message: widget.controller.text,replyMessage: widget.replayMessage));
                          if(widget.scrollController.hasClients) widget.scrollController.jumpTo(widget.scrollController.position.minScrollExtent);
                          widget.controller.clear();
                          setState(() => isSendButton = false);
                          widget.onCancelReply();
                        }
                      }, 
                        icon: Icon(Icons.send,color: theme(context).cardColor))
                    
                    //? Media and Record BUtton
                    : Row(children: [
                        IconButton(
                          onPressed: ()=> showBottomSheet(
                            context: context, 
                            builder: (context) => Container(
                              width: sizeW(context),
                              height: sizeH(context)*0.4,
                              padding: EdgeInsets.only(
                                left: isEnglish(context) ? sizeW(context)*0.08 : 0,
                                right: isEnglish(context) ? 0 : sizeW(context)*0.08,
                                ),
                              decoration: BoxDecoration(
                                color:  theme(context).scaffoldBackgroundColor,
                                border: Border(top: BorderSide(color: theme(context).primaryColorDark,width: sizeW(context)*0.002)),
                              ),
                              child:ListView.builder(
                                itemCount: 3,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => oneItemBottomShet(kBottomShetIcon[index],kBottomShetTitle[index],kBottomShetEvent[index]),)
                          ),
                        ),
                        icon: Icon(Icons.perm_media_outlined,color: theme(context).cardColor,)),
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
        await audioRecord.start(RecordConfig(),path: path);
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
      context.read<UploadBloc>().add(UploadVoiceEvent(receiverId,path!,widget.chatRoomId,null));
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
                    

