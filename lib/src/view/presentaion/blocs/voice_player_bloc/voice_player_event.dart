part of 'voice_player_bloc.dart';

@immutable
class VoicePlayerEvent {}

class InitialVoicePlayerEvent extends VoicePlayerEvent{}

class InitiInUIPlayerEvent extends InitialVoicePlayerEvent{}

class PlayerOrPauseEvent extends InitialVoicePlayerEvent{
  final String data;
  final String fileUid;
  final String fileType;
  PlayerOrPauseEvent(this.data,this.fileType,this.fileUid);
}