
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:p_4/src/core/widget/splash_screen.dart';
import 'package:p_4/src/view/data/data_source/local/initi_hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:p_4/locator.dart';
import 'package:p_4/src/config/theme/cubit/theme_cubit.dart';
import 'package:p_4/src/config/theme/notification/notification_service.dart';
import 'package:p_4/src/core/common/bloc_providers.dart';
import 'package:p_4/src/core/common/constance/texts.dart';
import 'package:p_4/src/core/common/localization_setup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future main()async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(url: kUrlBackendApi, anonKey: kKeyBackendApi);

  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory :await getTemporaryDirectory());

  await EasyLocalization.ensureInitialized();

  await LocalNotificationService().setup();

  await openBoxes();

  await getItSetup();
  
  runApp(localizationSetup(blocProviders(const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key}); 

  @override 
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> { 
  
  @override
  void initState() {
    super.initState();
    context.read<ThemeBloc>().add(GetThemeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc,ThemeState>(
      builder:(context, state) {
        if(state is LoadedThemeState){
          return MaterialApp(
    
            debugShowCheckedModeBanner: false,
        
            //! localization
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
        
            theme: state.theme,
            themeAnimationCurve: Curves.ease,
            themeAnimationDuration: const Duration(microseconds: 1000),
            
            home: SplashScreen(isDark: state.isDark ?? false),
            // home: MyWidget(),

          );
        }
        return const MaterialApp();
      }
    );
  }
}

