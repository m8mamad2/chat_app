
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/core/common/bottom_shet_helper.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/domain/repo/helper/user_helper_repo_head.dart';
import 'package:p_4/src/view/domain/repo/user_repo_head.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/user_bloc/user_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/theme.dart';

class UserHelperRepoBody extends UserHelperRepoHeader{
  
  final UserRepoHead repo;
  UserHelperRepoBody(this.repo);
    
  @override
  Future<UserModel> getUserData() async => await repo.getUserData();

  @override
  Stream<UserModel> getUserInfo() => repo.getUserInfo();

  @override
  Stream<String?> getUserPicture() => repo.getUserPicture();

  @override
  Future<void> updateUserInfo(BuildContext context,Map<String, dynamic> data) async {
    await repo.updateUserInfo(data)
      .then((value)async{
        if(value == 'ok'){ 
          context.navigationBack(context); 
          context.navigationBack(context); 
          context.read<GetUserData>().add(GetUserDataEvent());
          }
        else { await errorBottomShetHelper(context, value,(){context.navigationBack(context);}); }
      } );
  }

  @override
  Future userPicture(BuildContext context,XFile file) async{
    await repo.userPicture(file)
      .then((value)async{
        if(value == 'ok'){ 
          context.navigationBack(context); 
          context.navigationBack(context); 
          context.navigationBack(context); 
          context.read<GetUserData>().add(GetUserDataEvent());
        }
        else { await errorBottomShetHelper(context, value,(){context.navigationBack(context);}); }
      } );
  }

  @override
  Future<void> isInApp(BuildContext context,String phone,TextEditingController addMemberController)async{
    await repo.isInApp(phone)
      .then((value) async {
        if(value.keys.first == 'ok') {
          UserModel res = value.values.first!;
          Contact contact = Contact(displayName: res.name,givenName: res.name,phones: [Item(label: 'Mobile',value: res.phone)],);
          await ContactsService.addContact(contact);
          context.read<AllUserBloc>().add(GetAllUserEvent(context));
          context.navigationBack(context);
        }
        else {
          await showDialog(
            context: context, 
            builder:(context) => AlertDialog(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text('Invited to Radical'.tr(),style:theme(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                     Padding(
                      padding:const EdgeInsets.only(bottom: 10),
                      child: Text('is not on Radical yet, whould your like to invite them to join?'.tr())),
                    Row(
                      children: [
                        TextButton(
                          onPressed: ()=>context.navigationBack(context), 
                          child:Text('Cancel'.tr())),
                        TextButton(
                          onPressed: ()async{
                            final Uri smsModel = Uri(
                              scheme: 'sms',
                              path: addMemberController.text.trim(),
                              queryParameters:<String,String>{'body':'Come on Bro! come to Radical'} );
                            if(!await launchUrl(smsModel))log('I Cant Do This');
                          }, 
                          child: Text('Invited'.tr())),
                      ],
                    )
                  ],
                ),
              ),
            ));
            }
        addMemberController.clear();
      });
  }

} 