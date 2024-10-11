import 'dart:developer';
import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/constance/images.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/data/repo/upload_repo_body.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../core/common/sizes.dart';
import '../../../../../core/widget/loading.dart';

class VideoTypeWidget extends StatefulWidget {
  final MessageModel data;
  final Alignment alignment;
  const VideoTypeWidget({super.key,required this.data,required this.alignment});

  @override
  State<VideoTypeWidget> createState() => VideoTypeWidgetState();
}
class VideoTypeWidgetState extends State<VideoTypeWidget> {

  bool isLoading = false;
  UploadRepoBody repo = UploadRepoBody();

  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: UnconstrainedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 20.0),
          child: Container(
            height: sizeH(context)*0.8,
            width: sizeW(context)*0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme(context).primaryColorDark,
                width: 1
              )
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FutureBuilder(
                future: repo.imageOfVideo(widget.data.messsage,widget.data.uid),
                builder:(context, snapshot) {
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    // case ConnectionState.waitisng: return loading(context);
                    default:
                      if(snapshot.data == null) return loading(context);
                      final pathOfVideo = snapshot.data;
                      return Container(
                        padding: EdgeInsets.all(sizeW(context)*0.105),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(pathOfVideo ?? '',)),
                            onError: (exception, stackTrace) => AssetImage(kLogoImage),
                          )
                        ),
                        child: isLoading 
                        ? smallLoading(context,color: theme(context).scaffoldBackgroundColor)
                        : CircleAvatar(
                          backgroundColor: Colors.black87,
                          child: IconButton(
                            onPressed: ()=> download(),
                            icon: Icon(Icons.play_arrow,color: theme(context).scaffoldBackgroundColor,),
                          ),
                        ),
                      );
                  }
                }, 
              )
            )
          )
        )
      )
    );
  }
  download()async{
    setState(() => isLoading = true);
    await 
    await repo.downloadVideo(widget.data.messsage, widget.data.fileType!, widget.data.uid)
        .then((value) {
          setState(()=> isLoading = false);
          context.navigation(context, VideoPlayerWidget(path: value));});
    // ignore: use_build_context_synchronously
  }
  
}

class VideoLoadingTypeWidget extends StatelessWidget {
  final Alignment alignment;
  const VideoLoadingTypeWidget({super.key,required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: UnconstrainedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: sizeW(context)*0.02),
          child: Container(
            height: sizeH(context)*0.8,
            width: sizeW(context)*0.3,
            decoration: BoxDecoration(
              color: theme(context).primaryColorDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme(context).scaffoldBackgroundColor,
                width: 2
              )
            ),
            child: smallLoading(context,color: theme(context).scaffoldBackgroundColor)
          ),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String? path;
  const VideoPlayerWidget({super.key,required this.path});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}
class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {

  late VideoPlayerController videoPlayerController;
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(File(widget.path!))..initialize().then((value) => setState((){}));
    flickManager = FlickManager(videoPlayerController: videoPlayerController);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlickVideoPlayer(flickManager: flickManager,),
    );
  }
}