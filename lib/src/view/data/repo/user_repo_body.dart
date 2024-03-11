import 'dart:developer';
import 'dart:async';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/domain/repo/user_repo_head.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepoBody extends UserRepoHead{
  SupabaseClient supbase = Supabase.instance.client;

  @override
  Stream<UserModel> getUserInfo(){
    String currentUser = supbase.auth.currentUser!.id;
    try{
      return supbase.from('user')
        .stream(primaryKey: ['id'])
        .eq('uid', currentUser)
        .order('timestamp')
        .map((event) => UserModel.fromJson(event[0]));
    }
    on SocketException catch(e){log('in Group Created Metod $e');return const Stream.empty();}
    on PostgrestException catch(e){log('in Group Created Metod $e');return const Stream.empty();}
    on SupabaseRealtimeError catch(e){log('in Group Created Metod $e');return const Stream.empty();}
    on Exception catch(e){log('in Group Created Metod $e');return const Stream.empty();}
    
  }

  @override
  Future<String> updateUserInfo(Map<String,dynamic> data)async{
    final String user = supbase.auth.currentUser!.id;
    try{
      await supbase
        .from('user')
        .update(data)
        .eq('uid', user).then((value) => log('OK Updated'));
      return 'ok';
    }
    on SupabaseRealtimeError catch(e){return e.toString();}
    on PostgrestException catch(e){return e.toString();}
    on SocketException catch(e){return e.toString();}
    on Exception catch(e){return e.toString();}
    catch(e){ log('Error in Update user Info-> $e');return e.toString(); }
  }

  @override
  Future<String> userPicture(XFile file)async{
    final String user = supbase.auth.currentUser!.id;

    try{
      final byte = await file.readAsBytes();
      final fileExt = file.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      await supbase.storage.from('user').uploadBinary(fileName, byte);

      final String getUrl = await supbase.storage.from('user').createSignedUrl(fileName, 60 * 60 * 24 * 365 * 10);

      await supbase.from('user').update({'image':getUrl}).eq('uid', user).then((value) => log('After UPdate Picture'));
      return 'ok';
    }
    on SupabaseRealtimeError catch(e){return e.toString();}
    on PostgrestException catch(e){return e.toString();}
    on SocketException catch(e){return e.toString();}
    on Exception catch(e){return e.toString();}
    catch(e){ log('Error update User Picture -> $e'); return e.toString();}
  }

  @override
  Stream<String?> getUserPicture(){
    String user = supbase.auth.currentUser!.id;
    return supbase.from('user')
        .stream(primaryKey: ['id'])
        .eq('uid',user)
        .order('timestamp')
        .map((event) =>event[0]['image']);
  }

  @override
  Future<UserModel> getUserData()async{
    final String currentUser = supbase.auth.currentUser!.id;
    final res = supbase.from('user')
      .select()
      .eq('uid', currentUser)
      .then((value) => UserModel.fromJson(value[0]));
    log('$res');
    return res;
  }

  @override
  Future<Map<String,UserModel?>> isInApp(String phone)async{
    UserModel? res = await supbase.from('user').select().eq('phone', phone).then((value) { return value.isEmpty ? null : UserModel.fromJson(value[0]);});
    return res != null ? {'ok':res} : {'no':null};
  }

}