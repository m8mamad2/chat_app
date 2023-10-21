import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/auth_check.dart';
import 'package:p_4/src/core/widget/loading.dart';
import '../../view/presentaion/blocs/lock_bloc/lock_bloc.dart';
import '../../view/presentaion/screens/setting_screen/lock_screens/lock_enter_screen.dart';
import '../common/internet_check/internet_check_connection.dart';
import 'not_internet_screen.dart';

class IsLockScreen extends StatefulWidget {
  const IsLockScreen({super.key});

  @override
  State<IsLockScreen> createState() => _IsLockScreenState();
}
class _IsLockScreenState extends State<IsLockScreen> {
  @override
  void initState() {
    context.read<LockBloc>().add(GetLockEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LockBloc, LockState>(
      builder: (context, state) {
        if(state is LoadingLockState) return SizedBox(width: sizeW(context),height: sizeH(context),child: loading(context),);
        if(state is SuccessLockState){
          bool isLock = state.data != null && state.data!.isNotEmpty && state.data![0].isLock == true ? true : false;
          return isLock ? LockEnteringScreen() : AuthCheckWidget();
        }
        if(state is FailLockState) return SizedBox(width: sizeW(context),height: sizeH(context),child: Text(state.fail),);
        return Scaffold(appBar: AppBar(),);
      },
    );
  }
}

class BeforLockScreenINternet extends StatefulWidget {
  const BeforLockScreenINternet({super.key});

  @override
  State<BeforLockScreenINternet> createState() => _BeforLockScreenINternetState();
}
class _BeforLockScreenINternetState extends State<BeforLockScreenINternet> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}