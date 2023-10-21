import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/widget/auth_check.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';

import '../../../../core/common/sizes.dart';


class AuthInfoScreen extends StatefulWidget {
  const AuthInfoScreen({super.key});

  @override
  State<AuthInfoScreen> createState() => _AuthInfoScreenState();
}

class _AuthInfoScreenState extends State<AuthInfoScreen> {
  
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(IsUserLogedIn());
  }

  XFile? image;
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:const SizedBox.shrink(),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: Container(
              color: theme(context).primaryColor,
              height: sizeH(context)*0.001,
            ),
          ),
        title: Text('User Information',style: theme(context).textTheme.titleMedium!.copyWith(fontSize: sizeW(context)*0.025,fontFamily: 'header',),),
        backgroundColor: theme(context).backgroundColor,
      ),
      body: Form(
        key: key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: sizeH(context)*0.07,bottom: sizeH(context)*0.03),
              child: const Center(child: Text('Please Enter your name and add a picture as a profile'))),
            Padding(
              padding: EdgeInsets.symmetric(vertical: sizeH(context)*0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: ()async{
                      XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
                      setState(() => file != null ? image = file : log('Choese Image null'),);
                    },
                    child: CircleAvatar(
                      radius: sizeW(context)*0.052,
                      backgroundImage: image != null ? FileImage(File(image!.path)) : null,
                      child: image != null ? null : Icon(Icons.add_a_photo,size: sizeW(context)*0.04,color: Colors.white,),
                    ),
                  ),
                  SizedBox(
                    width: sizeW(context)*0.33,
                    child: TextFormField(
                      validator: (value) => value!.isEmpty ? 'Enter SomeThing ...' : null,
                      controller: controller,
                      decoration: const InputDecoration(hintText: 'Enter your name',),
                    ))
                ],
              ),
            ),
          ],
        )
      ),
      floatingActionButton:BlocBuilder<AuthBloc,AuthState0>(
          builder: (context, state) {
            log('$state');
            if(state is AuthLoadingState) return FloatingActionButton(backgroundColor: theme(context).primaryColor,onPressed:null,child: smallLoading(context,color: theme(context).backgroundColor));
            if(state is AuthSucessState || state is AuthInitialState){
             return FloatingActionButton(
              backgroundColor: theme(context).primaryColor,
              child: Icon(Icons.check, color:theme(context).backgroundColor),
              onPressed: (){
                if(key.currentState!.validate()){
                  context.read<AuthBloc>().add(AuthInfoEvent(context, image, controller.text.trim()));
                  context.navigation(context, const AuthCheckWidget());
                }
              },
              );
            }
            if(state is AuthFailState)return FailBlocWidget(state.error);
            return Container(width: 100,height: 100,color: Colors.amber,);
          },
        
        ),
       
    );
  }
  

}

