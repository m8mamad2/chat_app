import 'package:flutter/material.dart';

extension Navigate on BuildContext{
  Future navigation(BuildContext context,Widget widget) =>Navigator.of(context).push(MaterialPageRoute(builder: (context) =>widget ,));
  Future navigationRemoveUtils(BuildContext context,Widget widget) =>Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>widget ,),(route) => false,);
  void navigationBack(BuildContext context)=> Navigator.of(context).pop();
}