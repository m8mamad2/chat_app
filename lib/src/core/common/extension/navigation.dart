import 'package:flutter/material.dart';

extension Navigate on BuildContext{
  Future navigation(BuildContext context,Widget widget) =>Navigator.of(context).push(MaterialPageRoute(builder: (context) =>widget ,));
  void navigationBack(BuildContext context)=> Navigator.of(context).pop();
}