
import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/loading.dart';
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
import 'package:p_4/src/view/data/model/message_model.dart';
import 'package:p_4/src/view/data/model/user_model.dart';
import 'package:p_4/src/view/data/repo/chat_repo_body.dart';
import 'package:p_4/src/view/presentaion/blocs/chat_bloc/chat_bloc.dart';
import 'package:p_4/src/view/presentaion/screens/setting_screen/lock_screens/lock_enter_screen.dart';
import 'package:p_4/src/view/presentaion/screens/setting_screen/lock_screens/lock_setting_screen.dart';
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

  UserModel userModel = UserModel(
    uid: 'feb2e7d1-cd88-4e4b-8ad7-b73717c009dc',
    email: 'ms9amdl@mgail.com'
  );

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
            // home: LockSettingScreen(),

          );
        }
        return const MaterialApp();
      }
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}
class _MyWidgetState extends State<MyWidget> {

  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: StreamBuilder(
                stream:BB().s(),
                builder: (context, snapshot) {
                  log('-------------- DATA ${snapshot.connectionState.toString()}');
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:return loading(context);
                    default:
                      return snapshot.data == null || snapshot.data!.isEmpty ? const Text('Null'): ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) => Container(
                          color: Colors.white,
                          alignment: Alignment.topRight,
                          child: Text(snapshot.data![index].messsage,style: TextStyle(color: Colors.black),),
                        ),);
                  }
                },),
            )
          ],
        ),
      )
    );
  }
}
class BB{
  
  StreamController<List<MessageModel>> controller = StreamController.broadcast();
   
  Stream<List<MessageModel>> s () async* {
    final SupabaseClient supabase = Supabase.instance.client;
    String curretnUserID = supabase.auth.currentUser!.id;
    List<String> ids = [curretnUserID,'805ab831-e198-44e6-b959-41bbc311de1b'];
    ids.sort();
    String chatRoomId = ids.join('_');  

    Stream<List<MessageModel>> messagesStream = 
      supabase
        .from('chat')
        .stream(primaryKey: ['id'])
        .limit(15)
        .order('timestamp')
        .eq('chatRoomId', chatRoomId)
        .map((event) => event.map((e) => MessageModel.fromJson(e,curretnUserID)).toList())
        .handleError((error){log(error);})
        .asBroadcastStream();
    
    messagesStream.listen((event) { 
      controller.add(event);
    });
    
          
    yield* controller.stream;
  }

  void disposeStream()=> controller.close();
}


class MyWidget2 extends StatefulWidget {
  const MyWidget2({super.key});

  @override
  State<MyWidget2> createState() => _MyWidget2State();
}
class _MyWidget2State extends State<MyWidget2> {
  
  @override
  void initState() {
    super.initState();
    context.read<MessagesBloc>().add(GetMessageEvent(context: context, receiverId: 'feb2e7d1-cd88-4e4b-8ad7-b73717c009dc', limit: 5));
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      
    );
  }
}