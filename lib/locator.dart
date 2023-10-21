import 'package:get_it/get_it.dart';
import 'package:p_4/src/config/theme/cubit/theme_cubit.dart';
import 'package:p_4/src/view/data/repo/auth_repo.dart';
import 'package:p_4/src/view/data/repo/chat_repo_body.dart';
import 'package:p_4/src/view/data/repo/group_repo_body.dart';
import 'package:p_4/src/view/data/repo/helper/auth_helper_body.dart';
import 'package:p_4/src/view/data/repo/helper/chat_helper_repo_body.dart';
import 'package:p_4/src/view/data/repo/helper/group_helper_repo_body.dart';
import 'package:p_4/src/view/data/repo/helper/user_helper_body.dart';
import 'package:p_4/src/view/data/repo/lock_repo_body.dart';
import 'package:p_4/src/view/data/repo/upload_repo_body.dart';
import 'package:p_4/src/view/data/repo/user_repo_body.dart';
import 'package:p_4/src/view/domain/repo/auth_repo_head.dart';
import 'package:p_4/src/view/domain/repo/chat_repo_header.dart';
import 'package:p_4/src/view/domain/repo/group_repo_head.dart';
import 'package:p_4/src/view/domain/repo/helper/auth_helepr_header.dart';
import 'package:p_4/src/view/domain/repo/helper/chat_helper_repo_header.dart';
import 'package:p_4/src/view/domain/repo/helper/group_helper_repo_heade.dart';
import 'package:p_4/src/view/domain/repo/helper/user_helper_repo_head.dart';
import 'package:p_4/src/view/domain/repo/lock_repo_head.dart';
import 'package:p_4/src/view/domain/repo/upload_repo_head.dart';
import 'package:p_4/src/view/domain/repo/user_repo_head.dart';
import 'package:p_4/src/view/domain/usecase/auth_usecase.dart';
import 'package:p_4/src/view/domain/usecase/chat_usecase.dart';
import 'package:p_4/src/view/domain/usecase/group_usecase.dart';
import 'package:p_4/src/view/domain/usecase/lock_usecase.dart';
import 'package:p_4/src/view/domain/usecase/upload_usecase.dart';
import 'package:p_4/src/view/domain/usecase/user_usecase.dart';
import 'package:p_4/src/view/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/group_bloc/group_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/lock_bloc/lock_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/upload_bloc/upload_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/user_bloc/user_bloc.dart';
import 'package:p_4/src/view/presentaion/blocs/voice_player_bloc/voice_player_bloc.dart';

final GetIt locator = GetIt.instance;

 getItSetup(){
    // locator.registerSingleton<ThemeCubit>(ThemeCubit());

    locator.registerSingleton<AuthRepoHeader>(AuthRepoBody());
    locator.registerSingleton<AuthHelperHeader>(AuthHelperBody(locator()));
    locator.registerSingleton<AuthUseCase>(AuthUseCase(repo: locator()));
    locator.registerSingleton<AuthBloc>(AuthBloc(locator()));

    locator.registerSingleton<ChatRepoHeader>(ChatRepoBody());
    locator.registerSingleton<ChatHelperRepoHeader>(ChatHelperRepoBody(locator()));
    locator.registerSingleton<ChatUseCase>(ChatUseCase(locator()));
    locator.registerSingleton<ChatBloc>(ChatBloc(locator()));

    locator.registerSingleton<GroupRepoHeader>(GroupRepoBody());
    locator.registerSingleton<GroupRepoHelperHeader>(GroupHelperRepoBody(locator()));
    locator.registerSingleton<GroupUsecase>(GroupUsecase(locator()));
    locator.registerSingleton<GroupBloc>(GroupBloc(locator()));

    locator.registerSingleton<UploadRepoHead>(UploadRepoBody());
    locator.registerSingleton<UploadUseCaes>(UploadUseCaes(locator()));
    locator.registerSingleton<UploadBloc>(UploadBloc(locator()));

    locator.registerSingleton<ExistGroupBloc>(ExistGroupBloc(locator()));
    locator.registerSingleton<ExistConversitionBloc>(ExistConversitionBloc(locator()));
    locator.registerSingleton<AllUserBloc>(AllUserBloc(locator()));
    locator.registerSingleton<MessagesBloc>(MessagesBloc(locator()));


    locator.registerSingleton<UserRepoHead>(UserRepoBody());
    locator.registerSingleton<UserHelperRepoHeader>(UserHelperRepoBody(locator()));
    locator.registerSingleton<UserUsecase>(UserUsecase(locator()));
    locator.registerSingleton<UserBloc>(UserBloc(locator()));
    
    locator.registerSingleton<VoicePlayerBloc>(VoicePlayerBloc(locator()));

    locator.registerSingleton<LockRepoHeader>(LockRepoBody());
    locator.registerSingleton<LockUseCase>(LockUseCase(locator()));
    locator.registerSingleton<LockBloc>(LockBloc(locator()));

    locator.registerSingleton<GetUserData>(GetUserData(locator()));
  }