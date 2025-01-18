import 'dart:convert';

import 'package:crm/AppBar.dart';

import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';

import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Hotel/ChangeAuthPwdHotel.dart';
import 'package:crm/Hotel/HotelAddUser.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Utils/Utils.dart';

import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/model/hotel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/hotel.dart' as hotelSrv;

class ListHotel extends StatefulWidget {
  final String? category;
  final int? id;
  final bool? search;
  const ListHotel({super.key,  this.id, this.search,this.category});

  @override
  State<ListHotel> createState() => _ListHotel();
}

class _ListHotel extends State<ListHotel> with SingleTickerProviderStateMixin {
  bool isSearching = false;
  bool row = false;
  String selectedValue1 = 'Subscriber ID';
  
  final int itemsPerPage = 5;
  bool isLoading = false;

  List<HotelDet> listHotel = [];
  int currentPage = 1;
  int limit = 5;

  String? menuIdString = '';
  List<int> menuIdList = [];
  bool isIspAdmin = false;
Future<void> getMenuAccess() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
  isIspAdmin = pref.getBool('isIspAdmin') as bool;

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
  getMenuAccess();
  getListHotel();
  // Initialize _obscurePasswords dynamically after fetching the hotels
  _obscurePasswords = [];
}

Future<void> getListHotel({String? category}) async {
  setState(() {
    isLoading = true; // Set loading to true when fetching data
  });

  HotelResp resp;

  // If widget.search is true, perform the search operation
  if (widget.search == true) {
    resp = await hotelSrv.listHotelSearch(widget.id!); // Search for hotels using widget.id
  } else {
    // Handle different categories or default case (Total)
   if (widget.category == 'Online') {
    resp = await hotelSrv.listHotel(conn: 1); // Assuming conn: 1 for online
  } else if (widget.category== 'Offline') {
    resp = await hotelSrv.listHotel(conn: 2); // Assuming conn: 2 for offline
  } else if (widget.category == 'Active') {
    resp = await hotelSrv.listHotel(acctstatus: 1); // Active hotels
  } else if (widget.category == 'Expired') {
    resp = await hotelSrv.listHotel(acctstatus: -1); // Expired hotels
  } else if (widget.category == 'Total') {
    resp = await hotelSrv.listHotel(); // All hotels (Total)
  } else {
    resp = await hotelSrv.listHotel(); // Default: All hotels
  }
  }

  setState(() {
    if (resp.error) {
      alert(context, resp.msg);
    }
    listHotel = resp.error == true ? [] : resp.data ?? [];
    // Initialize _obscurePasswords based on the list of hotels fetched
    _obscurePasswords = List<bool>.filled(listHotel.length, true);
    isLoading = false; // Set loading to false once data is fetched
  });
}


// Future<void> getListHotel() async {
//   setState(() {
//     isLoading = true;
//   });

//   HotelResp resp;

//   // Choose the appropriate service call based on the value of `widget.search`
//   if (widget.search == true) {
//     resp = await hotelSrv.listHotelSearch(widget.id!);
//   } else {
//     resp = await hotelSrv.listHotel();
//   }

//   setState(() {
//     if (resp.error) {
//       alert(context, resp.msg);
//     }
//     listHotel = resp.error == true ? [] : resp.data ?? [];
//     // Initialize _obscurePasswords based on the list of hotels fetched
//     _obscurePasswords = List<bool>.filled(listHotel.length, true);
//     isLoading = false;
//   });
// }



