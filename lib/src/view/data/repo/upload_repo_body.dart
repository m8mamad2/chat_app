
// ignore_for_file: void_checks

import 'dart:developer';
import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'package:p_4/src/core/common/permission_service.dart';
import 'package:path/path.dart' as pathh;
import 'package:p_4/src/view/domain/repo/upload_repo_head.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:video_thumbnail/video_thumbnail.dart';


class UploadRepoBody extends UploadRepoHead{
  final SupabaseClient supabase = Supabase.instance.client;
  PermissionService permission = PermissionService();

  @override
  Future<bool> uploadThings(dynamic thing,String receiverID,String type,String fakeType,String chatRoomId,MessageModel? replyMessage) async {

      String curretnUserID = supabase.auth.currentUser!.id;
      String uid =const Uuid().v1();

    try {

      MessageModel firstModel = MessageModel(
        uid: uid,
        senderID: curretnUserID, 
        receiverID: receiverID, 
        messsage: '', 
        type: fakeType, 
        timestamp: DateFormat.yMMMEd().format(DateTime.now()) , 
        fileType: fakeType, 
        markAsRead: false, 
        isMine: true, 
        chatRoomID: chatRoomId,
        replyMessage: replyMessage
        );
      await supabase.from('chat').insert(firstModel.toMap()).then((value) => print('AFTER CREATE  ---> 1/ and UId is$uid'));
      

      // ! upload to storage
      final bytes = await thing.readAsBytes();
      final fileExt = thing.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await supabase.storage.from('chat').uploadBinary(filePath,bytes,);

      //! get url from Storage
      final String getUrl = await supabase.storage.from('chat').createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);

      //! add to DB
      MessageModel data = MessageModel(
        uid:uid,
        senderID: curretnUserID, 
        receiverID: receiverID, 
        messsage: getUrl, 
        //? type رو دستی میدیم
        type: type, 
        timestamp: DateFormat.yMMMEd().format(DateTime.now()) , 
        fileType: fileExt, 
        markAsRead: false, 
        isMine: true, 
        chatRoomID: chatRoomId,
        replyMessage: replyMessage
        );
      await supabase.from('chat').update(data.toMap()).eq('uid', uid);
      return true;

    } 
    on StorageException catch (error) { await supabase.from('chat').delete().eq('uid', uid); return false;} 
    on PostgrestException catch (error) { await supabase.from('chat').delete().eq('uid', uid); return false;} 
    on Exception catch (error) { await supabase.from('chat').delete().eq('uid', uid); return false;} 
    catch (error) { 
      await supabase.from('chat').delete().eq('uid', uid);
      return false;
      }  
   
  }
  
  @override
  Future<bool> uploadMedia(String receiverId,String chatRoomId,MessageModel? replyMessage) async {
    XFile? media = await ImagePicker().pickMedia();
    String? mime = media?.path.split('.').last;
    String type (){
      if(mime == 'mp4' ||  mime =='x-flv' || mime == 'MP2T' )return 'video';
      else if(mime == 'jpg' || mime == 'png' || mime == 'jpeg') return 'image';
      log(mime ?? 'NUlll');
      return '';
    }
    String dataType = type();
    log(dataType);
    log('fake$dataType');

    if(media != null){
      try{
        await uploadThings(media, receiverId,dataType,'fake$dataType',chatRoomId,replyMessage);
        return true;
      }
      catch(e){ return false; }
    }
    else{ return false;}
  }

  @override
  Future<bool> uploadFile(String receiverId,String chatRoomId,MessageModel? replyMessage) async {
    FilePickerResult? res = await FilePicker.platform.pickFiles();
    if(res != null){
      try{
        io.File file = io.File(res.files.single.path!);
        await uploadThings(file, receiverId, 'file','fakeFile',chatRoomId,replyMessage);
        return true;
      }
      catch(e){ return false; }
    }
    else { return false; }
  }

  @override
  Future<bool> uploadVoice(String receiverId,String path,String chatRoomId,MessageModel? replyMessage) async {
  io.File file = io.File(path);
  try{
    await uploadThings(file, receiverId, 'voice','fakeVoice',chatRoomId,replyMessage);
    return true;
  }
  catch(e){ return false; }
}

  @override
  Future<String?> downlaodFile(String data, String fileType,String fileUid) async { 

    bool isDownloaded = false;
    await permission.req([Permission.storage, Permission.manageExternalStorage]);

    //! path 
    final String path = (await getExternalStorageDirectory())!.path;
    final file = io.File('$path/${fileUid.substring(0,5)}.$fileType');
    List<io.FileSystemEntity> fileDirectory = io.Directory('$path/').listSync();

    //! check if in Files
    for(var onePath in fileDirectory){
      if(onePath.path.contains(file.path)){
        print('-----------> in Donwloaded');
        isDownloaded = true;
        await OpenFile.open(onePath.path);
        return 'ok';
      }
    }
    
    //! not in Files
    if(isDownloaded == false){
      final res = await http.get(Uri.parse(data));
      try{
        if(res.statusCode == 200){
          File data = await file.writeAsBytes(res.bodyBytes);
          await OpenFile.open(data.path);
          return 'ok';
        }
      }
      catch(e){ 
        print('Error -- > $e');
        return res.statusCode.toString();
      }
      // if(response.statusCode == 200){
      //   ! write to file
      //   await file.writeAsBytes(response.bodyBytes);
      //   ! open file
      //   if(await Permission.storage.status.isGranted){
      //     try{
      //       log('in Download');
      //       await OpenFile.open(file.path);
      //       return 'inFile';
      //     }
      //     catch(e){ print("---> Error in Cath ${e.toString()}"); return 'error'; }
      //   }}
      // else { log(response.body); return 'error';}
    }
    
  }
  
  @override
  Future<String?> downloadVoice(String data, String fileType,String fileUid) async {

    bool isDownloaded = false;
    await permission.req([Permission.storage, Permission.manageExternalStorage]);
    

    // ! path
    final String path = (await getExternalStorageDirectory())!.path;
    final file = io.File('$path/${fileUid.substring(0,5)}.$fileType');
    List<io.FileSystemEntity> fileDirectory = io.Directory('$path/').listSync();

    //! check if in Files
    for(var onePath in fileDirectory){
      if(onePath.path.contains(file.path)){
        log('---->>>>>in For');
        isDownloaded = true;
        return onePath.path;
        // return 'inFile';
      }
    }

    if(isDownloaded == false){
      final response = await http.get(Uri.parse(data));
      if(response.statusCode == 200){
        //! write to file
        await file.writeAsBytes(response.bodyBytes);
        //! return String that save in local 
        log('in Downlaoded ...');
        return file.path;
      }
      else { print('--------Error ${response.statusCode}');return null;}
    }
  }
  
  @override
  Future<String?> downloadVideo(String data, String fileType,String fileUid) async {

    bool isDownloaded = false;
    // await [Permission.accessMediaLocation,Permission.storage,Permission.manageExternalStorage,Permission.videos,Permission.mediaLibrary].request().then((value) => log('After Permission'));
    await permission.req([Permission.accessMediaLocation,Permission.storage,Permission.manageExternalStorage,Permission.videos,Permission.mediaLibrary]);
  
    // ! path
    final String path = (await getExternalStorageDirectory())!.path;
    final file = io.File('$path/${fileUid.substring(0,5)}.$fileType');
    List<io.FileSystemEntity> fileDirectory = io.Directory('$path/').listSync();

    //! check if in Files
    for(var onePath in fileDirectory){
      if(onePath.path.contains(file.path)){
        log('---->>>>>in For');
        isDownloaded = true;
        return  onePath.path;
        // return 'inFile';
      }
    }

    if(isDownloaded == false){
      final response = await http.get(Uri.parse(data));
      if(response.statusCode == 200){
        //! write to file
        await file.writeAsBytes(response.bodyBytes);
        //! return String that save in local 
        log('in Downlaoded ...');
        return file.path;
        // return file.path;
      }
      else { print('--------Error ${response.statusCode}');return response.statusCode.toString();}
    }
  }


  Future<String?> imageOfVideo(String url,String fileUid)async{

    try{
      await permission.req([Permission.storage,Permission.manageExternalStorage,Permission.videos,Permission.mediaLibrary]);
      
      bool isDownloaded = false;
      final String mainpath = (await getExternalStorageDirectory())!.path;
      final io.File file = io.File('$mainpath/${fileUid.substring(0,5)}.png');
      List<io.FileSystemEntity> fileDirectory = io.Directory('$mainpath/').listSync();

      //! check if in Files
      for(var onePath in fileDirectory){
        if(onePath.path.contains(file.path)){
          log('---->>>>>in For');
          isDownloaded = true;
          log('In For ---, Video Image');
          return onePath.path;
        }
      }

    if(isDownloaded == false){
      try{

        String? img = await VideoThumbnail.thumbnailFile( video: url, thumbnailPath: mainpath,imageFormat: ImageFormat.PNG,maxWidth: 120,quality: 30);
        String newEndPath = '${fileUid.substring(0,5)}.png';
        String newPath = pathh.join(mainpath,newEndPath);
        io.File f = await io.File(img!).copy(newPath);
        log('In Downloaded ---, Video Image');
        log(f.path);

        return f.path;
      }
      catch(e){log('-------> $e') ;return '';}
      }
    }
    on SupabaseRealtimeError catch(e){return e.toString();}
    on PostgrestException catch(e){return e.toString();}
    on SocketException catch(e){return e.toString();}
    on Exception catch(e){return e.toString();}
    catch(e){return e.toString();}
  }

}



