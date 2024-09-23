
import 'package:crm/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/CommonBottBar.dart';
import 'package:crm/Components/DashBoard/DashBoard.dart';
import 'package:crm/Components/Subscriber/AddSubscriber/AddSubscriber.dart';
import 'package:crm/Components/Subscriber/Complaints/AddComplaints.dart';
import 'package:crm/Components/Subscriber/Complaints/Complaints.dart';
import 'package:crm/Components/Subscriber/ListSubscriber.dart';
import 'package:crm/Components/Subscriber/SubscriberInvoice/SubscriberInvoice.dart';
import 'package:crm/Franchise/ListFranchise.dart';
import 'package:crm/Franchise/ViewFranchise.dart';
import 'package:crm/Hotel/HotelAddUser.dart';
import 'package:crm/Hotel/ListHotel.dart';
import 'package:crm/Payment/Payment.dart';

import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Support/RefundPolicy.dart';
import 'package:crm/Support/PrivacyPolicy.dart';
import 'package:crm/Support/Terms&Conditions.dart';
import 'package:crm/model/reseller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crm/service/reseller.dart' as resellerSrv;
class DarwerCode extends StatefulWidget {
  ResellarDet? resellerDet;


  @override
  State<DarwerCode> createState() => _DrawerState();
}

class _DrawerState extends State<DarwerCode> {
   bool ispresent = false;

  static const breakpoint = 600.0;
  bool isDrawerOpen = false;
  int levelid = 0;
  bool isIspAdmin = false;
  int id = 0;
  int selectedAmount = 0;
  bool isSubscriber = false;

  dynamic Wallet;

  // Future<void> getMenuAccess() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   levelid = pref.getInt('level_id') ?? 0;
  //   isIspAdmin = pref.getBool('isIspAdmin') ?? false;
  //   id = pref.getInt('id') ?? 0;
  //   isSubscriber = pref.getBool('isSubscriber') ?? false;
    
  //     print('Leveliddddddddd---${levelid}');
  //       print('Adminsssssss----${isIspAdmin }');
  //         print('Iddddddddddddd----${id}');
  //           print('IsSubscriberssssssssss----${isSubscriber}');
    // if (!isIspAdmin && levelid > 4 && !isSubscriber) {
    //   fetchData();
    // }
  // }

  Future<void> fetchData() async {
    final resp = await resellerSrv.fetchResellerDetail(id);
    setState(() {
      if (resp.error) {
        alert(context, resp.msg);
      } else {
        widget.resellerDet = resp.data;
        Wallet = widget.resellerDet?.wallet ?? 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getMenuAccess();
     getIdLevelID();
  }

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

Future<void> getMenuAccess() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      levelid = pref.getInt('level_id') ?? 0;
      isIspAdmin = pref.getBool('isIspAdmin') ?? false;
      isSubscriber = pref.getBool('isSubscriber') ?? false;
         id = pref.getInt('id') ?? 0;
      // // Debugging logs to check the values
      // print("isIspAdmin: $isIspAdmin");
      // print("levelid: $levelid");
      // print("isSubscriber: $isSubscriber");
    });
    if (!isIspAdmin && levelid > 4 && !isSubscriber) {
      fetchData();
    }
  }
bool shouldShowMenuItem() {
  // print("Evaluating visibility logic");
  // print("isIspAdmin: $isIspAdmin, isSubscriber: $isSubscriber, levelid: $levelid");

  // Visibility based on levelid or isIspAdmin
  if (levelid == 14 || levelid <= 3 || isIspAdmin) {
    // print("Showing because user has access via levelid or isIspAdmin");
    return true;
  }

  if (isIspAdmin) {
    // print("Showing because user is ISP Admin");
    return true;
  }

  if (!isSubscriber && levelid != 14 && levelid != 18) {
    // print("Showing because user is not subscriber and levelid is valid");
    return true;
  }

  // print("Hiding the menu item");
  return false;
}
bool checkLevelAndAdmin() {
  return levelid == 14 || levelid <= 3 || isIspAdmin;
}


