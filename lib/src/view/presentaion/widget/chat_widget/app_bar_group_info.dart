import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/model/create_group_model.dart';
import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';
import 'package:p_4/src/view/presentaion/screens/chat_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../config/theme/theme.dart';
import '../../../../core/common/is_english.dart';
import '../../../../core/common/sizes.dart';
import '../../../data/model/user_model.dart';

class AppbarGroupInfoScreen extends StatefulWidget {
  final CreateGroupModel data;
  const AppbarGroupInfoScreen({super.key,required this.data});

  @override
  State<AppbarGroupInfoScreen> createState() => _AppbarGroupInfoScreenState();
}

class _AppbarGroupInfoScreenState extends State<AppbarGroupInfoScreen> {
  late List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: theme(context).cardColor),onPressed: () => context.navigationBack(context),),
        actions: [ 
          BlocBuilder<GroupBloc,GroupState>(
            builder: (context, state) {
              if(state is GroupLoadingState)return smallLoading(context);
              if(state is GroupSuccessState || state is GroupInitialState)return popupItem(context, ()=> context.read<GroupBloc>().add(LeftGroupEvent(context, widget.data.uid)), Icons.delete_forever_outlined);              
              if(state is GroupLoadingState)return const Icon(Icons.error);
              return Container();
            },
          )],  
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Container(
                    width: sizeW(context),
                    height: sizeH(context)*0.27,
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: theme(context).primaryColorDark,width: sizeW(context)*0.0015)),
                      color: theme(context).backgroundColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.019,vertical: 10),
                      child: Row(
                        children: [
                          widget.data.image != null && widget.data.image!.isNotEmpty
                            ? CircleAvatar( radius: sizeW(context)*0.045,backgroundColor: theme(context).primaryColorDark ,backgroundImage: NetworkImage(widget.data.image!),)
                            : CircleAvatar( radius: sizeW(context)*0.045,backgroundColor: theme(context).primaryColorDark ,child: Text(widget.data.name[0].toUpperCase(),style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).backgroundColor)),),
                          sizeBoxW(sizeW(context)*0.02),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.data.name ,style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'header',color: theme(context).cardColor,fontSize: sizeW(context)*0.024),),
                              Text('${users.length} members',style: theme(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w400),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                    SizedBox(
                      width: sizeW(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(title: Text('Info'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(color: theme(context).primaryColorDark),),),
                          ListTile(
                              title: Text(widget.data.bio ?? 'Nothing'.tr(),style: theme(context).textTheme.titleSmall!.copyWith(),),
                              subtitle:  Text('Bio'.tr()),
                            ),
                          Container(color: theme(context).primaryColorDark,height: sizeW(context)*0.0015,width: sizeW(context),)
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only( 
                    right:isEnglish(context) ? sizeW(context)*0.03 : 0,
                  left:isEnglish(context) ? 0 : sizeW(context)*0.03,
                  bottom: sizeH(context)*0.1),
                  child: Align(
                    alignment: isEnglish(context) ? Alignment.centerRight : Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => context.navigationBack(context),
                      child: CircleAvatar(
                        radius: sizeW(context)*0.04,
                        backgroundColor: theme(context).primaryColorDark,
                        child: Icon(Icons.chat,color: theme(context).backgroundColor,),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              color: theme(context).backgroundColor,
              margin: const EdgeInsets.only(top: 5),
              width: sizeW(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(title: Text('memebers'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(color: theme(context).primaryColorDark),),),
                  ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      thickness: 0.4,
                      indent: sizeW(context)*0.1,
                    ),
                    itemCount:users.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      UserModel user = users[index];
                      return widget.data.creater == user.uid
                        ? ListTile(
                          title: Text(user.name ?? user.uid!.substring(0,5),style:theme(context).textTheme.titleSmall!.copyWith(fontFamily: 'body',fontWeight: FontWeight.w500)),
                          leading: CircleAvatar(radius: sizeW(context)*0.03,),
                          trailing: Text('Admin'.tr(),style: theme(context).textTheme.bodySmall!.copyWith(color: theme(context).primaryColorDark),),
                        )
                        : ListTile(
                            onTap: () { context.navigation(context, ChatPage(data: users[index]));},
                            leading: users[index].image != null 
                                  ? CircleAvatar( radius: sizeW(context)*0.03, backgroundImage: NetworkImage(users[index].image!),)
                                  : CircleAvatar( radius: sizeW(context)*0.03, child: Text(users[index].name?[0].toLowerCase() ?? users[index].uid![0].toUpperCase()),),
                            title: Text(users[index].name ?? users[index].uid!.substring(0,5),style: theme(context).textTheme.titleSmall!.copyWith(fontFamily: 'body',fontWeight: FontWeight.w500),),
                          );
                    }
                  ),
                  
                  Container(margin: EdgeInsets.only(top: sizeH(context)*0.04),color: theme(context).primaryColorDark,height: sizeW(context)*0.0015,width: sizeW(context),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    users = widget.data.users.map((e) => UserModel.fromJson(e)).toList();
  }
}


IconButton popupItem(BuildContext context,VoidCallback onTap,IconData icon)=>IconButton(onPressed: onTap,icon: Icon(icon,color: theme(context).cardColor,),);
