import 'package:p_4/src/view/data/data_source/local/initi_hive.dart';
import 'package:p_4/src/view/data/model/local/lock_model.dart';
import 'package:p_4/src/view/domain/entity/lock_entity.dart';
import 'package:p_4/src/view/domain/repo/lock_repo_head.dart';
import 'package:uuid/uuid.dart';

class LockRepoBody extends LockRepoHeader{
  
  @override
  List<LockEntity> getPassword() => boxList[0].values.toList() as List<LockEntity>;

  @override
  Future<void> deletePassword() async => boxList[0].clear();

  @override
  Future<void> savePassword(String password)async{
    final LockModel data = LockModel(const Uuid().v1(), password, true);
    await boxList[0].put(data.id, data);
  }

}