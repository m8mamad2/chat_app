import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:p_4/src/config/theme/theme.dart';

// Widget loading()=> Center(child: LoadingAnimationWidget.beat(color: Colors.white, size: 30));

Widget loading(BuildContext contex)=> Center(
  child: LottieBuilder.asset(
    'assets/lottie/first.json',
    delegates:LottieDelegates(
      text: (initialText) => '**$initialText**',
      values: [
        ValueDelegate.color(['Index_finger','**'], value: theme(contex).primaryColorDark),
        ValueDelegate.color(['Middle_finger','**'],value: theme(contex).primaryColorDark),
        ValueDelegate.color(['Ring_finger','**'],  value: theme(contex).primaryColorDark),
        ValueDelegate.color(['little_finger','**'],value: theme(contex).primaryColorDark),
        ValueDelegate.color(['Hand/Thump','**'],   value: theme(contex).primaryColorDark),
      ]
    ),
  )
);

Widget smallLoading(BuildContext context,{Color? color}) => Center(
  child: CircularProgressIndicator(color: color ?? theme(context).primaryColorDark,)
  // LottieBuilder.asset(
  //   'assets/lottie/small_animation.json',
  //   delegates:LottieDelegates(
  //     text: (initialText) {
  //       log(initialText);
  //       return '**$initialText**';
  //     },
  //     values: [
  //     ]
  //   ),
  //   ),
  
);



class MMMMMMMM extends StatefulWidget {
  const MMMMMMMM({super.key});

  @override
  State<MMMMMMMM> createState() => _MMMMMMMMState();
}

class _MMMMMMMMState extends State<MMMMMMMM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: smallLoading(context),
      ),
    );
  }
}