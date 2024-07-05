
import 'dart:ui';

import 'package:crm/AppStaticData/logger.dart';
import 'package:crm/AppStaticData/routes.dart';
import 'package:crm/Components/Auth/LoginPage.dart';
import 'package:crm/Components/DashBoard/DashBoard.dart';
import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';



import 'package:shared_preferences/shared_preferences.dart';


String? token;
bool isSubscriber=false;
int id=0;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
  );
  runApp(const MyWidget());
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
    isSubscriber = pref.getBool('isSubscriber') as bool;
     id = pref.getInt('id') as int ;
    setState(() {});
    print("Token : $token");
  }

  @override
  void initState() {
    super.initState();
    userLogin();
  }


  @override
  Widget build(BuildContext context) {
    logger.i('Application Started');
    // print("Main.dart Token : $token");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ColorNotifire(),
        ),
      ],
      child: GetMaterialApp(
        locale: const Locale('en', 'US'),
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.initial,
        getPages: getPage,
        title: 'BMS',
        theme: ThemeData(
            useMaterial3: false,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            fontFamily: "Gilroy",
            dividerColor: Colors.transparent,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color(0xFF0059E7),
            )),
        home: token == null || token!.isEmpty ? LoginPage() : isSubscriber ? ViewSubscriber(subscriberId: id) : DashBoard(),
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