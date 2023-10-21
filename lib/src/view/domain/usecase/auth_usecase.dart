import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/view/domain/repo/helper/auth_helepr_header.dart';

class AuthUseCase{
  AuthHelperHeader repo;
  AuthUseCase({required this.repo});

  Future<void> login (BuildContext context,String email,String password)async => await repo.logIn(context,email, password);
  Future<void> signup(BuildContext context,String email,String phone,String password)async => await repo.signUp(context,email,phone,password);
  Future<void> logout(BuildContext context) async => await repo.logOut(context);
  Future<void> addUserInfo(BuildContext context,XFile? image,String name) async => await repo.addUserInfo(context, image, name);
  bool isUserLogedIn()=> repo.isUserLogedIn();
  // Future<String?> otpVerify(BuildContext context,String phone,String token)async => await repo.otpVerify(context,phone,token);
}