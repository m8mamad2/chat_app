import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

bool isEnglish(BuildContext context)=> context.locale.toString().contains('en_US') == true ? true : false;