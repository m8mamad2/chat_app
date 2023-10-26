import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/presentaion/blocs/user_bloc/user_bloc.dart';

import '../../../../config/theme/theme.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({super.key});

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}
class _EditNameScreenState extends State<EditNameScreen> {

  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
          preferredSize: Size.fromHeight(sizeH(context)*0.001),
          child: Container(
            height :sizeH(context)*0.001,
            width: sizeW(context),
            color: theme(context).primaryColorDark,
          ),
        ),
          title: Text('Edit name',style: theme(context).textTheme.titleMedium!.copyWith(fontSize: sizeW(context)*0.025,fontFamily: 'header',),),
          leading: IconButton(onPressed: ()=>context.navigationBack(context), icon:const Icon(Icons.arrow_back)),
          actions: [
            BlocBuilder<UserBloc,UserState>(
              builder: (context, state) {
                if(state is UserLoadingState)return smallLoading(context);
                if(state is UserSuccessState){
                 return IconButton(
                    onPressed: (){
                      if(key.currentState!.validate()){ context.read<UserBloc>().add(UpdateUserInfoEvent(context,{'name':_controller.text.trim()})); }
                      else {log('Not Valid');}
                    }, 
                    icon: Icon(Icons.check,color: theme(context).primaryColorDark,));
                }
                if(state is UserFailState)return FailBlocWidget(state.fail.toString());
                return Container();
              },
              
            ),
          ]
        ),
        body: Form(
                key: key,
                child: Column(
                  children: [
                    sizeBoxH(sizeH(context)*0.1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        autofocus: true,
                        validator: (value) => value == null || value.isEmpty ? 'Enter something' : null,
                        decoration:const InputDecoration(hintText: 'Enter your name'),
                        controller: _controller,)),
                  ],
                ),
              )
      ),
    );
  }
}

            