
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'package:p_4/src/config/theme/theme.dart';
// import 'package:p_4/src/core/common/constance/lotties.dart';
// import 'package:p_4/src/core/common/extension/navigation.dart';
// import 'package:p_4/src/core/common/sizes.dart';
// import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
// import 'package:p_4/src/core/widget/loading.dart';
// import 'package:p_4/src/view/data/repo/user_repo_body.dart';
// import 'package:p_4/src/view/presentaion/blocs/user_bloc/user_bloc.dart';
// import 'package:p_4/src/view/presentaion/screens/setting_screen/bio_screen.dart';
// import 'package:p_4/src/view/presentaion/widget/setting_widget/setting_items_widgets.dart';
// import 'package:p_4/src/view/presentaion/screens/setting_screen/edit_name.dart';
// import 'package:p_4/src/view/presentaion/widget/setting_widget/select_image_profile.dart';

// import '../widget/setting_widget/setting_account_items_widget.dart';
// import '../widget/setting_widget/setting_help_items.dart';

// class SettingScreen extends StatefulWidget {
//   const SettingScreen({super.key});

//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(  
//       body:CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             backgroundColor: theme(context).primaryColor,
//             pinned: true,
//             expandedHeight: sizeH(context)*0.4,
//             leading: IconButton(icon: const Icon(Icons.arrow_back),onPressed: ()=>context.navigationBack(context)),
//             actions: [
//               PopupMenuButton(itemBuilder: (context) => [
//                 popupItem(context, ()=> context.navigation(context, EditNameScreen()) , 'edit Name', Icons.edit),
//                 popupItem(context, ()=> showModalBottomSheet(
//                   context: context,builder: (context) => BottomShetImagesWidget(),), 'Set Profile Image', Icons.image),
//                 ]
//               )
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               centerTitle: true,
//               titlePadding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.06,vertical: sizeH(context)*0.02),
//               title: BlocBuilder<UserBloc,UserState>(
//                     builder: (context, state) {
//                       if(state is UserLoadingState)return loading();
//                       if(state is UserSuccessState){
//                         return Row(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             StreamBuilder<String?>(
//                               stream: state.userPicture,
//                               builder: (context, snapshot) {
//                                 log('${snapshot.connectionState}');
//                                 switch(snapshot.connectionState){
//                                   case ConnectionState.waiting:return const SizedBox.shrink();
//                                   default:
//                                     return snapshot.data != null
//                                       ? CircleAvatar(backgroundColor: Colors.black,backgroundImage: NetworkImage(snapshot.data!),)
//                                       : CircleAvatar(child: kUserPersonLottie,);
//                                 }
//                               },),
//                             sizeBoxW(sizeW(context)*0.01),
//                             StreamBuilder(
//                               stream: state.userModel,
//                               builder: (context, snapshot) {
//                                 switch(snapshot.connectionState){
//                                   case ConnectionState.none:
//                                   case ConnectionState.waiting:return const SizedBox.shrink();
//                                   default:
//                                   return snapshot.data?.name != null  
//                                     ? Text(snapshot.data!.uid!.substring(0,3),style: theme(context).textTheme.labelLarge,)
//                                     : const Text('no name');
//                                 }
//                               },),
//                           ],
//                         );}
//                       if(state is UserFailState)return FailBlocWidget(state.fail);
//                       return Container();
//                     },
//                   ),
//             )
//           ),
//           const SettingAccountItemsWidget(),
//           const SettingImtesWidget(),
//           const SettingHelpWidget()
//         ],
//       )
//     );
//   }


//   @override
//   void initState() {
//     super.initState();
//     context.read<UserBloc>().add(GetUserDataEvent());
//   }

// }

// PopupMenuItem popupItem(BuildContext context,VoidCallback onTap,String title,IconData icon)=>PopupMenuItem(
//   child: InkWell(
//     onTap: onTap,
//     child: Row(
//       children: [
//         Icon(icon,color: Colors.black,),
//         Text(title),
//       ],
//     ),
//   ),);




