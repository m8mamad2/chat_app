import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class AuthHelperHeader{
  Future<void> signUp(BuildContext context,String email, String phone,String password);
  Future<void> logIn(BuildContext context,String email,String password);
  Future<void> logOut(BuildContext context,);
  bool isUserLogedIn();
  Future<void> addUserInfo(BuildContext context,XFile? image,String name);
  Future<void> deleteAccount(BuildContext context);
  // Future otpVerify(BuildContext context,String phone,String token);
}