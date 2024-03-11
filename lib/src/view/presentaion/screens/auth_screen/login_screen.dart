import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/view/presentaion/widget/auth_widget/auth_button_widget.dart';
import 'package:p_4/src/view/presentaion/widget/auth_widget/auth_textfiled_widget.dart';
import 'package:p_4/src/view/presentaion/screens/auth_screen/signup_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';

import '../../../../core/common/constance/lotties.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isHide = true;
  bool obsucreText = true;
  final GlobalKey<FormState> key = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthBloc,AuthState0>(
          builder: (context, state) {
            log('$state');
            if(state is AuthLoadingState)return loading(context);
            if(state is AuthSucessState || state is AuthInitialState){
              return Form(
                key: key,
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        sizeBoxH(sizeH(context)* 0.1),
                        logoLottie(context),
                        sizeBoxH(sizeH(context)*0.07),
                        Container(
                            margin: EdgeInsets.only(
                              bottom: sizeH(context)*0.05,
                              // right:isEnglish(context) ? sizeW(context)*0.17:0,
                              // left:isEnglish(context) ? 0:sizeW(context)*0.17,
                            ),
                            child: Text('Login to Your Account'.tr(),style: 
                            theme(context).textTheme.titleMedium!.copyWith(fontFamily: 'header'),)),
                        AuthTextFieldWidget(
                          controller: _emailController, 
                          hintText: 'Email', 
                          obsucreText: false, 
                          icon: Icons.email,
                          isHide: isHide,
                          onPressHide: onPressHide,
                          isPassword: false,
                          validatorType: 'email',
                          textInputType: TextInputType.emailAddress,
                          ),
                        AuthTextFieldWidget(
                          controller: _passwordController, 
                          hintText: 'Password', 
                          obsucreText: true, 
                          icon: Icons.password,
                          isHide: isHide,
                          onPressHide: onPressHide,
                          isPassword: true,
                          validatorType: 'password',
                          textInputType: TextInputType.text,
                          ),
                        sizeBoxH(sizeH(context)*0.1),
                        sizeBoxH(sizeH(context)*0.07),
                        authElevatedButton(
                          context,
                          'Login'.tr(),
                          () async {
                            if(key.currentState!.validate()){
                              context.read<AuthBloc>().add(AuthLoginEvent(context: context, password: _passwordController.text.trim(),email: _emailController.text.trim()));
                            }
                          }),
                        sizeBoxH(10),
                        TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(color: theme(context).primaryColorDark,),
                            minimumSize: Size(sizeW(context)*0.33, sizeH(context)*0.12),
                          ),
                          onPressed: ()=> context.navigation(context, const SignupScreen()), 
                          child: Text('Or SignUp'.tr(),style: TextStyle(color: theme(context).primaryColorDark),))
                      ],
                    ),
                  ),
                ),
              );}
            if(state is AuthFailState)return FailBlocWidget(state.error);
            return Container();
          },
        ),
      ),
    );
  }
   void onPressHide() async  {
    setState(() {
       isHide = !isHide;
       obsucreText = !obsucreText;
       });
    }

                        

    // aa()async{
    //   SupabaseClient supabase = Supabase.instance.client;
    //   await supabase.auth.signInWithOtp(
    //     email:_phoneController.text.trim(),);
    // }

}