import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/constance/lotties.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/data/repo/user_repo_body.dart';
import 'package:p_4/src/view/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/user_bloc/user_bloc.dart';
import 'package:p_4/src/view/presentaion/screens/setting_screen/edit_bio_screen.dart';
import 'package:p_4/src/view/presentaion/widget/setting_widget/setting_items_widgets.dart';
import 'package:p_4/src/view/presentaion/screens/setting_screen/edit_name.dart';
import 'package:p_4/src/view/presentaion/widget/setting_widget/select_image_profile.dart';

import '../../../core/widget/cache_image.dart';
import '../widget/setting_widget/setting_account_items_widget.dart';
import '../widget/setting_widget/setting_help_items.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      body:CustomScrollView(
        slivers: [
          SliverAppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(sizeH(context)*0.002),
              child: Container(width: sizeW(context),height: sizeH(context)*0.002,color: theme(context).primaryColor,)),
            backgroundColor: theme(context).scaffoldBackgroundColor,
            pinned: true,
            expandedHeight: sizeH(context)*0.3,
            leading: IconButton(icon: const Icon(Icons.arrow_back),onPressed: ()=>context.navigationBack(context)),
            actions: [
              PopupMenuButton(
                position: PopupMenuPosition.under,
                color: theme(context).backgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color: theme(context).cardColor,width: sizeW(context)*0.0002)),
                itemBuilder: (context) => [
                  popupItem(context, ()=> context.navigation(context, const EditNameScreen()) , 'edit Name', Icons.edit_outlined),
                  popupItem(context, ()=> showModalBottomSheet(
                    shape:const RoundedRectangleBorder( borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),)),
                    context: context,
                    builder: (context) => const BottomShetImagesWidget(),), 'Set Profile Image', Icons.image_outlined),
                  popupItem(context, ()=> context.read<AuthBloc>().add(AuthLogoutEvent(context: context)) , 'logout', Icons.logout_outlined),
                ]
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.7,
              collapseMode: CollapseMode.parallax,
              titlePadding: EdgeInsets.symmetric(horizontal: sizeW(context)*0.06,vertical: sizeH(context)*0.02),
              title: BlocBuilder<GetUserData,GetUserDataState>(
                builder: (context, state) {
                  log(state.toString());
                  if(state is LoadingUserDataState)return smallLoading(context);
                  if(state is LoadedUserDataState){
                    UserModel? data = state.model;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        data != null && data.image != null 
                          ? Container(
                            height: sizeH(context)*0.1,
                            width: sizeW(context)*0.05,
                            decoration: BoxDecoration(
                              color: theme(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: cachedImageWidget(context, data.image!, null,null),
                            ),
                          )
                          : CircleAvatar(child: kUserPersonLottie,),
                        sizeBoxW(sizeW(context)*0.01),
                        data?.name != null  
                          ? Text(data?.name ?? 'nothing',style: theme(context).textTheme.labelLarge!.copyWith(fontFamily: 'header',fontSize: sizeW(context)*0.016),)
                          : const Text('no name'),
                        sizeBoxH(sizeH(context)*0.01)
                      ],
                    );}
                  return Container();
                },
                  ),
            )
          ),
          const SettingAccountItemsWidget(),
          const SettingImtesWidget(),
          const SettingHelpWidget()
        ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<GetUserData>().add(GetUserDataEvent());
  }

}

PopupMenuItem popupItem(BuildContext context,VoidCallback onTap,String title,IconData icon)=>PopupMenuItem(
  child: InkWell(
    onTap: onTap,
    child: SizedBox(
      child: Row(
        children: [
         Icon(icon,color: theme(context).primaryColor,),
         sizeBoxW(sizeW(context)*0.01),
         Text(title,style: theme(context).textTheme.bodyMedium!.copyWith(fontFamily: 'body'),),
        ],
      ),
    )
  ),);



