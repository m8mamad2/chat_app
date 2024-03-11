import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/locator.dart';
import 'package:p_4/src/config/theme/cubit/theme_cubit.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/lock_bloc/lock_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/setting_blocs/font_size_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/upload_bloc/upload_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/user_bloc/user_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/voice_player_bloc/voice_player_bloc.dart';

import '../../view/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'internet_check/bloc/internet_bloc.dart';
import 'internet_check/internet_check_connection.dart';

  Widget blocProviders(Widget child)=> MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(create: (context) => locator(),),
      // BlocProvider<ThemeCubit>(create: (context) => locator(),),
      BlocProvider<ChatBloc>(create: (_) => locator(),),
      BlocProvider<GroupBloc>(create: (_) => locator(),),
      BlocProvider<UploadBloc>(create: (_) => locator(),),
      BlocProvider<ExistGroupBloc>(create:(_) => locator()),
      BlocProvider<ExistConversitionBloc>(create:(_) => locator()),
      BlocProvider<AllUserBloc>(create:(_) => locator()),
      BlocProvider<UserBloc>(create:(_) => locator()),
      BlocProvider<VoicePlayerBloc>(create:(_) => locator()),
      BlocProvider<LockBloc>(create:(_) => locator()),
      BlocProvider<GetUserData>(create:(_) => locator()),
      BlocProvider<MessagesBloc>(create:(_) => locator()),
      BlocProvider<FontSizeBloc>(create:(_) => FontSizeBloc()),
      BlocProvider<BorderRadiusBloc>(create:(_) => BorderRadiusBloc()),
      BlocProvider<ThemeBloc>(create:(_) => ThemeBloc()),
      BlocProvider<InternetBloc>(create:(_) => InternetBloc()),
      BlocProvider<GroupMessageBloc>(create:(_) => locator()),
    ], 
    child: child);
    