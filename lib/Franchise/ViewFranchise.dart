
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';

import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Franchise/ResellerPackage.dart';
import 'package:crm/Franchise/SettingAndNotification.dart';
import 'package:crm/Franchise/UpdateResellerPWD.dart';
import 'package:crm/Franchise/UploadResellerDocument.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/model/reseller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crm/model/subscriber.dart';
import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:flutter/widgets.dart';

import 'package:crm/service/reseller.dart' as resellerSrv;
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewFranchise extends StatefulWidget {
  ResellarDet? resellerDet;
  int? resellerId;
  ViewFranchise({
    Key? key,
    required this.resellerId,
  }) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<ViewFranchise> with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController authPwdController = TextEditingController();
 

  final formkey = GlobalKey<FormState>();
  int selectedIndex = 0;
  final PageController _pageController = PageController();


  Future<void> fetchData() async {
    final resp = await resellerSrv.fetchResellerDetail(widget.resellerId!);
    setState(() {
      if (resp.error) alert(context, resp.msg);
      widget.resellerDet = resp.data;
    });
    // getShare();
  }

  List<CircleDet> idAndNames = [];

  Future<void> circle() async {
    String apiUrl = 'circle';
    CircleResp resp = (await subscriberSrv.circle(apiUrl));

    setState(() {
      idAndNames = resp.error == true ? [] : resp.data ?? [];
    });
  }

  List<LevelDet> levell = [];
  Future<void> level() async {
    String apiUrl = 'circle';
    LevelDetResp resp = (await resellerSrv.level(apiUrl));

    setState(() {
      levell = resp.error == true ? [] : resp.data ?? [];
    });
  }

  

  bool isExpanded = false;
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool isExpanded3 = false;
  bool isExpanded4 = false;
  bool isExpanded5 = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getMenuAccess();
      

  }

  List<viewResellerPackPriceDet> ResellerPackPrice = [];
  Future<void> getViewResellerPackPrice() async {
    viewResellerPackPriceResp resp =
        await resellerSrv.ViewResellerPackPrice(widget.resellerId!, 1);
    setState(() {
      if (resp.error) alert(context, resp.msg);
      ResellerPackPrice = resp as List<viewResellerPackPriceDet>;
    });
  }

  int levelid = 0;
  bool isIspAdmin = false;
  int id = 0;
  bool isSubscriber = false;
  getMenuAccess() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    levelid = pref.getInt('level_id') as int;
    isIspAdmin = pref.getBool('isIspAdmin') as bool;
    id = pref.getInt('id') as int;
    isSubscriber = pref.getBool('isSubscriber') as bool;
    print('LevelId----${levelid}');
    if (isSubscriber == false) {
      fetchData();
      circle();
      level();
    }
  
  }



  List<dynamic> share_types = [
    {
      'id': -1,
      'name': 'Disabled',
    },
    {
      'id': 0,
      'name': 'Bulk',
      'level': [5, 8, 11, 14, 18],
    },
    {
      'id': 1,
      'name': 'Common share',
      'level': [5, 6, 8, 9, 11, 12],
    },
    {
      'id': 2,
      'name': 'Package share',
      'level': [5, 6, 8, 9, 11, 12],
    },
    {
      'id': 3,
      'name': 'Package price share',
      'level': [5, 6, 8, 9, 11, 12],
    },
  ];

 
 Future<void> refreshData() async {
   setState(() {
      isLoading = true;
    });
  try {
    if (selectedIndex == 0) {
      
      // print('Selecetedvalue1-----$selectedIndex');
      await fetchData();
      circle();
      level();
    } else if (selectedIndex == 1) {
      // print(selectedIndex);
     setState(() {
      isLoading = true;
    });
    //  SubscriberInvoice(subscriberId: widget.subscriberDet!.id);
    // } else if(selectedIndex == 2) {
    //   print(selectedIndex);
    setState(() {
      isLoading = true;
    });
      // SubscriberGraph(
      //   subscriberId: widget.subscriberDet!.id,
      //   Username: widget.subscriberDet!.username,
      // );
    }
  } catch (e, stackTrace) {
    print('Exception occurred: $e');
    // print('Stack trace: $stackTrace');
  } finally {
    
    setState(() {
      isLoading =false;
    });
  }
}

                                    // ResellerPackage(
                                    //     resellerId: widget
                                    //         .resellerDet?.settings.resellerId);
   

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  final textStyle = Theme.of(context).textTheme.bodyLarge;
  final selectedTextStyle = textStyle?.copyWith(fontWeight: FontWeight.bold);

  final notifier = Provider.of<ColorNotifire>(context);

  return DefaultTabController(
          length: 3,
          child: Scaffold(
            
            key: _scaffoldKey,
              drawer: DarwerCode(),
              backgroundColor: notifier.getbgcolor,
              
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
          const ComunTitle(title: 'View Franchise', path: "Franchise"),

                            if(widget.resellerDet != null)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                child: NeumorphicToggle(
                                  style: const NeumorphicToggleStyle(
                                    depth: 5,
                                      backgroundColor: Colors.white
                                  ),
                                  height: 50,
                                  selectedIndex: selectedIndex,
                                  displayForegroundOnlyIfSelected: true,
                                  children: [
                                    ToggleElement(
                                      background:  Center(
                                        child: Text(
                                          "Info",
                                         style: mediumBlackTextStyle.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      foreground:  Center(
                                        child: Text(
                                          "Info",
                                           style: mediumBlackTextStyle.copyWith(color: Colors.white,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ToggleElement(
                                      background: Center(
                                        child: Text(
                                          "Options",
                                          style: mediumBlackTextStyle.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      foreground: Center(
                                        child: Text(
                                          "Options",
                                            style: mediumBlackTextStyle.copyWith(color: Colors.white,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    ToggleElement(
                                      background:  Center(
                                        child: Text(
                                          "Packages",
                                          style: mediumBlackTextStyle.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      foreground: Center(
                                        child: Text(
                                          "Packages",
                                         style: mediumBlackTextStyle.copyWith(color: Colors.white,fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                  thumb: Neumorphic(
                                    style: NeumorphicStyle(
                                      color: appMainColor,
                                      depth: 5,
                                      shape: NeumorphicShape.flat,
                                    
                                      boxShape: NeumorphicBoxShape.roundRect(
                                        BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  onChanged: (index) {
                                    setState(() {
                                      selectedIndex = index;
                                
                                      _pageController.animateToPage(
                                        index,
                                        duration:const Duration(milliseconds: 300),
                                        curve: Curves.ease,
                                      );
                                    });

                                  },

                                ),
                              ),
                           Expanded(
                              child: PageView(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                children: [
                               if(widget.resellerDet != null)
                                       Container(
                                        //  width: screenWidth,
              decoration: BoxDecoration(
                color: notifier.getcontiner,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12))),

                                         child: SingleChildScrollView(
                                                                             child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                                                               Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                             _buildProfile1(isphon: true)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                       ),
                                           
                                  SettingNotification(
                                        resellerId: widget
                                            .resellerDet?.settings.resellerId),
                    
                                  ResellerPackage(
                                        resellerId: widget
                                            .resellerDet?.settings.resellerId),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  if (isLoading) // Show circular progress indicator if isLoading is true
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
              ),
              
                  bottomNavigationBar: BottomAppBar(
      shadowColor: notifier.getprimerycolor,
      color: notifier.getprimerycolor,
      surfaceTintColor: notifier.getprimerycolor,
      child: BottomNavBar(scaffoldKey: _scaffoldKey),
    ),
              ),
        );
  
               
  
}

  Widget _buildProfile1({required bool isphon}) {
     final notifier = Provider.of<ColorNotifire>(context);
   
    return 
    
     Column(
      children: [
       
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               
                                  IconButton(onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          setState(() {
                            isLoading = true; // Set loading to true before fetching data
                          });
                          refreshData().then((_) {
                            setState(() {
                              isLoading = false; // Set loading to false after data is fetched
                            });
                        
                          });
                         
                        }, icon: Icon(Icons.refresh, color:notifier.getMainText),)
              ],
            ),
         ),
        
        Column(
          children: [
            const SizedBox(height: 10),
           Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(isphon ? 10 : padding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                              ),
                              child: Column(
                                children: [
                                 
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: isphon ? 10 : padding),
                                    child: Column(
                                      children: [
                                          
                                  _buildCommonListTile2(title: widget.resellerDet
                                                                              ?.fullName ??
                                                                          'N/A' ,subtitle: PopupMenuButton(
                                      iconColor: notifier.geticoncolor ,
                                       color: notifier.getcontiner,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                                      itemBuilder: (BuildContext context){
                                        
                                        return[
                                        _buildPopupAdminMenuItem()
                                      ];}) ),
                                    _buildCommonListTile(title: "MOBILE", subtitle: ": ${widget.resellerDet
                                                                              ?.mobile
                                                                               ??
                                                                          'N/A'}"),
                                                                         
                                        _buildCommonListTile(title: "ACCOUNT ID", subtitle:': ${widget.resellerDet?.id??'N/A'}'),
                                        
                                        // _buildCommonListTile(title: "ROLE", subtitle:levell
                                        //                                   .firstWhere(
                                        //                                     (level) =>
                                        //                                         level.levelId ==
                                        //                                         widget.resellerDet?.levelId,
                                        //                                     orElse: () => LevelDet(
                                        //                                         levelId: 0,
                                        //                                         levelRole: 0,
                                        //                                         levelName: '',
                                        //                                         levelMenu: []),
                                        //                                   )
                                        //                                   .levelName,),
                                        
                                        _buildCommonListTile(title: "CIRCLE", subtitle: ': ${idAndNames
                                                                          .firstWhere(
                                                                            (circle) =>
                                                                                circle.id ==
                                                                                widget.resellerDet?.circle,
                                                                            orElse: () =>
                                                                                CircleDet(id: 0, circle_name: 'Default Circle Name'),
                                                                          )
                                                                          .circle_name}'),
                                        
                                        _buildCommonListTile(title: "PROFILE ID", subtitle: ': ${widget.resellerDet?.profileId??'N/A'}'),
                                        
                                        _buildCommonListTile(title: "BUSINESS", subtitle: ': ${widget.resellerDet?.company??'N/A'}'),
                                        
                                        _buildCommonListTile(title: "EMAIL", subtitle: ': ${widget.resellerDet?.email??'N/A'}'),
                                        
                                       
                                      ],
                                    ),
                                  ),
                                   
                                ],
                              ),
                            ),
                         const SizedBoxx(),
                                  Container(
                                      padding: EdgeInsets.all(isphon ? 10 : padding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                              ),
                                    child: Material(
                                            // Added Material widget here
                                            color: Colors.transparent, 
                                            child: Theme(
                                               data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                              child: ExpansionTile(
                                                                                   
                                                                                    collapsedIconColor:notifier.getMainText,
                                                                                    iconColor:notifier.getMainText,
                                                                                    expandedAlignment: Alignment.topLeft,
                                                                                   
                                                                                    title:Text(
                                                                                      'BUISNESS DETAILS',
                                                                                      style: mainTextStyle.copyWith(color:notifier.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "BUSINESS", subtitle: ': ${widget.resellerDet?.company??'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "NAS", subtitle: ': ${widget.resellerDet?.nas.nasName??'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "GST", subtitle: widget.resellerDet?.settings.gstNo ??
                                                                            '---'),
                                                                                      
                                                                                      _buildCommonListTile1(title: "VOICE", subtitle:  Icon(
                                                                        widget.resellerDet?.voiceType ==
                                                                                -1
                                                                            ? Icons.close
                                                                            : Icons.check,
                                                                        color: widget.resellerDet?.voiceType ==
                                                                                -1
                                                                            ? Colors.red // Color for close icon
                                                                            : Colors.green, // Color for check icon
                                                                      ),),
                                                                                      
                                                                                      _buildCommonListTile1(title: "OTT", subtitle:  Icon(
                                                                        widget.resellerDet?.ottType ==
                                                                                -1
                                                                            ? Icons.close
                                                                            : Icons.check,
                                                                        color: widget.resellerDet?.ottType ==
                                                                                -1
                                                                            ? Colors.red // Color for close icon
                                                                            : Colors.green, // Color for check icon
                                                                      ),),
                                                                                      
                                                                                      _buildCommonListTile1(title: "CARD", subtitle:Icon(
                                                                        widget.resellerDet?.cardType ==
                                                                                -1
                                                                            ? Icons.close
                                                                            : Icons.check,
                                                                        color: widget.resellerDet?.cardType ==
                                                                                -1
                                                                            ? Colors.red // Color for close icon
                                                                            : Colors.green, // Color for check icon
                                                                      ),),
                                                                                      
                                                                                      _buildCommonListTile1(title: "ADD ON", subtitle: Icon(
                                                                        widget.resellerDet?.addonType ==
                                                                                -1
                                                                            ? Icons.close
                                                                            : Icons.check,
                                                                        color: widget.resellerDet?.addonType ==
                                                                                -1
                                                                            ? Colors.red // Color for close icon
                                                                            : Colors.green, // Color for check icon
                                                                      ),),
                                                                                      
                                                                                      _buildCommonListTile1(title: "VPN", subtitle: Icon(
                                                                        widget.resellerDet?.vpnType ==
                                                                                -1
                                                                            ? Icons.close
                                                                            : Icons.check,
                                                                        color: widget.resellerDet?.vpnType ==
                                                                                -1
                                                                            ? Colors.red // Color for close icon
                                                                            : Colors.green, // Color for check icon
                                                                      ),),
                                                                                      
                                              
                                              ]
                                                                                        
                                                                                  ),
                                            )
                                          ),
                                  ),
                                  const SizedBoxx(),
                                  Container(
                                      padding: EdgeInsets.all(isphon ? 10 : padding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                              ),
                                    child: Material(
                                            // Added Material widget here
                                            color: Colors.transparent, 
                                            child: Theme(
                                               data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                              child: ExpansionTile(
                                                                                   
                                                                                    collapsedIconColor:notifier.getMainText,
                                                                                    iconColor:notifier.getMainText,
                                                                                    expandedAlignment: Alignment.topLeft,
                                                                                   
                                                                                    title:Text(
                                                                                      'BRANCH DETAILS',
                                                                                      style: mainTextStyle.copyWith(color:notifier.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [

                                                                                      
                                                                                      _buildCommonListTile(title: "PRIMARY", subtitle:  ': ${widget.resellerDet?.addressBook[0]
                                                                              .village ??
                                                                          'N/A'}'),
                                                                            if (widget
                                                                          .resellerDet!
                                                                          .addressBook
                                                                          .length >
                                                                      1)
                                                                                      
                                                                                        if (widget
                                                                          .resellerDet!
                                                                          .addressBook
                                                                          .length >
                                                                      1)
                                                                                      _buildCommonListTile(title: "SECONDARY", subtitle:  ': ${widget.resellerDet?.addressBook[1].village ??
                                                                              'N/A'}'),
                                                                                      
                                                                                      
                                              
                                              ]
                                                                                        
                                                                                  ),
                                            )
                                          ),
                                  ),
                                    const SizedBoxx(),
                                  Container(
                                      padding: EdgeInsets.all(isphon ? 10 : padding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                              ),
                                    child: Material(
                                            // Added Material widget here
                                            color: Colors.transparent, 
                                            child: Theme(
                                               data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                              child: ExpansionTile(
                                                                                   
                                                                                    collapsedIconColor:notifier.getMainText,
                                                                                    iconColor:notifier.getMainText,
                                                                                    expandedAlignment: Alignment.topLeft,
                                                                                   
                                                                                    title:Text(
                                                                                      'AGREEMENT DETAILS',
                                                                                      style: mainTextStyle.copyWith(color:notifier.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "STATUS", subtitle:  ': ${widget.resellerDet?.rStatus??'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "START DATE", subtitle:  ': ${widget.resellerDet?.agreement.startDate??'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "END DATE", subtitle: ': ${widget.resellerDet?.agreement.endDate??'N/A'}'),
                                                                                      
                                                                                      
                                              
                                              ]
                                                                                        
                                                                                  ),
                                            )
                                          ),
                                  ),
              
                                  Visibility(
                                     visible: (widget.resellerDet
                                                                ?.levelId !=
                                                            14 &&
                                                        widget.resellerDet
                                                                ?.levelId !=
                                                            18),
                                    child: Column(
                                      children: [
                                        Visibility(
                                           visible: widget
                                                                        .resellerDet!
                                                                        .ottType !=
                                                                    -1,
                                          child: const SizedBoxx()),
                                     
                                    Visibility(
                                       visible: widget
                                                                    .resellerDet!
                                                                    .ottType !=
                                                                -1,
                                      child: Container(
                                          padding: EdgeInsets.all(isphon ? 10 : padding),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(12),
                                                                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                                                    ),
                                        child: Material(
                                                // Added Material widget here
                                                color: Colors.transparent, 
                                                child: Theme(
                                                   data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                                  child: ExpansionTile(
                                                                                       
                                                                                        collapsedIconColor:notifier.getMainText,
                                                                                        iconColor:notifier.getMainText,
                                                                                        expandedAlignment: Alignment.topLeft,
                                                                                       
                                                                                        title:Text(
                                                                                          'OTT SHARE',
                                                                                          style: mainTextStyle.copyWith(color:notifier.getMainText, fontSize: 18),
                                                                                        ),
                                                                                        children:
                                                                                            [
                                                  _buildCommonListTile(title: "TYPE", subtitle:': ${(share_types.firstWhere(
                                        (item) => item['id'] == widget.resellerDet?.ottType,
                                        orElse: () => null
                                      ) ?? {'name': ''})['name']}'),
                                                                                          
                                                                                          _buildCommonListTile(title: "ISP", subtitle:': ${widget.resellerDet!.share.firstWhere(
                                        (shares) => shares.busId ==3 ,
                                        orElse: () => Share(
                                          id: 0, 
                                          resellerId: 0, 
                                          busId: 0, 
                                          ispShare: 0, 
                                          distShare: 0, 
                                          subdistShare: 0, 
                                          resellerShare: 0, 
                                          hotelShare: 0,
                                        )
                                      ).ispShare}%'),
                                                                                          
                                                                                          _buildCommonListTile(title: "DISTRIBUTOR: ", subtitle:': ${widget.resellerDet!.share.firstWhere(
                                        (shares) => shares.busId ==3 ,
                                        orElse: () => Share(
                                          id: 0, 
                                          resellerId: 0, 
                                          busId: 0, 
                                          ispShare: 0, 
                                          distShare: 0, 
                                          subdistShare: 0, 
                                          resellerShare: 0, 
                                          hotelShare: 0,
                                        )
                                      ).distShare}%'),
                                                                                          
                                                                                          _buildCommonListTile(title: "SUB DISTRIBUTOR: ", subtitle: ': ${widget.resellerDet!.share.firstWhere(
                                        (shares) => shares.busId ==3 ,
                                        orElse: () => Share(
                                          id: 0, 
                                          resellerId: 0, 
                                          busId: 0, 
                                          ispShare: 0, 
                                          distShare: 0, 
                                          subdistShare: 0, 
                                          resellerShare: 0, 
                                          hotelShare: 0,
                                        )
                                      ).subdistShare}%'),
                                                                                          
                                                  
                                                    _buildCommonListTile(title: "RESELLER: ", subtitle:': ${widget.resellerDet!.share.firstWhere(
                                        (shares) => shares.busId ==3 ,
                                        orElse: () => Share(
                                          id: 0, 
                                          resellerId: 0, 
                                          busId: 0, 
                                          ispShare: 0, 
                                          distShare: 0, 
                                          subdistShare: 0, 
                                          resellerShare: 0, 
                                          hotelShare: 0,
                                        )
                                      ).resellerShare}%'),
                                                                                          
                                                  
                                                  ]
                                                                                            
                                                                                      ),
                                                )
                                              ),
                                      ),
                                    ),
                                      Visibility(
                                         visible: widget
                                                                    .resellerDet!
                                                                    .voiceType !=
                                                                -1,
                                        child: const SizedBoxx()),
                                    Visibility(
                                       visible: widget
                                                                    .resellerDet!
                                                                    .voiceType !=
                                                                -1,
                                      child: Container(
                                          padding: EdgeInsets.all(isphon ? 10 : padding),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(12),
                                                                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                                                    ),
                                        child: Material(
                                                // Added Material widget here
                                                color: Colors.transparent, 
                                                child: Theme(
                                                   data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                                  child: ExpansionTile(
                                                                                       
                                                                                        collapsedIconColor:notifier.getMainText,
                                                                                        iconColor:notifier.getMainText,
                                                                                        expandedAlignment: Alignment.topLeft,
                                                                                       
                                                                                        title:Text(
                                                                                          'VOICE SHARE',
                                                                                          style: mainTextStyle.copyWith(color:notifier.getMainText, fontSize: 18),
                                                                                        ),
                                                                                        children:
                                                                                            [
                                                  _buildCommonListTile(title: "TYPE", subtitle:': ${(share_types.firstWhere(
                                        (item) => item['id'] == widget.resellerDet?.voiceType,
                                        orElse: () => null
                                      ) ?? {'name': ''})['name']}'),
                                                                                          
                                                                                          _buildCommonListTile(title: "ISP", subtitle: ': ${widget.resellerDet!.share.firstWhere(
                                        (shares) => shares.busId ==2 ,
                                        orElse: () => Share(
                                          id: 0, 
                                          resellerId: 0, 
                                          busId: 0, 
                                          ispShare: 0, 
                                          distShare: 0, 
                                          subdistShare: 0, 
                                          resellerShare: 0, 
                                          hotelShare: 0,
                                        )
                                      ).ispShare}%'),
                                                                                          
                                                                                          _buildCommonListTile(title: "DISTRIBUTOR", subtitle:  ': ${widget.resellerDet!.share.firstWhere(
                                        (shares) => shares.busId ==2 ,
                                        orElse: () => Share(
                                          id: 0, 
                                          resellerId: 0, 
                                          busId: 0, 
                                          ispShare: 0, 
                                          distShare: 0, 
                                          subdistShare: 0, 
                                          resellerShare: 0, 
                                          hotelShare: 0,
                                        )
                                      ).distShare}%'),
                                                                                          
                                                                                          _buildCommonListTile(title: "SUB DISTRIBUTOR", subtitle:': ${widget.resellerDet!.share.firstWhere(
                                        (shares) => shares.busId ==2 ,
                                        orElse: () => Share(
                                          id: 0, 
                                          resellerId: 0, 
                                          busId: 0, 
                                          ispShare: 0, 
                                          distShare: 0, 
                                          subdistShare: 0, 
                                          resellerShare: 0, 
                                          hotelShare: 0,
                                        )
                                      ).subdistShare}%'),
                                                                                          
                                                  
                                                    _buildCommonListTile(title: "RESELLER", subtitle: ': ${widget.resellerDet!.share.firstWhere(
                                        (shares) => shares.busId ==2 ,
                                        orElse: () => Share(
                                          id: 0, 
                                          resellerId: 0, 
                                          busId: 0, 
                                          ispShare: 0, 
                                          distShare: 0, 
                                          subdistShare: 0, 
                                          resellerShare: 0, 
                                          hotelShare: 0,
                                        )
                                      ).resellerShare}%'),
                                                                                          
                                                  
                                                  ]
                                                                                            
                                                                                      ),
                                                )
                                              ),
                                      ),
                                    ),
                                      Visibility(
                                         visible: (widget
                                                                        .resellerDet
                                                                        ?.levelId !=
                                                                    5 &&
                                                                widget.resellerDet
                                                                        ?.levelId !=
                                                                    8 &&
                                                                widget.resellerDet
                                                                        ?.levelId !=
                                                                    11),
                                        child: const SizedBoxx()),
                                    Visibility(
                                       visible: (widget
                                                                        .resellerDet
                                                                        ?.levelId !=
                                                                    5 &&
                                                                widget.resellerDet
                                                                        ?.levelId !=
                                                                    8 &&
                                                                widget.resellerDet
                                                                        ?.levelId !=
                                                                    11),
                                      child: Container(
                                          padding: EdgeInsets.all(isphon ? 10 : padding),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(12),
                                                                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                                                    ),
                                        child: Material(
                                                // Added Material widget here
                                                color: Colors.transparent, 
                                                child: Theme(
                                                   data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                                  child: ExpansionTile(
                                                                                       
                                                                                        collapsedIconColor:notifier.getMainText,
                                                                                        iconColor:notifier.getMainText,
                                                                                        expandedAlignment: Alignment.topLeft,
                                                                                       
                                                                                        title:Text(
                                                                                          'BROADBAND SHARE',
                                                                                          style: mainTextStyle.copyWith(color:notifier.getMainText, fontSize: 18),
                                                                                        ),
                                                                                        children:
                                                                                            [
                                                  _buildCommonListTile(title: "TYPE", subtitle:': ${(share_types.firstWhere(
                                        (item) => item['id'] == widget.resellerDet?.bbType,
                                        orElse: () => null
                                      ) ?? {'name': ''})['name']}'),
                                                                                          
                                                                                          _buildCommonListTile(title: "ISP", subtitle:': ${widget.resellerDet!.share.firstWhere(
                                        (shares) => shares.busId ==1 ,
                                        orElse: () => Share(
                                          id: 0, 
                                          resellerId: 0, 
                                          busId: 0, 
                                          ispShare: 0, 
                                          distShare: 0, 
                                          subdistShare: 0, 
                                          resellerShare: 0, 
                                          hotelShare: 0,
                                        )
                                      ).ispShare}%'),
                                                                                          
                                                                                          _buildCommonListTile(title: "DISTRIBUTOR", subtitle:': ${widget.resellerDet!.share.firstWhere(
                                        (shares) => shares.busId ==1 ,
                                        orElse: () => Share(
                                          id: 0, 
                                          resellerId: 0, 
                                          busId: 0, 
                                          ispShare: 0, 
                                          distShare: 0, 
                                          subdistShare: 0, 
                                          resellerShare: 0, 
                                          hotelShare: 0,
                                        )
                                      ).distShare}%'),
                                                                                          
                                                                                          _buildCommonListTile(title: "SUB DISTRIBUTOR", subtitle: ': ${widget.resellerDet!.share.firstWhere(
                                        (shares) => shares.busId ==1 ,
                                        orElse: () => Share(
                                          id: 0, 
                                          resellerId: 0, 
                                          busId: 0, 
                                          ispShare: 0, 
                                          distShare: 0, 
                                          subdistShare: 0, 
                                          resellerShare: 0, 
                                          hotelShare: 0,
                                        )
                                      ).subdistShare}%'),
                                                                                          
                                                  
                                                    _buildCommonListTile(title: "RESELLER", subtitle: ': ${widget.resellerDet!.share.firstWhere(
                                        (shares) => shares.busId ==1 ,
                                        orElse: () => Share(
                                          id: 0, 
                                          resellerId: 0, 
                                          busId: 0, 
                                          ispShare: 0, 
                                          distShare: 0, 
                                          subdistShare: 0, 
                                          resellerShare: 0, 
                                          hotelShare: 0,
                                        )
                                      ).resellerShare}%'),
                                                                                          
                                                  
                                                  ]
                                                                                            
                                                                                      ),
                                                )
                                              ),
                                      ),
                                    ),
                                     ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  )
                
                     
                    
          ],
        ),
      ],
    );
  }
  Widget _buildSwitchListTile(String title, bool value) {
      
       final notifier = Provider.of<ColorNotifire>(context);
    
    return SwitchListTile(
       activeColor: appMainColor,
      title: Text(
        title,
         style:
                    mediumBlackTextStyle.copyWith(color:notifier.getMainText),
      ),
      value: value,
      onChanged: (val) {
        setState(() {
          // Handle the switch change
        });
      },
    );
  }
  
 PopupMenuItem _buildPopupAdminMenuItem() {
   final notifier = Provider.of<ColorNotifire>(context, listen: false);
    return PopupMenuItem(
      enabled: false,
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            
            width: 200,
            child: Center(
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(20),
                },
                children: [
                  row(title: 'Update Password', icon:Icons.reset_tv),
                
                               row(title: 'Upload Logo', icon:   Icons.people),
                                 row(title: 'Upload Signature', icon:   Icons.edit),
                 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
bool light1 = true;

TableRow row({required String title, required IconData icon}) {
     
    final notifier = Provider.of<ColorNotifire>(context, listen: false);
  
  return TableRow(children: [
    TableRowInkWell(
      onTap: () {
     
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Icon(icon, color:notifier.geticoncolor),
      ),
    ),
    TableRowInkWell(
      onTap: () {
     if (title == 'Update Password') {
          showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  backgroundColor:notifier.getbgcolor,
                                                     
                                                  actions: [
                                                    UpdateResellerPwd(
                                                      resellerId: widget
                                                          .resellerDet!.id,
                                                    ),
                                                  ],
                                                ),
                                              ).then((val) => {
                                                    print('dialog--$val'),
                                                    if (val) fetchData()
                                                  });
        }
         if (title == 'Upload Logo') {
          showDialog(
                                                context: context,
                                                builder: (ctx) =>
                                                    Dialog.fullscreen(
                                                       backgroundColor:notifier.getbgcolor,
                                                        child:
                                                            ResellerDocUpload(
                                                          resellerId: widget
                                                              .resellerDet!.id,
                                                          isLogo: true,
                                                          isSign: false,
                                                        )),
                                              ).then((val) => {
                                                    print('dialog--$val'),
                                                  });
         
        }

          if (title == 'Upload Signature') {
             showDialog(
                                                context: context,
                                                builder: (ctx) =>
                                                    Dialog.fullscreen(
                                                      backgroundColor:notifier.getbgcolor,
                                                        child:
                                                            ResellerDocUpload(
                                                          resellerId: widget
                                                              .resellerDet!.id,
                                                          isLogo: false,
                                                          isSign: true,
                                                        )),
                                              ).then((val) => {
                                                    print('dialog--$val'),
                                                  });
            
          }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 20, top: 12, right: 20),
        child: Text(title,
            style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
      ),
    ),
  ]);
}

Widget _buildCommonListTile1({
  required String title,
  required Widget subtitle,
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
            style:  mediumBlackTextStyle.copyWith(
              color: notifier.getMainText,
            ),
          ),
        ),
        const SizedBox(width: 10), // Add some spacing between title and subtitle
        Expanded(
          child:subtitle,
        ),
      ],
    ),
  );
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
          style:  mediumBlackTextStyle.copyWith(
              color: notifier.getMainText,
            ),
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
            style:  mediumBlackTextStyle.copyWith(
              color: notifier.getMainText,
            ),
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
}
