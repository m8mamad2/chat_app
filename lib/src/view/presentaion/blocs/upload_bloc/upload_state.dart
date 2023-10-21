part of 'upload_bloc.dart';

@immutable
class UploadState {}

class UploadInitialState extends UploadState{}

class UploadLoadingState extends UploadState{}

// ignore: must_be_immutable
class UploadSuccessState extends UploadState{
  Stream<String>? downlaodFile;
  Stream<Map<String?,String>>? downloadVoice;
  UploadSuccessState({this.downlaodFile,this.downloadVoice}):super();
}

class UploadFailState extends UploadState{
  final String error;
  UploadFailState({required this.error});
}

