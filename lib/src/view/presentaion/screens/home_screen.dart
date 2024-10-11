

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/extension/navigation.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/view/presentaion/screens/auth_screen/signup_screen.dart';
import 'package:p_4/src/view/presentaion/screens/setting_screen.dart';
import 'package:p_4/src/view/presentaion/widget/home_widget/home_tab_chat_screen.dart';
import 'package:p_4/src/view/presentaion/widget/home_widget/home_tab_group_screen.dart';

import '../../../core/common/constance/images.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/chat_bloc/chat_bloc.dart';
import '../widget/home_widget/drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2, 
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: sizeH(context)*0.18,
          backgroundColor: theme(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Image.asset(
            kLogoTypograghyImage,
            color: theme(context).cardColor,
            fit: BoxFit.fill,),
          actions: [
            IconButton(onPressed: () => context.navigation(context, const SettingScreen()),icon: Icon(Icons.settings),),
            // IconButton(onPressed:() async{context.read<AuthBloc>().add(AuthLogoutEvent(context: context));context.navigation(context, SignupScreen());},icon: const Icon(Icons.logout)),
          ],
          bottom: TabBar(
            indicatorColor: theme(context).primaryColorDark,
            tabs: [
              Tab(icon: Icon(Icons.chat,color: theme(context).cardColor,),),
              Tab(icon: Icon(Icons.group,color: theme(context).cardColor,),),
            ]),
        ),
        body:const TabBarView(
          children:<Widget> [
            TabChatScreen(),
            TabGroupScreen()
          ]),
        drawer: const HomeDrawerWidget()
      ));
  }
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<ExistConversitionBloc>().add(GetExistConversition(context));
  }
}

