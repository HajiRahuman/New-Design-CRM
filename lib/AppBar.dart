// ignore_for_file: deprecated_member_use



import 'package:crm/AppStaticData.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/StaticData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';


class AppBarCode extends StatefulWidget implements PreferredSizeWidget {
  const AppBarCode({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppBarCode> createState() => _AppBarCodeState();
}

class _AppBarCodeState extends State<AppBarCode> {
  bool search = false;
  bool darkMood = false;
  final AppConst controller = Get.put(AppConst());


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
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context);
    final screenwidth = Get.width;
    bool ispresent = false;
    // getting the value from the provider instance

    const breakpoint = 600.0;

    if (screenwidth >= breakpoint) {
      setState(() {
        ispresent = true;
      });
    }
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GetBuilder<AppConst>(builder: (controller) {
        return AppBar(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: notifier.getbordercolor)),
          backgroundColor: notifier.getprimerycolor,
          elevation: 1,
          leading: ispresent
              ? InkWell(
                  onTap: () {
                    controller.updateshowDrawer();
                  },
                  child: SizedBox(
                      height: 27,
                      width: 27,
                      child: Center(
                          child: SvgPicture.asset(
                        "assets/menu-left.svg",
                        height: 25,
                        width: 25,
                        color: notifier.geticoncolor,
                      ))))
              : InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: SizedBox(
                      height: 27,
                      width: 27,
                      child: Center(
                          child: SvgPicture.asset(
                        "assets/menu-left.svg",
                        height: 25,
                        width: 25,
                        color: notifier.geticoncolor,
                      )))),
          title: search
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                        height: 42,
                        width: Get.width * 0.3,
                        child: TextField(
                          style: TextStyle(color: notifier.getMainText),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(top: 5),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: notifier.getbordercolor, width: 2)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: notifier.getbordercolor, width: 2)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: notifier.getbordercolor, width: 2)),
                            hintStyle: TextStyle(color: notifier.getMainText),
                            hintText: "Search..",
                            prefixIcon: SizedBox(
                                height: 16,
                                width: 16,
                                child: Center(
                                    child: SvgPicture.asset(
                                  "assets/search.svg",
                                  height: 16,
                                  width: 16,
                                  color: notifier.geticoncolor,
                                ))),
                          ),
                        )),
                  ],
                )
              : const SizedBox(),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                constraints.maxWidth < 600
                    ? InkWell(
                       onTap: () {
                          _buildSearcDialogBox();
                        },
                      child: SvgPicture.asset(
                            "assets/search.svg",
                            width: 20,
                            height: 20,
                            color: notifier.geticoncolor,
                          ),
                    )
                    : InkWell(
                        onTap: () {
                          setState(() {
                            search = !search;
                          });
                        },
                        child: 
                        SvgPicture.asset(
                          search ? "assets/times.svg" : "assets/search.svg",
                          width: search ? 16 : 20,
                          height: search ? 16 : 20,
                          color: notifier.geticoncolor,
                        ),
                      ),
                constraints.maxWidth < 600
                    ? const SizedBox()
                    : const SizedBox(
                        width: 10,
                      ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      darkMood = !darkMood;
                    });

                    if (notifier.isDark == false) {
                      notifier.isavalable(true);
                    } else {
                      notifier.isavalable(false);
                    }
                  },
                  child: SvgPicture.asset(
                    darkMood ? "assets/sun.svg" : "assets/moon.svg",
                    width: 20,
                    height: 20,
                    color: notifier.geticoncolor,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
               
                PopupMenuButton(
                  color: notifier.getcontiner,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  tooltip: "Account",
                  offset: Offset(0, constraints.maxWidth >= 800 ? 60 : 50),
                  child: constraints.maxWidth >= 800
                      ? SizedBox(
                          width: 140,
                          child: ListTile(
                            leading: const CircleAvatar(
                                radius: 18,
                                backgroundImage:
                                    AssetImage("assets/profile.png"),
                                backgroundColor: Colors.transparent),
                            title: Text("Buzz",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    color: notifier.getMainText)),
                            trailing: null,
                            subtitle: Row(
                              children: [
                                Text("admin",
                                    style: TextStyle(
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                        color: notifier.getMaingey)),
                                Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 12,
                                  color: notifier.geticoncolor,
                                )
                              ],
                            ),
                          ),
                        )
                      : const CircleAvatar(
                          radius: 18,
                          backgroundImage: AssetImage("assets/profile.png"),
                          backgroundColor: Colors.transparent),
                  itemBuilder: (ctx) => [
                    _buildPopupAdminMenuItem(),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        );
      });
    });
  }


  PopupMenuItem _buildPopupAdminMenuItem() {
    return PopupMenuItem(
      enabled: false,
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            width: 155,
            child: Center(
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(20),
                },
                children: [
                  row(title: 'Profile', icon: 'assets/user.svg', index: 13),
                 
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SvgPicture.asset(
                        "assets/tool.svg",
                        width: 18,
                        height: 18,
                        color: notifire!.geticoncolor,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 5, left: 20, top: 12, right: 20),
                          child: Text("RTL",
                              style: mediumBlackTextStyle.copyWith(
                                  color: notifire!.getMainText)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Obx(() => Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: SizedBox(
                                height: 20,
                                width: 50,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: Switch(
                                    value: controller.switchistrue.value,
                                    onChanged: (bool value) {
                                      controller.switchistrue.value = value;
                                      Future.delayed(
                                        const Duration(milliseconds: 300),
                                        () {
                                          if (value == true) {
                                            Get.updateLocale(
                                                const Locale('ur', 'PK'));
                                            Get.back();
                                          } else {
                                            Get.updateLocale(
                                                const Locale('en', 'US'));
                                            Get.back();
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )),
                      ],
                    )
                  ]),
                  row(title: 'Logout', icon: 'assets/log-out.svg', index: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
 Future<void> _buildSearcDialogBox() {
    return showDialog(
      context: context,
      anchorPoint: const Offset(200, 389),
      builder: (context) {
        return Align(
          alignment: Alignment.topCenter,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                 
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Container(
                    width: 500,
                    decoration: BoxDecoration(
                        color: notifire!.getcontiner,
                        borderRadius: BorderRadius.circular(10)),
                    child: Material(
                      color: notifire!.getcontiner,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: StatefulBuilder(builder: (context, setState) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Universal Search",
                                style: TextStyle(
                                    color: notifire!.getMainText,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                                   Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: DropdownButtonFormField<int>(
                                            style: TextStyle(color: notifire!.getMainText),
                                                                          dropdownColor: notifire!.getcontiner,
                                                                          padding: const EdgeInsets.only(left: 10),
                                                                         decoration: InputDecoration(
                                                                           contentPadding: EdgeInsets.only(left: 15),
                                                              
                                                                            hintStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                            hintText: 'Search Type',
                                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                 color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                                          ),
                                                        
                                                            onChanged: (newValue) async {
                                                              setState(() {
                                                              
                                                              });
                                                          
                                                            },
                                                            items: fields
                                                .map((field) => DropdownMenuItem<int>(
                                              value: field['id'],
                                              child: Text(field['label']),
                                            ))
                                                .toList(),
                                                          
                                                          ),
                                      ),

                                          
                                 const SizedBox(height: 15),
                               
                                Padding(
                                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                        child: DropdownButtonFormField<int>(
                                            style: TextStyle(color: notifire!.getMainText),
                                                                          dropdownColor: notifire!.getcontiner,
                                                                          padding: const EdgeInsets.only(left: 10),
                                                                         decoration: InputDecoration(
                                                                           contentPadding: EdgeInsets.only(left: 15),
                                                              
                                                                            hintStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                            hintText: 'Search',
                                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                 color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                                          ),
                                                        
                                                            onChanged: (newValue) async {
                                                              setState(() {
                                                              
                                                              });
                                                          
                                                            },
                                                            items: fields
                                                .map((field) => DropdownMenuItem<int>(
                                              value: field['id'],
                                              child: Text(field['label']),
                                            ))
                                                .toList(),
                                                          
                                                          ),
                                      ),

                                       Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _buildcomunbutton(
                                    title: 'Close',
                                    color: appMainColor,
                                    ontap: () {
                                      if (_formKey.currentState!.validate()) {}
                                    },
                                  ),
                                ],
                              )
                             
                            
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
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

  TableRow row(
      {required String title, required String icon, required int index}) {
    return TableRow(children: [
      TableRowInkWell(
        onTap: () {
          // controller.changePage(index);
          Get.back();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SvgPicture.asset(icon,
              width: 18, height: 18, color: notifire!.geticoncolor),
        ),
      ),
      TableRowInkWell(
        onTap: () {
          // controller.changePage(index);
          Get.back();
        },
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 5, left: 20, top: 12, right: 20),
          child: Text(title,
              style:
                  mediumBlackTextStyle.copyWith(color: notifire!.getMainText)),
        ),
      ),
    ]);
  }
}
