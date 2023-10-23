// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';


class CallingRepoBody{

  String token ='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiJkMDU0ZWJkMi03NzJmLTRmYjktODNkMC1kMzg1YjhkMjhiYmQiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY5MzIzMzEwNCwiZXhwIjoxNzI0NzY5MTA0fQ.m3H-Ue6BPDX8edNjzm-zB-E6KiXYfZofFd7guxRzsuA';
  final SupabaseClient supabase = Supabase.instance.client;

  //! get token for create room
  Future<String> createRoom()async{
    final http.Response response = await http.post(
      Uri.parse("https://api.videosdk.live/v2/rooms"),
      headers: {'Authorization':token}
    );
    print('---> ${json.decode(response.body)['roomId']}');
    return json.decode(response.body)['roomId'];
  }

  Future<void> inviteToCall(String receiverID,String callRoomId,String chatRoomID)async{
    final String currentUserId = supabase.auth.currentUser!.id;
    MessageModel model = MessageModel(
      senderID: currentUserId, 
      receiverID: receiverID, 
      messsage: callRoomId, 
      type: 'videoCall', 
      timestamp: DateFormat.yMMMEd().format(DateTime.now()), 
      fileType: 'videoCall', 
      markAsRead: false, 
      isMine: true, 
      chatRoomID: chatRoomID, 
      replyMessage: null,
      uid: const Uuid().v1());

    try{
    
    await supabase.from('chat').insert(model.toMap()) .then((value) => print("SUCCESS")) .catchError((e)=>print('FAIL'));
    

    }
    catch(e){ print('------------Error $e'); }

  }

  Future<void> endCall(String receiverID,String callRoomId,String chatRoomID,String uid)async{
   
    final String currentUserId = supabase.auth.currentUser!.id;
    MessageModel model = MessageModel(
      senderID: currentUserId, 
      receiverID: receiverID, 
      messsage: callRoomId, 
      type: 'videoCallEnded', 
      timestamp: DateFormat.yMMMEd().format(DateTime.now()), 
      fileType: 'videoCallEnded', 
      markAsRead: false, 
      isMine: true, 
      chatRoomID: chatRoomID, 
      replyMessage: null,
      uid: const Uuid().v1()); 

    await supabase.from('chat').update(model.toMap()).eq('uid', uid).then((value) => print('UPDATED')).catchError((e)=>print('FAILED'));

  }
} 



//! play rington
// class MyWidget extends StatefulWidget {
//   const MyWidget({super.key});
//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }
// class _MyWidgetState extends State<MyWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           Center(
//             child:ElevatedButton(
//               onPressed: ()async{
//                 // FlutterRingtonePlayer.playRingtone();
//                   // android: AndroidSounds.notification,
//                   // ios: IosSounds.glass,
//                   // looping: true,volume: 0.1,asAlarm: false
//                 // ).then((value) => log('RingTon STARTD'));
//                 // shakeDetector.startListening();
//               },
//               child: Text('Play'),
//             ) ,),
//           Center(
//             child:ElevatedButton(
//               onPressed: ()async{
//                 // await FlutterRingtonePlayer.stop();
//               },
//               child: Text('End'),
//             ) ,)
//         ],
//       ),
//     );
//   }
// }
