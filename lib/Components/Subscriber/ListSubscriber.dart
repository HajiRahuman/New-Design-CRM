
import 'dart:convert';

import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/Subscriber/AddSubscriber/AddSubscriber.dart';
import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/model/subscriber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/subscriber.dart' as subscriberSrv;

class ListSubscriber extends StatefulWidget {
  final String? category;
  const ListSubscriber({super.key, this.category});

  @override
  State<ListSubscriber> createState() => _ListSubscriber();
}

class _ListSubscriber extends State<ListSubscriber> with SingleTickerProviderStateMixin {
  ColorNotifire notifire = ColorNotifire();
  int currentPage = 1;
  final int itemsPerPage = 5;
  bool isSearching = false;
  bool row = false;
  String selectedValue1 = 'Subscriber ID';
  
  List<SubscriberDet> listSubscriber = [];
  bool isLoading = false; // Add a loading flag
  
  int limit = 5;

  
// Future<void> getListSubscriber({int? acctstatus, int? conn}) async {
//   setState(() {
//     isLoading = true; // Set loading to true when fetching data
//   });

//   // Call subscriber method based on button press (total, online, offline, etc.)
//   ListSubscriberResp resp = await subscriberSrv.listSubscriber(
//     acctstatus: acctstatus,
//     conn: conn,
//     reselusertype: false, // Example: assuming no reseller type filtering
//   );

//   setState(() {
//     if (resp.error) {
//       alert(context, resp.msg);
//     }
//     listSubscriber = resp.error == true ? [] : resp.data ?? [];
//     isLoading = false; // Set loading to false once data is fetched
//   });
// }
Future<void> getListSubscriber({int? acctstatus, int? conn}) async {
  setState(() {
    isLoading = true; // Set loading to true when fetching data
  });

  // Example: Filter by category (Total, Active, Online, etc.)
  ListSubscriberResp resp;
  if (widget.category == 'Online') {
    resp = await subscriberSrv.listSubscriber(
      conn: 1,
      reselusertype: false // Filter for online subscribers
    );
  } else if (widget.category == 'Offline') {
    resp = await subscriberSrv.listSubscriber(
      conn: 2,
       reselusertype: false // Filter for offline subscribers
    );
  } else if (widget.category == 'Active') {
    resp = await subscriberSrv.listSubscriber(
      acctstatus: 1,
       reselusertype: false // Filter for active subscribers
    );
  } else if (widget.category == 'Hold') {
    resp = await subscriberSrv.listSubscriber(
      acctstatus: 2,
       reselusertype: false // Filter for hold subscribers
    );
  } else if (widget.category == 'Expired') {
    resp = await subscriberSrv.listSubscriber(
      acctstatus: -1,
       reselusertype: false // Filter for expired subscribers
    );
  } else {
    resp = await subscriberSrv.listSubscriber(reselusertype: false); // Default (all subscribers)
  }

  setState(() {
    if (resp.error) {
      alert(context, resp.msg);
    }
    listSubscriber = resp.error == true ? [] : resp.data ?? [];
    isLoading = false; // Set loading to false once data is fetched
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
    getMenuAccess();
    getListSubscriber();
  }

  void navigateToViewSubscriber(int subscriberId, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewSubscriber(subscriberId: subscriberId),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    final notifier = Provider.of<ColorNotifire>(context);
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
                      const ComunTitle(title: 'List Subscriber', path: "Subscriber"),
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
    final endIndex = (startIndex + itemsPerPage < listSubscriber.length)
        ? startIndex + itemsPerPage
        : listSubscriber.length;

    final paginatedList = listSubscriber.sublist(startIndex, endIndex);
    final notifier = Provider.of<ColorNotifire>(context);

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
                                       1202
                                        ].contains(id))) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                  return AddSubscriber();
                }));
              }
              },
              child: Text(
                "Add",
                style: mediumBlackTextStyle.copyWith(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () async {
                  getListSubscriber();
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
                    child:
                      ListView.builder(
                  shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paginatedList.length,
                      itemBuilder: (context, index) {
                        final subscriber = paginatedList[index];
                  return Column(
                    children: [
                      Container(
                      decoration: BoxDecoration(
    color: notifire.getcontiner, // Move the color inside the decoration
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey.withOpacity(0.3)),
  ),
                        child: Column(
                          children: [
                            ListTile(
                          
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(subscriber.profileid, 
                                  
                                    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText,fontWeight: FontWeight.bold,fontSize: 16,fontFamily: "Gilroy",),
                                              ),
                                               InkWell(
                              child: SvgPicture.asset(
                                "assets/settings.svg",
                                color: notifier.getMainText,
                              ),
                              onTap: () {
                                  if (  menuIdList.any((id) => [
                                       1204
                                        ].contains(id))) {
                                navigateToViewSubscriber(subscriber.id, context);
                                        }
                              },
                            ),
                                ],
                              ),
                              subtitle:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child:
                            
                             Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                Text(subscriber.fullname,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),),
                                 Text(subscriber.mobile,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),),
                                   Text("VALIDITY : ${subscriber.expiration.isNotEmpty 
                                     ? (subscriber.expiration == 'No Expiry' 
                                         ? 'No Expiry' 
                                         : DateFormat('MMM dd, yyyy ,\nhh:mm:ss a').format(DateTime.parse(subscriber.expiration).toLocal())) 
                                     : "---"}",  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),),
                                
                               ],
                             ),
                          ),
                          Column(
                            children: [
                              _buildCommonListTile1(
                                subtitle: "${subscriber.acctstatus}",
                                subtitleColor: subscriber.acctstatus == 'Active'
                                    ? const Color(0xff43A047) // Green for Active
                                    : const Color(0xFFEE4B2B), // Red for Inactive
                                borderColor: subscriber.acctstatus == 'Active'
                                    ? const Color(0xff43A047) // Green border for Active
                                    : const Color(0xFFEE4B2B), // Red border for Inactive
                              ),
                              _buildCommonListTile1(
                                subtitle: "${subscriber.conn}",
                                subtitleColor: subscriber.conn == 'Online'
                                    ? const Color(0xff25D366) // Green for Online
                                    : const Color(0xFFEE4B2B), // Red for Offline
                                borderColor: subscriber.conn == 'Online'
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
                      ),
                      const SizedBox(height: 10)
                    ],
                  );
                },
              ),
                    
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount: paginatedList.length,
                    //   itemBuilder: (context, index) {
                    //     final subscriber = paginatedList[index];
                    //     return Column(
                    //       children: [
                    //         Container(
                    //           padding: EdgeInsets.all(isphon ? 10 : padding),
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(12),
                    //             border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    //           ),
                    //           child: Column(
                    //             children: [
                    //               Padding(
                    //                 padding: EdgeInsets.symmetric(horizontal: isphon ? 10 : padding),
                    //                 child: Column(
                    //                   children: [
                    //                     _buildCommonListTile2(
                    //                       title: subscriber.fullname,
                    //                       subtitle: InkWell(
                    //                         child: SvgPicture.asset(
                    //                           "assets/settings.svg",
                    //                           height: 18,
                    //                           width: 18,
                    //                           color: notifier.getMainText,
                    //                         ),
                    //                         onTap: () {
                    //                           navigateToViewSubscriber(subscriber.id, context);
                    //                         },
                    //                       ),
                    //                     ),
                    //                     _buildCommonListTile(
                    //                         title: "MOBILE", subtitle: ": ${subscriber.mobile}"),
                    //                     _buildCommonListTile(
                    //                         title: "PROFILE", subtitle: ": ${subscriber.profileid}"),
                    //                     Row(
                    //                       // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //                       children: [
                    //                         Expanded(
                    //                           child: _buildCommonListTile1(
                    //                             title: "ACCOUNT",
                    //                             subtitle: "${subscriber.acctstatus}",
                    //                             subtitleColor: subscriber.acctstatus == 'Active'
                    //                                 ? const Color(0xff43A047) // Green for Active
                    //                                 : const Color(0xFFEE4B2B), // Red for Inactive
                    //                             borderColor: subscriber.acctstatus == 'Active'
                    //                                 ? const Color(0xff43A047) // Green border for Active
                    //                                 : const Color(0xFFEE4B2B), // Red border for Inactive
                    //                           ),
                    //                         ),
                    //                      const SizedBox(width: 10),
                    //                     Expanded(
                    //                       child: _buildCommonListTile1(
                    //                         title: "STATUS",
                    //                         subtitle: "${subscriber.conn}",
                    //                         subtitleColor: subscriber.conn == 'Online'
                    //                             ? const Color(0xff25D366) // Green for Online
                    //                             : const Color(0xFFEE4B2B), // Red for Offline
                    //                         borderColor: subscriber.conn == 'Online'
                    //                             ? const Color(0xff25D366) // Green border for Online
                    //                             : const Color(0xFFEE4B2B), // Red border for Offline
                    //                       ),
                    //                     ),
                    //                      ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         const SizedBox(height: 10),
                    //       ],
                    //     );
                    //   },
                    // ),
                  ),
                ],
              ),
              
        _buildPaginationControls()
      ],
    );
  }

  Widget _buildCommonListTile1({
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
// Widget _buildCommonListTile1({
//     required String title,
//     required String subtitle,
//     Color? subtitleColor,
//     Color? borderColor, // Optional border color parameter
//   }) {
//     final notifier = Provider.of<ColorNotifire>(context, listen: false);

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 2), // Control the gap between items
//       child: Row(
//           //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//         Text(
//                 title,
//                 style: mediumBlackTextStyle.copyWith(
//                   color: notifier.getMainText,
//                 ),
//               ),
         
          
//           const SizedBox(width: 10),
        // Container(
        //         padding: const EdgeInsets.fromLTRB(3, 0, 3, 0), // Add padding for better visual appearance
        //         decoration: BoxDecoration(
        //           border: Border.all(color: borderColor ?? Colors.transparent), // Use provided border color or transparent if not provided
        //           borderRadius: BorderRadius.circular(4), // Border radius
        //         ),
        //         child: Text(
        //           textAlign: TextAlign.center,
        //           subtitle,
        //           style: mediumBlackTextStyle.copyWith(
        //             color: subtitleColor ?? notifier.getMainText,
        //           ),
        //         ),
        //       ),
         
          
//         ],
//       ),
//     );
//   }
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

  Widget _buildCommonListTile2({
    required String title,
    required Widget subtitle,
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
            child: subtitle,
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
          onPressed: (currentPage * itemsPerPage) < listSubscriber.length
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
