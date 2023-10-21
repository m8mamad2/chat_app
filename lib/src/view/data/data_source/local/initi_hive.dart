import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:p_4/src/view/data/model/local/lock_model.dart';
import 'package:p_4/src/view/domain/entity/lock_entity.dart';
import 'package:path_provider/path_provider.dart';

List<Box> boxList = [];

Future<List<Box>> openBoxes()async{
  var directory = await getApplicationDocumentsDirectory();

  Hive.init(kIsWeb ? '/assets/' : directory.path);
  Hive.registerAdapter<LockEntity>(LockModelAdapter());

  var lockBox = await Hive.openBox<LockEntity>('lock_box');

  boxList.add(lockBox);

  return boxList;
}