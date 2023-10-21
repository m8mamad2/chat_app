
import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p_4/src/core/common/sizes.dart';
import 'package:p_4/src/core/widget/fail_bloc_widget.dart';
import 'package:p_4/src/core/widget/loading.dart';
import 'package:p_4/src/view/data/repo/chat_repo_body.dart';

abstract class MMMEvent{}
class ChangeConnectionEvent extends MMMEvent{}
class B extends MMMEvent{}

abstract class MMMState{}
class InitialMMMState extends MMMState{}
class LoadingMMMState extends MMMState{}
class SuccessMMMState extends MMMState{
  final bool isConnected;
  SuccessMMMState(this.isConnected);
}
class FailMMMState extends MMMState{
  String fail;
  FailMMMState(this.fail);
}

class MMMBloc extends Bloc<MMMEvent, MMMState> {
  
  MMMBloc() : super(InitialMMMState()) {

    Stream<InternetConnectionStatus> ss = InternetConnectionChecker().onStatusChange;

    on<B>((event, emit)async {
      emit(LoadingMMMState());

     var a = await ss.forEach((element) {
        if(element == InternetConnectionStatus.connected){
          emit(SuccessMMMState(true));
        }
        else { emit(SuccessMMMState(false));}

       }).catchError((e)=>emit(FailMMMState(e.toString())));
      
      a;
      
    },);
    // ignore: void_checks
    on<ChangeConnectionEvent>((event, emit)async*{
      log('INNININININI');
      emit(LoadingMMMState());

      yield ss.forEach((element) {
        if(element == InternetConnectionStatus.connected){
          emit(SuccessMMMState(true));
        }
        else { emit(SuccessMMMState(false));}

       }).catchError((e)=>emit(FailMMMState(e.toString())));
      
    //  yield InternetConnectionChecker().onStatusChange.listen((event)async {
    //     if (event == InternetConnectionStatus.connected){ emit(SuccessMMMState(true)); }
    //     else { emit(SuccessMMMState(false)); 
    //     }
    //   },);
    });

  }
}


class MMMScsren extends StatefulWidget {
  const MMMScsren({super.key});

  @override
  State<MMMScsren> createState() => _MMMScsrenState();
}
class _MMMScsrenState extends State<MMMScsren> {
 
 @override
  void initState() {
    context.read<MMMBloc>().add(B());
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<MMMBloc,MMMState>(
          listener: (context, state) {
            log('in Listener $state');
            if(state is SuccessMMMState){
              state.isConnected == true ? log('TRUE __+++') : log("FALSE __++");
            }
          },
          builder: (context, state) {
            log('in Builder $state');
            if(state is InitialMMMState|| state is LoadingMMMState)return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: ()=> context.read<MMMBloc>().add(ChangeConnectionEvent()), child: Text('Fi')),
                  ElevatedButton(onPressed: ()=> context.read<MMMBloc>().add(B()), child: Text('B')),
                ],
              ),
            );
            if(state is SuccessMMMState){
              return Text('Data is : ${state.isConnected}');
            }
            if(state is FailMMMState)return Text('Error');
            return Container(
              width: 100,
              height: 100,
              color: Colors.amber,
            );
          },
        ),
      ),
    );
  }
}










final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class CheckMyConnection {
  static bool isConnect = false;
  static bool isInit = false;

  static hasConnection( {required void Function() hasConnection, required void Function() noConnection}) async {
    Timer.periodic(const Duration(seconds: 1), (_) async {
      isConnect = await InternetConnectionChecker().hasConnection;
      if (isInit == false && isConnect == true) {
        isInit = true;
        hasConnection.call();
      } else if (isInit == true && isConnect == false) {
        isInit = false;
        noConnection.call();
      }
    });
  }
}


class Base extends StatefulWidget {
  final String title;
  const Base({Key? key, required this.title}) : super(key: key);

  @override
  State<Base> createState() => _BaseState();
}
class _BaseState extends State<Base> {
  final snackBar1 = SnackBar(
    content: const Text(
      'Internet Connected',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green,
  );

  final snackBar2 = SnackBar(
    content: const Text(
      'No Internet Connection',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
  );

  @override
  void initState() {
    super.initState();
    CheckMyConnection.hasConnection(hasConnection: () {
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(snackBar1);
    }, noConnection: () {
      ScaffoldMessenger.of(navigatorKey.currentContext!)
          .showSnackBar(snackBar2);
    });
  }

  @override
  Widget build(BuildContext context) {
  return DefaultTabController(
        length: 3,
        child: Scaffold(
          key: navigatorKey,
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      );
  }
}