

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/data/repo/upload_repo_body.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/message_bubble_widget.dart';

class VoiceTypeWidget extends StatefulWidget {
  final MessageModel data;
  final Alignment alignment;
  final bool isMine;
  const VoiceTypeWidget({
    required this.data,
    required this.alignment,
    required this.isMine,
    Key? key,
  }) : super(key: key);

  @override
  State<VoiceTypeWidget> createState() => _VoiceTypeWidgetState();
}
class _VoiceTypeWidgetState extends State<VoiceTypeWidget> {

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _initPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  FractionallySizedBox(
      widthFactor: 0.7,
      alignment: widget.alignment,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: sizeW(context)*0.02),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BubbleBackground(
              colors: [
                  if (widget.isMine) ...[theme(context).primaryColorDark , theme(context).primaryColorDark.withOpacity(0.5),] 
                  else ...[theme(context).primaryColorDark , theme(context).primaryColorDark.withOpacity(0.5),],
                
              ],
              child: Container(   
                decoration:BoxDecoration(borderRadius: BorderRadius.circular(16),),
                height: sizeH(context)*0.18,
                child: Stack( 
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       isLoading
                        ? smallLoading(context,color: theme(context).scaffoldBackgroundColor)
                        : InkWell(
                            onTap:playPause,
                            child: CircleAvatar(
                              radius: (sizeW(context)*0.035).toDouble(),
                              backgroundColor: theme(context).scaffoldBackgroundColor,
                              child: Icon(icon,color: theme(context).primaryColorDark,),
                            ),
                          ),
                        const SizedBox(width: 4,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: sizeW(context) * 0.22,
                              child:Slider(
                                activeColor: theme(context).scaffoldBackgroundColor,
                                inactiveColor: theme(context).scaffoldBackgroundColor,
                                min: 0,
                                max: duration.inSeconds.toDouble(),
                                value: position.inSeconds.toDouble(), 
                                onChanged: (value) async {
                                  await audioPlayer.seek(Duration(seconds: value.toInt()));
                                  setState(() {});
                                },),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.02),
                              child: Text(duration.toString().substring(2,7),
                                style: theme(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                  fontSize: sizeW(context)*0.013,
                                ),),
                            ),
                          
                          ],
                        ),
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(Icons.check,size: 15,color: Colors.white,)),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  late IconData icon;
  bool isPlaying = false;
  Duration duration = const Duration();
  Duration position = const Duration();
  late AudioPlayer audioPlayer;
  UploadRepoBody repo = UploadRepoBody();


  Future _initPlayer()async{

    audioPlayer.onDurationChanged.listen((event) { setState(() { duration = event; }); });

    audioPlayer.onPositionChanged.listen((event) { setState(() { position = event; }); });

    audioPlayer.onPlayerComplete.listen((event) { 
      setState(()  {
        position = duration;
        icon = Icons.replay;
        isPlaying = false;
        });
    });
    icon = Icons.play_arrow;
  }


  void playPause()async{
    if(isPlaying){
     await audioPlayer.pause();
     icon = Icons.play_arrow;
     isPlaying = false; }
    else{
      setState(()=> isLoading = true);
      String? get = await repo.downloadVoice(widget.data.messsage, widget.data.fileType!,widget.data.uid)
        .then((value) {
          setState(()=>isLoading =  false);
          return value;
        });
      Source urlSource = UrlSource(get!);
      
      icon = Icons.pause;

      await audioPlayer.play(urlSource);
      isPlaying = true;}
    
    setState((){});
  }


}

class VoiceLoadingTypeWidget extends StatefulWidget {
  final MessageModel data;
  final Alignment alignment;
  final bool isMine;
  const VoiceLoadingTypeWidget({
    required this.data,
    required this.alignment,
    required this.isMine,
    Key? key,
  }) : super(key: key);

  @override
  State<VoiceLoadingTypeWidget> createState() => _VoiceLoadingTypeWidgetState();
}
class _VoiceLoadingTypeWidgetState extends State<VoiceLoadingTypeWidget> {

  @override
  Widget build(BuildContext context) {
    return  FractionallySizedBox(
      widthFactor: 0.7,
      alignment: widget.alignment,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: sizeW(context)*0.02),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BubbleBackground(
              colors: [
                if (widget.isMine) ...[theme(context).primaryColorDark , theme(context).primaryColorDark.withOpacity(0.5),] 
                else ...[theme(context).primaryColorDark , theme(context).primaryColorDark.withOpacity(0.5),],
              ],
              child: Container(
                decoration:BoxDecoration(borderRadius: BorderRadius.circular(16)),
                height: sizeH(context)*0.18,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        radius: (sizeW(context)*0.035).toDouble(),
                        backgroundColor: theme(context).scaffoldBackgroundColor,
                        child: SizedBox(
                          width: sizeW(context)*0.055,
                          height: sizeH(context)*0.11,
                          child: CircularProgressIndicator(color: theme(context).primaryColorDark,strokeWidth: 1,)),
                    ),
                    const SizedBox(width: 4,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: sizeW(context) * 0.22,
                          child:Slider(
                            activeColor: theme(context).scaffoldBackgroundColor,
                            inactiveColor: theme(context).scaffoldBackgroundColor,
                            min: 0,
                            max: 0,
                            value: 0, 
                            onChanged: (value) {},),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.02),
                          child: Text('00:00',
                            style: theme(context).textTheme.titleMedium!.copyWith(
                              color: theme(context).scaffoldBackgroundColor,
                              fontSize: sizeW(context)*0.013,
                            ),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


