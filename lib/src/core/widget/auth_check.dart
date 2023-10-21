
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:supabase/supabase.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
// import 'package:p_4/src/core/widget/loading.dart';
// import 'package:p_4/src/view/presentaion/blocs/auth_bloc/auth_bloc.dart';
// import 'package:p_4/src/view/presentaion/screens/auth_screen/signup_screen.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../view/presentaion/screens/home_screen.dart';


// class AuthCheckWidget extends StatefulWidget {
//   const AuthCheckWidget({super.key});

//   @override
//   State<AuthCheckWidget> createState() => _AuthCheckWidgetState();
// }
// class _AuthCheckWidgetState extends State<AuthCheckWidget> {
  
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   context.read<AuthBloc>().add(IsUserLogedIn());
//   // }
//   SupabaseClient supabase = Supabase.instance.client;
//   bool isLogin(){
//     final session =  supabase.auth.currentSession;
//     final currentUser = supabase.auth.currentUser?.id;
//     if(session != null && currentUser != null) return true;
//     else return false;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: BlocBuilder<AuthBloc,AuthState0>(
//           builder: (context, state) {
//             log('$state ---> in Check ');
//             if(state is AuthLoadingState)return smallLoading(context);
//             if(state is AuthSucessState) {
//               log('======================> ${state.isUserLoggedIn}');
//               return state.isUserLoggedIn ?? false ? const HomeScreen() : const SignupScreen();
//             }
//             if(state is AuthFailState)return FailBlocWidget(state.error);
//             return Container();
//           },),
//       ),
//     );
//   }
// }


import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:p_4/src/view/presentaion/screens/auth_screen/signup_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../view/presentaion/screens/home_screen.dart';


class AuthCheckWidget extends StatefulWidget {
  const AuthCheckWidget({super.key});

  @override
  State<AuthCheckWidget> createState() => _AuthCheckWidgetState();
}
class _AuthCheckWidgetState extends State<AuthCheckWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<bool>(
          future: isUserLogged(),
          builder: (context, snapshot) {
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:return Center(child: smallLoading(context));
                default:
                log('-------------------------------------${snapshot.data.toString()}');
                  return snapshot.data == true
                      ? const HomeScreen()
                      : const SignupScreen();
              }
            }
        ),
      ),
    );
  }

  Future<bool> isUserLogged()async{
    final SupabaseClient supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;
    final curretnUser = supabase.auth.currentUser?.id;
    if(session != null && curretnUser != null) { return true;}
    else { return false; }
  }
}


