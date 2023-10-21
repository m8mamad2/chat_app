import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  InternetBloc() : super(InitialInternetState()) {
    Stream<InternetConnectionStatus> chekcer = InternetConnectionChecker().onStatusChange;
    
    on<ConnectionCheckEvent>((event, emit)async {
      log('NEMIDANAM 000000000000000000');
      emit(LoadingInternetState());
        
      var check = 
        await chekcer.
        forEach((element) {
            if(element == InternetConnectionStatus.connected){ emit(SuccessInternetState(true));}
            else { emit(SuccessInternetState(false));}})
        .catchError((e)=>emit(FailInternetState(e.toString())));
      check;
        
    });
  }
}