// ignore: unused_element
late List<bool> _obscurePasswords; 
  

  String obscurePassword(String password, bool isObscured) {
    return isObscured ? '*' * password.length : password;
  }
  int selectedHotelIndex = -1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
      final notifier = Provider.of<ColorNotifire>(context);
    return Scaffold(
       key: _scaffoldKey,
     drawer: DarwerCode(), 
      backgroundColor:notifier.getbgcolor,
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const SizedBoxx(),
                          const ComunTitle(title: 'List Hotel', path: "Hotel"),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, right: padding, left: padding, bottom: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color:notifier.getcontiner,
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
                           if(widget.search!=true)
                          _buildPaginationControls(),
                          const SizedBoxx(),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
           if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:  BottomAppBar(
            shadowColor:notifier.getprimerycolor ,
             color: notifier.getprimerycolor,
             surfaceTintColor: notifier.getprimerycolor,
            child: BottomNavBar(scaffoldKey: _scaffoldKey),
            
          ),
    );
  }


  Widget _buildProfile1({required bool isphon}) {
       final startIndex = (currentPage - 1) * itemsPerPage;
  final endIndex = (startIndex + itemsPerPage <  listHotel.length)
      ? startIndex + itemsPerPage
      :  listHotel.length;

  final paginatedList =  listHotel.sublist(startIndex, endIndex);
     final notifier = Provider.of<ColorNotifire>(context);
     double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
            alignment: Alignment.topRight,
              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: appMainColor,
                                  fixedSize: const Size.fromHeight(40),
                                ),
                                onPressed: () async {
                                    if (  menuIdList.any((id) => [
                                       1405
                                        ].contains(id)) || isIspAdmin==true) {
                        showDialog(
                          context: context,
                          builder: (ctx) =>
                              Dialog.fullscreen(
                                
                                 backgroundColor:notifier.getbgcolor,
                                  child:HotelAddUser(hotel: null)                                                             ),
                        ).then((val) => {
                          print('dialog--$val'),
                          if (val)  getListHotel(),
                        });
                      }
                                },
                                child: Text(
                                  "Add",
                                  style: mediumBlackTextStyle.copyWith(
                                      color: Colors.white),
                                )),
            ),
            
                                IconButton( onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        setState(() {
                          isLoading = true; // Set loading to true before fetching data
                        });
                         getListHotel().then((_) {
                          setState(() {
                            isLoading = false; // Set loading to false after data is fetched
                          });
                      
                        });
                       
                      }, icon: Icon(Icons.refresh, color: notifier.getMainText),)
          ],
        ),
        const SizedBoxx(),
        Row(
          children: [
             Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                             itemCount: paginatedList.length,
                              itemBuilder: (context, index) {
                          
                              final hotelsubs = paginatedList[index];
                    // final isHotelSelected = index == selectedHotelIndex;
                                             
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
                                                    Text(hotelsubs.id.toString(),
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
                                        _buildPopupAdminMenuItem(hotelsubs),
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
                                                                      "PASSWORD",
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
                                                                      "REJECTION MSG",
                                                                         textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "REJECTION ON",
                                                                         textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    // Text(
                                                                    //   "EXPIRY",
                                                                    //      textAlign: TextAlign.center,
                                                                    // style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    // ),
                                                                    // Text(
                                                                    //   "DURATION TYPE",
                                                                    //      textAlign: TextAlign.center,
                                                                    // style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    // ),
                                                                   
                                                                  ],
                                                                ),
                                                                // dividerRow(const Color(0xff7366ff)),
                                                                // ignore: unused_local_variable
                                                                // for (var invoices in  listSubsInvoive) ...[
                                                                  
                                                                  newRow(
                                                                 password: hotelsubs.authPassword,
                                                                 mode:hotelsubs.packMode ,
                                                                 reseller:hotelsubs.resellerId ,
                                                                 dlLimit: formatBytes(hotelsubs.dlLimit),
  upLimit: formatBytes(hotelsubs.ulLimit),
  totalLimit: formatBytes(hotelsubs.totalLimit),
  onlineLimit: formatBytes(hotelsubs.timeLimit),
  rejectionMSG:hotelsubs.authReject.isNotEmpty? hotelsubs.authReject :"---",
  rejectionON:hotelsubs.authRejectDate.isNotEmpty 
                                     ? (hotelsubs.authRejectDate== 'No Expiry' 
                                         ? 'No Expiry' 
                                         : DateFormat('MMM dd, yyyy ,\nhh:mm:ss a').format(DateTime.parse(hotelsubs.authRejectDate).toLocal())) 
                                     : "---",

 
                                                                //  type:cardsubs.cardType ,
                                                                //  price:cardsubs.cardPrice ,
                                                                //  expiry: cardsubs.cardExpiry,
                                                                //  cardduration:cardsubs.cardDuration, cardDurationType: cardsubs.cardDurationType ,
                                                                    
                                                                
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
                                 Column(
                    children: [
                     Column(
                          children: [
                            ListTile(
                          
                            
                              subtitle:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child:
                            
                             Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                Text(hotelsubs.username,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),),
                                 Text(hotelsubs.packName,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),),
                                   Text("VALIDITY : ${hotelsubs.expiration.isNotEmpty 
                                     ? (hotelsubs.expiration == 'No Expiry' 
                                         ? 'No Expiry' 
                                         : DateFormat('MMM dd, yyyy ,\nhh:mm:ss a').format(DateTime.parse(hotelsubs.expiration).toLocal())) 
                                     : "---"}",  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),),
                                
                               ],
                             ),
                          ),
                          Column(
                            children: [
                              _buildCommonListTile3(
                                subtitle: "${hotelsubs.acctStatus}",
                                subtitleColor: hotelsubs.acctStatus == 'Active'
                                    ? const Color(0xff43A047) // Green for Active
                                    : const Color(0xFFEE4B2B), // Red for Inactive
                                borderColor: hotelsubs.acctStatus == 'Active'
                                    ? const Color(0xff43A047) // Green border for Active
                                    : const Color(0xFFEE4B2B), // Red border for Inactive
                              ),
                              _buildCommonListTile3(
                                subtitle: "${hotelsubs.conn}",
                                subtitleColor: hotelsubs.conn == 'Online'
                                    ? const Color(0xff25D366) // Green for Online
                                    : const Color(0xFFEE4B2B), // Red for Offline
                                borderColor: hotelsubs.conn == 'Online'
                                    ? const Color(0xff25D366) // Green border for Online
                                    : const Color(0xFFEE4B2B), // Red border for Offline
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                           
                             )
                          ],
                        ),
                      
                      const SizedBox(height: 10)
                    ],
                  ),
                                  
                                          
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                     
                                  ],
                                );
                              },
                            )),

          ],
        ),
      ],
    );
  }

  
  Widget _buildCommonListTile3({
    //  required String title,
    required String subtitle,
     Color? subtitleColor,
       Color? borderColor,
  }) {
    final notifier = Provider.of<ColorNotifire>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3), // Control the gap between items
      child: Row(
        children: [
          // Expanded(
          //   child: Text(
          //     title,
          //     style: mediumBlackTextStyle.copyWith(
          //       color: notifier.getMainText,
          //     ),
          //   ),
          // ),
          // const SizedBox(width: 10),
            Container(
                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0), // Add padding for better visual appearance
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor ?? Colors.transparent), // Use provided border color or transparent if not provided
                  borderRadius: BorderRadius.circular(4), // Border radius
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  subtitle,
                  style: mediumBlackTextStyle.copyWith(
                    color: subtitleColor ?? notifier.getMainText,
                  ),
                ),
              ),
          
        ],
      ),
    );
  }
 PopupMenuItem _buildPopupAdminMenuItem(HotelDet hotelsubs) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);
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
                row1(title: 'Activation', icon: Icons.edit, hotelsubs: hotelsubs, context: context),
                row1(title: 'Change Auth PWD', icon: Icons.key, hotelsubs: hotelsubs, context: context),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
