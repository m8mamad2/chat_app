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
  
  List<UserModel>? serachUser = <UserModel>[];
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
      color: theme(context).scaffoldBackgroundColor,
      child: BlocConsumer<AllUserBloc,AllUserState>(
        listener: (context, state) {
          if(state is LoadedAllUserState)serachUser = state.model;
        },
        builder: (context, state) {
          if(state is LoadingAllUserState)return smallLoading(context);
          if(state is LoadedAllUserState){
            List<UserModel>? data = state.model;
            return Scaffold(
              appBar:isSearch 
                ? AppBar(
                  title: SizedBox(
                    height: sizeH(context)*0.1,
                    child: TextField(
                      autofocus: true,
                      textInputAction:TextInputAction.search,
                      onChanged: (text) {
                        setState(() =>
                          serachUser = data!.where((item) => item.name!.toLowerCase().contains(text.toLowerCase())).toList());
                      },
                      controller: controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: sizeH(context)*0.01,left: sizeW(context)*0.01),
                        focusedBorder: border( theme(context).primaryColorDark),
                        enabledBorder: border( theme(context).primaryColorDark),
                        border: InputBorder.none,),
                    ),
                  ),
                  leading: IconButton(icon: const Icon(Icons.arrow_back,),onPressed: (){
                    isSearch = !isSearch;
                    serachUser = state.model;
                    setState(() { });
                  },),
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
                    : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: serachUser!.length ,
                            itemBuilder:(context, index) { 
                              String res = serachUser![index].name ?? '';
                              return InkWell(
                              onTap: () => context.navigation(context, ChatPage(data: serachUser![index])),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: sizeH(context)*0.015),
                                  child: ListTile(
                                    title: Text(res,style: theme(context).textTheme.titleSmall!.copyWith(fontSize: sizeW(context)*0.018,fontFamily: 'body',fontWeight: FontWeight.w500),),
                                    onTap: () => context.navigation(context, ChatPage(data: serachUser![index])),
                                    leading: serachUser![index].image != null && serachUser![index].image!.isNotEmpty
                                        ? Container(
                                          width: sizeW(context)*0.066,
                                          decoration: BoxDecoration(
                                            color: theme(context).primaryColorDark,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              onError: (exception, stackTrace) => setState(() => AssetImage(kLogoImage)),
                                              image: NetworkImage(serachUser![index].image!))
                                          ),
                                        )
                                        : CircleAvatar( 
                                        backgroundColor: theme(context).primaryColorDark,
                                        radius: sizeW(context)*0.034, 
                                        child: Text(serachUser![index].name?[0].toUpperCase() ?? serachUser![index].uid![0].toUpperCase(),style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).scaffoldBackgroundColor),),),
                                  
                                  ),
                                ),
                            );})
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: theme(context).primaryColorDark,
                child: Icon(Icons.person_add_alt_1_sharp,color: theme(context).scaffoldBackgroundColor,),
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
  OutlineInputBorder border (Color color) => OutlineInputBorder( borderRadius: BorderRadius.circular(12),  borderSide:BorderSide(color: color, width: 0.4));
  
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
     

      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: theme(context).scaffoldBackgroundColor,
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
                          child: Text('Craete Contanst'.tr(),style:theme(context).textTheme.titleMedium!.copyWith(color: theme(context).scaffoldBackgroundColor))),
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
