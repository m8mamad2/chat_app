import 'package:p_4/src/view/data/model/user_model.dart';

class CreateGroupEntity{
  final UserModel user;
  final String uid;
  final String name;

  CreateGroupEntity({required this.uid,required this.name,required this.user});
}