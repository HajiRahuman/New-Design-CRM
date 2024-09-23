

import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData/AppColors.dart';
import 'package:flutter/material.dart';



class ColorNotifire with ChangeNotifier {
bool _isDark = false;
  bool get isDark => _isDark;
  ThemePreference _themePreference = ThemePreference(); // Create an instance of ThemePreference

  ColorNotifire() {
    _loadTheme();
  }

  _loadTheme() async {
    _isDark = await _themePreference.getTheme();
    notifyListeners();
  }


  setDarkMode(bool value) {
    _isDark = value;
    notifyListeners(); // This will trigger a rebuild
  }
  void isavalable(bool value) {
    _isDark = value;
    _themePreference.setDarkTheme(value); // Save the preference
    notifyListeners();
  }

  
  get getIsDark => isDark;
  get getprimerycolor => isDark ? darkPrimeryColor : primeryColor;
  get getbgcolor => isDark ? darkbgcolor : bgcolor;
  get getbordercolor => isDark ? darkbordercolor : bordercolor;
  get geticoncolor => isDark ? darkiconcolor : iconcolor;
  get getcontiner => isDark ? darkcontinercolor : continercolor;
  get getcontinershadow => isDark ? darkcontinercolo1r : continercolo1r;

  get getTextColor1 => isDark ? textwhite : textdark;
  get getMainText => isDark ? themgrey : themblack;
  get getMaingey => isDark ? themblackgrey : themlitegrey;

  get getbacknoticolor => isDark ? darkbackcolor : notibackcolor;
  get getsubcolors => isDark ? darksubcolor : notisubcolor;
  get getbacktextcolors => isDark ? darktextcolor : backtextcolor;
  get getfiltextcolors => isDark ? darkfilcolor : filtexcolor;
  get getdolorcolors => isDark ? darkdolorcolor : dolorcolor;
  get getmaintext => isDark ? themblack1 : themgrey1;




}