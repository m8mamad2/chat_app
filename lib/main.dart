
import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/auth_check.dart';
import 'package:p_4/src/core/common/internet_check/internet_check_connection.dart';
import 'package:p_4/src/core/widget/is_lock_screen.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/core/widget/not_internet_screen.dart';
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
import 'package:permission_handler/permission_handler.dart';
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
            
            home: SplashScreen(),
            // home: MyWidget(),
          );
        }
        return const MaterialApp();
      }
    );
  }
}

// class NNN extends StatelessWidget {
//   const NNN({
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height,
//       color: Colors.amber,
//       child: StreamBuilder<InternetConnectionStatus>(
//         stream: InternetConnectionChecker().onStatusChange,
//         builder: (context, snapshot){
//             log('{snapshot.connectionState}----${snapshot.data}');
//             switch(snapshot.connectionState){
//               case ConnectionState.none:return Text('none ${snapshot.data}');
//               case ConnectionState.waiting:return Text('Waiting ${snapshot.data}');
//               case ConnectionState.active: return snapshot.data == InternetConnectionStatus.connected ? AuthCheckWidget() : NotInternetScreen();
//               case ConnectionState.done:   return snapshot.data == InternetConnectionStatus.connected ? AuthCheckWidget() : NotInternetScreen();
//             }
//         },
//       ),
//     );
//   }
// }


//! vibraer
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:flutter_vibrate/flutter_vibrate.dart';
// class XXX extends StatefulWidget {
//   const XXX({Key? key}) : super(key: key);
//   @override
//   _XXXState createState() => _XXXState();
// }
// class _XXXState extends State<XXX> {
//   bool _canVibrate = true;
//   final Iterable<Duration> pauses = [
//     const Duration(milliseconds: 500),
//     const Duration(milliseconds: 1000),
//     const Duration(milliseconds: 500),
//   ];
//   @override
//   void initState() {
//     super.initState();
//     _init();
//   }
//   Future<void> _init() async {
//     bool canVibrate = await Vibrate.canVibrate;
//     setState(() {
//       _canVibrate = canVibrate;
//       _canVibrate
//           ? debugPrint('This device can vibrate')
//           : debugPrint('This device cannot vibrate');
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Haptic Feedback Example')),
//         body: Center(
//           child: ListView(children: [
//             ListTile(
//               title: const Text('Vibrate'),
//               leading: const Icon(Icons.vibration, color: Colors.teal),
//               onTap: () {
//                 if (_canVibrate) Vibrate.vibrate;
//               },
//             ),
//             ListTile(
//               title: const Text('Vibrate with Pauses'),
//               leading: const Icon(Icons.vibration, color: Colors.brown),
//               onTap: () {
//                 if (_canVibrate) {
//                   Vibrate.vibrateWithPauses(pauses);
//                 }
//               },
//             ),
//             const Divider(height: 1),
//             ListTile(
//               title: const Text('Impact'),
//               leading: const Icon(Icons.tap_and_play, color: Colors.orange),
//               onTap: () {
//                 if (_canVibrate) {
//                   Vibrate.feedback(FeedbackType.impact);
//                 }
//               },
//             ),
//             ListTile(
//               title: const Text('Selection'),
//               leading: const Icon(Icons.select_all, color: Colors.blue),
//               onTap: () {
//                 if (_canVibrate) {
//                   Vibrate.feedback(FeedbackType.selection);
//                 }
//               },
//             ),
//             ListTile(
//               title: const Text('Success'),
//               leading: const Icon(Icons.check, color: Colors.green),
//               onTap: () {
//                 if (_canVibrate) {
//                   Vibrate.feedback(FeedbackType.success);
//                 }
//               },
//             ),
//             ListTile(
//               title: const Text('Warning'),
//               leading: const Icon(Icons.warning, color: Colors.red),
//               onTap: () {
//                 if (_canVibrate) {
//                   Vibrate.feedback(FeedbackType.warning);
//                 }
//               },
//             ),
//             ListTile(
//               title: const Text('Error'),
//               leading: const Icon(Icons.error, color: Colors.red),
//               onTap: () {
//                 if (_canVibrate) {
//                   Vibrate.feedback(FeedbackType.error);
//                 }
//               },
//             ),
//             const Divider(height: 1),
//             ListTile(
//               title: const Text('Heavy'),
//               leading:
//                   const Icon(Icons.notification_important, color: Colors.red),
//               onTap: () {
//                 if (_canVibrate) {
//                   Vibrate.feedback(FeedbackType.heavy);
//                 }
//               },
//             ),
//             ListTile(
//               title: const Text('Medium'),
//               leading:
//                   const Icon(Icons.notification_important, color: Colors.green),
//               onTap: () {
//                 if (_canVibrate) {
//                   Vibrate.feedback(FeedbackType.medium);
//                 }
//               },
//             ),
//             ListTile(
//               title: const Text('Light'),
//               leading:
//                   Icon(Icons.notification_important, color: Colors.yellow[700]),
//               onTap: () {
//                 if (_canVibrate) {
//                   Vibrate.feedback(FeedbackType.light);
//                 }
//               },
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
// }

