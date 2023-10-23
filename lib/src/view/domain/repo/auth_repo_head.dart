
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class AuthRepoHeader{
  Future<String> login(String email,String password);
  Future<String> signUp(String email,String phone,String password,BuildContext context);
  Future<void> signOut(BuildContext context);
  bool isUserLogedIn();
  Future<String> addUserInfo(XFile? image,String name);
  Future<void> deleteAccount(BuildContext context);
  // Future<String> otpVerify(String phone,String token,);
}