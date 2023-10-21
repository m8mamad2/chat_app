
import 'package:bloc/bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class FontSizeEvent{}
class InitialFontSizeEvent extends FontSizeEvent{}
class ChangeFontSizeEvent extends InitialFontSizeEvent{
  double fonstSize;
  ChangeFontSizeEvent(this.fonstSize);
}
class GetFontSizeEvent extends InitialFontSizeEvent{}

class FontSizeState{}
class InitialFontSizeState extends FontSizeState{}
class LoadedFontSizeState extends FontSizeState{
  double fontSize;
  LoadedFontSizeState({required this.fontSize});
}

class FontSizeBloc extends Bloc<FontSizeEvent, FontSizeState> {
  late SharedPreferences preferences;
  FontSizeBloc() : super(InitialFontSizeState()) {
    on<InitialFontSizeEvent>((event, emit) async{
      
      preferences = await SharedPreferences.getInstance();
      
      if(event is GetFontSizeEvent){
        double data = preferences.getDouble('font_size')??16;
        emit(LoadedFontSizeState(fontSize: data));
      }

      if(event is ChangeFontSizeEvent){
        await preferences.setDouble('font_size', event.fonstSize);
        emit(LoadedFontSizeState(fontSize: event.fonstSize));
      }

    });
  }
}




abstract class BorderRadiusEvent{}
class InitialBorderRadiusEvent extends BorderRadiusEvent{}
class ChangeBorderRadiusEvent extends InitialBorderRadiusEvent{
  double borderRadius;
  ChangeBorderRadiusEvent(this.borderRadius);
}
class GetBorderRadiusEvent extends InitialBorderRadiusEvent{}

class BorderRadiusState{}
class InitialBorderRadiusState extends BorderRadiusState{}
class LoadedBorderRadiusState extends BorderRadiusState{
  double borderRadius;
  LoadedBorderRadiusState({required this.borderRadius});
}


class BorderRadiusBloc extends Bloc<BorderRadiusEvent, BorderRadiusState> {
  late SharedPreferences preferences;
  BorderRadiusBloc() : super(InitialBorderRadiusState()) {
    on<InitialBorderRadiusEvent>((event, emit) async{
      
      preferences = await SharedPreferences.getInstance();
      
      if(event is GetBorderRadiusEvent){
        double data = preferences.getDouble('border_Radius') ?? 16;
        emit(LoadedBorderRadiusState(borderRadius: data));
      }

      if(event is ChangeBorderRadiusEvent){
        await preferences.setDouble('border_Radius', event.borderRadius);
        emit(LoadedBorderRadiusState(borderRadius: event.borderRadius));
      }

    });
  }
}
