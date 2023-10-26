// Future bottomShet
import 'package:flutter/material.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/constance/lotties.dart';
import 'package:p_4/src/core/common/sizes.dart';

Future errorBottomShetHelper(BuildContext context,String error,void Function() onTap)=> showModalBottomSheet(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  context: context, 
  builder: (context) => Container(
    width: double.infinity,
    decoration:const BoxDecoration(
      color: Colors.white,
      borderRadius:  BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        errorLottie(context),
        Text('Error',style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).primaryColorDark),),
        sizeBoxH(sizeH(context)*0.05),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Center(
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: theme(context).textTheme.titleMedium!.copyWith(),),
          )),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ElevatedButton(
            onPressed:onTap, 
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8, sizeH(context)*0.13),
              backgroundColor: theme(context).primaryColorDark
            ),
            child: Text('ok',style: theme(context).textTheme.titleMedium!.copyWith(color: theme(context).backgroundColor),)),
        ),
    ]),
  ),);
