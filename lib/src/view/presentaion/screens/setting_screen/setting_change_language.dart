import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';

class SettingChangeLanguage extends StatefulWidget {
  const SettingChangeLanguage({super.key});

  @override
  State<SettingChangeLanguage> createState() => _SettingChangeLanguageState();
}

class _SettingChangeLanguageState extends State<SettingChangeLanguage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0.0),
                    child: Container(
                      color: theme(context).primaryColorDark,
                      height: sizeH(context)*0.001,
                    ),
                  ),
        title: Text('Change Language'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontSize: sizeW(context)*0.025,fontFamily: 'header',),),
        backgroundColor: theme(context).backgroundColor, 
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back),onPressed: () => context.navigationBack(context),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.021  ,vertical: sizeH(context)*0.05),
            child: Text('Languages',style: theme(context).textTheme.titleMedium!.copyWith(color: theme(context).primaryColorDark),),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              oneItam('Persian'.tr(), context, 'fa', 'IR',),
              oneItam('English'.tr(), context, 'en', 'US',)
            ],
            )
        ],
      ),
    );
  }
   Widget oneItam(String title, BuildContext context, String languageCode, String counrtyCode,) {
    bool isActive =  context.locale.toString().contains('${languageCode}_$counrtyCode') ? true : false ;
    return ListTile(
      onTap: () { context.setLocale(Locale(languageCode,counrtyCode)); setState((){});},
      trailing: isActive ? Icon(Icons.check,color: theme(context).primaryColorDark,) : null,
      title: Text(title,style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'body'),),
    );
   }
}
