import 'package:flutter/material.dart';
import 'package:p_4/src/core/common/constance/lotties.dart';
import 'package:p_4/src/core/common/sizes.dart';

import '../../config/theme/theme.dart';

Widget FailBlocWidget(String? e)=> Center(child: Text(e.toString()),);
class ErrorBlocWidget extends StatefulWidget {
  const ErrorBlocWidget({super.key});

  @override
  State<ErrorBlocWidget> createState() => _ErrorBlocWidgetState();
}

class _ErrorBlocWidgetState extends State<ErrorBlocWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme(context).scaffoldBackgroundColor,
      appBar: AppBar( 
        backgroundColor: theme(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: null,
        leading: null),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          sizeBoxH(sizeH(context)*0.1),
          SizedBox(
            width: sizeW(context)*0.9,
            child:errorLottie(context),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.05,vertical: sizeH(context)*0.02),
            child: Text('there is a problem. Some of the reasons and solutions are:',
              style: theme(context).textTheme.titleSmall!
              .copyWith(
                color: theme(context).focusColor,
                fontWeight: FontWeight.w800,
                fontSize: sizeW(context)*0.044
            ),),
          ),
          sizeBoxH(sizeH(context)*0.04),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) => oneItem(kErrorBloc[index]),)
        ],
      ),
    );
  }
  Widget oneItem(String text)=> Padding(
    padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.05,vertical: sizeH(context)*0.01),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: theme(context).focusColor,
          radius: sizeW(context)*0.01,),
        sizeBoxW(sizeW(context)*0.01),
        Text(text,
          style: theme(context).textTheme.titleSmall!.copyWith(
            fontSize: sizeW(context)*0.035,
            color: theme(context).focusColor.withOpacity(0.5)
          ),)
      ],
    ),
  );
}

List<String> kErrorBloc = [
  'check your connection to Internet',
  'close the app and open it again',
  'The problem could be from the server side',
  'please try again later'
];