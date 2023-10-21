
import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';

class PermissionService{
 
  Future req(List<Permission> permissions)async{
    Map<Permission,PermissionStatus> status =  await permissions.request();
    for(var i in status.values){
      if(i.isGranted){ log('IN Granted');}
      else if(i.isDenied){
        await permissions.request();
        log('In Denied');
      }
      else if(i.isPermanentlyDenied){ 
        log('In OpenSetting');
        openAppSettings(); }
      else{
        log('In Else --> ${status.values} ,, $status');
      }
    }
  }

}