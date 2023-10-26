import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../config/theme/theme.dart';
import '../sizes.dart';

final LottieBuilder kUserPersonLottie= LottieBuilder.asset('assets/lottie/user_person.json');

SizedBox kLockLottier(BuildContext context) => SizedBox(
  height: sizeH(context)*0.4,
  child: LottieBuilder.asset(
    'assets/lottie/lock.json',
    delegates: LottieDelegates(
      text: (initialText) => '**$initialText**',
      values: [
        ValueDelegate.colorFilter(['**','Shape Layer 2','**'],value: ColorFilter.mode(theme(context).primaryColorDark, BlendMode.src)),
        ValueDelegate.colorFilter(['**','Shape Layer 6','**'],value: ColorFilter.mode(theme(context).primaryColorDark, BlendMode.src)),
        ValueDelegate.colorFilter(['**','Shape Layer 5','**'],value: ColorFilter.mode(theme(context).primaryColorDark, BlendMode.src)),
        ValueDelegate.colorFilter(['**','Shape Layer 4','**'],value: ColorFilter.mode(theme(context).primaryColorDark, BlendMode.src)),
        ValueDelegate.colorFilter(['**','Artwork 26 Outlines','**'],value: ColorFilter.mode(theme(context).backgroundColor, BlendMode.src)),
        ValueDelegate.colorFilter(['**','Artwork 25 Outlines','**'],value: ColorFilter.mode(theme(context).primaryColorDark, BlendMode.src)),
      ]
    ),
    fit: BoxFit.contain,
    ));

Widget startConversitionLottie(BuildContext context)=> Center(
  child:   Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: sizeW(context)*0.3,
        height: sizeH(context)*0.5,
        child: LottieBuilder.asset(
           'assets/lottie/start_conversition.json',
           fit: BoxFit.fill,
           delegates: LottieDelegates(
            text: (initialText) => '**$initialText**',
            values: [
              ValueDelegate.colorFilter(['**','路径 14442','**'],value: ColorFilter.mode(theme(context).primaryColorDark, BlendMode.src)),
              ValueDelegate.colorFilter(['**','路径 14441','**'],value: ColorFilter.mode(theme(context).primaryColorDark, BlendMode.src)),
              ValueDelegate.colorFilter(['**','椭圆 1320','**'],value: ColorFilter.mode(theme(context).backgroundColor, BlendMode.src)),
              ValueDelegate.colorFilter(['**','减去 16','**'],value: ColorFilter.mode(theme(context).primaryColorDark, BlendMode.src)),
              ValueDelegate.colorFilter(['**','路径 14443','**'],value: ColorFilter.mode(theme(context).cardColor, BlendMode.src)),
              ValueDelegate.colorFilter(['**','矩形 4626','**'],value: ColorFilter.mode(theme(context).cardColor, BlendMode.src)),
              ValueDelegate.colorFilter(['**','椭圆 1322','**'],value: ColorFilter.mode(theme(context).cardColor, BlendMode.src)),
              ValueDelegate.colorFilter(['**','椭圆 1321','**'],value: ColorFilter.mode(theme(context).cardColor, BlendMode.src)),
            ]
           ),
           ),
      ),
       Text('Start Conversition Right Now!'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'header'),)
    ],
  ),
);

Widget errorLottie(BuildContext context)=> Center(
  child: SizedBox(
    height: sizeH(context)*0.5,
    child: LottieBuilder.asset(
       'assets/lottie/error.json',
       fit: BoxFit.fill,
       delegates: LottieDelegates(
        text: (initialText) => '**$initialText**',
        values: [
          ValueDelegate.colorFilter(['**','exclamation','**'],value: ColorFilter.mode(theme(context).backgroundColor, BlendMode.src)),
          ValueDelegate.colorFilter(['**','stroke circle','**'],value: ColorFilter.mode(theme(context).primaryColorDark, BlendMode.src)),
          ValueDelegate.colorFilter(['**','stroke circle 2','**'],value: ColorFilter.mode(theme(context).backgroundColor, BlendMode.src)),
          ValueDelegate.colorFilter(['**','circle','**'],value: ColorFilter.mode(theme(context).primaryColorDark, BlendMode.src)),
        ]
       ),
       ),
  ),
);

Widget logoLottie(BuildContext context)=> SizedBox(
  child: LottieBuilder.asset(
    'assets/image/logo/lottie_with_out_animation.json',
    fit: BoxFit.cover,
    delegates: LottieDelegates(
        text: (initialText) => '**$initialText**',
        values: [
          ValueDelegate.colorFilter(['**','first','**'],value: ColorFilter.mode(theme(context).cardColor, BlendMode.src)),
          ValueDelegate.colorFilter(['**','bg','**'],value: ColorFilter.mode(theme(context).backgroundColor, BlendMode.src)),
          ValueDelegate.colorFilter(['**','second','**'],value: ColorFilter.mode(theme(context).primaryColorDark, BlendMode.src)),
        ]
       ),  ),
);