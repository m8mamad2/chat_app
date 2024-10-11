import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/presentaion/blocs/lock_bloc/lock_bloc.dart';

import 'lock_change_pass.dart';

class LockSettingScreen extends StatefulWidget {
  const LockSettingScreen({super.key});

  @override
  State<LockSettingScreen> createState() => _LockSettingScreenState();
}

class _LockSettingScreenState extends State<LockSettingScreen> {

  @override
  void initState() {
    super.initState();
    context.read<LockBloc>().add(GetLockEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(sizeH(context)*0.001),
          child: Container(
            height :sizeH(context)*0.001,
            width: sizeW(context),
            color: theme(context).primaryColorDark,
          ),
        ),
        title: Text('Lock Setting'.tr(),style: theme(context).textTheme.titleMedium!.copyWith(fontSize: sizeW(context)*0.025,fontFamily: 'header',),),
        leading: IconButton(icon:const Icon(Icons.arrow_back),onPressed: (){context.navigationBack(context);context.navigationBack(context);},),
      ),
      body: BlocBuilder<LockBloc,LockStartBloc>(
        builder: (context, state) {
          if(state is LoadingLockStartBloc)return loading(context);
          if(state is SuccessLockStartBloc){
            return Container(
              height: sizeH(context)*0.4,
              width: sizeW(context),
              color: theme(context).scaffoldBackgroundColor,
              margin: EdgeInsets.only(top: sizeH(context)*0.04),
              child: ListView(
                children: [
                  ListTile(
                    minLeadingWidth: sizeW(context)*0.02,
                    title:Text('Trun Off PassCode'.tr()),
                    leading: Icon(Icons.lock_open,color: theme(context).primaryColorDark),
                    onTap: () {
                      context.read<LockBloc>().add(DeleteLockEvent());
                      context.navigationBack(context);
                      context.navigationBack(context);
                    } ,),
                  ListTile(
                    minLeadingWidth: sizeW(context)*0.02,
                    title: Text('Change Passcode'.tr()),
                    leading: Icon(Icons.change_circle_outlined,color: theme(context).primaryColorDark,),
                    onTap: () => context.navigation(context, const LockChangePass()),
                  ),
                ],
              ),
            );
          }
          if(state is FailLockStartBloc)return FailBlocWidget(state.fail);

          return Container();
        },
      ),
    );
  }
}