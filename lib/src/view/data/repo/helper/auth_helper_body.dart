
// ignore_for_file: avoid_renaming_method_parameters


import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/core/widget/auth_check.dart';
import 'package:p_4/src/view/presentaion/screens/auth_screen/auth_info_screen.dart';
import 'package:p_4/src/view/presentaion/screens/auth_screen/otp_screen.dart';
import 'package:p_4/src/view/presentaion/screens/home_screen.dart';
import 'package:p_4/src/core/common/bottom_shet_helper.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/view/domain/repo/auth_repo_head.dart';
import 'package:p_4/src/view/domain/repo/helper/auth_helepr_header.dart';

import '../../../presentaion/blocs/auth_bloc/auth_bloc.dart';

class AuthHelperBody extends AuthHelperHeader{

  AuthRepoHeader authRepo;
  AuthHelperBody(this.authRepo);

  @override
  Future<void> logIn(BuildContext context,String email, String password) async {
    return await authRepo.login(email, password)
      .then((value) async {
        if(value == 'ok'){ context.navigation(context, const HomeScreen());}
        else{ errorBottomShetHelper(context, value,(){
          context.navigationBack(context);
        }); }
      });
  }

  @override
  Future signUp(BuildContext context,String email, String phone, String password) async => await authRepo.signUp(email, phone, password,context);
    // return await authRepo.signUp(email,phone,password);
      // .then((value) async {
      //   if(value == 'ok'){
      //     context.navigation(context, const AuthInfoScreen());
      //     }
      //   else{ errorBottomShetHelper(context, value,(){context.navigationBack(context);});}
      // });
  

  @override
  Future<void> logOut(BuildContext context) async => await authRepo.signOut(context);

  @override
  Future<void> deleteAccount(BuildContext context)async=>await authRepo.deleteAccount(context);
  // {
  //   return await authRepo.signOut()
  //     .then((value)async {
  //       if(value == 'ok'){
  //         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthCheckWidget(),));
  //       }
  //       else{await errorBottomShetHelper(context, value, () => context.navigationBack(context));}
  //     });
  // }
  
  @override
  bool isUserLogedIn()=> authRepo.isUserLogedIn();
  
  @override
  Future<void> addUserInfo(BuildContext context,XFile? image,String name)async{
    return await authRepo.addUserInfo(image, name)
      .then((value) async {
        value == 'ok'
          ? context.navigation(context, const HomeScreen())
          : errorBottomShetHelper(context, value,(){context.navigationBack(context);});
      });
  }

  // @override
  // Future<void> otpVerify(BuildContext context,String phone,String token)async{
  //   await authRepo.otpVerify(phone, token)
  //     .then( (value) async => 
  //       value == 'ok' 
  //         ? await context.navigation(context, const AuthCheckWidget())
  //         : await bottomShetHelper(context, 'please Try again!'));

  // }

}