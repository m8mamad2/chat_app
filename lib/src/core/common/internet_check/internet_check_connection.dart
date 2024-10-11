
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:p_4/src/config/theme/theme.dart';
// import 'package:p_4/src/core/widget/auth_check.dart';
// import 'package:p_4/src/core/widget/loading.dart';
// import 'package:p_4/src/core/widget/not_internet_screen.dart';
// class InternetCheckConnection extends StatefulWidget {
//   const InternetCheckConnection({super.key});
//   @override
//   State<InternetCheckConnection> createState() => _InternetCheckConnectionState();
// }
// class _InternetCheckConnectionState extends State<InternetCheckConnection> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: theme(context).scaffoldBackgroundColor,
//       body: Center(
//         child: StreamBuilder<InternetConnectionStatus>(
//           stream: InternetConnectionChecker().onStatusChange,
//           builder: (context, snapshot){
//             log('--> Connectiong : ${snapshot.connectionState.toString()}');
//             switch(snapshot.connectionState){
//               case ConnectionState.none:
//               case ConnectionState.waiting:return smallLoading(context);
//               default:
//                 log('----> Connection Res : ${snapshot.data}');
//                 if(snapshot.data == InternetConnectionStatus.connected){return const AuthCheckWidget();}
//                 else { return const NotInternetScreen();}
//             }
//           },),
//           ),
//     );
//   }
// }

import 'dart:developer';
import 'dart:convert' as convert;

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:p_4/src/core/common/bottom_shet_helper.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/internet_check/bloc/internet_bloc.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/is_lock_screen.dart';
import 'package:p_4/src/core/widget/not_internet_screen.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/domain/usecase/chat_usecase.dart';

import '../../../config/theme/theme.dart';
import '../../widget/loading.dart';
import '../constance/lotties.dart';


class InternetCheckerWidget extends StatefulWidget {
  const InternetCheckerWidget({super.key});

  @override
  State<InternetCheckerWidget> createState() => _InternetCheckerWidgetState();
}
class _InternetCheckerWidgetState extends State<InternetCheckerWidget> {
  
  bool isShowingOrNot= false;

  @override
  void initState() {
    context.read<InternetBloc>().add(ConnectionCheckEvent());
    super.initState();
  }
  
  bool loading = false;
  bool aftherTry = false; 
  
  Future showing() async {
    setState(() => isShowingOrNot = true);
    await showModalBottomSheet(
      enableDrag: false,  
      context: context, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      builder: (context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
    ),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            errorLottie(context),
            Text('Error',style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).primaryColorDark),),
            sizeBoxH(sizeH(context)*0.05),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Center(
                child: Text(
                  aftherTry ? 'Not Connected yet ... one more time!'.tr() : 'Check Your Connection Please...'.tr(),
                  textAlign: TextAlign.center,
                  style: theme(context).textTheme.titleMedium!.copyWith(),),
              )),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed:()async {
                  setState(()=> loading = true);
                  bool isConnect =  await InternetConnectionChecker().hasConnection;
                  isConnect == true ? setState(()=> aftherTry =false) : setState(()=> aftherTry =true);
                  setState(()=> loading = false);
                } , 
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width * 0.8, sizeH(context)*0.13),
                  backgroundColor: theme(context).primaryColorDark
                ),
                child:loading ? CircularProgressIndicator(color: theme(context).cardColor,) :Text('ok',style: theme(context).textTheme.titleMedium!.copyWith(color: theme(context).cardColor),)),
            ),
        ]),
    ),);
  }
      
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<InternetBloc,InternetState>(
          listener: (context, state) async {
            log('--> In LIstenter$state');
            if(state is SuccessInternetState){
              if(isShowingOrNot){
                state.isConnected == true ? context.navigationBack(context) : null;
                setState(() => isShowingOrNot = false);
              }
              else {
                state.isConnected == true ? null : await showing();
              }
            }
          },
          builder: (context, state) {
            if(state is LoadingInternetState)return smallLoading(context);
            if(state is SuccessInternetState){
              return state.isConnected ? IsLockScreen() : NotInternetScreen();
            }
            if(state is FailInternetState)return Text('Error');
            return Container(
              width: 100,
              height: 100,
              color: Colors.amber,
            );
          },
        ),
      ),
    );
  }
}

