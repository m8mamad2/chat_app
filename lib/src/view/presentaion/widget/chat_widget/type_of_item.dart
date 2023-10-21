import 'package:flutter/material.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/types/file_type_widget.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/types/image_type_widget.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/types/location_type_widget.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/types/message_type_widget.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/types/video_call_type.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/types/video_type_widget.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/types/voice_type_widget.dart';


Widget messageItemWidget(BuildContext context,MessageModel messageModel,){

    bool isMine = messageModel.isMine;
    Alignment alignment = isMine ? Alignment.centerRight : Alignment.centerLeft;
    String type = messageModel.type;

    switch(type){
      case 'image' : return ImageTypeWidget(url: messageModel.messsage,alignment: alignment,);
      case 'fakeimage' : return ImageLoadingTypeWidget(alignment: alignment,);

      case 'video': return VideoTypeWidget(data: messageModel,alignment: alignment);
      case 'fakevideo': return VideoLoadingTypeWidget(alignment: alignment);
      
      case 'file' :return FileTypeWidget(data: messageModel,alignment: alignment,isMine: isMine,);
      case 'fakeFile' :return FileLoaingTypeWidget(data: messageModel,alignment: alignment,isMine: isMine,);
      
      case 'voice': return VoiceTypeWidget(data: messageModel,alignment: alignment,isMine: isMine,);
      case 'fakeVoice': return VoiceLoadingTypeWidget(data: messageModel,alignment: alignment,isMine: isMine,);

      case 'videoCall':return VideoCallTypeWidget(aligment: alignment, data: messageModel, isMine: isMine);
      case 'videoCallEnded':return VideoCallEndedTypeWidget(aligment: alignment, data: messageModel, isMine: isMine);
      
      case 'location': return LocationTypeWidget(data: messageModel,alignment: alignment);

      default: return MessageTypeWidget(aligment: alignment, data: messageModel,isMine: isMine,);
    }
  }

