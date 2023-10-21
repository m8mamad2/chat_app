
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
//       backgroundColor: theme(context).backgroundColor,
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
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/internet_check/bloc/internet_bloc.dart';
import 'package:p_4/src/core/widget/is_lock_screen.dart';
import 'package:p_4/src/core/widget/not_internet_screen.dart';
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/domain/usecase/chat_usecase.dart';

import '../../widget/loading.dart';


class InternetCheckerWidget extends StatefulWidget {
  const InternetCheckerWidget({super.key});

  @override
  State<InternetCheckerWidget> createState() => _InternetCheckerWidgetState();
}
class _InternetCheckerWidgetState extends State<InternetCheckerWidget> {
  
  @override
  void initState() {
    context.read<InternetBloc>().add(ConnectionCheckEvent());
    super.initState();
  }
  
  Future showing() async => await showDialog(
    context: context, 
    builder:(context) => AlertDialog(
      actions: [
        ElevatedButton(onPressed: ()async{
          
          bool isConnect =  await InternetConnectionChecker().hasConnection;
          // ignore: use_build_context_synchronously
          return isConnect ? context.navigationBack(context) : null;

        }, child: Text('Check'))
      ],
    ));
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<InternetBloc,InternetState>(
          listener: (context, state) async {
            log('--> In LIstenter$state');
            if(state is SuccessInternetState){
              state.isConnected == true ? null : await showing();
            }
          },
          builder: (context, state) {
            // if(state is LoadingInternetState)return smallLoading(context);
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

