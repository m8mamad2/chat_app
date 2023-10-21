// part of 'auth_bloc.dart';

// @immutable
// abstract class AuthState {
//   final bool? isLoaded;
//   const AuthState({this.isLoaded});
// }

// class AuthLoadingState extends AuthState {
// bool isLoaded = false;
// AuthLoadingState({required bool isLoaded}):super(isLoaded: isLoaded);
// }

// class AuthSucessState extends AuthState {
//   const AuthSucessState({required bool isLoaded}):super(isLoaded: isLoaded);
// }

// class AuthFailState extends AuthState {
//   final String? error;
//   final bool isLoaded;
//   AuthFailState({required this.error,required this.isLoaded}):super(isLoaded:isLoaded );
// }



part of 'auth_bloc.dart';

@immutable
abstract class AuthState0 {
  const AuthState0();
}

class AuthInitialState extends AuthState0{}

class AuthLoadingState extends AuthState0 {}

class AuthSucessState extends AuthState0 {
  bool? isUserLoggedIn;
  AuthSucessState({this.isUserLoggedIn});
}

class AuthFailState extends AuthState0 {
  final String? error;
  const AuthFailState({required this.error});
}