  int resellerID=0;
  getIdLevelID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    resellerID = pref.getInt('id') as int;
  }

  @override
  



  void navigateToViewReseller(int resellerId, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewFranchise(resellerId: resellerId),
      ),
    );
  }
  @override
   Widget build(BuildContext context) {
       final notifier = Provider.of<ColorNotifire>(context);

  
      return SafeArea(
        child:Drawer(
            backgroundColor: notifier.getprimerycolor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: notifier.getbordercolor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
//                 Padding(
//                   padding: EdgeInsets.only(
//                     left: ispresent ? 30 : 15,
//                     top: ispresent ? 24 : 20,
//                     bottom: ispresent ? 10 : 12,
//                   ),
//                   child: DrawerHeader(
//   child: Padding(
//     padding: const EdgeInsets.all(0),
//     child: 
//   ),
// )

//                 ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isIspAdmin && levelid > 4 && !isSubscriber) 
          // Show this column if the condition is true
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  '\nWallet Amount\n Rs.$Wallet /-',
                  textAlign: TextAlign.center,
                 style: mainTextStyle.copyWith(
              fontSize: 16, color: notifier.getMainText),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: appMainColor),
                child: const Text(
                  'Top Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: notifier.getbgcolor,
                      actions: [Payment()],
                    ),
                  ).then((val) => {
                    if (val) getMenuAccess(),
                  });
                },
              ),
            ],
          )
        else
          // Show this image if the condition is false
          Padding(
                  padding: EdgeInsets.only(
                      left: ispresent ? 30 : 15,
                      top: ispresent ? 24 : 20,
                      bottom: ispresent ? 10 : 12),
                  child: InkWell(
                    onTap: () {
                      
                    },
                    child:
                        ClipRRect(
                        borderRadius:const BorderRadius.all(Radius.circular(20)),
                      child: Image.asset(
                        'assets/images/logogsi.png',
                          width: 230, // Set the desired width
                            height: 150, // Set the desired height
                            fit: BoxFit.cover, // Adjust the fit as needed
                      ),
                    ),
                       
                       
                    
                    
                  ),
                ),
              
      ],
    ),
    
                          Visibility(
                            visible: isSubscriber==false,
                            child: _buildSingletile1(
                              header: "Dashboard",
                               iconpath: Icon(Icons.home, color: notifier.getMainText),
                              ontap: () {
                               Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>  DashBoard()),
      (Route<dynamic> route) => false,
    );
                              },
                            ),
                          ),
                           Visibility(
                             visible : [2,3,5,6,8,9,11,12,14,18].contains(levelid) ? true :false,
                            child: _buildDivider(title: 'FRANCHISE')),
                          Visibility(
                              visible : [2,3,5,6,8,9,11,12,14,18].contains(levelid) ? true :false,
                            child: _buildSingletile1(
                              header: "Franchise Info",
                                iconpath: Icon(Icons.description, color: notifier.getMainText),
                              ontap: () {
                                // Navigator.of(context).pushReplacement(
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) =>
                                //         const ListFranchise(),
                                //   ),
                                // );
                                 navigateToViewReseller(
                        resellerID, context);
                              },
                            ),
                          ),

                           Visibility(
                             visible: shouldShowMenuItem(),
                            child: _buildDivider(title: 'SUBSCRIBER')),
                          Visibility(
                            visible: shouldShowMenuItem(),
                            

                            child:
                            _buildSingletile1(
                              header: 'List Subscriber',
                               iconpath: Icon(Icons.list, color: notifier.getMainText),
                              ontap: () {
                                Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ListSubscriber(),
                                            ),
                                          );
                              },
                            ),
                            
                          ),
                            Visibility(
                            visible: shouldShowMenuItem(),
                            

                            child:
                            _buildSingletile1(
                              header: 'Add Subscriber',
                                iconpath: Icon(Icons.add, color: notifier.getMainText),
                              ontap: () {
                                Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddSubscriber(),
                                            ),
                                          );
                              },
                            ),
                            
                          ),

                           Visibility(
                               visible: (levelid == 14 || levelid <=3 || isIspAdmin) ? true :false,
                            child: _buildDivider(title: 'HOTEL')
                            
                            
                          ),
                          Visibility(
                               visible: (levelid == 14 || levelid <=3 || isIspAdmin) ? true :false,
                            child: _buildSingletile1(
                             header: 'List Hotel',
                               iconpath: Icon(Icons.list, color: notifier.getMainText),
                              ontap: () {
                                Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ListHotel(),
                                            ),
                                          );
                              },
                            ),
                            
                            
                          ),
                           Visibility(
                               visible: (levelid == 14 || levelid <=3 || isIspAdmin) ? true :false,
                            child: _buildSingletile1(
                             header: 'Add Hotel',
                              iconpath: Icon(Icons.add_business, color: notifier.getMainText),
                              ontap: () {
                                Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HotelAddUser(hotel: null)  ,
                                            ),
                                          );
                              },
                            ),
                            
                            
                          ),
                          Visibility(
                              visible: isSubscriber==false,
                            child: _buildDivider(title: 'COMPLAINTS')),
                          Visibility(
                             visible: isSubscriber==false,
                            child: _buildSingletile1(
                              header: "List Complaints",
                             iconpath: Icon(Icons.list, color: notifier.getMainText),
                              ontap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Complaints(
                                      subscriberId: 0,
                                      resellerID: 0,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                           Visibility(
                             visible: isSubscriber==false,
                            child: _buildSingletile1(
                              header: "Add Complaints",
                              iconpath: Icon(Icons.construction, color: notifier.getMainText),
                              ontap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  AddComplaint()      
                                  ),
                                );
                              },
                            ),
                          ),
                           _buildDivider(title: 'GENERAL'),
                         _buildSingletile1(
                                  header: "Refund Policy",
                                  iconpath: Icon(Icons.description, color: notifier.getMainText),
                                  
                                  ontap: () {
                                   Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RefundPolicy(),
                                            ),
                                          );
                              
                            
                                  }),
                          
  
                                _buildSingletile1(
                                                                   header: "Privacy Policy",
                                                                   iconpath: Icon(Icons.privacy_tip, color: notifier.getMainText),
                                                                   
                                                                   ontap: () {
                                                                     Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const PrivacyPolicy(),
                                            ),
                                          );
                                   
                                                                   }),
                                
                                 
                               
                                  _buildSingletile1(
                                                                    header: "Terms & Conditions",
                                                                    iconpath:Icon(Icons.gavel, color: notifier.getMainText),
                                                                    
                                                                    ontap: () {
                                                                     Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const TermsAndConditions(),
                                            ),
                                          );
                                     
                                                                    }),
                                
                        ],
                      ),
                    ),
                  ),
                ),
                const ComunBottomBar(),
              ],
            ),
          ),

        );
   }
     Widget _buildsizeboxwithheight() {
    return SizedBox(
      height: ispresent ? 25 : 20,
    );
  }

 Widget _buildSingletile1(
      {required String header,
      required Icon iconpath,
      required void Function() ontap}) {
         final notifier = Provider.of<ColorNotifire>(context);
    return  ListTileTheme(
          // horizontalTitleGap: 12.0,
          dense: true,
          child: ListTile(
            hoverColor: Colors.transparent,
            onTap: ontap,
            title: Text(
              header,  style: mediumBlackTextStyle.copyWith(
              fontSize: 14, color: notifier.getMainText),
        
             
            ),
            leading: iconpath,
            trailing: const SizedBox(),
             contentPadding: EdgeInsets.symmetric(
            vertical: ispresent ? 5 : 2, horizontal: 8),
        
        )
        );
  }
  
   Widget _buildcomuntext({required String title}) {
    final notifier = Provider.of<ColorNotifire>(context);
    return Text(
      title,
      style: mediumGreyTextStyle.copyWith(
          fontSize: 13, color: notifier.getMainText),
    );
  }
