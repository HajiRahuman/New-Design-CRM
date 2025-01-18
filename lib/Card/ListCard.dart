
import 'dart:convert';

import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Card/CardAddUpdate.dart';
import 'package:crm/Card/ChangecardProAuthPwd.dart';
import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Utils/Utils.dart';
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/model/card.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:crm/service/card.dart' as cardSrv;
import 'package:shared_preferences/shared_preferences.dart';

class ListCard extends StatefulWidget {
 final int? id;
  final bool? search;
  const ListCard({super.key,  this.id, this.search});

  @override
  State<ListCard> createState() => _ListCard();
}

class _ListCard extends State<ListCard> with SingleTickerProviderStateMixin {
  ColorNotifire notifire = ColorNotifire();
  int currentPage = 1;
  final int itemsPerPage = 5;
  bool isSearching = false;
  bool row = false;
  String selectedValue1 = 'Subscriber ID';
  
 
  bool isLoading = false; // Add a loading flag
  
  int limit = 5;

 List<CardDet> listCard = [];
Future<void> getListCard() async {
  setState(() {
    isLoading = true;
  });
    CardResp resp;

  // Choose the appropriate service call based on the value of `widget.search`
  if (widget.search == true) {
    resp = await cardSrv.listCardSearch(widget.id!);
  } else {
    resp =  await cardSrv.listCard();
  }
  
  setState(() {
    if (resp.error) {
      alert(context, resp.msg);
    }
    listCard  = resp.error == true ? [] : resp.data ?? [];
   
    isLoading = false;
  });
}
 String? menuIdString = '';
  List<int> menuIdList = [];
Future<void> getMenuAccess() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
     
      menuIdString = pref.getString("menu_id");

