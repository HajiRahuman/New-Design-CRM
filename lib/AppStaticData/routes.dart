// ignore_for_file: prefer_const_constructors




import 'package:crm/HomePage.dart';
import 'package:crm/splash_screen.dart';
import 'package:get/get.dart';




class Routes {
  static String initial = "/";
  static String homepage = "/homePage";
}

final getPage = [
  GetPage(
    name: Routes.initial,
    page: () => SplashScreen(),
  ),
  GetPage(
    name: Routes.homepage,
    page: () => HomePage(),
  ),
];
