import 'dart:convert';

import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Card/CardAddUpdate.dart';
import 'package:crm/Card/ListCard.dart';
import 'package:crm/CommonBottBar.dart';
import 'package:crm/Components/DashBoard/DashBoard.dart';
import 'package:crm/Components/Subscriber/AddSubscriber/AddSubscriber.dart';
import 'package:crm/Components/Subscriber/Complaints/AddComplaints.dart';
import 'package:crm/Components/Subscriber/Complaints/Complaints.dart';
import 'package:crm/Components/Subscriber/ListSubscriber.dart';
import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/Franchise/ListFranchise.dart';

import 'package:crm/Franchise/ViewFranchise.dart';
import 'package:crm/Hotel/HotelAddUser.dart';
import 'package:crm/Hotel/ListHotel.dart';
import 'package:crm/Payment/Payment.dart';

import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Support/RefundPolicy.dart';
import 'package:crm/Support/PrivacyPolicy.dart';
import 'package:crm/Support/Terms&Conditions.dart';
import 'package:crm/model/drawer.dart';
import 'package:crm/model/reseller.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crm/service/reseller.dart' as resellerSrv;
import 'package:crm/service/drawer.dart' as drawerSrv;

class DarwerCode extends StatefulWidget {
  DepositSummary? depositSummary;

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
  String? menuIdString = '';
  List<int> menuIdList = [];
 int cardLimit = 0;
  int hotelLimit = 0;

  double rotationAngle = 0.0;
  List<String> data = [];