TableRow newRow({
  required String password,
  required String  mode,
  required int reseller,
   required String dlLimit, // Changed to String
  required String upLimit, // Changed to String
  required String totalLimit, // Changed to String
  required String onlineLimit, // Changed to String
  required String rejectionMSG,
  required String  rejectionON,
  
}) {
  // Convert price and taxAmt to double
  
final notifier = Provider.of<ColorNotifire>(context, listen: false);
  return TableRow(
    children: [
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text( password, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
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
  rejectionMSG,
  textAlign: TextAlign.center,
  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),
),


      ),
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(rejectionON, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
//     
    ],
  );
}
 

bool light1 = true;
TableRow row1({
  required String title,
  required IconData icon,
  required HotelDet hotelsubs,
  required BuildContext context, // Add this to pass context explicitly
}) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);
  return TableRow(children: [
    TableRowInkWell(
      onTap: () {
        Navigator.of(context).pop();
         if (  menuIdList.any((id) => [
                                       1407
                                        ].contains(id)) ||isIspAdmin==true) {
        if (title == 'Activation') {
          showDialog(
            context: context,
            builder: (ctx) => Dialog.fullscreen(
              backgroundColor: notifier.getbgcolor,
              child: HotelAddUser(hotel: hotelsubs),
            ),
          ).then((val) {
            print('dialog--$val');
            if (val == true) {
              getListHotel();
            }
          });
        }
                                        }
        if (title == 'Change Auth PWD') {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: notifier.getbgcolor,
              actions: [ChangeAuthPwdHotel(hotel: hotelsubs)],
            ),
          ).then((val) {
            print('dialog--$val');
            if (val == true) {
              getListHotel();
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
          if (  menuIdList.any((id) => [
                                       1407
                                        ].contains(id)) ||isIspAdmin ==true) {
        if (title == 'Activation') {
          showDialog(
            context: context,
            builder: (ctx) => Dialog.fullscreen(
              backgroundColor: notifier.getbgcolor,
              child: HotelAddUser(hotel: hotelsubs),
            ),
          ).then((val) {
            print('dialog--$val');
            if (val == true) {
              getListHotel();
            }
          });
        }
                                        }
        if (title == 'Change Auth PWD') {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: notifier.getbgcolor,
              actions: [ChangeAuthPwdHotel(hotel: hotelsubs)],
            ),
          ).then((val) {
            print('dialog--$val');
            if (val == true) {
              getListHotel();
            }
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 20, top: 12, right: 20),
        child: Text(
          title,
          style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),
        ),
      ),
    ),
  ]);
}

Widget  _buildCommonListTile2({
  required String title,
  required Widget subtitle,
}) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);

  return Container(
    padding:const EdgeInsets.symmetric(vertical:3), // Control the gap between items
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: mediumGreyTextStyle,
        ),
       
        subtitle
      ],
    ),
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
      crossAxisAlignment: CrossAxisAlignment.start, // Align children to start to handle long text
      children: [
        Expanded(
          child: Text(
            title,
            style: mediumGreyTextStyle,
          ),
        ),
        const SizedBox(width: 10), // Add some spacing between title and subtitle
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

Widget _buildCommonListTile1({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ColorNotifire notifier,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: mediumGreyTextStyle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                subtitle,
                style: mediumBlackTextStyle.copyWith(
                  color: notifier.getMainText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPaginationControls() {
    final notifier = Provider.of<ColorNotifire>(context);
    final totalPages = (  listHotel.length / itemsPerPage).ceil();
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
        Text("Page $currentPage of $totalPages",style:  mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
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