Widget _buildDivider({required String title}) {
  final notifier = Provider.of<ColorNotifire>(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // SizedBox(
      //   height: ispresent ? 15 : 10,
      //   width: ispresent ? 230 : 260,
      //   child: Center(
      //     child: Divider(
      //       color: notifier.getbordercolor,
      //       height: 1,
      //     ),
      //   ),
      // ),
      // SizedBox(height: ispresent ? 15 : 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the text horizontally
        children: [
        Expanded(child: Divider(color:notifier.getMainText)),
          Expanded( // This will help to fill the available space in the Row
            child: Align(
              alignment: ispresent ? Alignment.centerRight : Alignment.center, // Align right if `ispresent` is true, otherwise center
              child: Text(
                title,
              style: mediumBlackTextStyle.copyWith(
                    color:  notifier.getMainText,fontSize:12,fontWeight: FontWeight.bold  // Use the provided color or the default color from notifier
                  ),
              ),
            ),
          ),
          Expanded(child: Divider(color:notifier.getMainText)),
        ],
      ),
    ],
  );
}
   Widget _buildSingletile({
    required String header,
    required String iconpath,
    required void Function() ontap,
  }) {
    final notifier = Provider.of<ColorNotifire>(context);
    return ListTileTheme(
      horizontalTitleGap: 12.0,
      dense: true,
      child: ListTile(
        hoverColor: Colors.transparent,
        onTap: ontap,
        title: Text(
          header,
          style: mediumBlackTextStyle.copyWith(
              fontSize: 14, color: notifier.getMainText),
        ),
        leading: SvgPicture.asset(
          iconpath,
          height: 18,
          width: 18,
          color: notifier.getMainText,
        ),
        trailing: const SizedBox(),
        contentPadding: EdgeInsets.symmetric(
            vertical: ispresent ? 5 : 2, horizontal: 8),
      ),
    );
  }
Widget _buildexpansiontilt({
    required Widget children,
    required String header,
    required String iconpath,
  }) {
    final notifier = Provider.of<ColorNotifire>(context);
    return ListTileTheme(
      horizontalTitleGap: 12.0,
      dense: true,
      child: ExpansionTile(
        title: Text(
          header,
          style: mediumBlackTextStyle.copyWith(
              fontSize: 14, color: notifier.getMainText),
        ),
        leading: SvgPicture.asset(
          iconpath,
          height: 18,
          width: 18,
          color: notifier.getMainText,
        ),
        tilePadding: EdgeInsets.symmetric(
            vertical: ispresent ? 5 : 2, horizontal: 8),
        iconColor: appMainColor,
        collapsedIconColor: Colors.grey,
        children: <Widget>[children],
      ),
    );
  }
  Widget _buildcomunDesh() {
    final notifier = Provider.of<ColorNotifire>(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          "assets/minus.svg",
          color: notifier.getMainText,
          width: 6,
        ),
        const SizedBox(width: 25),
      ],
    );
  }
   }
