// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:p_4/src/view/domain/usecase/auth_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState0> {
  final AuthUseCase useCase;
  AuthBloc(this.useCase):super( AuthInitialState() ){

  on<AuthSignUpEvent>((event, emit) async {

    emit(AuthLoadingState());

    try{
      await useCase.signup(event.context,event.email,event.phone,event.password)
        .then((value) {
          emit(AuthSucessState(isUserLoggedIn: true));
        });
    }
    catch(e){ emit(AuthFailState(error: e.toString())); }
    
  },);
  on<AuthLoginEvent>((event, emit) async {

    emit(AuthLoadingState());

    try{
      await useCase.login(event.context, event.email, event.password);
      emit(AuthSucessState(isUserLoggedIn: true));
    }
    catch(e){ emit(AuthFailState(error: e.toString())); }
    
  },);
  on<AuthLogoutEvent>((event, emit) async {

    emit(AuthLoadingState());

    try{
      await useCase.logout(event.context).then((value) => emit(AuthSucessState(isUserLoggedIn: false)));
    }
    catch(e){log('____))))_____>$e') ;emit(AuthFailState(error: e.toString())); }
    
  },);
  on<IsUserLogedIn>((event, emit) {
    // emit(AuthLoadingState());
    // try{
      // bool isUserLogedIn = useCase.isUserLogedIn();
      emit(AuthSucessState(isUserLoggedIn: true));
    // }
    // catch(e){ emit(AuthFailState(error: e.toString()));}
  },);
  on<AuthInfoEvent>((event, emit) async {
    emit(AuthLoadingState());
    try{
      await useCase.addUserInfo(event.context, event.image, event.name);
      emit(AuthSucessState(isUserLoggedIn: true));
    }
    catch(e){ emit(AuthFailState(error: e.toString()));}
  },);
  on<AuthDeleteAccout>((event, emit) async{
    emit(AuthLoadingState());

    try{
      await useCase.deleteAccount(event.context).then((value) => emit(AuthSucessState(isUserLoggedIn: false)));
    }
    catch(e){log('____))))_____>$e') ;emit(AuthFailState(error: e.toString())); }
  });
  // on<AuthVeriFyEvent>((event, emit) async {
    
  //   try{
  //     await useCase.otpVerify(event.context, event.phone, event.token);
  //     emit(AuthSucessState());
  //   }
  //   catch(e){ emit(AuthFailState(error: e.toString())); }
    
  // },);
  
  }
}
