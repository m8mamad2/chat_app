
import 'package:flutter/material.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/view/data/repo/calling_repo_body.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/video_call_screen.dart';

import '../../../../data/model/message_model.dart';
import '../../../../data/repo/chat_repo_body.dart';
import '../message_bubble_widget.dart';

class VideoCallTypeWidget extends StatelessWidget {
  final Alignment aligment;
  final MessageModel data;
  final bool isMine;
  const VideoCallTypeWidget({super.key,required this.aligment,required this.data,required this.isMine,});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: aligment,
      widthFactor: 0.7,
      child: Align(
        alignment: aligment,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: sizeW(context)*0.02),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: BubbleBackground(
              colors: [
                if (isMine) ...const [
                  Color(0xFF6C7689),
                  Color(0xFF3A364B),
                ] else ...const [
                  Color(0xFF19B7FF),
                  Color(0xFF491CCB),
                ],
              ],
              child: SizedBox(
                height: sizeH(context)*0.18,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async{
                        CallingRepoBody repo = CallingRepoBody();
                        context.navigation(context, VideoCallScreen(roomId: data.messsage, token: repo.token));
              
                        String currentUserId = ChatRepoBody().currentUserId()!;
                        List<String> ids = [currentUserId,data.receiverID];
                        ids.sort();
                        String chatRoomId = ids.join('_');
              
                        await repo.endCall(data.receiverID, data.messsage, chatRoomId, data.uid);
                      },
                      child:CircleAvatar(
                        radius: (sizeW(context)*0.035).toDouble(),
                          backgroundColor: const Color(0xff1b2028),
                        child:const Icon(Icons.call,color: Colors.white,)),
                    ),
                    sizeBoxW(sizeW(context)*0.01),
                    const Text('Calling',style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
              ),
            ),
          ),
        ),
    );
  }
}

class VideoCallEndedTypeWidget extends StatelessWidget {
  final Alignment aligment;
  final MessageModel data;
  final bool isMine;
  const VideoCallEndedTypeWidget({super.key,required this.aligment,required this.data,required this.isMine,});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: aligment,
      widthFactor: 0.7,
      child: Align(
        alignment: aligment,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: sizeW(context)*0.02),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: BubbleBackground(
              colors: [
                if (isMine) ...const [
                  Color(0xFF6C7689),
                  Color(0xFF3A364B),
                ] else ...const [
                  Color(0xFF19B7FF),
                  Color(0xFF491CCB),
                ],
              ],
                child: SizedBox(
                  height: sizeH(context)*0.18,
                  child: Row(
                    children:[
                       CircleAvatar(
                          radius: (sizeW(context)*0.035).toDouble(),
                          backgroundColor: const Color(0xff1b2028),
                          child: const Icon(Icons.call,color: Colors.white,)),
                       sizeBoxW(sizeW(context)*0.01),
                       const Text('Call Ended',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}