//!download proccess 
// class MyWidget extends StatefulWidget {
//   const MyWidget({super.key});
//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }
// class _MyWidgetState extends State<MyWidget> {
//   Stream<Map <Stream<bool> , Map< int , Stream<int> >>> downloadProccess()async*{
//       final vvv = StreamController<Map<Stream<bool>,Map<int,Stream<int>>>>();
//       final downloadingState = StreamController<bool>();
//       final receiverState = StreamController<int>();
//       final client = http.Client();
//       int total=0; //! all data
//       int receiver=0; //! receiver data
//       final List<int> bytes = []; //! downloaded file as byte
//       http.StreamedResponse response = await client.send(http.Request("GET", Uri.parse('https://upload.wikimedia.org/wikipedia/commons/f/ff/Pizigani_1367_Chart_10MB.jpg')));
//       total = response.contentLength ?? 0;
//       response.stream.listen((value) { 
//         bytes.addAll(value);
//         receiver += value.length;
//         receiverState.add(receiver);
//         downloadingState.add(true);
//         vvv.add({ downloadingState.stream : { total : receiverState.stream } });
//       })
//       .onDone((){
//         log('Doned');
//         downloadingState.add(false);
//         vvv.add({ downloadingState.stream : { total : receiverState.stream } });
//         // final file = File();
//         // await file.weiteAsByte(_bytes);
//         // _image = file;
//       });
//       yield*  vvv.stream;
//   }
//   bool start =false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             StreamBuilder(
//               stream: start ? downloadProccess() : const Stream.empty(),
//               builder: (context, snapshot) {
//                 switch(snapshot.connectionState){
//                   case ConnectionState.none:
//                   case ConnectionState.waiting:return loading();
//                   default:
//                    if(snapshot.data == null || snapshot.data!.isEmpty) return const Text('Nothing');
//                    final Map<int,Stream<int>> values = snapshot.data!.values.last;
//                    return Column(
//                     children: [
//                       //! bool
//                       StreamBuilder(
//                         stream: snapshot.data!.keys.last,
//                         builder: (context, snapshot) {
//                           switch(snapshot.connectionState){
//                             case ConnectionState.none:
//                             case ConnectionState.waiting:return loading();
//                             default:
//                               return Text('${snapshot.data}');
//                           }
//                         },),
//                       Text('${values.keys.last ~/ 1024} KB'),
//                       StreamBuilder(
//                         stream: values.values.last,
//                         builder: (context, snapshot) {
//                           switch(snapshot.connectionState){
//                             case ConnectionState.none:
//                             case ConnectionState.waiting:return loading();
//                             default:
//                               return Text(snapshot.data.toString());
//                           }
//                         },),
//                     ],
//                    );
//                 }
//               },),
//             ElevatedButton(
//               onPressed: () async => setState(()=> start = !start),
//               child: Text('data'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class GivePermission extends StatefulWidget {
//   const GivePermission({super.key});
//   @override
//   State<GivePermission> createState() => _GivePermissionState();
// }
// class _GivePermissionState extends State<GivePermission> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         children: [
//           ElevatedButton(onPressed: ()async{
//             await PermissionService().reqqq();
//           }, child: Text('Permission')),
//         ],
//       ),
//     );
//   }
// }

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
