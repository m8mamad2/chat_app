import 'package:flutter/material.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/presentaion/widget/chat_widget/location_show.dart';

import '../../../../../core/common/sizes.dart';

class LocationTypeWidget extends StatelessWidget {
  final MessageModel data;
  final Alignment alignment;
  const LocationTypeWidget({super.key,required this.alignment,required this.data});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: UnconstrainedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: sizeW(context)*0.02),
          child: GestureDetector(
            onTap: ()=> context.navigation(context, LocationShowWidget(data: data,)),
            child: Container(
              height: sizeH(context)*0.8,
              width: sizeW(context)*0.3,
              decoration: BoxDecoration(
                color: theme(context).primaryColorDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 2
                )
              ),
              child: Icon(Icons.location_on_outlined,size:sizeW(context)*0.07 ,color: theme(context).backgroundColor,)
            ),
          ),
        ),
      ),
    );
  }
}