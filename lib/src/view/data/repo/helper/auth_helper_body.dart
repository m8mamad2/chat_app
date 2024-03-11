
// ignore_for_file: avoid_renaming_method_parameters


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/view/presentaion/screens/home_screen.dart';
import 'package:p_4/src/core/common/bottom_shet_helper.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/view/domain/repo/auth_repo_head.dart';
import 'package:p_4/src/view/domain/repo/helper/auth_helepr_header.dart';


class AuthHelperBody extends AuthHelperHeader{

  AuthRepoHeader authRepo;
  AuthHelperBody(this.authRepo);

  @override
  Future<void> logIn(BuildContext context,String email, String password) async {
    return await authRepo.login(email, password)
      .then((value) async {
        if(value == 'ok'){ context.navigationRemoveUtils(context, const HomeScreen());}
        else{ errorBottomShetHelper(context, value,(){
          context.navigationBack(context);
        }); }
      });
  }

  @override
  Future signUp(BuildContext context,String email, String phone, String password) async => await authRepo.signUp(email, phone, password,context);
  

  @override
  Future<void> logOut(BuildContext context) async => await authRepo.signOut(context);

  @override
  Future<void> deleteAccount(BuildContext context)async=>await authRepo.deleteAccount(context);
  
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

}