import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget localizationSetup(Widget child)=> EasyLocalization(
  supportedLocales: const [Locale('en','US'),Locale('fa','IR')], 
  path: 'assets/localization',
  child: child, 
  );