
// ignore_for_file: overridden_fields

import 'package:hive_flutter/hive_flutter.dart';
import 'package:p_4/src/view/domain/entity/lock_entity.dart';

part 'lock_model.g.dart';

@HiveType(typeId: 1)
class LockModel extends LockEntity{

  @override
  @HiveField(0)
  final String id;
  
  @override
  @HiveField(1)
  final String password;
  
  @override
  @HiveField(2)
  final bool isLock;

  LockModel(this.id,this.password,this.isLock) : super(id,password,isLock);
}