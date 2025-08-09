

import 'package:crm/AppStaticData/logger.dart';
import 'package:crm/Service/versionManagement.dart' as VersionSrv;
import 'package:crm/Providers/providercolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:crm/AppBar.dart';
import 'package:crm/Components/Auth/LoginPage.dart';
import 'package:crm/Components/DashBoard/DashBoard.dart';
import 'package:crm/Components/DashBoard/SubscriberDashBoard.dart';
import 'package:url_launcher/url_launcher.dart';



String? token;
bool isSubscriber = false;
int id = 0;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// Main Application
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ColorNotifire()),
      ],
      child:const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyWidget(),
      ),
    ),
  );
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool isForceUpdate = false;
  bool isUpdateAvailable=false;
  String version = "1.0.0";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GetVersion();
      // checkVersion(context); // Check for updates when the app starts
    });
    userLogin();
    _loadTheme();
  }

  userLogin() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('authToken');
    isSubscriber = pref.getBool('isSubscriber') ?? false;
    id = pref.getInt('id') ?? 0;
    setState(() {});
    print("Token : $token");
  }

  Future<void> GetVersion() async {
    try {
      final resp = await VersionSrv.getVersion(version);
      setState(() {
        isForceUpdate = resp.isForceUpdate;
        isUpdateAvailable = resp.isUpdateAvailable;
        print("Force Update Required: $isForceUpdate");
      });
       if (isUpdateAvailable) {
        Future.delayed(Duration(milliseconds: 500), () {
         showUpdateDialog(context); 
        });
      }
    } catch (e) {
      print("Error fetching version: $e");
    }
  }

void showUpdateDialog(BuildContext context) {
  showDialog(
     barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:const Text("Update Available"),
        content:const Text("A new version of the app is available. Please update to continue."),
        actions: [
          Visibility(
            // visible:isForceUpdate,
            child: TextButton(
              child:const Text("Update"),
              onPressed: () {
              
                launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.gsn.isp"));
              
              },
            ),
          ),
          Visibility(
            visible:isForceUpdate==false,
            child: TextButton(
              child:const Text("Later"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}
  void _loadTheme() async {
    bool isDark = await ThemePreference().getTheme();
    Provider.of<ColorNotifire>(context, listen: false).setDarkMode(isDark);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context);
    logger.i('Application Started');

    return GetMaterialApp(
      theme: notifier.isDark ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'CRM',
      home: token == null || token!.isEmpty
          ? LoginPage()
          : isSubscriber
              ? SubscriberDashBoard(subscriberId: id)
              : DashBoard(),
    );
  }
}