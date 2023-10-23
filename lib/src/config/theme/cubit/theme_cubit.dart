import 'dart:developer';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:p_4/src/config/theme/theme.dart';
import 'package:p_4/src/core/common/constance/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeEvent{}
class GetThemeEvent extends ThemeEvent{}
class ChangeColorThemeEvent extends ThemeEvent{
  Color? color;
  ChangeColorThemeEvent(this.color);
}
class ChangeLightDarkThemeEvent extends ThemeEvent{}


class ThemeState{}
class InitialThemeState extends ThemeState{}
class LoadedThemeState extends ThemeState{
  final ThemeData theme;
  LoadedThemeState(this.theme);
}


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  late SharedPreferences preferences;
  ThemeBloc() : super(InitialThemeState()) {

    on<ThemeEvent>((event, emit) async{
        preferences = await SharedPreferences.getInstance();

        if(event is ChangeColorThemeEvent){
          
          bool isDark = preferences.getBool('is_dark') ?? false;
          await preferences.setInt('color', event.color?.value ?? 0xff1b2028);
          Color color = event.color ?? Color(preferences.getInt('color') ?? 0xff1b2028);

          isDark == true 
            ? emit(LoadedThemeState(dark(color)))
            : emit(LoadedThemeState(light(color)));
        }

        if(event is ChangeLightDarkThemeEvent){
          bool isDark = preferences.getBool('is_dark') ?? false;
          Color color = Color(preferences.getInt('color') ?? 0xff1b2028);

          emit(LoadedThemeState(isDark ? light(color) : dark(color)));
          await preferences.setBool('is_dark', !isDark);
        }


        if(event is GetThemeEvent){
          bool isDark = preferences.getBool('is_dark') ?? false;
          Color color = Color(preferences.getInt('color') ?? 0xff1b2028);
          emit(LoadedThemeState(isDark == true ? dark(color) : light(color)));
        }
    });

  }

  ThemeData light(Color color)=> ThemeData(
    colorSchemeSeed: color,
    brightness: Brightness.light,
    useMaterial3: true,
    cardColor: Colors.black,//!
    // colorScheme: ColorScheme.light(
    //   primary: color
    // ),
  );
  ThemeData dark(Color color)=> ThemeData(
    colorSchemeSeed: color,
    brightness: Brightness.dark,
    useMaterial3: true,
    cardColor: Colors.white, //! 
  );
}

