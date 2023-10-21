
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:p_4/src/core/common/extension/navigation.dart';
// import 'package:p_4/src/core/widget/loading.dart';
// import 'package:p_4/src/view/presentaion/blocs/auth_bloc/auth_bloc.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../../../core/widget/auth_check.dart';

// class OTPScreen extends StatefulWidget {
//   final String phone;
//   const OTPScreen({super.key,required this.phone});

//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }
// class _OTPScreenState extends State<OTPScreen> {

//   final TextEditingController _otpController = TextEditingController();
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(controller: _otpController,decoration:const InputDecoration(hintText: 'enter Otp Code'),),
//             BlocBuilder<AuthBloc,AuthState0>(
//               builder: (context, state) {
//                 if(state is AuthLoadingState)return loading();
//                 if(state is AuthFailState)return Container(width: 100,height: 100,color: Colors.amber,);
//                 if(state is AuthSucessState) {
//                   return ElevatedButton(
//                     onPressed: ()async => context.read<AuthBloc>().add(AuthVeriFyEvent(context: context, phone: widget.phone, token: _otpController.text.trim())),
//                     child: const Text('verify'));
//                 }
//                 return Container();
//               },
//             ),
//             ElevatedButton(onPressed: ()=>context.navigation(context, const AuthCheckWidget()), child: const Text('Let Go'))
//           ],
//         ),
//       ),
//     );
//   }
// }