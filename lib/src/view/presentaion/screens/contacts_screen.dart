// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/presentaion/blocs/user_bloc/user_bloc.dart';
import 'package:p_4/src/view/presentaion/screens/chat_screen.dart';

import '../../../core/common/constance/images.dart';
import '../blocs/chat_bloc/chat_bloc.dart';
import '../widget/contact_widget/contact_afer_appbar.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  
  List<UserModel> searchedUser = <UserModel>[];
  bool isSearch = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
      super.initState();
      context.read<AllUserBloc>().add(GetAllUserEvent(context));
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeW(context),
      height: sizeH(context),
      color: theme(context).backgroundColor,
      child: BlocBuilder<AllUserBloc,AllUserState>(
        builder: (context, state) {
          if(state is LoadingAllUserState)return smallLoading(context);
          if(state is LoadedAllUserState){
            List<UserModel>? data = state.model;
            return Scaffold(
              appBar:isSearch 
                ? AppBar(
                  title: TextField(
                    textInputAction:TextInputAction.search,
                    onChanged: (text) {},
                    controller: controller,
                    decoration: const InputDecoration(border: InputBorder.none,),
                  ),
                  leading: IconButton(icon: const Icon(Icons.arrow_back,),onPressed: () => onPressed(),),
                )
                : AppBar(
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0.0),
                    child: Container(
                      color: theme(context).primaryColorDark,
                      height: sizeH(context)*0.001,
                    ),
                  ),
                  title: Text('Contacts'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontSize: sizeW(context)*0.025,fontFamily: 'header',),),
                  leading: IconButton(icon:const Icon(Icons.arrow_back),onPressed: ()=>context.navigationBack(context),),
                  actions: [ IconButton(onPressed: ()=>onPressed(), icon: const Icon(Icons.search))],
                ),
              body: Column(
                children: [
                  isSearch ?  const SizedBox.shrink() : const ContactAfterAppbar(),
                  data == null || data.isEmpty
                    ? Center(child: Text('No contact'.tr()))
                    : isSearch
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount:searchedUser.length ,
                          itemBuilder: (context, index) {
                            String res = data[index].name!;
                            return InkWell(
                            onTap: () => context.navigation(context, ChatPage(data: data[index])),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: sizeH(context)*0.01),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: sizeW(context)*0.03,
                                    child: data[index].image != null ? Image.network(data[index].image!,fit: BoxFit.cover,) : Text(data[index].name?[0] ?? ''),
                                  ),
                                  title: Text(res),
                                  onTap: () => context.navigation(context, ChatPage(data: data[index])),
                                ),
                              ),
                          );})
                      : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:data.length ,
                            itemBuilder:(context, index) { 
                              String res = data[index].name ?? '';
                              return InkWell(
                              onTap: () => context.navigation(context, ChatPage(data: data[index])),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: sizeH(context)*0.015),
                                  child: ListTile(
                                    title: Text(res,style: theme(context).textTheme.titleSmall!.copyWith(fontSize: sizeW(context)*0.018,fontFamily: 'body',fontWeight: FontWeight.w500),),
                                    onTap: () => context.navigation(context, ChatPage(data: data[index])),
                                    leading: data[index].image != null && data[index].image!.isNotEmpty
                                        ? Container(
                                          width: sizeW(context)*0.066,
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
                                        radius: sizeW(context)*0.034, 
                                        child: Text(data[index].name?[0].toUpperCase() ?? data[index].uid![0].toUpperCase(),style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).backgroundColor),),),
                                  
                                  ),
                                ),
                            );})
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: theme(context).primaryColorDark,
                child: Icon(Icons.person_add_alt_1_sharp,color: theme(context).backgroundColor,),
                onPressed: ()async{
                  // context.read<UserBloc>().add();
                  await addMember();
                }
                ),
            );
          }
          return Container();
        }
      ),
    );
  }
 
  onPressed()=>setState(()=>isSearch = !isSearch);


  final TextEditingController _addMemberController = TextEditingController();
  GlobalKey<FormState> addMemberKey = GlobalKey<FormState>();
  
  addMember()async=>showModalBottomSheet(
    isScrollControlled: true,
    shape:const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )
    ),
    context: context, 
    builder: (context) {
     
      OutlineInputBorder border (Color color) => OutlineInputBorder(
         borderRadius: BorderRadius.circular(12), 
         borderSide:BorderSide(color: color, width: 0.4));

      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: theme(context).backgroundColor,
            borderRadius:const BorderRadius.only(
             topLeft: Radius.circular(20),
              topRight: Radius.circular(20), 
            )
          ),
          height: sizeH(context)*0.6,
          child: BlocBuilder<UserBloc,UserState>(
            builder: (context, state) {
              log(state.toString());
              if(state is UserLoadingState)return smallLoading(context);
              if(state is UserSuccessState || state is UserInitialState){
                return Form(
                  key: addMemberKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizeBoxH(sizeH(context)*0.04),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: sizeH(context)*0.02),
                          child: Text('New Contact'.tr(),style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header'),),
                        ),
                        TextFormField(
                          controller: _addMemberController,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          style: theme(context).textTheme.bodyMedium!.copyWith(fontFamily: 'body'),
                          validator: (value) => value!.isEmpty ? 'Enter Something'.tr() : null,
                          decoration: InputDecoration(
                            labelText: 'Phone number'.tr(),
                            labelStyle: theme(context).textTheme.bodySmall,
                            prefixIcon:Icon(Icons.phone,color: theme(context).primaryColorDark,) ,
                            fillColor: theme(context).canvasColor,
                            filled: true,
                            errorStyle: theme(context).textTheme.labelSmall!.copyWith(
                              color: Colors.red,
                              fontSize: sizeW(context)*0.01
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: sizeW(context)*0.021),
                            focusedErrorBorder: border(Colors.red),
                            enabledBorder: border(theme(context).primaryColorDark),
                            errorBorder: border(Colors.red),
                            focusedBorder: border(theme(context).primaryColorDark),
                          ),
                        ),
                        sizeBoxH(sizeH(context)*0.1),
                        ElevatedButton(
                          onPressed: ()async{
                            if(addMemberKey.currentState!.validate()) context.read<UserBloc>().add(UserIsInAppEvent(context, _addMemberController.text.trim(), _addMemberController));
                          }, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme(context).primaryColorDark,
                            minimumSize: Size(sizeW(context), sizeH(context)*0.13),
                            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15) )
                          ),
                          child: Text('Craete Contanst'.tr(),style:theme(context).textTheme.titleMedium!.copyWith(color: theme(context).backgroundColor))),
                      ],
                    ),
                  ),
                );}
              if(state is UserFailState)return FailBlocWidget(state.fail.toString());
              return Container();
            },
          ),
        ),
      );
    }
  );

}
