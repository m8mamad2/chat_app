// ignore_for_file: list_remove_unrelated_type


import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/retry.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/data/repo/group_repo_body.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';
import 'package:p_4/src/view/presentaion/screens/create_group_info_screen.dart';

import '../../../config/theme/theme.dart';
import '../../../core/common/constance/images.dart';
import '../../../core/common/sizes.dart';
import '../../../core/widget/loading.dart';
import '../../../core/widget/random_colors.dart';
import '../../data/repo/chat_repo_body.dart';
import '../blocs/user_bloc/user_bloc.dart';
import 'chat_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => CreateGroupScreenState();
}
class CreateGroupScreenState extends State<CreateGroupScreen> {

  @override
  void initState() {
    super.initState();
    context.read<AllUserBloc>().add(GetAllUserEvent(context));
    context.read<GetUserData>().add(GetUserDataEvent());
  }


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
        title: Text('New Group'.tr(),
        style: theme(context).textTheme.titleMedium!.copyWith(fontSize: sizeW(context)*0.025,fontFamily: 'header',),),
        leading: IconButton(icon:const Icon(Icons.arrow_back),onPressed: ()=>context.navigationBack(context),),
      ),
      body: Column(
        children: [
            sizeBoxH(sizeH(context)*0.03),
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: chips.isEmpty ? [emptyChipsWidget(context)] : chips.map((e) => buildChip(e, theme(context).primaryColorDark ,true)).toList(),),
            sizeBoxH(sizeH(context)*0.05),
            BlocBuilder<AllUserBloc,AllUserState>(
              builder: (context, state) {
                log('$state');
                if(state is LoadingAllUserState)return smallLoading(context);
                if(state is LoadedAllUserState){
                  List<UserModel>? data = state.model;

                  return data != null  
                    ? ListView.separated(
                        separatorBuilder: (context, index) => Divider( thickness: 0.4, color: theme(context).primaryColorDark, indent: sizeW(context)*0.1,),
                        shrinkWrap: true,
                        itemCount: data.length ,
                        itemBuilder:(context, index) {
                          
                          UserModel model = data[index];
                
                          return Padding(
                            padding : EdgeInsets.zero,
                            child: ListTile(
                              onTap: () {
                                  chips.isEmpty 
                                    ?  setState(() { chips.add(data[index]);} )
                                    : chips.contains(data[index]) ? null : setState(() => chips.add(data[index]),);
                              },
                              title: Text(model.name ?? model.uid!.substring(0,5),style: theme(context).textTheme.titleSmall!.copyWith(fontSize: sizeW(context)*0.016,fontFamily: 'body',fontWeight: FontWeight.w500),),
                              leading: data[index].image != null && data[index].image!.isNotEmpty
                                  ? Container(
                                    width: sizeW(context)*0.06,
                                    decoration: BoxDecoration(
                                      color: theme(context).primaryColorDark,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        onError: (exception, stackTrace) => setState(() => AssetImage(kLogoImage)),
                                        image: NetworkImage(data[index].image!))
                                    ),
                                  )
                                  : CircleAvatar( 
                                    backgroundColor: theme(context).primaryColorDark,
                                    radius: sizeW(context)*0.029, 
                                    child: Text(data[index].name?[0].toUpperCase() ?? data[index].uid![0].toUpperCase(),style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'header',color: theme(context).scaffoldBackgroundColor),),),
                                  
                            ),
                          );}
                      )
                    :const Text('NUll');
                }
                return Container();
              },
          )
        ],
      ),
      floatingActionButton: BlocBuilder<GetUserData,GetUserDataState>(
        builder: (context, state) {
          if(state is LoadingUserDataState)return loading(context);
          if(state is LoadedUserDataState){
            UserModel? mySelf = state.model;
            return FloatingActionButton(
              backgroundColor: theme(context).primaryColorDark,
              child: Icon(Icons.check,color: theme(context).scaffoldBackgroundColor,),
              onPressed: ()async{
                chips.isNotEmpty 
                ? context.navigation(context, CreateGroupInfoScreen(data: chips,myself: mySelf!,))
                : log('Empty');
                  // context.read<GroupBloc>().add(CreateGroupEvent(name: 'First', users: chips, uid: 'Fourth 0'));
              });
          }
          return Container();
        },
      ),
    );
  }

  SizedBox emptyChipsWidget(BuildContext context) {
    return SizedBox(width: sizeW(context),height: sizeH(context)*0.12,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.03,vertical: sizeH(context)*0.03),
                child:  Text('Who would you like to add?'.tr()),
              ));
  }

  List<UserModel> chips = [];
  Widget buildChip(UserModel model, Color color,bool isSelected) {
    return Chip(
      deleteIcon: Icon(Icons.close,size: sizeW(context)*0.02,color: Colors.white,),
      onDeleted:() {setState(() {chips.removeWhere((element) => element.uid == model.uid);});},
      avatar: Container(
        width: sizeW(context)*0.09,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme(context).scaffoldBackgroundColor,
          image: DecorationImage(
            fit: BoxFit.cover,
            onError: (exception, stackTrace) => setState(() => AssetImage(kLogoImage)),
            image: NetworkImage(model.image ??''))
        ),
        child: Center(child: model.image != null ? null : Text(model.name?[0].toUpperCase() ?? model.uid![0].toUpperCase(),style: theme(context).textTheme.titleSmall!.copyWith(fontSize: 10,fontWeight: FontWeight.bold))),

      ),
      label: Text(
        model.name?[0].toUpperCase() ?? model.uid![0].toUpperCase(),
        style:theme(context).textTheme.bodySmall!.copyWith(color: theme(context).scaffoldBackgroundColor),
      ),
      backgroundColor: color,
      elevation: 1.0,
    );
  }
}






