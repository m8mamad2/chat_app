


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/view/presentaion/screens/setting_screen/setting_change_language.dart';
import 'package:p_4/src/view/presentaion/screens/setting_screen/setting_chat_screen.dart';
import 'package:p_4/src/view/presentaion/screens/setting_screen/setting_privacy_screen.dart';


Widget settingOneItem(BuildContext context,String title,IconData icon,Widget widget) {
 return ListTile(
    onTap:()=> context.navigation(context, widget) ,
    title: Text(title.tr(),style: theme(context).textTheme.titleMedium!.copyWith(),),
    leading: Icon(icon,color:theme(context).primaryColorDark)
);
}
List<String> kSettingTitle = ['Chat Setting','Privacy Security'.tr(),'Language'.tr()];
List<IconData> kSettingIcon = [Icons.chat_sharp,Icons.privacy_tip,Icons.language];
List kSettingOnTap = const[
  SettingChatSetting(),
  SettingPrivacyScreen(),
  SettingChangeLanguage(),
];



class SettingImtesWidget extends StatelessWidget {
  const SettingImtesWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: sizeW(context),
        color: theme(context).backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: sizeW(context),
              height: sizeH(context)*0.003,
              color: theme(context).primaryColorDark,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.023,vertical: sizeH(context)*0.05),
              child: Text('Setting'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'header',color: theme(context).primaryColorDark),),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: kSettingIcon.length,
              padding: EdgeInsets.zero,
              itemBuilder:(context,index)=> settingOneItem(context, kSettingTitle[index], kSettingIcon[index],kSettingOnTap[index])),
            sizeBoxH(sizeH(context)*0.05)
          ],
        ),
      ),
    );
  }
}


