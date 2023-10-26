import 'package:flutter/material.dart';
import 'package:p_4/src/config/theme/theme.dart';

import '../../../../core/common/sizes.dart';

Widget authElevatedButton(BuildContext context,String text,VoidCallback onPress)=> 
  ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(sizeW(context)*0.33, sizeH(context)*0.13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sizeW(context)*0.1)
        ),
        backgroundColor: theme(context).primaryColorDark
      ), 
      child:  Text(text,style: theme(context).textTheme.titleMedium!.copyWith(color: theme(context).backgroundColor),),
      );
