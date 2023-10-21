part of 'lock_bloc.dart';

@immutable
class LockEvent {}

class SavePasswordLockEvent extends LockEvent{
  final String passwrod;
  SavePasswordLockEvent(this.passwrod);
}

class GetLockEvent extends LockEvent{}

class DeleteLockEvent extends LockEvent{}

