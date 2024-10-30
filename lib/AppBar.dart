// ignore_for_file: deprecated_member_use



import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/Components/DashBoard/DashBoard.dart';
import 'package:crm/Components/DashBoard/SubscriberDashBoard.dart';
import 'package:crm/Components/Subscriber/SubscriberInvoice/SubscriberInvoice.dart';
import 'package:crm/Layout/Search.dart';
import 'package:crm/Providers/providercolors.dart';


import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/main.dart';
import 'package:crm/service/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


class  BottomNavBar extends StatefulWidget implements PreferredSizeWidget {
   final GlobalKey<ScaffoldState> scaffoldKey;

  BottomNavBar({super.key, required this.scaffoldKey});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State< BottomNavBar> createState() => _AppBarCodeState();
}

class _AppBarCodeState extends State< BottomNavBar> {
  bool search = false;
  bool darkMood = false;
  bool isSubscriber = false;
 @override
  void initState(){
  super.initState();
   getMenuAccess();
 }

 String username='';
getMenuAccess() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  setState(() {
    username = pref.getString('username') ?? ''; // Use null safety check
    isSubscriber = pref.getBool('isSubscriber') ?? false;
  });
}

  List<Map<String, dynamic>> fields = [
    {'id': 1, 'label': 'Profile ID', 'key': 'profileid', 'hide': false},
    {'id': 2, 'label': 'Account No', 'key': 'id', 'hide': false},
    {'id': 3, 'label': 'UserName', 'key': 'fullname', 'hide': true},
    {'id': 4, 'label': 'Email', 'key': 'emailpri', 'hide': true},
    {'id': 5, 'label': 'Mobile', 'key': 'mobile', 'hide': true},
    {'id': 6, 'label': 'Local IPV4', 'key': 'ipv4', 'hide': true},
    {'id': 7, 'label': 'Public IPV4', 'key': 'ipaddr', 'hide': true},
    {'id': 8, 'label': 'Mac Address', 'key': 'usermac', 'hide': true},
  ];

  
  void _handleMenuButtonPressed() {
    if (widget.scaffoldKey.currentState!.isDrawerOpen) {
      widget.scaffoldKey.currentState!.openEndDrawer();
    } else {
      widget.scaffoldKey.currentState!.openDrawer();
    }
  }
  @override
  
  Widget build(BuildContext context) {
        final notifier = Provider.of<ColorNotifire>(context);
    return BottomAppBar(
       color: notifier.getprimerycolor,
  shape: const CircularNotchedRectangle(),
  notchMargin: 5.0,
  clipBehavior: Clip.antiAlias,
  child: SizedBox(
    height: kBottomNavigationBarHeight,
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.menu,color: notifier.geticoncolor),
          onPressed: () {
            setState(() {
                _handleMenuButtonPressed();
            });
          },
        ),
        IconButton(
          icon:  Icon(Icons.home,color: notifier.geticoncolor),
          onPressed: () {
            setState(() {
              if(isSubscriber==false){
                  Navigator.pushAndRemoveUntil(
                      navigatorKey.currentContext as BuildContext,
                      MaterialPageRoute(
                          builder: (context) => DashBoard()),
                      (Route<dynamic> route) => false,
                  );
              }else{
                Navigator.pushAndRemoveUntil(
                      navigatorKey.currentContext as BuildContext,
                      MaterialPageRoute(
                          builder: (context) => SubscriberDashBoard(subscriberId: id,)),
                      (Route<dynamic> route) => false,
                  ); 
              }
            });
          
          },
        ),
        IconButton(
          icon:  Icon(Icons.search,color: notifier.geticoncolor,),
          onPressed: () {
            setState(() {
              if(isSubscriber==false){
               _buildSearcDialogBox();
              }
            });
          },
        ),
         PopupMenuButton(
              iconColor:notifier.geticoncolor ,
                                       color: notifier.getcontiner,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  tooltip: username,
                  // offset: Offset(0, constraints.maxWidth >= 800 ? 60 : 50),
                  child: 
                    const   CircleAvatar(
                                radius: 18,
                                backgroundImage:
                                    AssetImage("assets/profile.png"),
                                backgroundColor: Colors.transparent),
                                                       
                           
                          
                        
                      
                  itemBuilder: (ctx) => [
                  
                  
                    _buildPopupAdminMenuItem(context),
                  ],
                ),
      ],
    ),
  )
       );
  }

PopupMenuItem _buildPopupAdminMenuItem(BuildContext context) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);
  
  return PopupMenuItem(
    enabled: false,
    padding: const EdgeInsets.all(0),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 155,
            child: Center(
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(20),
                },
                children: [
                  // Removed the 'Profile' row
                  // Removed the 'Settings' row
                  
                  row(title: 'Logout', icon: 'assets/log-out.svg'),
                  row1(title: 'Theme', icon:  notifier.isDark ? "assets/sun.svg" : "assets/moon.svg", )
                ],
              ),
            ),
          ),
        ],
      ),
  );
}


TableRow row({required String title, required String icon}) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);
  return TableRow(children: [
    TableRowInkWell(
      onTap: () {
        if (title == 'Logout') {
          logout(); // Call logout function when Logout is clicked
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SvgPicture.asset(icon,
            width: 18, height: 18, color: notifier.geticoncolor),
      ),
    ),
    TableRowInkWell(
      onTap: () {
        if (title == 'Logout') {
          logout(); // Call logout function when Logout is clicked
        }
      },
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 5, left: 20, top: 12, right: 20),
        child: Text(title,
            style:
                mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
    ),
  ]);
}
TableRow row1({required String title, required String  icon}) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);
  return TableRow(children: [
    InkWell(
      onTap: () {
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child:SvgPicture.asset(icon,
            width: 18, height: 18, color: notifier.geticoncolor),
      ),
    ),
    InkWell(
     onTap: () async {
        // Toggle the theme here
        bool newTheme = !notifier.isDark;
        notifier.setDarkMode(newTheme);
        await ThemePreference().setDarkTheme(newTheme);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 20, top: 12, right: 20),
        child: Text(title,
            style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
    ),
  ]);
}

Future<void> _buildSearcDialogBox() {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);
  
  return  
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: notifier.getbgcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Search(),
          ),  
        
      );
    },
  );
}

 
  final _formKey = GlobalKey<FormState>();

  Widget _buildcomunbutton(
      {required String title, required Color color, void Function()? ontap}) {
    return ElevatedButton(
        onPressed: (){
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: color.withOpacity(0.1),
            fixedSize: const Size.fromHeight(34)),
        child: Text(
          title,
          style: TextStyle(
              color: color, fontSize: 14, fontWeight: FontWeight.w200),
        ));
  }
  

  bool light1 = true;
}
class ThemePreference {
  static const THEME_STATUS = "THEME_STATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false; // Defaults to light mode
  }
}
