


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/view/presentaion/widget/setting_widget/settign_webview_widget.dart';
import 'package:url_launcher/url_launcher.dart';


Widget settingOneItem(BuildContext context,String title,IconData icon,String url) {
 return ListTile(
    onTap:()async{
      // final Uri data = Uri.parse(url);
      // if ( await launchUrl(data)) { await launchUrl(data); } 
      // else { throw 'Could not open the map.'; }
      context.navigation(context, WebViewScreenWidget(url: url));
    } ,
    title: Text(title.tr(),style: theme(context).textTheme.titleMedium!.copyWith(),),
    leading: Icon(icon,color:theme(context).primaryColorDark)
);
}
List<String> kSettingTitle = ['FQA','Privacy Policy'];
List<IconData> kSettingIcon = [Icons.question_mark,Icons.policy];
List<String> kSettingUrl = const['https://customers.ai/blog/how-to-make-q-and-a-chatbot','https://customers.ai/blog/how-to-make-q-and-a-chatbot',];


class SettingHelpWidget extends StatelessWidget {
  const SettingHelpWidget({super.key,});

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
              child: Text('Help'.tr().tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'header',color: theme(context).primaryColorDark),),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: kSettingIcon.length,
              padding: EdgeInsets.zero,
              itemBuilder:(context,index)=> settingOneItem(context, kSettingTitle[index], kSettingIcon[index],kSettingUrl[index])),
            sizeBoxH(sizeH(context)*0.05)
          ],
        ),
      ),
    );
  }
}


