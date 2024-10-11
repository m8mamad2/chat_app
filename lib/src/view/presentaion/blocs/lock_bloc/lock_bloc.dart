import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:p_4/src/view/domain/entity/lock_entity.dart';
import 'package:p_4/src/view/domain/usecase/lock_usecase.dart';

part 'lock_event.dart';
part 'lock_state.dart';

class LockBloc extends Bloc<LockEvent, LockStartBloc> {
  final LockUseCase useCase;
  LockBloc(this.useCase) : super(InitialLockStartBloc()) {
    on<LockEvent>((event, emit) async {

      emit(LoadingLockStartBloc());
      
      try{
        if(event is GetLockEvent) {
          final List<LockEntity> data = useCase.getPassword();
          emit(SuccessLockStartBloc(data: data));}
        if(event is SavePasswordLockEvent){
          await useCase.savePassword(event.passwrod);
          emit(SuccessLockStartBloc());}
        if(event is DeleteLockEvent){
          await useCase.deletePassword();
          emit(SuccessLockStartBloc());
        }
      }
      catch(e){ emit(FailLockStartBloc(e.toString())); }

    });
  }
}
