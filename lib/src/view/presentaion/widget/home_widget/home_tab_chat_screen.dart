import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/core/common/constance/lotties.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/cache_image.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';
import 'package:p_4/src/view/presentaion/screens/save_message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../config/theme/theme.dart';
import '../../../../core/common/constance/images.dart';
import '../../../../core/widget/loading.dart';
import '../../screens/chat_screen.dart';
import '../../screens/contacts_screen.dart';

class TabChatScreen extends StatefulWidget {
  const TabChatScreen({super.key});

  @override
  State<TabChatScreen> createState() => TabChatScreenState();
}
class TabChatScreenState extends State<TabChatScreen> {

  SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    context.read<ExistConversitionBloc>().add(GetExistConversition(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: BlocBuilder<ExistConversitionBloc,ExistConversitionState>(
        builder: (context, state) {
          if(state is LoadingExistConversitionState)return loading(context);
          if(state is ErrorExistGroupState)return FailBlocWidget('Error');
          if(state is LoadedExistConversitionState) {
            List<UserModel>? data = state.model;
            return data == null || data.isEmpty 
              ? Center(child: startConversitionLottie(context),)
              : ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  thickness: 0.4,
                  indent: sizeW(context)*0.1,
                ),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: data[index].uid == supabase.auth.currentSession!.user.id
                      ? ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme(context).primaryColor,
                          radius: sizeW(context)*0.034,
                          child: Icon(Icons.save,color: theme(context).backgroundColor),),
                        title: Text('Save Message',style: theme(context).textTheme.titleSmall!.copyWith(fontFamily: 'body',fontWeight: FontWeight.w500),),
                        onTap: ()=> context.navigation(context, const SaveMessageScreen()),
                      )
                      : ListTile(
                        onTap: () => context.navigation(context, ChatPage(data: data[index])),
                        title: Text(data[index].name!,style: theme(context).textTheme.titleSmall!.copyWith(fontFamily: 'body',fontWeight: FontWeight.w500),),
                        leading: data[index].image != null && data[index].image!.isNotEmpty
                          ? Container(
                            height: sizeH(context)*0.2,
                            width: sizeW(context)*0.07,
                            decoration: BoxDecoration(
                              color: theme(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: cachedImageWidget(context, data[index].image!, null,null),
                            ),
                          )
                          : Container(
                            decoration: BoxDecoration(
                              color: theme(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            height: sizeH(context)*0.2,
                            width: sizeW(context)*0.07,
                            child: Center(child: Text(data[index].name![0].toUpperCase(),style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).backgroundColor),)),
                          )
                          
                          // : CircleAvatar( 
                          //     backgroundColor: theme(context).primaryColor,
                          //     radius: sizeW(context)*0.034, 
                              // child: Text(data[index].name![0].toUpperCase(),style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).backgroundColor),),),),
                      ),
                  );
                },);}
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme(context).primaryColor,
        heroTag: 'contactsAdd',
        onPressed: () => context.navigation(context, const ContactsScreen()),
        child: Icon(Icons.add,color: theme(context).backgroundColor),),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:p_4/src/core/common/constance/lotties.dart';
// import 'package:p_4/src/core/common/extension/navigation.dart';
// import 'package:p_4/src/core/common/sizes.dart';
// import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
// import 'package:p_4/src/view/data/model/user_model.dart';
// import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
// import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';
// import 'package:p_4/src/view/presentaion/screens/save_message.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../../../config/theme/theme.dart';
// import '../../../../core/common/constance/images.dart';
// import '../../../../core/widget/loading.dart';
// import '../../screens/chat_screen.dart';
// import '../../screens/contacts_screen.dart';

// class TabChatScreen extends StatefulWidget {
//   const TabChatScreen({super.key});

//   @override
//   State<TabChatScreen> createState() => TabChatScreenState();
// }
// class TabChatScreenState extends State<TabChatScreen> {

//   SupabaseClient supabase = Supabase.instance.client;

//   @override
//   void initState() {
//     context.read<ExistConversitionBloc>().add(GetExistConversition(context));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//   return Scaffold(
//       body: BlocBuilder<ExistConversitionBloc,ExistConversitionState>(
//         builder: (context, state) {
//           if(state is LoadingExistConversitionState)return loading(context);
//           if(state is ErrorExistGroupState)return FailBlocWidget('Error');
//           if(state is LoadedExistConversitionState) {
//             List<UserModel>? data = state.model;
//             return data == null || data.isEmpty 
//               ? Center(child: startConversitionLottie(context),)
//               : ListView.separated(
//                 separatorBuilder: (context, index) => Divider(thickness: 0.4,indent: sizeW(context)*0.1,),
//                 shrinkWrap: true,
//                 itemCount: data.length,
//                 itemBuilder: (context, index) {
//                 // return data[index].uid == supabase.auth.currentSession!.user.id 
//                 return ListTile(
//                   minLeadingWidth: sizeW(context)*0.04,
//                   onTap: () => context.navigation(context, ChatPage(data: data[index])),
//                   title: Text(data[index].name!,style: theme(context).textTheme.titleSmall!.copyWith(fontFamily: 'body',fontWeight: FontWeight.w500),),
//                   leading: Container(
//                     width: sizeW(context)*0.1,
//                     color: Colors.amber,

//                   ),
//                   // leading: SizedBox(
//                   //   child: data[index].image != null && data[index].image!.isNotEmpty
//                   //     ? Container(
//                   //       decoration: BoxDecoration(
//                   //         color: theme(context).primaryColor,
//                   //         shape: BoxShape.circle,
//                   //         image: DecorationImage(
//                   //           onError: (exception, stackTrace) => setState(() => AssetImage(kLogoImage)),
//                   //           image: NetworkImage(data[index].image!))
//                   //       ),
//                   //     )
//                   //     : Container(
//                   //       width: sizeW(context)*0.6,
//                   //       decoration: BoxDecoration(
//                   //         color: theme(context).primaryColor,
//                   //         shape: BoxShape.circle,
//                   //       ),
//                   //       child: Text(data[index].name![0].toUpperCase(),style: theme(context).textTheme.titleLarge!.copyWith(fontFamily: 'header',color: theme(context).backgroundColor),),
//                   //     ),
//                   // )
//                   );
//                 },);}
//           return Container();
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: theme(context).primaryColor,
//         heroTag: 'contactsAdd',
//         onPressed: () => context.navigation(context, const ContactsScreen()),
//         child: Icon(Icons.add,color: theme(context).backgroundColor),),
//     );
//   }
// }