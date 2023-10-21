part of 'internet_bloc.dart';

@immutable
class InternetState {}

class InitialInternetState extends InternetState{}

class LoadingInternetState extends InternetState{}

class SuccessInternetState extends InternetState{
  final bool isConnected;
  SuccessInternetState(this.isConnected);
}

class FailInternetState extends InternetState{
  final String fail;
  FailInternetState(this.fail);
}
