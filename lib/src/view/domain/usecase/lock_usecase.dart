import 'package:p_4/src/view/domain/repo/lock_repo_head.dart';

import '../entity/lock_entity.dart';

class LockUseCase{
  final LockRepoHeader repo;
  LockUseCase(this.repo);

  List<LockEntity> getPassword() => repo.getPassword();
  Future<void> deletePassword()async => await repo.deletePassword();
  Future<void> savePassword(String password)async => await repo.savePassword(password);
}