// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/common/bottom_shet_helper.dart';
import '../../../core/widget/auth_check.dart';
import '../../domain/repo/auth_repo_head.dart';
import '../../presentaion/screens/auth_screen/auth_info_screen.dart';


class AuthRepoBody extends AuthRepoHeader{

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<String> login(String email,String password)async{
    try{
      await supabase.auth.signInWithPassword(email: email,password: password);
      return 'ok';
    }

    catch (e){ print(e.toString()); return e.toString(); }

  }

  @override
  Future<String> signUp(String email,String phone,String password,BuildContext context)async{
    try{
      final respone =await supabase.auth.signUp(email: email,password: password)
        .then((value) async => await supabase.auth.signInWithPassword(email: email,password: password) );
      
      log('----- IN REPO $respone');
      log('------------------------------>>>>>>${respone.user!.id}');

      await supabase.from('user').insert({
        'uid':respone.user!.id,
        'phone':phone,
        'email':respone.user!.email}).then((value) => context.navigation(context,const AuthInfoScreen()));

      return 'ok';
    }
    
    on PostgrestException catch(e){await errorBottomShetHelper(context, e.toString(), () {context.navigationBack(context); }); log(e.toString()); return e.toString();}
    catch(e){await errorBottomShetHelper(context, e.toString(), () {context.navigationBack(context); }); log(e.toString());return e.toString(); }
  }

  @override
  Future<void> signOut(BuildContext context)async{
    try{
    await supabase.auth.signOut();
     // ignore: use_build_context_synchronously
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthCheckWidget(),));
    }
    on Exception catch(e){await errorBottomShetHelper(context, e.toString(), () {context.navigationBack(context); });}
    catch(e){await errorBottomShetHelper(context, e.toString(), () {context.navigationBack(context); });}
  }
  
  @override
  bool isUserLogedIn(){
    final session =  supabase.auth.currentSession;
    final currentUser = supabase.auth.currentUser?.id;
    if(session != null && currentUser != null) return true;
    else return false;
  }

  @override
  Future<String> addUserInfo(XFile? image,String name)async{
    final String currentUser = supabase.auth.currentUser!.id;
    String? notNullImage;
    try{

      if(image != null){
        final byte = await image.readAsBytes();
        final fileExt = image.path.split('.').last;
        final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
        await supabase.storage.from('user').uploadBinary(fileName, byte);
        final String getUrl = await supabase.storage.from('user').createSignedUrl(fileName, 60 * 60 * 24 * 365 * 10);
        notNullImage = getUrl;}

      await supabase.from('user').update( {'image':notNullImage,'name':name }).eq('uid', currentUser).then((value)=> log('Afther Info S----'));
      return 'ok';
    }
    catch(e){log('$e====> After Info');return e.toString();}
  }
}