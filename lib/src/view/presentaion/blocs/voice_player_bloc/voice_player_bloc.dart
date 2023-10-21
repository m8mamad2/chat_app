import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:p_4/src/view/data/repo/upload_repo_body.dart';
import 'package:p_4/src/view/domain/usecase/upload_usecase.dart';

part 'voice_player_event.dart';
part 'voice_player_state.dart';

// class VoicePlayerBloc extends Bloc<VoicePlayerEvent, VoicePlayerState> {
//   UploadUseCaes useCaes;
//   VoicePlayerBloc(this.useCaes) : super(InitialVoicePlayerState()) {

//     AudioPlayer audioPlayer = AudioPlayer();
//     bool isPlaying = false;
//     late IconData icon;
//     Duration duration = const Duration();
//     Duration position = const Duration();
    
//     Stream init()async*{
//       yield audioPlayer.onDurationChanged.listen((event) { duration = event; });

//       yield audioPlayer.onPositionChanged.listen((event) { position = event; });

//       yield audioPlayer.onPlayerComplete.listen((event) {  position = duration; icon = Icons.replay; isPlaying = false; });

//       yield icon = Icons.play_arrow;
//     }

//     Stream playPause(dynamic data,String fileType,String fileUid)async*{
//       if(isPlaying){
//         yield icon = Icons.play_arrow;
//         yield isPlaying = false;
//         await audioPlayer.pause();
//       }
//       else{
//         // String? get = context.read().add(DownloadVoiceEvent(widget.data.messsage, widget.data.fileType!));
//         // String? get = await useCaes.downloadVoice(data, fileType,fileType);
//         // Source urlSource = UrlSource(get!);
//         // yield icon = Icons.pause;
//         // yield isPlaying = true;
//         // await audioPlayer.play(urlSource);
//       }
//     }
  
    
//     // ignore: void_checks
//     on<InitialVoicePlayerEvent>((event, emit)async*{
        


//       emit(LoadingVoicePlayerState());

//       try{

//         if(event is InitiInUIPlayerEvent)yield init();
//         if(event is PlayerOrPauseEvent) yield playPause(event.data,event.fileType,event.fileUid);

//         emit(SuccessVoicePlayerState(
//           icon: icon,
//           duration: duration,
//           position: position
//         ));
//       }
//       catch(e){emit(FailVoicePlayerState(e.toString()));}



//     });
    
  
//   }
// }

class VoicePlayerBloc extends Bloc<VoicePlayerEvent, VoicePlayerState> {
  UploadUseCaes useCaes;
  VoicePlayerBloc(this.useCaes) : super(InitialVoicePlayerState()) {

    AudioPlayer audioPlayer = AudioPlayer();
    bool isPlaying = false;
    late IconData icon;
    Duration duration = const Duration();
    Duration position = const Duration();
    
    Stream init()async*{
      yield audioPlayer.onDurationChanged.listen((event) { duration = event; });

      yield audioPlayer.onPositionChanged.listen((event) { position = event; });

      yield audioPlayer.onPlayerComplete.listen((event) {  position = duration; icon = Icons.replay; isPlaying = false; });

      yield icon = Icons.play_arrow;
    }

    Stream playPause(dynamic data,String fileType,String fileUid)async*{
      if(isPlaying){
        yield icon = Icons.play_arrow;
        yield isPlaying = false;
        await audioPlayer.pause();
      }
      else{
        // String? get = context.read().add(DownloadVoiceEvent(widget.data.messsage, widget.data.fileType!));
        // String? get = await useCaes.downloadVoice(data, fileType,fileType);
        // Source urlSource = UrlSource(get!);
        // yield icon = Icons.pause;
        // yield isPlaying = true;
        // await audioPlayer.play(urlSource);
      }
    }
  
    
    // ignore: void_checks
    on<InitialVoicePlayerEvent>((event, emit)async*{
        


      emit(LoadingVoicePlayerState());

      try{

        if(event is InitiInUIPlayerEvent)yield init();
        if(event is PlayerOrPauseEvent) yield playPause(event.data,event.fileType,event.fileUid);

        emit(SuccessVoicePlayerState(
          icon: icon,
          duration: duration,
          position: position
        ));
      }
      catch(e){emit(FailVoicePlayerState(e.toString()));}



    });
    
  
  }
}