  Future<void> getSubscriberSummary() async {
    // Define the URL
    final resp = await drawerSrv.getDepositSummaryData();
    if (resp.error == false) {
      setState(() {
        widget.depositSummary = resp.summary;
      });
    }
  }

//  List<ResellarDet> reseller = [];
  List<ResellarAmountDet> reseller = [];
// int userId = 123; // Replace this with the actual user ID
  double wallet = 0; // Default wallet value
  Future<void> fetchData() async {
    ResellerAmountDetResp resp = await resellerSrv.fetchResellerAmount();

    setState(() {
      if (!resp.error && resp.data != null) {
        reseller = resp.data!;

        // Find the reseller by user ID and update the wallet value
        final resellerDet = reseller.firstWhere(
          (reseller) => reseller.id == id,
          orElse: () => ResellarAmountDet(
              id: id, wallet: 0), // Return a default object if not found
        );

        wallet = resellerDet.wallet;

        // Optionally, log the wallet value for debugging
        // print("Wallet for user $id: $wallet");
      } else {
        reseller = [];
        wallet = 0; // Reset wallet in case of error
        // Optionally, log the error message
        // print("Error fetching data: ${resp.msg}");
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

  bool isSuperAdmin = false;
  Future<void> getMenuAccess() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      levelid = pref.getInt('level_id') ?? 0;
      isIspAdmin = pref.getBool('isIspAdmin') ?? false;
      isSubscriber = pref.getBool('isSubscriber') ?? false;
      id = pref.getInt('id') ?? 0;
      isSuperAdmin = pref.getBool("isSuperAdmin") as bool;
 cardLimit = pref.getInt('cardlimit') ?? 0;
      hotelLimit = pref.getInt('hotellimit') ?? 0;
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

    // Fetch data only if specific conditions are met
    if (!isIspAdmin && levelid > 4 && !isSubscriber) {
      fetchData();
    }
    if (![14, 15].contains(levelid) && !isSubscriber && levelid <= 3 ||
        isSuperAdmin ||
        isIspAdmin) {
      getSubscriberSummary();
    }
  }

  bool shouldShowMenuItem() {
    // Check for ISP Admin role and specific menu_id values
    if (isIspAdmin &&
        (menuIdList.contains(1201) || menuIdList.contains(1202))) {
      return true; // Show menu item if the menu_id is either 1201 or 1202 and user is ISP Admin
    }

    // Visibility based on levelid or isIspAdmin
    if (levelid == 14 || levelid <= 3 || isIspAdmin) {
      return true; // Show if user has access via levelid or isIspAdmin
    }

    // Additional conditions
    if (!isSubscriber && levelid != 14 && levelid != 18) {
      return true; // Show if user is not a subscriber and levelid is valid
    }

    // Hide the menu item by default
    return false;
  }

  bool checkLevelAndAdmin() {
    return levelid == 14 || levelid <= 3 || isIspAdmin;
  }

  int resellerID = 0;
  getIdLevelID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    resellerID = pref.getInt('id') as int;
  }

  @override
  Widget _buildFrontCard() {
    final notifier = Provider.of<ColorNotifire>(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      width: 200,
      height: 100,
      child: widget.depositSummary != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Online Payment',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Gilroy"),
                    ),
                    Icon(Icons.flip, color: Colors.green),
                  ],
                ),
                Center(
                  child: Text(
                    '₹ ${widget.depositSummary!.online}',
                    style: const TextStyle(
                        color: appMainColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Gilroy"),
                  ),
                ),
              ],
            )
          : const Center(
              child:
                  CircularProgressIndicator()), // Show a loading indicator if data is null
    );
  }

  Widget _buildBackCard() {
    final notifier = Provider.of<ColorNotifire>(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      width: 200,
      height: 100,
      child: widget.depositSummary != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Other Payment',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Gilroy"),
                    ),
                    Icon(Icons.flip, color: Colors.green),
                  ],
                ),
                Center(
                  child: Text(
                    '₹ ${widget.depositSummary!.other}',
                    style: const TextStyle(
                        color: appMainColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Gilroy"),
                  ),
                ),
              ],
            )
          : const Center(
              child:
                  CircularProgressIndicator()), // Show a loading indicator if data is null
    );
  }

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
      child: Drawer(
        backgroundColor: notifier.getprimerycolor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: notifier.getbordercolor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          // First Visibility Block
                          Visibility(
                            visible:
                                ![14, 15].contains(levelid) && !isSubscriber,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Inner Visibility Block
                                Visibility(
                                  visible: !isIspAdmin &&
                                      levelid > 4 &&
                                      !isSubscriber,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '\nWallet Amount\n Rs.$wallet /-',
                                          textAlign: TextAlign.center,
                                          style: mainTextStyle.copyWith(
                                            fontSize: 16,
                                            color: notifier.getMainText,
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: ![7, 10, 13, 15, 17, 19]
                                            .contains(levelid),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: appMainColor),
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
                                                backgroundColor:
                                                    notifier.getbgcolor,
                                                actions: [Payment()],
                                              ),
                                            ).then((val) => {
                                                  if (val) getMenuAccess(),
                                                });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: levelid <= 3 ||
                                      isSuperAdmin ||
                                      isIspAdmin,
                                  child: Center(
                                    child: FlipCard(
                                      direction: FlipDirection.HORIZONTAL,
                                      front: _buildFrontCard(),
                                      back: _buildBackCard(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Second Section (Image)
                          if ([14, 15].contains(levelid) || isSubscriber)
                            Padding(
                              padding: EdgeInsets.only(
                                left: ispresent ? 30 : 15,
                                top: ispresent ? 24 : 20,
                                bottom: ispresent ? 10 : 12,
                              ),
                              child: InkWell(
                                onTap: () {
                                  // Handle onTap
                                },
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: Image.asset(
                                    'assets/images/logogsi.png',
                                    width: 230, // Set the desired width
                                    height: 150, // Set the desired height
                                    fit: BoxFit
                                        .cover, // Adjust the fit as needed
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      Visibility(
                        visible: isSubscriber == false || isIspAdmin == true,
                        child: _buildSingletile1(
                          header: "Dashboard",
                          iconpath:
                              Icon(Icons.home, color: notifier.getMainText),
                          ontap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashBoard()),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ),
                      // Ensure menuIdList contains specific menu_ids
                      Visibility(
                        visible:
                            //  [2, 3, 5, 6, 8, 9, 11, 12, 14, 18].contains(levelid) &&
                            menuIdList.any((id) =>
                                    [1101, 1102, 1103, 1104].contains(id)) ||
                                isIspAdmin == true,
                        child: _buildDivider(title: 'FRANCHISE'),
                      ),
                      Visibility(
                        visible:
                            // [2, 3, 5, 6, 8, 9, 11, 12, 14, 18].contains(levelid) &&
                            menuIdList.any((id) =>
                                    [1101, 1102, 1103, 1104].contains(id)) ||
                                isIspAdmin == true,
                        child: _buildSingletile1(
                          header: isIspAdmin ? 'Franchise' : "Franchise Info",
                          iconpath: Icon(Icons.description,
                              color: notifier.getMainText),
                          ontap: () {
                            if (isIspAdmin == true) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ListFranchise(),
                                ),
                              );
                            } else {
                              navigateToViewReseller(resellerID, context);
                            }
                          },
                        ),
                      ),

                      Visibility(
                          //showmenufunction
                          visible: menuIdList
                                  .any((id) => [1201, 1202].contains(id)) ||
                              isIspAdmin == true,
                          child: _buildDivider(title: 'SUBSCRIBER')),
                      Visibility(
                        //showmenufunction
                        visible:
                            menuIdList.any((id) => [1201].contains(id)) ||
                                isIspAdmin == true,
                        child: _buildSingletile1(
                          header: 'List Subscriber',
                          iconpath:
                              Icon(Icons.list, color: notifier.getMainText),
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListSubscriber(),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        //showmenufunction
                        visible:
                            menuIdList.any((id) => [1202].contains(id)) ||
                                isIspAdmin == true,
                        child: _buildSingletile1(
                          header: 'Add Subscriber',
                          iconpath:
                              Icon(Icons.add, color: notifier.getMainText),
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddSubscriber(),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: isSubscriber == true,
                        child: _buildSingletile1(
                          header: 'Overview',
                          iconpath:
                              Icon(Icons.list, color: notifier.getMainText),
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewSubscriber(subscriberId: id),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible:
                            // (levelid == 14 || levelid <=3) &&
                            (hotelLimit != -1 || isSuperAdmin) &&
                                    menuIdList.any((id) => [
                                          1401,
                                          1402,
                                          1403,
                                          1404,
                                          1405
                                        ].contains(id)) ||
                                isIspAdmin == true,
                        child: _buildDivider(title: 'HOTEL'),
                      ),
                      Visibility(
                        visible:
                            // (levelid == 14 || levelid <=3) &&
                            (hotelLimit != -1 || isSuperAdmin) &&
                                    menuIdList.any((id) => [
                                          1401,
                                          1402,
                                          1403,
                                          1404
                                        ].contains(id)) ||
                                isIspAdmin == true,
                        child: _buildSingletile1(
                          header: 'List Hotel',
                          iconpath:
                              Icon(Icons.list, color: notifier.getMainText),
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListHotel(),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible:
                            // (levelid == 14 || levelid <=3) &&
                            (hotelLimit != -1 || isSuperAdmin) &&
                                    menuIdList.any((id) => [
                                         1405
                                        ].contains(id)) ||
                                isIspAdmin == true,
                        child: _buildSingletile1(
                          header: 'Add Hotel',
                          iconpath: Icon(Icons.add_business,
                              color: notifier.getMainText),
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HotelAddUser(hotel: null),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible:
                            // (levelid == 14 || levelid <=3) &&
                            (cardLimit != -1 || isSuperAdmin) &&
                                    menuIdList.any((id) =>
                                        [1001, 1004, 1005,1002, 1003].contains(id)) ||
                                isIspAdmin == true,
                        child: _buildDivider(title: 'CARD'),
                      ),
                      Visibility(
                        visible:
                            // (levelid == 14 || levelid <=3) &&
                            (cardLimit != -1 || isSuperAdmin) &&
                                    menuIdList.any((id) =>
                                        [1001, 1004, 1005].contains(id)) ||
                                isIspAdmin == true,
                        child: _buildSingletile1(
                          header: 'List Card',
                          iconpath:
                              Icon(Icons.list, color: notifier.getMainText),
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListCard(),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible:
                            // (levelid == 14 || levelid <=3) &&
                            (cardLimit != -1 || isSuperAdmin) &&
                                    menuIdList.any((id) =>
                                        [1002, 1003].contains(id)) ||
                                isIspAdmin == true,
                        child: _buildSingletile1(
                          header: 'Generate Card',
                          iconpath: Icon(Icons.add_business,
                              color: notifier.getMainText),
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CardAddUpdate(card: null),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                          visible: isSubscriber == false &&
                                  menuIdList.any((id) =>
                                      [1701, 1702, 1703].contains(id)) ||
                              isIspAdmin == true,
                          child: _buildDivider(title: 'COMPLAINTS')),
                      Visibility(
                        visible: isSubscriber == false &&
                                menuIdList.any(
                                    (id) => [1701, 1702, 1703].contains(id)) ||
                            isIspAdmin == true,
                        child: _buildSingletile1(
                          header: "List Complaints",
                          iconpath:
                              Icon(Icons.list, color: notifier.getMainText),
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
                        visible: isSubscriber == false &&
                                menuIdList.any(
                                    (id) => [1701, 1702, 1703].contains(id)) ||
                            isIspAdmin == true,
                        child: _buildSingletile1(
                          header: "Add Complaints",
                          iconpath: Icon(Icons.construction,
                              color: notifier.getMainText),
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddComplaint()),
                            );
                          },
                        ),
                      ),
                      _buildDivider(title: 'GENERAL'),
                      _buildSingletile1(
                          header: "Refund Policy",
                          iconpath: Icon(Icons.description,
                              color: notifier.getMainText),
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RefundPolicy(),
                              ),
                            );
                          }),

                      _buildSingletile1(
                          header: "Privacy Policy",
                          iconpath: Icon(Icons.privacy_tip,
                              color: notifier.getMainText),
                          ontap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPolicy(),
                              ),
                            );
                          }),

                      _buildSingletile1(
                          header: "Terms & Conditions",
                          iconpath:
                              Icon(Icons.gavel, color: notifier.getMainText),
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
    return ListTileTheme(
        // horizontalTitleGap: 12.0,
        dense: true,
        child: ListTile(
          hoverColor: Colors.transparent,
          onTap: ontap,
          title: Text(
            header,
            style: mediumBlackTextStyle.copyWith(
                fontSize: 14, color: notifier.getMainText),
          ),
          leading: iconpath,
          trailing: const SizedBox(),
          contentPadding:
              EdgeInsets.symmetric(vertical: ispresent ? 5 : 2, horizontal: 8),
        ));
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
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the text horizontally
          children: [
            Expanded(child: Divider(color: notifier.getMainText)),
            Expanded(
              // This will help to fill the available space in the Row
              child: Align(
                alignment: ispresent
                    ? Alignment.centerRight
                    : Alignment
                        .center, // Align right if `ispresent` is true, otherwise center
                child: Text(
                  title,
                  style: mediumBlackTextStyle.copyWith(
                      color: notifier.getMainText,
                      fontSize: 12,
                      fontWeight: FontWeight
                          .bold // Use the provided color or the default color from notifier
                      ),
                ),
              ),
            ),
            Expanded(child: Divider(color: notifier.getMainText)),
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
        contentPadding:
            EdgeInsets.symmetric(vertical: ispresent ? 5 : 2, horizontal: 8),
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
        tilePadding:
            EdgeInsets.symmetric(vertical: ispresent ? 5 : 2, horizontal: 8),
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
