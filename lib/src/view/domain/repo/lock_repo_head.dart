import 'package:p_4/src/view/domain/entity/lock_entity.dart';

abstract class LockRepoHeader{
  List<LockEntity> getPassword();
  Future<void> deletePassword();
  Future<void> savePassword(String password);
}