import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:p_4/src/view/domain/usecase/upload_usecase.dart';

import '../../../data/model/message_model.dart';
part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadUseCaes useCase;
  UploadBloc(this.useCase) : super(UploadInitialState()) {
    
    on<UploadMediaEvent>((event, emit) async => await useCase.uploadMedia(event.receiverId,event.chatRoomId,event.replyMessage));
    on<UploadFileEvent>((event, emit) async => await useCase.uploadFile(event.receiverId,event.chatRoomId,event.replyMessage));
    on<UploadVoiceEvent>((event, emit) async => await useCase.uploadVoice(event.receiverId,event.path,event.chatRoomId,event.replyMessage));
    on<DownloadFileEvent>((event, emit){
      emit(UploadLoadingState());
      try{
        Stream<String> downloadFile = useCase.downloadFile(event.data, event.fileType, event.fileUid,).asBroadcastStream();
        emit(UploadSuccessState( downlaodFile: downloadFile ));

      }
      catch(e){emit(UploadFailState(error: e.toString()));}
    });
    on<DownloadVoiceEvent>((event, emit) async =>  useCase.downloadVoice(event.data,event.fileType,event.fileUid));
    on<DownloadVideoEvent>((event, emit) async =>  useCase.downloadVideo(event.data,event.fileType,event.fileUid));
    
// {
//       emit(UploadLoadingState());
//       try{
//         Stream<Map<String?,String>> downlaodVoice = useCase.downloadVoice(event.data,event.fileType,event.fileUid);
//         emit(UploadSuccessState(downloadVoice: downlaodVoice));
//       }
//       catch(e){ emit(UploadFailState(error: e.toString())); }
//     }  
  }
}
// Stream<String>