
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/presentaion/blocs/user_bloc/user_bloc.dart';
import 'package:p_4/src/view/presentaion/screens/contacts_screen.dart';
import 'package:p_4/src/view/presentaion/screens/create_group_screen.dart';
import 'package:p_4/src/view/presentaion/screens/setting_screen.dart';
import 'package:p_4/src/view/presentaion/screens/setting_screen/setting_chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/theme.dart';
import '../../../../core/common/constance/lotties.dart';
import '../../../../core/widget/cache_image.dart';
import '../../screens/save_message.dart';

class HomeDrawerWidget extends StatefulWidget {
  const HomeDrawerWidget({super.key});

  @override
  State<HomeDrawerWidget> createState() => _HomeDrawerWidgetState();
}
class _HomeDrawerWidgetState extends State<HomeDrawerWidget> {
 
  @override
  Widget build(BuildContext context) {
     return Drawer(
          child: BlocBuilder<GetUserData,GetUserDataState>(
            builder: (context, state) {
              if(state is LoadingUserDataState)return loading(context);
              if(state is LoadedUserDataState){
                UserModel data = state.model!;
                return Column(
                  children: [
                    //* header
                    Container(
                      width: sizeW(context),
                      decoration: BoxDecoration(color: theme(context).primaryColor,),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizeBoxH(sizeH(context)*0.1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              data.image != null 
                                ? Container(
                                  height: sizeH(context)*0.2,
                                  width: sizeW(context)*0.1,
                                  decoration: BoxDecoration(
                                    color: theme(context).primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: cachedImageWidget(context, data.image!, null,null),
                                  ),
                                )
                                : CircleAvatar(radius: sizeW(context)*0.045,child: kUserPersonLottie,),
                              IconButton(onPressed: ()=>Scaffold.of(context).closeDrawer(), icon: Icon(Icons.close,color: theme(context).backgroundColor,)),
                            ],
                          ),
                          sizeBoxH(sizeH(context)*0.035),
                          data.name != null  
                              ? Text(data.name ?? '',style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'header',color: theme(context).backgroundColor,fontSize: sizeW(context)*0.024),)
                              : const Text('no name'),
                          Text(data.phone!,style: theme(context).textTheme.titleSmall!.copyWith(fontSize: sizeW(context)*0.015,color: theme(context).canvasColor,fontWeight: FontWeight.w300),),
                          sizeBoxH(sizeH(context)*0.05),
                        ],
                      )),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: kDrawerTitle.length,
                      itemBuilder: (context, index) => drawerOneItem(context, kDrawerTitle[index], kDraewrIcons[index], kDrawerOnTapWidgets[index])),
                    Divider(
                      color: theme(context).primaryColor,
                      thickness: 1,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: kSettingTitle.length,
                      itemBuilder: (context, index) => settingOneItem(context, kSettingTitle[index], kSettingIcon[index], kSettingUrl[index])),
                  ],
                );
              }
              return Container();  
            },
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    context.read<GetUserData>().add(GetUserDataEvent());
  }
}

List<String> kDrawerTitle = ['new Group','Contacts','Save Message','Setting',];
List<IconData> kDraewrIcons = [Icons.group,Icons.person,Icons.save,Icons.settings,];
List<Widget> kDrawerOnTapWidgets = const [CreateGroupScreen(),ContactsScreen(),SaveMessageScreen(),SettingScreen(),];
Widget drawerOneItem(BuildContext context,String title, IconData icon,Widget onTap) => ListTile(
  title: Text(title,style: theme(context).textTheme.titleSmall!.copyWith(fontFamily: 'header',fontWeight: FontWeight.w400),),
  minLeadingWidth: sizeW(context)*0.02,
  leading: Icon(icon,color: theme(context).primaryColor,),
  onTap: ()=>context.navigation(context, onTap),
);


Widget settingOneItem(BuildContext context,String title,IconData icon,String url) {
 return ListTile(
    onTap:()async{
      final Uri data = Uri.parse(url);
      if ( await launchUrl(data)) { await launchUrl(data); } 
      else { throw 'Could not open the map.'; }
    } ,
    minLeadingWidth: sizeW(context)*0.02,
    title: Text(title,style: theme(context).textTheme.titleSmall!.copyWith(fontFamily: 'header',fontWeight: FontWeight.w400),),
    leading: Icon(icon,color: theme(context).primaryColor)
);
}
List<String> kSettingTitle = ['FQA','privacy Policy'];
List<IconData> kSettingIcon = [Icons.question_mark,Icons.policy];
List<String> kSettingUrl = const[
  'https://customers.ai/blog/how-to-make-q-and-a-chatbot',
  'https://customers.ai/blog/how-to-make-q-and-a-chatbot',
];
