import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/presentaion/blocs/upload_bloc/upload_bloc.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/message_bubble_widget.dart';

class FileTypeWidget extends StatefulWidget {
  final Alignment alignment;
  final MessageModel data;
  final bool isMine;
  const FileTypeWidget({super.key,required this.data,required this.alignment,required this.isMine});

  @override
  State<FileTypeWidget> createState() => _FileTypeWidgetState();
}
class _FileTypeWidgetState extends State<FileTypeWidget> {
  
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: widget.alignment,
      widthFactor: 0.7,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: sizeW(context)*0.02),
        child: GestureDetector(
            onTap: ()async {    
              context.read<UploadBloc>().add(DownloadFileEvent(widget.data.messsage,widget.data.fileType!,widget.data.uid));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BubbleBackground(
                colors: [
                    // if (widget.isMine) ...const [Color(0xFF6C7689),Color(0xFF3A364B),] 
                    // else ...const [Color(0xFF19B7FF),Color(0xFF491CCB),],
                    if (widget.isMine) ...[theme(context).primaryColorDark , theme(context).primaryColorDark.withOpacity(0.5),] 
                    else ... [theme(context).primaryColorDark , theme(context).primaryColorDark.withOpacity(0.5),],
                ],
                child: SizedBox(
                  height: sizeH(context)*0.18,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment:widget.isMine ?  MainAxisAlignment.start:MainAxisAlignment.end,
                        children: [
                          sizeBoxW(4),
                          CircleAvatar(
                            radius: (sizeW(context)*0.035).toDouble(),
                            backgroundColor: theme(context).backgroundColor,
                            child: Icon(Icons.file_copy,color: theme(context).primaryColorDark),
                            ),
                          sizeBoxW(sizeW(context)*0.01),
                          BlocBuilder<UploadBloc,UploadState>(
                            builder: (context, state) {
                              if(state is UploadInitialState)return const Text('initial File');
                              if(state is UploadLoadingState)return const Text('Loading');
                              if(state is UploadSuccessState){
                              return StreamBuilder(
                                stream: state.downlaodFile!.asBroadcastStream(),
                                builder: (context, snapshot) {
                                  switch(snapshot.connectionState){
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:return loading(context);
                                    default:
                                      return snapshot.data == null 
                                        ? const Text('File')
                                        : const Text('File');
                                  }
                                },);
                              }
                              if(state is UploadFailState)return const Text('Fail');
                              return const Text('File');
                            },
                          )
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
}

class FileLoaingTypeWidget extends StatelessWidget {
  final Alignment alignment;
  final MessageModel data;
  final bool isMine;
  const FileLoaingTypeWidget({super.key,required this.data,required this.alignment,required this.isMine});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: alignment,
      widthFactor: 0.7,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: sizeW(context)*0.02),
        child: SizedBox(
          height: sizeH(context)*0.18,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BubbleBackground(
              colors: [
                if (isMine) ...[theme(context).primaryColorDark , theme(context).primaryColorDark.withOpacity(0.5),] 
                else ...const [Color(0xFF19B7FF),Color(0xFF491CCB),],
              ],
              child:Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment:isMine ?  MainAxisAlignment.start:MainAxisAlignment.end,
                    children: [
                      sizeBoxW(4),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: sizeH(context)*0.16,
                            width: sizeW(context)*0.078,
                            child:  CircularProgressIndicator(strokeWidth: 1,color: theme(context).backgroundColor,)),
                          CircleAvatar(
                            radius: (sizeW(context)*0.035).toDouble(),
                            backgroundColor: const Color(0xff1b2028),
                            child: Icon(Icons.file_copy,color: theme(context).backgroundColor),
                            ),
                        ],
                      ),
                      sizeBoxW(sizeW(context)*0.01),
                      const Text('File',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            height: sizeH(context)*0.02,
                            width: sizeW(context)*0.01,
                            child:  CircularProgressIndicator(
                              strokeWidth: 1,
                              color: theme(context).backgroundColor,),
                          )),
                      )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
