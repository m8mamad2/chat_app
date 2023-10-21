part of 'voice_player_bloc.dart';

@immutable
class VoicePlayerState {}

class InitialVoicePlayerState extends VoicePlayerState {}

class LoadingVoicePlayerState extends VoicePlayerState {}

class SuccessVoicePlayerState extends VoicePlayerState {
  IconData icon;
  Duration duration;
  Duration position;
  SuccessVoicePlayerState({required this.icon,required this.duration,required this.position});
}

class FailVoicePlayerState extends VoicePlayerState {
  String fail;
  FailVoicePlayerState(this.fail);
}
