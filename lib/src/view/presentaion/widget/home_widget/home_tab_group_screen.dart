


import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/constance/images.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/model/create_group_model.dart';
import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';
import 'package:p_4/src/view/presentaion/screens/create_group_screen.dart';
import 'package:p_4/src/view/presentaion/screens/group_chat_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/constance/lotties.dart';
import '../../../../core/common/sizes.dart';
import '../../../../core/widget/cache_image.dart';

class TabGroupScreen extends StatefulWidget {
  const TabGroupScreen({super.key});

  @override
  State<TabGroupScreen> createState() => _TabGroupScreenState();
}
class _TabGroupScreenState extends State<TabGroupScreen> {

  @override
  void initState() {
    context.read<ExistGroupBloc>().add(GetExsistGroups());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ExistGroupBloc,ExistGroupState>(
        builder: (context, state) {
          if(state is LoadingExistGroupState)return loading(context);
          if(state is LoadedExistGroupState){
             final List<CreateGroupModel>? data = state.model;
             return data == null || data.isEmpty
              ? Center(child: startConversitionLottie(context),)
              : ListView.separated(
                separatorBuilder: (context, index) => Divider(thickness: 0.4,indent: sizeW(context)*0.1,),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  List<String> names = data.map((e) => e.name).toList();
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: sizeH(context)*0.02),
                    child: ListTile(
                      title: Text(names[index],style: theme(context).textTheme.titleSmall!.copyWith(fontFamily: 'body',fontWeight: FontWeight.w500),),
                      onTap:()=>context.navigation(context, GroupScreen(groupModel:data[index],)),
                      leading: data[index].image != null && data[index].image!.isNotEmpty
                        ? Container(
                          width: sizeW(context)*0.07,
                          decoration: BoxDecoration(
                            color: theme(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: cachedImageWidget(context, data[index].image!, null,null),
                            ),
                        )
                        : CircleAvatar( 
                          // backgroundColor: theme(context).primaryColor,
                          backgroundColor: theme(context).primaryColor,
                          radius: sizeW(context)*0.034, 
                          child: Text(data[index].name[0].toUpperCase(),style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).backgroundColor),),),
                      ),
                  );
                },);
          }
          return Container();
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme(context).primaryColor,
        onPressed: ()=> context.navigation(context, const CreateGroupScreen()),
        child: Icon(Icons.add,color: theme(context).backgroundColor),
      ),
    );
  }

}


