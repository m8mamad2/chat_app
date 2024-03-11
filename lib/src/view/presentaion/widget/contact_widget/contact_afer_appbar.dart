
// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/is_english.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/data/repo/chat_repo_body.dart';
import 'package:p_4/src/view/presentaion/screens/chat_screen.dart';
import 'package:p_4/src/view/presentaion/screens/create_group_screen.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../blocs/user_bloc/user_bloc.dart';



class ContactAfterAppbar extends StatelessWidget {
  const ContactAfterAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

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
                          child: Text('New Contact',style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header'),),
                        ),
                        TextFormField(
                          controller: _addMemberController,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          style: theme(context).textTheme.bodyMedium!.copyWith(fontFamily: 'body'),
                          validator: (value) => value!.isEmpty ? 'enter Something' : null,
                          decoration: InputDecoration(
                            labelText: 'phone number',
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
                          child: Text('Craete Contanst',style:theme(context).textTheme.titleMedium!.copyWith(color: theme(context).backgroundColor))),
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


    return Column(
    children: [
      ListTile(
        minLeadingWidth: sizeW(context)*0.01,
        title: Text('Invite Friends'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'body',fontWeight: FontWeight.w300),),
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.015),
          child: Icon(Icons.person_add_alt_outlined,color: theme(context).primaryColorDark,),
        ),
        onTap: ()async => await addMember(),
      ),
      ListTile(
        minLeadingWidth: sizeW(context)*0.01,
        title: Text('Create Group'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'body',fontWeight: FontWeight.w300),),
        leading: Padding(
          padding:  EdgeInsets.symmetric(horizontal: sizeW(context)*0.015),
          child: Icon(Icons.group_outlined,color: theme(context).primaryColorDark,),
        ),
        onTap: () => context.navigation(context, const CreateGroupScreen()),
      ),
      Container(
          alignment: isEnglish(context) ? Alignment.centerLeft : Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.035),
          margin: EdgeInsets.only(bottom: 10),
          width: sizeW(context),
          height: sizeH(context)*0.063,
          color: theme(context).primaryColorDark,
          
          child: Text('Contacts'.tr(),style:theme(context).textTheme.bodySmall!.copyWith(color: theme(context).backgroundColor,fontWeight: FontWeight.w500) ,),
        ),
    ],
  );
  
  }
  
}
