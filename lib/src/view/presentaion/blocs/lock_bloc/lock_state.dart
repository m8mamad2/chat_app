part of 'lock_bloc.dart';

@immutable
class LockState {}

class InitialLockState extends LockState {}

class LoadingLockState extends LockState {}

class SuccessLockState extends LockState {
  final List<LockEntity>? data;
  SuccessLockState({this.data});
}

class FailLockState extends LockState {
  final String fail;
  FailLockState(this.fail);
}

