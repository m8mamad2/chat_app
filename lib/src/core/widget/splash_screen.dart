// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/internet_check/bloc/internet_bloc.dart';
import 'package:p_4/src/core/common/internet_check/internet_check_connection.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/auth_check.dart';
import 'package:p_4/src/core/widget/is_lock_screen.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/user_bloc/user_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  final bool isDark;
  const SplashScreen({super.key,required this.isDark});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDark ? const Color(0xff1A1C1E) : theme(context).backgroundColor,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              widget.isDark 
              ? 'assets/image/logo/New-file2.gif'
              : 'assets/image/logo/New-file.gif',width: sizeW(context)*0.7,height: MediaQuery.of(context).size.height*0.6,),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: sizeH(context)*0.4,left: sizeW(context)*0.2),
                width: sizeW(context),height: sizeH(context)*0.2,color: const Color(0xff1A1C1E),)),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.8),
              child: FutureBuilder(
                future: isInternetConnectAndCanGo(),
                builder: (context, snapshot) {
                  log(snapshot.connectionState.toString());
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:return smallLoading(context);
                    default:
                      bool isConnected = snapshot.data!;
                      log(snapshot.data.toString());
                      return isConnected 
                        ?  smallLoading(context)
                        :  IconButton(
                          onPressed: ()async{
                            await isInternetConnectAndCanGo();
                            setState(() {});
                          }, 
                          icon: const Icon(Icons.local_dining));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> isInternetConnectAndCanGo()async{
    bool isInternetConnect = await InternetConnectionChecker().hasConnection;

    if(isInternetConnect){
      final SupabaseClient supabase = Supabase.instance.client;
      final session = supabase.auth.currentSession;
      final curretnUser = supabase.auth.currentUser?.id;
      if(session != null && curretnUser != null) {
        context.read<GetUserData>().add(GetUserDataEvent());
        context.read<ExistConversitionBloc>().add(GetExistConversition(context));
        context.read<ExistGroupBloc>().add(GetExsistGroups());
      }
      
      // Future.delayed(const Duration(seconds: 5),() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const IsLockScreen(),)),);
      if(mounted){
       await Future.delayed(const Duration(seconds: 5),() {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const InternetCheckerWidget(),));});
      }
      return true;
    }
    else { return false; }
  }
}

