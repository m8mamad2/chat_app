import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/presentaion/blocs/setting_blocs/font_size_bloc.dart';
import 'dart:ui' as ui;

import '../../../../../config/theme/notification/notification_service.dart';
import '../message_bubble_widget.dart';

class MessageTypeWidget extends StatefulWidget {
  final Alignment aligment;
  final MessageModel data;
  final bool isMine;
  const MessageTypeWidget({super.key,required this.aligment,required this.data,required this.isMine,});

  @override
  State<MessageTypeWidget> createState() => _MessageTypeWidgetState();
}

class _MessageTypeWidgetState extends State<MessageTypeWidget> {
  LocalNotificationService notification = LocalNotificationService();
  @override
  void initState() {
    super.initState();
    context.read<FontSizeBloc>().add(GetFontSizeEvent());
    context.read<BorderRadiusBloc>().add(GetBorderRadiusEvent());
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // log('in Did Change');
    // if(widget.isMine) notif('Message', widget.data.messsage, widget.data.senderID);
  // notif(String title,String body,String channel)async => await notification.addNotification(title, body, channel);
  }


  @override
  Widget build(BuildContext context) {
    final bool isReply = widget.data.replyMessage != null;
    return FractionallySizedBox(
      alignment: widget.aligment,
      widthFactor: 0.6,
      child: Align(
        alignment: widget.aligment,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
          child: BlocBuilder<BorderRadiusBloc,BorderRadiusState>(
            builder:(context, state) {
              if(state is LoadedBorderRadiusState){
               return ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(state.borderRadius)),
                  child: BubbleBackground(
                      colors: [
                        if (widget.isMine) ...[theme(context).primaryColorDark , theme(context).primaryColorDark.withOpacity(0.5),] 
                        else ...[theme(context).primaryColorDark , theme(context).primaryColorDark.withOpacity(0.5),],
                      ],
                      child: BlocBuilder<FontSizeBloc,FontSizeState>(
                        builder: (context, state) {
                          if(state is LoadedFontSizeState){
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Stack(
                                alignment:widget.isMine ? Alignment.bottomRight : Alignment.bottomLeft,
                                children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    isReply 
                                      ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(widget.data.replyMessage!.messsage,style: theme(context).textTheme.bodySmall!.copyWith(
                                          fontSize: sizeW(context)*0.015,
                                        ),),
                                      ),
                                    )
                                      : const SizedBox.shrink(),
                                    Padding(
                                      padding:widget.isMine ? const EdgeInsets.only(right: 10) : const EdgeInsets.only(left: 10),
                                      child: Text(widget.data.messsage,style: theme(context).textTheme.titleSmall!.copyWith(
                                        fontSize: state.fontSize,
                                        color: theme(context).scaffoldBackgroundColor
                                      ),),
                                    ),
                                  ],
                                ),
                                Icon(Icons.check,size: 10,color: theme(context).scaffoldBackgroundColor,)  
                                ]),
                            );
                          }
                          return Container(width: 100,height: 100,color: Colors.amber,);
                        },
                      ),
                    ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}



