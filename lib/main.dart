
import 'dart:ui';
import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData/logger.dart';
import 'package:crm/AppStaticData/routes.dart';
import 'package:crm/Components/Auth/LoginPage.dart';
import 'package:crm/Components/DashBoard/DashBoard.dart';

import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/HomePage.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


String? token;
bool isSubscriber=false;
int id=0;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ColorNotifire()),
        // Other providers...
      ],
      child: MyWidget(),
    ),
  );
}




class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {

  
  userLogin() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('authToken');
    isSubscriber = pref.getBool('isSubscriber') ?? false;
     id = pref.getInt('id') ?? 0 ;
    setState(() {});
    print("Token : $token");
  }

  @override
  void initState() {
    super.initState();
    userLogin();
    _loadTheme();
  }

  void _loadTheme() async {
    bool isDark = await ThemePreference().getTheme();
    Provider.of<ColorNotifire>(context, listen: false).setDarkMode(isDark);
  }

  @override
  Widget build(BuildContext context) {
     final notifier = Provider.of<ColorNotifire>(context);
    logger.i('Application Started');
    // print("Main.dart Token : $token");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ColorNotifire(),
        ),
      ],
      child: GetMaterialApp(
        theme: notifier.isDark ? ThemeData.dark() : ThemeData.light(),
        debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'CRM',
     
        home: token == null || token!.isEmpty ? LoginPage() : isSubscriber ? ViewSubscriber(subscriberId:id )  : DashBoard(),
      ),
    );
  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}