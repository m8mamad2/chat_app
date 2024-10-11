
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/auth_check.dart';
import 'package:p_4/src/core/widget/loading.dart';
import '../../view/presentaion/blocs/lock_bloc/lock_bloc.dart' as lockBloc;
import '../../view/presentaion/screens/setting_screen/lock_screens/lock_enter_screen.dart';

class IsLockScreen extends StatefulWidget {
  const IsLockScreen({super.key});

  @override
  State<IsLockScreen> createState() => _IsLockScreenState();
}
class _IsLockScreenState extends State<IsLockScreen> {
  @override
  void initState() {
    context.read<lockBloc.LockBloc>().add(lockBloc.GetLockEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<lockBloc.LockBloc, lockBloc.LockStartBloc>(
      builder: (context, state) {
        if(state is lockBloc.LoadingLockStartBloc) return SizedBox(width: sizeW(context),height: sizeH(context),child: loading(context),);
        if(state is lockBloc.SuccessLockStartBloc){
          bool isLock = state.data != null && state.data!.isNotEmpty && state.data![0].isLock == true ? true : false;
          return isLock ? LockEnteringScreen() : AuthCheckWidget();
        }
        if(state is lockBloc.FailLockStartBloc) return SizedBox(width: sizeW(context),height: sizeH(context),child: Text(state.fail),);
        return Scaffold(appBar: AppBar(),);
      },
    );
  }
}
