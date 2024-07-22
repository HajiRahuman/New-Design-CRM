import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData.dart';
import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/StaticData.dart';
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class ListHotel extends StatefulWidget {
  const ListHotel({super.key});

  @override
  State<ListHotel> createState() => _ListHotel();
}

class _ListHotel extends State<ListHotel> with SingleTickerProviderStateMixin {
  ColorNotifire notifire = ColorNotifire();
  int currentPage = 1;
  final int itemsPerPage = 5;
  final List<Map<String, String>> subscribers = List.generate(20, (index) {
    return {
      "name": "RAHMAN $index",
      "mobile": "739377399",
      "profileId": "rahman",
      "account": "Active",
      "status": "Online",
    };
  });
 AppConst obj = AppConst();
  final AppConst controller = Get.put(AppConst());
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      
      backgroundColor: notifire.getbgcolor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBoxx(),
                  const ComunTitle(title: 'List Hotel', path: "Hotel"),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, right: padding, left: padding, bottom: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: notifire.getcontiner,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(padding),
                                  child: _buildProfile1(isphon: true),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildPaginationControls(),
                  const SizedBoxx(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Map<String, String>> getItemsForCurrentPage() {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return subscribers.sublist(
      startIndex,
      endIndex > subscribers.length ? subscribers.length : endIndex,
    );
  }

  Widget _buildProfile1({required bool isphon}) {
       final notifier = Provider.of<ColorNotifire>(context);
   
    return Column(
      children: [
        Align(
alignment: Alignment.topRight,
          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: appMainColor,
                              fixedSize: const Size.fromHeight(40),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Add",
                              style: mediumBlackTextStyle.copyWith(
                                  color: Colors.white),
                            )),
        ),
        const SizedBoxx(),
        Row(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: getItemsForCurrentPage().length,
                itemBuilder: (context, index) {
                  final subscriber = getItemsForCurrentPage()[index];
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                             
                           ListTile(
                                   
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage("assets/avatar2.png"),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child:  _buildCommonListTile(title: "LOGIN: ", subtitle: 'login'),
                                 
                                    ),
                                     trailing: PopupMenuButton(
                                      iconColor:notifire.geticoncolor ,
                                       color: notifier.getcontiner,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                                      itemBuilder: (BuildContext context){
                                        
                                        return[
                                        _buildPopupAdminMenuItem()
                                      ];})
                                     
                                   
                                  ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: isphon ? 10 : padding),
                              child: Column(
                                children: [
                                  _buildCommonListTile(title: "ACCOUNT: ", subtitle: 'account'),
                                   const SizedBox(height: 10),
                                  _buildCommonListTile(title: "STATUS: ", subtitle: 'status'),
                                  const SizedBox(height: 10),
                          
                                    _buildCommonListTile(title: "PASSWORD: ", subtitle:'password'),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
 PopupMenuItem _buildPopupAdminMenuItem() {
    return PopupMenuItem(
      enabled: false,
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 200,
            child: Center(
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(20),
                },
                children: [
                  row(title: 'Activation', icon: Icons.edit, index: 13),
                  row(title: 'Change Auth PWD', icon:Icons.key, index: 12),
                 
                 
                 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
bool light1 = true;

TableRow row({required String title, required IconData icon, required int index}) {
  return TableRow(children: [
    TableRowInkWell(
      onTap: () {
        // controller.changePage(index);
        Get.back();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Icon(icon, color: notifire.geticoncolor),
      ),
    ),
    TableRowInkWell(
      onTap: () {
        // controller.changePage(index);
        Get.back();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 20, top: 12, right: 20),
        child: Text(title,
            style: mediumBlackTextStyle.copyWith(color: notifire!.getMainText)),
      ),
    ),
  ]);
}

  Widget _buildCommonListTile({required String title, required String subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: title, style: mediumGreyTextStyle),
              TextSpan(text: subtitle, style: mediumBlackTextStyle.copyWith(color: notifire.getMainText)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationControls() {
    final notifier = Provider.of<ColorNotifire>(context);
    final totalPages = (subscribers.length / itemsPerPage).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back,color: notifier.geticoncolor,),
          onPressed: currentPage > 1
              ? () {
                  setState(() {
                    currentPage--;
                  });
                }
              : null,
        ),
        Text("Page $currentPage of $totalPages",style:  mediumBlackTextStyle.copyWith(color: notifire.getMainText)),
        IconButton(
          icon:Icon(Icons.arrow_forward,      color: notifier.geticoncolor),
          onPressed: currentPage < totalPages
              ? () {
                  setState(() {
                    currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }
}
