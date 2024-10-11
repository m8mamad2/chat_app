part of 'lock_bloc.dart';

@immutable
class LockStartBloc {}

class InitialLockStartBloc extends LockStartBloc {}

class LoadingLockStartBloc extends LockStartBloc {}

class SuccessLockStartBloc extends LockStartBloc {
  final List<LockEntity>? data;
  SuccessLockStartBloc({this.data});
}

class FailLockStartBloc extends LockStartBloc {
  final String fail;
  FailLockStartBloc(this.fail);
}

