// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:p_4/src/core/common/sizes.dart';
// import 'package:videosdk/videosdk.dart';

// class VideoCallScreen extends StatefulWidget {
//   final String roomId;
//   final String token;
//   const VideoCallScreen({super.key,required this.roomId,required this.token});

//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }

// class _VideoCallScreenState extends State<VideoCallScreen> {
//   Map<String, Stream?> participantVideoStreams = {};

//   bool micEnabled = true;
//   bool cameraEnabled = true;
//   late Room room;

//   void setParticipantStreamEvents(Participant participant) {
   
//     participant.on(Events.streamEnabled, (Stream stream) {
//       if (stream.kind == 'video') setState(() => participantVideoStreams[participant.id] = stream);
//     });

//     participant.on(Events.streamDisabled, (Stream stream) {
//       if (stream.kind == 'video') setState(() => participantVideoStreams.remove(participant.id));
//     });
//   }

//   void setRoomEventListener(Room room) {
//     setParticipantStreamEvents(room.localParticipant);

//     room.on(Events.participantJoined,(Participant participant) => setParticipantStreamEvents(participant),);
    
//     room.on(Events.participantLeft, (String participantId) {
//       if (participantVideoStreams.containsKey(participantId)) {
//         setState(() => participantVideoStreams.remove(participantId));
//       }
//     });
//     room.on(Events.roomLeft, () {
//       participantVideoStreams.clear();
//       // widget.leaveRoom(); //! navigate back
//     });
//   }
  
//    @override
//   void initState() {
//     super.initState();
    
//     room = VideoSDK.createRoom(
//       roomId: widget.roomId,
//       token: widget.token,
//       displayName: "Yash Chudasama",
//       micEnabled: micEnabled,
//       camEnabled: cameraEnabled,
//       maxResolution: 'hd',
//       defaultCameraIndex: 1,
//       notification: const NotificationInfo(
//         title: "Video SDK",
//         message: "Video SDK is sharing screen in the room",
//         icon: "notification_share", // drawable icon name
//       ),
//     );

//     setRoomEventListener(room);

//     room.join();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           ...participantVideoStreams.values.map((e) => SizedBox(
//             width: sizeW(context),
//             height: sizeH(context) * 1,
//             child: RTCVideoView(
//               e!.renderer!,
//               objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
//             ),
//           ),).toList(),
//           Text("Room ID: ${widget.roomId}"),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                 onPressed: leave,
//                 child: const Text("Leave"),
//               ),
//               ElevatedButton(
//                 onPressed: toggleMic,
//                 child: const Text("Toggle Mic"),
//               ),
//               ElevatedButton(
//                 onPressed: toggleCamera,
//                 child: const Text("Toggle Camera"),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//   toggleMic () {
//     micEnabled ? room.muteMic() : room.unmuteMic();
//     micEnabled = !micEnabled;
//   }
//   toggleCamera () {
//     cameraEnabled
//         ? room.disableCam()
//         : room.enableCam();
//     cameraEnabled = !cameraEnabled;
//   }
//   leave () => room.leave();
        
// }

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:videosdk/videosdk.dart';

import '../../../data/repo/calling_repo_body.dart';

class VideoCallScreen extends StatefulWidget {
  final String roomId;
  final String token;
  const VideoCallScreen({super.key,required this.roomId,required this.token});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  Map<String, Stream?> participantVideoStreams = {};
  bool micEnabled = true;
  bool cameraEnabled = true;
  late Room room;
  bool isLoading = true;

  void setParticipantStreamEvents(Participant participant) {
   
    participant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == 'video') setState(() => participantVideoStreams[participant.id] = stream);
    });

    participant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == 'video') setState(() => participantVideoStreams.remove(participant.id));
    });}

  void setRoomEventListener(Room room) {
    setParticipantStreamEvents(room.localParticipant);

    room.on(Events.participantJoined,(Participant participant) => setParticipantStreamEvents(participant),);
    
    room.on(Events.participantLeft, (String participantId) {
      if (participantVideoStreams.containsKey(participantId)) {
        setState(() => participantVideoStreams.remove(participantId));
      }
    });
    room.on(Events.roomLeft, () {
      participantVideoStreams.clear();
      // widget.leaveRoom(); //! navigate back
    });
    
    }
  
  @override
  void initState() {
    super.initState();
    
    room = VideoSDK.createRoom(
      roomId: widget.roomId,
      token: widget.token,
      displayName: "Yash Chudasama",
      micEnabled: micEnabled,
      camEnabled: cameraEnabled,
      maxResolution: 'hd',
      defaultCameraIndex: 1,
      notification: const NotificationInfo(
        title: "Video SDK",
        message: "Video SDK is sharing screen in the room",
        icon: "notification_share", // drawable icon name
      ),
    );

    setRoomEventListener(room);

    room.join();
  }

  @override
  void dispose() {
    super.dispose();
    room.end();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        leave();
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          body:Stack(
              children: [
                ...participantVideoStreams.values.map((e) => 
                  SizedBox(
                  width: sizeW(context),
                  height: sizeH(context) * 1,
                  child: RTCVideoView(
                    e!.renderer!,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                ),).toList(),
                
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: sizeH(context)*0.08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        button(toggleCamera, Icons.camera,false),
                        button(leave, Icons.call_end,true),
                        button(toggleMic, Icons.mic_off_outlined,false),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }

  void toggleMic () {
    micEnabled ? room.muteMic() : room.unmuteMic();
    micEnabled = !micEnabled;
  }
  void toggleCamera () {
    cameraEnabled
        ? room.disableCam()
        : room.enableCam();
    cameraEnabled = !cameraEnabled;
  }
  Future leave () async{
    room.leave();
    context.navigationBack(context);
    // await repo.endCall(receiverID, callRoomId, chatRoomID, uid)
  }
  CallingRepoBody repo = CallingRepoBody();

  Widget show(Stream e)=> Positioned.fill( child: RTCVideoView(e.renderer!,objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,));
  Widget button(VoidCallback onPress,IconData icon,bool isEndCall) => FloatingActionButton(
    heroTag: '$icon',
    onPressed: onPress,
    backgroundColor:isEndCall ? Colors.red : Colors.grey.shade200 ,
    child: Icon(icon , color: isEndCall ? Colors.white : Colors.black54,),
    );
}