      // Safely decode menu_id string into a list
      if (menuIdString != null) {
        try {
          menuIdList = List<int>.from(jsonDecode(menuIdString!));
        } catch (e) {
          menuIdList = [];

          print("Error decoding menu_id: $e");
        }
      } else {
        menuIdList = [];
      }
    });

    
  }
  @override
  void initState() {
    super.initState();
   getListCard();
   getMenuAccess();
  }

  void navigateToViewSubscriber(int subscriberId, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListCard(id:subscriberId),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 List<Map<String, dynamic>> cardTypeList = [
  {'id': 0, 'label': 'No Card'},
  {'id': 1, 'label': 'Hotel Rooms'},
  {'id': 2, 'label': 'One Time'},
  {'id': 3, 'label': 'Refill'},
];
String getCardTypeLabel(int id) {
  final type = cardTypeList.firstWhere((element) => element['id'] == id, orElse: () => {'label': '---'});
  return type['label'] as String;
}

List<Map<String, dynamic>> card_expiry = [
  {'id': 0, 'label': 'Defined By Valid'},
  {'id': 1, 'label': 'Calculated From Card Activation'},
];
String getCardExpiryLabel(int id) {
  final type = card_expiry.firstWhere((element) => element['id'] == id, orElse: () => {'label': '---'});
  return type['label'] as String;
}

 List<Map<String, dynamic>> carddurationtype= [
  {'id': 0, 'label': 'Days'},
  {'id': 1, 'label': 'Months'},
  {'id': 2, 'label': 'Minutes'},
];
String getCarddurationtypeLabel(int id) {
  final type = carddurationtype.firstWhere((element) => element['id'] == id, orElse: () => {'label': '---'});
  return type['label'] as String;
}
  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    final notifier = Provider.of<ColorNotifire>(context);
      // double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DarwerCode(), 
      key: _scaffoldKey,
      backgroundColor: notifire.getbgcolor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBoxx(),
                      const ComunTitle(title: 'List Card', path: "Card"),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, right:8, left: 8, bottom: 0),
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
                                      padding: const EdgeInsets.all(8),
                                      child: _buildProfile1(isphon: true),
                                    ),
                                  ),
                                ],
                              ),
                             
                            ],
                          ),
                        ),
                      ),
                      const SizedBoxx(),  
                    ],
                  ),
                ),
                if (isLoading) 
                           Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(
                          
                          ),
                        ),
                      ),
                    ), 
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shadowColor: notifier.getprimerycolor,
        color: notifier.getprimerycolor,
        surfaceTintColor: notifier.getprimerycolor,
        child: BottomNavBar(scaffoldKey: _scaffoldKey),
      ),
    );
  }

  Widget _buildProfile1({required bool isphon}) {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage < listCard .length)
        ? startIndex + itemsPerPage
        : listCard .length;

    final paginatedList = listCard .sublist(startIndex, endIndex);
    final notifier = Provider.of<ColorNotifire>(context);
  double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: appMainColor,
                fixedSize: const Size.fromHeight(40),
              ),

              onPressed: () {
                if (  menuIdList.any((id) => [
                                        1002, 1003
                                        ].contains(id))) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                  return CardAddUpdate(card: null,);
                }));
                }
              },
              child: Text(
                "Generate Card",
                style: mediumBlackTextStyle.copyWith(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () async {
                  getListCard();
                },
                icon: Icon(Icons.refresh, color: notifier.getMainText),
              ),
            ),
          ],
        ),
        // const SizedBox(height: 10),
        // Show loading indicator or the list of subscribers based on isLoading
      Row(
                children: [
                    Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                             itemCount: paginatedList.length,
                              itemBuilder: (context, index) {
                          
                               final cardsubs = paginatedList[index];   
                                             
                                return Column(
                                  children: [
                                    Container(
                                       padding:const EdgeInsets.all(0),
                                                            decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                                            ),
                                      child: Column(
                                        children: [
                                           
                                          Padding(
                                            padding: const EdgeInsets.all(0),
                                            
                                              child: ExpansionTile(
                                                collapsedIconColor:  notifier.getMainText ,
                                                iconColor: notifier.getMainText ,
                                                expandedAlignment:
                                                Alignment.topLeft,
                                                leading:  Text(
                                                  'ID',
                                                  // ignore: deprecated_member_use
                                                  textScaleFactor: 1,
                                               style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                ),
                                                title:
                                                Row(
                                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(cardsubs.id.toString(),
                                                        // ignore: deprecated_member_use
                                                        textScaleFactor: 1,
                                                          style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                    ),
                                                  
                                       PopupMenuButton(
                                      iconColor: notifier.geticoncolor ,
                                       color: notifier.getcontiner,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                                      itemBuilder: (BuildContext context){
                                        
                                        return[
                                        _buildPopupAdminMenuItem(cardsubs),
                                      ];}) 
                                              
                                                    
                                                  ],
                                                ),
                                                children: [
                                                  Column(
                                                    children: [
                                                       SizedBox(
                                                  height: 150,
                                                  width: screenWidth,
                                                   child: ListView(
                                                     scrollDirection: Axis.horizontal,
                                                    
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.topLeft,
                                                        child: SingleChildScrollView(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Table(
                                                              border: TableBorder.all(borderRadius: BorderRadius.circular(10),color: notifier.getMainText ),
                                                              columnWidths: const {
                                                                0: FixedColumnWidth(150),
                                                                1: FixedColumnWidth(150),
                                                                2: FixedColumnWidth(150),
                                                                3: FixedColumnWidth(150),
                                                                4: FixedColumnWidth(150),
                                                                5: FixedColumnWidth(150),
                                                                6: FixedColumnWidth(150),
                                                                7: FixedColumnWidth(150),
                                                                 8: FixedColumnWidth(150),
                                                                 9: FixedColumnWidth(150),
                                                                 10: FixedColumnWidth(150),
                                                                 11: FixedColumnWidth(150),
                                                                 12: FixedColumnWidth(150),
                                                                 13: FixedColumnWidth(150),
                                                                 14: FixedColumnWidth(150),
                                                              },
                                                              children: [
                                                                 TableRow(
                                                                
                                                                  children: [
                                                                    Text(
                                                                      "PACKAGE",
                                                                      textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                     Text(
                                                                      "MODE",
                                                                      textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                     Text(
                                                                      "RESELLER",
                                                                      textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "D/L",
                                                                      textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "U/L",
                                                                         textAlign: TextAlign.center,
                                                                      style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                   
                                                                    Text(
                                                                      "TOTAL",
                                                                         textAlign: TextAlign.center,
                                                                      style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "ONLINE TIME",
                                                                         textAlign: TextAlign.center,
                                                                    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "TYPE",
                                                                         textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "PRICE",
                                                                         textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "EXPIRY",
                                                                         textAlign: TextAlign.center,
                                                                    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "DURATION TYPE",
                                                                         textAlign: TextAlign.center,
                                                                    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                   
                                                                  ],
                                                                ),
                                                                // dividerRow(const Color(0xff7366ff)),
                                                                // ignore: unused_local_variable
                                                                // for (var invoices in  listSubsInvoive) ...[
                                                                  
                                                                  newRow(
                                                                 package: cardsubs.packName,
                                                                 mode:cardsubs.packMode ,
                                                                 reseller:cardsubs.resellerId ,
                                                                 dlLimit: formatBytes(cardsubs.dlLimit),
  upLimit: formatBytes(cardsubs.upLimit),
  totalLimit: formatBytes(cardsubs.totalLimit),
  onlineLimit: formatBytes(cardsubs.timeLimit),
                                                                 type:cardsubs.cardType ,
                                                                 price:cardsubs.cardPrice ,
                                                                 expiry: cardsubs.cardExpiry,
                                                                 cardduration:cardsubs.cardDuration, cardDurationType: cardsubs.cardDurationType ,
                                                                    
                                                                
                                                                  ),
                                                                  // dividerRow(Colors.red),
                                                                // ],
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                                                       ),
                                                 ),
                                                    
                                                     
                                                    ],
                                                  ),
                                                ],
                                              
                                            ),
                                          ),
                                         Divider(color: Colors.grey.withOpacity(0.3)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      children: [
                                        _buildCommonListTile(title: "PROFILE", subtitle: ": ${cardsubs.profileId}"),
                                    
                                    _buildCommonListTile(title: "AUTH PWD", subtitle:": ${cardsubs.authPassword}"),
                                      _buildCommonListTile(title: "PACKAGE", subtitle:": ${cardsubs.packName}"),
                                       _buildCommonListTile(title: "EXPIRATION", subtitle:": ${cardsubs.expiration.isNotEmpty 
                                           ? DateFormat('MMM dd, yyyy ,hh:mm:ss a').format(DateTime.parse(cardsubs.expiration).toLocal()) 
                                       : "---"}"),
                                    
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
                            )),
            //   
                ],
              ),
              if(widget.search!=true)
        _buildPaginationControls()
      ],
    );
  }

   PopupMenuItem _buildPopupAdminMenuItem(CardDet cardsubs) {
  // final notifier = Provider.of<ColorNotifire>(context, listen: false);
  return PopupMenuItem(
    enabled: false,
    padding: const EdgeInsets.all(0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          width:250,
          child: Center(
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(20),
              },
              children: [
                row1(title: 'Update', icon: Icons.edit, cardsubs: cardsubs, context: context),
                row1(title: 'Update Profile PWD', icon: Icons.key, cardsubs: cardsubs, context: context),
                   row1(title: 'Update Authentication PWD', icon: Icons.key, cardsubs: cardsubs, context: context),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

bool light1 = true;
TableRow row1({required String title, required IconData icon, required CardDet cardsubs,  required BuildContext context,}) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);
  return TableRow(children: [
    TableRowInkWell(
      onTap: () {
        Navigator.of(context).pop();
        if (title == 'Update') {
          showDialog(
            context: context,
            builder: (ctx) =>
                Dialog.fullscreen(
                  backgroundColor: notifier.getbgcolor,
                  child: CardAddUpdate(card: cardsubs),
                ),
          ).then((val) => {
            // print('dialog--$val'),
             if (val == true) {
               getListCard()
            }
          
          }); // Call logout function when Logout is clicked
        }
        if (title == 'Update Profile PWD') {
          showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  backgroundColor: notifier.getbgcolor,
                  actions: [ChangeCardProAuthPwd(card: cardsubs, title: 'Update Profile PWD',)],
                ),
          ).then((val) => {
            if (val == true) {
               getListCard()
            }
          });
        }
         if (title == 'Update Authentication PWD') {
          showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  backgroundColor: notifier.getbgcolor,
                  actions: [ChangeCardProAuthPwd(card: cardsubs, title: 'Update Authentication PWD',)],
                ),
          ).then((val) => {
           if (val == true) {
               getListCard()
            }
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Icon(icon, color: notifier.geticoncolor),
      ),
    ),
    TableRowInkWell(
      onTap: () {
        Navigator.of(context).pop();
       if (title == 'Update') {
          showDialog(
            context: context,
            builder: (ctx) =>
                Dialog.fullscreen(
                  backgroundColor: notifier.getbgcolor,
                    child: CardAddUpdate(card: cardsubs),
                ),
          ).then((val) => {
            if (val == true) {
               getListCard()
            }
          }); // Call logout function when Logout is clicked
        }
        if (title == 'Update Profile PWD') {
          showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  backgroundColor: notifier.getbgcolor,
                  actions: [ChangeCardProAuthPwd(card: cardsubs, title: 'Update Profile PWD',)],
                ),
          ).then((val) => {
            if (val == true) {
               getListCard()
            }
          });
        }
         if (title == 'Update Authentication PWD') {
          showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  backgroundColor: notifier.getbgcolor,
                  actions: [ChangeCardProAuthPwd(card: cardsubs, title: 'Update Authentication PWD',)],
                ),
          ).then((val) => {
             if (val == true) {
               getListCard()
            }
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 20, top: 12, right: 20),
        child: Text(title,
            style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
    ),
  ]);
}
TableRow newRow({
  required String package,
  required String  mode,
  required int reseller,
   required String dlLimit, // Changed to String
  required String upLimit, // Changed to String
  required String totalLimit, // Changed to String
  required String onlineLimit, // Changed to String
  required int  type,
  required int price,
  required int expiry,
  required int cardduration,
  int? cardDurationType,
}) {
  // Convert price and taxAmt to double
  
final notifier = Provider.of<ColorNotifire>(context, listen: false);
  return TableRow(
    children: [
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text( package, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
        Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text( "$mode", textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
        Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text( "$reseller", textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(dlLimit, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(upLimit, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
     Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(totalLimit , textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(onlineLimit, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
  getCardTypeLabel(type),
  textAlign: TextAlign.center,
  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),
),

      ),
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text("$price", textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(getCardExpiryLabel(expiry), textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
        Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
    "$cardduration ${getCarddurationtypeLabel(cardDurationType!)}", // Correct interpolation
    textAlign: TextAlign.center,
    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),
  ),
      ),
     
    ],
  );
}
 


  Widget _buildCommonListTile({
    required String title,
    required String subtitle,
  }) {
    final notifier = Provider.of<ColorNotifire>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3), // Control the gap between items
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: mediumBlackTextStyle.copyWith(
                color: notifier.getMainText,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              subtitle,
              style: mediumBlackTextStyle.copyWith(
                color: notifier.getMainText,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPaginationControls() {
     final notifier = Provider.of<ColorNotifire>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back,color: notifier.geticoncolor),
          onPressed: currentPage > 1
              ? () {
                  setState(() {
                    currentPage--;
                  });
                }
              : null,
        ),
        Text('$currentPage',style:TextStyle(color: notifier.getMainText,),),
        IconButton(
          icon: Icon(Icons.arrow_forward,color: notifier.geticoncolor,),
          onPressed: (currentPage * itemsPerPage) < listCard.length
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
