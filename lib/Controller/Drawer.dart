
import 'package:crm/AppStaticData.dart';
import 'package:crm/CommonBottBar.dart';

import 'package:crm/Providers/providercolors.dart';
import 'package:crm/StaticData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';


class DarwerCode extends StatefulWidget {
  const DarwerCode({super.key});

  @override
  State<DarwerCode> createState() => _DarwerCodeState();
}

class _DarwerCodeState extends State<DarwerCode> {
  AppConst obj = AppConst();
  final AppConst controller = Get.put(AppConst());

  final screenwidth = Get.width;
  bool ispresent = false;

  static const breakpoint = 600.0;

  @override
  Widget build(BuildContext context) {
        final notifier = Provider.of<ColorNotifire>(context);
    if (screenwidth >= breakpoint) {
      setState(() {
        ispresent = true;
      });
    }

    return GetBuilder<AppConst>(builder: (controller) {
      return SafeArea(
        child: Consumer<ColorNotifire>(
          builder: (context, value, child) => Drawer(
            backgroundColor: notifire!.getprimerycolor,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: notifire!.getbordercolor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: ispresent ? 30 : 15,
                      top: ispresent ? 24 : 20,
                      bottom: ispresent ? 10 : 12),
                  child: InkWell(
                    onTap: () {
                      controller.changePage(0);
                      Get.back();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/applogo.svg",
                          height: 48,
                          width: 48,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('C R M',style: TextStyle(color: notifire!.getTextColor1),),

                        const SizedBox(
                          height: 5,
                        ),
                       
                      ],
                    ),
                  ),
                ),
              
              
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDivider(title: 'GENERAL'),
                            SizedBox(
                              height: ispresent ? 10 : 8,
                            ),

                            _buildSingletile(
                                header: "Dashboards",
                                iconpath: "assets/home.svg",
                                index: 0,
                                ontap: () {
                                  controller.changePage(0);
                                  Get.back();
                                 
                                }),
                                 _buildSingletile(
                                header: "Franchise",
                                iconpath: "assets/receipt-list-alt.svg",
                                index: 1,
                                ontap: () {
                                  controller.changePage(4);
                                  Get.back();
                                 
                                }),
                              _buildexpansiontilt(
                                index: 3,
                                children: Row(
                                  children: [
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          height: ispresent ? 12 : 10,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              controller.changePage(1);
                                              Get.back();
                                            
                                            },
                                            child: Row(
                                              children: [
                                                _buildcomunDesh(index:3),
                                                _buildcomuntext(
                                                    title: 'List Subscriber', index: 3),
                                              ],
                                            )),
                                        _buildsizeboxwithheight(),
                                       
                                      ],
                                    ),
                                  ],
                                ),
                                header: 'Subscriber',
                                iconpath: 'assets/users.svg'),
                                _buildexpansiontilt(
                                index: 4,
                                children: Row(
                                  children: [
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          height: ispresent ? 12 : 10,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              controller.changePage(3);
                                              Get.back();
                                            
                                            },
                                            child: Row(
                                              children: [
                                                _buildcomunDesh(index:4),
                                                _buildcomuntext(
                                                    title: 'List Hotel', index:3),
                                              ],
                                            )),
                                        _buildsizeboxwithheight(),
                                       
                                      ],
                                    ),
                                  ],
                                ),
                                header: 'Hotel',
                                iconpath: 'assets/grid-circle.svg'),
                              _buildSingletile(
                                header: "Complaints",
                                iconpath: "assets/pen.svg",
                                index: 2,
                                ontap: () {
                                  controller.changePage(6);
                                  Get.back();
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                  const ComunBottomBar(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildsizeboxwithheight() {
    return SizedBox(
      height: ispresent ? 25 : 20,
    );
  }

  Widget _buildcomuntext({required String title, required int index}) {
    return Obx(
      () => Text(title,
          style: mediumGreyTextStyle.copyWith(
              fontSize: 13,
              color: controller.pageselecter.value == index
                  ? appMainColor
                  : notifire!.getMainText)),
    );
  }

  Widget _buildcomunDesh({required int index}) {
    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/minus.svg",
              color: controller.pageselecter.value == index
                  ? appMainColor
                  : notifire!.getMainText,
              width: 6),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
    );
  }

  Widget _buildexpansiontilt(
      {required Widget children,
      required String header,
      required String iconpath,
      required int index}) {
    return ListTileTheme(
      horizontalTitleGap: 12.0,
      dense: true,
      child: Theme(
         data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          
          title: Text(
            header,
            style: mediumBlackTextStyle.copyWith(
                fontSize: 14, color: notifire!.getMainText),
          ),
          leading: SvgPicture.asset(iconpath,
              height: 18, width: 18, color: notifire!.getMainText),
          tilePadding:
              EdgeInsets.symmetric(vertical: ispresent ? 5 : 2, horizontal: 8),
          iconColor: appMainColor,
          collapsedIconColor: Colors.grey,
          children: <Widget>[children],
        ),
      ),
    );
  }

  Widget _buildSingletile(
      {required String header,
      required String iconpath,
      required int index,
      required void Function() ontap}) {
    return Obx(() => ListTileTheme(
          horizontalTitleGap: 12.0,
          dense: true,
          child: ListTile(
            hoverColor: Colors.transparent,
            onTap: ontap,
            title: Text(
              header,
              style: mediumBlackTextStyle.copyWith(
                  fontSize: 14,
                  color: controller.pageselecter.value == index
                      ? appMainColor
                      : notifire!.getMainText),
            ),
            leading: SvgPicture.asset(iconpath,
                height: 18,
                width: 18,
                color: controller.pageselecter.value == index
                    ? appMainColor
                    : notifire!.getMainText),
            trailing: const SizedBox(),
            contentPadding: EdgeInsets.symmetric(
                vertical: ispresent ? 5 : 2, horizontal: 8),
          ),
        ));
  }

  Widget _buildDivider({required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            height: ispresent ? 15 : 10,
            width: ispresent ? 230 : 260,
            child: Center(
                child: Divider(color: notifire!.getbordercolor, height: 1))),
        SizedBox(
          height: ispresent ? 15 : 10,
        ),
        Text(
          title,
          style: mainTextStyle.copyWith(
              fontSize: 14, color: notifire!.getMainText),
        ),
        SizedBox(
          height: ispresent ? 10 : 8,
        ),
      ],
    );
  }
}

//9c9caa
