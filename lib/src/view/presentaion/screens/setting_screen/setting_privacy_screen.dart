import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../config/theme/theme.dart';
import '../../../../core/common/sizes.dart';
import 'lock_screens/lock_setup_screen.dart';

class SettingPrivacyScreen extends StatefulWidget {
  const SettingPrivacyScreen({super.key});

  @override
  State<SettingPrivacyScreen> createState() => _SettingPrivacyScreenState();
}

class _SettingPrivacyScreenState extends State<SettingPrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme(context).backgroundColor,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(sizeH(context)*0.001),
          child: Container(
            height :sizeH(context)*0.001,
            width: sizeW(context),
            color: theme(context).primaryColorDark,
          ),
        ),
        title: Text('Privacy & Security Setting'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontSize: sizeW(context)*0.025,fontFamily: 'header',),),
        leading: IconButton(icon: const Icon(Icons.arrow_back,),onPressed:()=> context.navigationBack(context),),
      ),
      body: Column(
        children: [
          Container(
            width: sizeW(context),
            color: theme(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.021  ,vertical: sizeH(context)*0.05),
                  child: Text('Security'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(color: theme(context).primaryColorDark),),
                ),

                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      minLeadingWidth: sizeW(context)*0.02,
                      leading:  Icon(Icons.lock_outline,color: theme(context).primaryColorDark,),
                      onTap: () => context.navigation(context, const LockScreen()),
                      title: Text('Passcode Lock'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(),),
                  )
                  ],
                  ),
                sizeBoxH(sizeH(context)*0.05)
              ],
            ),
          ),
        
        ],
      ),
    );
  }
}

