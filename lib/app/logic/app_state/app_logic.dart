import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toly_ui/app/logic/app_state/app_state.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

class AppLogic extends Cubit<AppState>{
  AppLogic():super(AppState(themeMode: ThemeMode.light));

  void changeThemeMode(ThemeMode style) async{
    AppState newState = state.copyWith(themeMode: style);
    // cao.write(newState.toAppConfigPo());
    emit(newState);
  }

  void toggleThemeModel(bool isDark){
    ThemeMode newModel;
    if (isDark) {
      newModel = ThemeMode.dark;
      // $message.changeBrightness(Brightness.dark);
    } else {
      newModel = ThemeMode.light;
      // $message.changeBrightness(Brightness.light);
    }
    changeThemeMode(newModel);
  }
}