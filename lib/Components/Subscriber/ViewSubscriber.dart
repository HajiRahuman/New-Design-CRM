
import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/Subscriber/AccountStatus.dart';
import 'package:crm/Components/Subscriber/AddSubscriber/AddSubscriber.dart';
import 'package:crm/Components/Subscriber/Complaints/Complaints.dart';
import 'package:crm/Components/Subscriber/MacBinding.dart';
import 'package:crm/Components/Subscriber/SessionCheck&Stop.dart';
import 'package:crm/Components/Subscriber/SubscriberRenewal.dart';
import 'package:crm/Components/Subscriber/UpdateAuthPwd.dart';
import 'package:crm/Components/Subscriber/UpdatePackage&Validity.dart';
import 'package:crm/Components/Subscriber/UpdateProfileId.dart';
import 'package:crm/Components/Subscriber/UpdateProfilePwd.dart';
import 'package:crm/Components/Subscriber/UploadDocument.dart';
import 'package:crm/Components/Subscriber/ViewDocument.dart';
import 'package:crm/Components/Subscriber/live_graph.dart';
import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/components/Subscriber/SubscriberGraph.dart';
import 'package:crm/components/Subscriber/SubscriberInvoice/SubscriberInvoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crm/model/subscriber.dart';
import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewSubscriber extends StatefulWidget {
  SubscriberFullDet? subscriberDet;
  UpdateUserDataDet? subscriberUpdateDet;
  int? subscriberId;

  ViewSubscriber({Key? key, required this.subscriberId}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<ViewSubscriber> with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController authPwdController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int selectedIndex = 0;
  PageController _pageController = PageController();

  Future<void> fetchData() async {
    final resp = await subscriberSrv.fetchSubscriberDetail(widget.subscriberId!);
    setState(() {
      if (resp.error) alert(context, resp.msg);
      widget.subscriberDet = resp.data;
    });

    await circle();
    await reseller();
  }

  Future<void> fetchData1() async {
    final resp = await subscriberSrv.getUpdateUserDetail(widget.subscriberId!);
    setState(() {
      if (resp.error) alert(context, resp.msg);
      widget.subscriberUpdateDet = resp.data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    getMenuAccess();
    controller2 = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller2.dispose();
    super.dispose();
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      await fetchData();
      await fetchData1();
    } catch (e) {
      // Handle any errors if needed
      // print('Error loading data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isExpanded = false;
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  List<CircleDet> idAndNames = [];
  List<BranchDet> reselleralice = [];
  bool isLoading = false;

  Future<void> circle() async {
    String apiUrl = 'circle';
    CircleResp resp = await subscriberSrv.circle(apiUrl);

    setState(() {
      idAndNames = resp.error == true ? [] : resp.data ?? [];
    });
  }

  Future<void> reseller() async {
    String apiUrl = 'resellerAlice';
    BranchResp resp = await subscriberSrv.resellerAlice(apiUrl);
    setState(() {
      reselleralice = resp.error == true ? [] : resp.data ?? [];
    });
  }

  int levelid = 0;
  bool isIspAdmin = false;
  int id = 0;
  int selectedAmount = 0;
  bool isSubscriber = false;

  getMenuAccess() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    levelid = pref.getInt('level_id') as int;
    isIspAdmin = pref.getBool('isIspAdmin') as bool;
    id = pref.getInt('id') as int;
    isSubscriber = pref.getBool('isSubscriber') as bool;

    if (!isIspAdmin && levelid > 4) {
      fetchData();
    }
  }

  late TabController controller2;

  int tab1 = 0;
  int tab2 = 0;
  int tab3 = 0;

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

 Future<void> refreshData() async {
   setState(() {
      isLoading = true;
    });
  try {
    if (selectedIndex == 0) {
      
      print('Selecetedvalue1-----$selectedIndex');
      await fetchData();
      circle();
      reseller();
    } else if (selectedIndex == 1) {
      print(selectedIndex);
     setState(() {
      isLoading = true;
    });
     SubscriberInvoice(subscriberId: widget.subscriberDet!.id);
    } else if(selectedIndex == 2) {
      print(selectedIndex);
    setState(() {
      isLoading = true;
    });
       SubscriberGraph(
        subscriberId: widget.subscriberDet!.id,
        Username: widget.subscriberDet!.username,
      );
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

 @override
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
          const ComunTitle(title: 'View Subscriber', path: "Subscriber"),

                            if (widget.subscriberDet != null)
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
                                         style: mediumBlackTextStyle.copyWith(),
                                        ),
                                      ),
                                      foreground:  Center(
                                        child: Text(
                                          "Info",
                                           style: mediumBlackTextStyle.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    ToggleElement(
                                      background: Center(
                                        child: Text(
                                          "Invoice",
                                          style: mediumBlackTextStyle.copyWith(),
                                        ),
                                      ),
                                      foreground: Center(
                                        child: Text(
                                          "Invoice",
                                            style: mediumBlackTextStyle.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    ToggleElement(
                                      background:  Center(
                                        child: Text(
                                          "Graph",
                                          style: mediumBlackTextStyle.copyWith(),
                                        ),
                                      ),
                                      foreground: Center(
                                        child: Text(
                                          "Graph",
                                         style: mediumBlackTextStyle.copyWith(color: Colors.white),
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
                               if(   widget.subscriberDet != null)
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
                                           
                                  if (widget.subscriberDet != null)
                                  SubscriberInvoice(subscriberId:widget.subscriberDet!.id),
                                  if (widget.subscriberDet != null)
                                  SubscriberGraph(subscriberId:widget.subscriberDet!.id, Username:widget.subscriberDet!.username,),
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
       
        
        
       
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             
                                IconButton( onPressed: () async {
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
                       
                      }, icon: Icon(Icons.refresh, color: notifier.getMainText),)
            ],
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
                                        _buildCommonListTile2(title:widget.subscriberDet
                                                     ?.profileid ??'N/A',subtitle:  PopupMenuButton(
                                      iconColor: notifier.geticoncolor ,
                                       color: notifier.getcontiner,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                                      itemBuilder: (BuildContext context){
                                        
                                        return[
                                        _buildPopupAdminMenuItem()
                                      ];}) ),
                
                                        _buildCommonListTile(title: "ACCOUNT TYPE", subtitle: ': ${widget.subscriberDet
                                                   ?.acctype ==
                                                   0
                                                   ? 'Normal'
                                                   : 'MAC'}',),
                                        
                                        _buildCommonListTile1(
  title: "ACCOUNT STATUS",
  subtitle: widget.subscriberDet?.acctstatus ?? 'N/A',
  subtitleColor: widget.subscriberDet?.acctstatus  == 'Active'
                                      ? const Color(0xff43A047) // Green for Active
                                      : const Color(0xFFEE4B2B), // Red for Inactive
                                  borderColor: widget.subscriberDet?.acctstatus  == 'Active'
                                      ? const Color(0xff43A047) // Green border for Active
                                      : const Color(0xFFEE4B2B), // Red // Color when not Online
),

                                        
                                        _buildCommonListTile1(
  title: "ONLINE STATUS",
  subtitle: widget.subscriberDet?.conn ?? 'N/A',
  subtitleColor: widget.subscriberDet?.conn  == 'Online'
                                      ? const Color(0xff43A047) // Green for Active
                                      : const Color(0xFFEE4B2B), // Red for Inactive
                                  borderColor: widget.subscriberDet?.conn == 'Online'
                                      ? const Color(0xff43A047) // Green border for Active
                                      : const Color(0xFFEE4B2B), // Red // Color when not Online
),


                                        
                                        _buildCommonListTile(title: "EXPIRY DATE", subtitle: ': ${DateFormat('dd/MM/yyyy-hh:mm a').format(DateTime.parse(widget.subscriberDet?.expiration ?? 'N/A'))}'),
                                        
                                        _buildCommonListTile(title: "IPV4 MODE", subtitle: ': ${widget.subscriberDet
                                                      ?.ipmode ??
                                                  'N/A'}',),
                                        
                                         _buildCommonListTile(title: "RADIUS REJECTION MSG", subtitle:": ${widget.subscriberDet
                                                      ?.authreject}"),
                                        
                                       _buildCommonListTile(
  title: "RADIUS REJECTION ON", 
  subtitle: widget.subscriberDet!.authreject_dt.isNotEmpty 
      ? ': ${DateFormat('dd/MM/yyyy-hh:mm a').format(DateTime.parse(widget.subscriberDet?.authreject_dt ?? 'N/A'))}' 
      : "---"
),


                                                    
                                        
                                          if ( widget.subscriberDet?.conn == 'Online')
                                        _buildCommonListTile(title: "IP ADDRESS", subtitle:  ': ${widget.subscriberDet
                                                      ?.framedipaddress ??
                                                  'N/A'}'),
                                                          
                                        
                                          if ( widget.subscriberDet?.conn == 'Online')
                                        _buildCommonListTile(title: "NAS IP ADDRESS", subtitle: ': ${widget.subscriberDet
                                                      ?.nasipaddress ??
                                                  'N/A'}'),
                                                        
                                        
                                          if ( widget.subscriberDet?.conn == 'Online')
                                        _buildCommonListTile(title: "LOGIN MAC", subtitle:': ${widget.subscriberDet
                                                      ?.callingstationid ??
                                                  'N/A'}'),
                                        
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
                                                                                      'PACK DETAILS',
                                                                                      style: mainTextStyle.copyWith(color:notifier.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "ACTIVE PACK", subtitle:': ${widget.subscriberDet?.packname ??'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "MODE", subtitle:': ${widget.subscriberDet?.packmode ??'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "RUNNING PACK", subtitle:': ${widget.subscriberDet?.rpackname??'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "PRICE NAME", subtitle:': ${widget.subscriberDet?.pricename ??'N/A'}'),
                                                                                      
                                              
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
                                                                                      'ONT INFORMATION',
                                                                                      style: mainTextStyle.copyWith(color:notifier.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "OLT", subtitle:': ${widget.subscriberDet?.oltname ??'---'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "PON", subtitle:': ${widget.subscriberDet?.pon ??'---'}'),
                                                                                      
                                                                                      _buildCommonListTile3(title: "STATUS", subtitle:  Icon(
                                                                        widget.subscriberDet?.onustatus ==
                                                                                false
                                                                            ? Icons.arrow_back
                                                                            : Icons.settings_ethernet,
                                                                        color: widget.subscriberDet?.onustatus ==
                                                                              false
                                                                            ? Colors.red // Color for close icon
                                                                            : Colors.green, // Color for check icon
                                                                      ),),
                                                                                      
                                                                                      _buildCommonListTile(title: "TX/RX", subtitle:': ${widget.subscriberDet?.onutx ??'---'}${'/'}${widget.subscriberDet?.onurx ??'---'}')
                                                                                      
                                              
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
                                                                                      'PERSONAL DETAILS',
                                                                                      style: mainTextStyle.copyWith(color:notifier.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "NAME", subtitle:': ${widget.subscriberDet!.info!.fullname}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "ACCOUNT ID", subtitle:': ${widget.subscriberDet?.id ??'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "CIRCLE", subtitle: ': ${idAndNames
                                                                .firstWhere(
                                                                  (circle) => circle.id == widget.subscriberDet?.circleid,
                                                              orElse: () => CircleDet(id: 0, circle_name: 'Default Circle Name'),
                                                            )
                                                                .circle_name}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "BRANCH", subtitle:': ${reselleralice
                                                                .firstWhere(
                                                                  (reseller) => reseller.resellerid == widget.subscriberDet?.resellerid,
                                                              orElse: () => BranchDet(resellerid: 0, village: 'Default Village'),
                                                            )
                                                                .village}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "CONNECTION TYPE", subtitle:  ': ${widget.subscriberDet
                                                                ?.conntype
                                                                .toString() !=
                                                                null
                                                                ? (widget.subscriberDet?.conntype ==
                                                                0
                                                                ? 'Home'
                                                                : (widget.subscriberDet?.conntype == 1
                                                                ? 'Demo'
                                                                : (widget.subscriberDet?.conntype == 2 ? 'Corporate' : 'Unknown')))
                                                                : '---' }'),
                                                                                      
                                                                                      _buildCommonListTile(title: "CREATED DATE", subtitle: ': ${widget.subscriberDet?.createdon ??'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "MOBILE", subtitle:': ${widget.subscriberDet?.info?.mobile ??'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "EMAIL", subtitle:  ': ${widget.subscriberDet!.info?.emailpri ??'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "GST", subtitle: ': ${widget.subscriberDet!.info?.ugst ??'N/A'}'),
                                                                                      
                                              
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
                                                                                      'ADDRESS DETAILS',
                                                                                      style: mainTextStyle.copyWith(color:notifier.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "STATE", subtitle:': ${widget.subscriberDet!.address_book.isNotEmpty
                                                              ? widget.subscriberDet!.address_book[0].state.toString()
                                                              : 'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "DISTRICT", subtitle:  ': ${widget.subscriberDet!.address_book.isNotEmpty
                                                              ? widget.subscriberDet!.address_book[0].district.toString()
                                                              : 'N/A'}'),
                                                                                      
                                                                                      _buildCommonListTile(title: "INSTALLATION ADDRESS", subtitle:': ${widget.subscriberDet!.address_book.isNotEmpty
                                                              ? widget.subscriberDet!.address_book[0].address.toString()
                                                              : 'N/A'}'),
                                                               if (widget.subscriberDet!.address_book.length >1) 
                                                                                      
                                                                                       if (widget.subscriberDet!.address_book.length >1) 
                                                                                      Visibility(
                                                                                          visible:widget.subscriberDet!.info!.addressflag=true    ,
                                                                                        child: _buildCommonListTile(title: "BILLING ADDRESS", subtitle: ': ${widget.subscriberDet!.address_book.isNotEmpty
                                                              ? widget.subscriberDet!.address_book[1].address.toString()
                                                              : 'N/A'}'),
                                                                                      ),
                                                                                      
                                              
                                              ]
                                                                                        
                                                                                  ),
                                            )
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

  
Widget _buildCommonListTile3({
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
            style: mediumGreyTextStyle,
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

void _showPopupMenu(BuildContext context, Offset offset, Size screenSize) {
  final RelativeRect position = RelativeRect.fromLTRB(
    offset.dx,
    offset.dy,
    screenSize.width - offset.dx,
    screenSize.height - offset.dy,
  );

  showMenu(
    context: context,
    position: position,
    items: <PopupMenuEntry>[
      _buildPopupAdminMenuItem(),
      // Add more PopupMenuItem or PopupMenuDivider entries here if needed
    ],
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
          // height: 700,
          width: 200,
          child: Center(
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(20),
              },
              children: [
                row(title: 'Renewal', icon: Icons.refresh),
                if ( isSubscriber==false)
                row(title: 'Update', icon: Icons.update),
                  if ( isSubscriber==false)
                row(title: 'Update Account Type', icon: Icons.update),
                if (widget.subscriberDet?.acctype != 1 && isSubscriber==false)
                row(title: 'Mac Binding', icon: Icons.subtitles),
                 if ( isSubscriber==false && levelid==3)
                row(title: 'Update Pack & Validity', icon: Icons.system_security_update_warning),
                if (widget.subscriberDet?.acctype != 1) 
                row(title: 'View Password', icon: Icons.password),
                 if ( isSubscriber==false)
                row(title: 'Update Profile Password', icon: Icons.reset_tv),
                if (widget.subscriberDet?.acctype !=1 && isSubscriber==false) 
                row(title: 'Update Auth Password', icon: Icons.update),
                 if ( isSubscriber==false)
                row(title: 'Update Profile ID', icon: Icons.fingerprint),
                 if ( isSubscriber==false)
                row(title: 'Account Status', icon: Icons.account_box),
                 if (widget.subscriberDet?.conn == 'Online')
                row(title: 'Live Graph', icon: Icons.reset_tv),
                   if (widget.subscriberDet?.conn == 'Online' && isSubscriber==false)
                row(title: 'Session Check/Stop', icon: Icons.fact_check),
                row(title: 'Upload Document', icon: Icons.upload_file),
                  if (widget.subscriberDet!.info?.addressflag! == true)
                  row(title: 'Upload Document(Different Address)', icon: Icons.upload_file),
                row(title: 'Upload Picture', icon: Icons.people),
                row(title: 'Upload Signature', icon: Icons.edit),
                row(title: 'View Document', icon: Icons.edit),
                row(title: 'Complaints', icon: Icons.note_add),
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
  double screenWidth = MediaQuery.of(context).size.width;
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
        if (title == 'Renewal') {
          showDialog(
                                        context: context,
                                        builder: (ctx) =>
                                             Dialog.fullscreen(
                                              backgroundColor:notifier.getbgcolor,
                                             
                                              child:
                                              Padding(
                                                padding:  EdgeInsets.all(8.0),
                                                child: SubscriberRenewal(resellerid: widget.subscriberDet!.resellerid,
                                                  uid: widget.subscriberDet!.id,
                                                  srvusermode:widget.subscriberDet!.srvusermode,
                                                  packid: widget.subscriberDet!.packid,subscriberId:
                                                    widget.subscriberDet!.id, expiration:widget.subscriberDet!.expiration,voiceid:widget.subscriberDet!.voiceid)
                                              ),

                                            ),
                                      ).then((val) => {
                                          // print('dialog--$val'),
                                          if (val) fetchData()
                                        });
        }
          if (title == 'Update') {
           Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) {
                                                return AddSubscriber(subscriberId: widget.subscriberDet!.id,
                                                  circleid: widget.subscriberDet!.circleid,
                                                  resellerid:widget.subscriberDet!.resellerid,
                                                  mac:widget.subscriberDet!.mac,
                                                  srvusermode: widget.subscriberDet!.srvusermode,
                                                aliceid: widget.subscriberDet!.info!.aliceid,
                                                );

                                              })).then((val) => {
                                          // print('dialog--$val'),
                                          if (val) fetchData()
                                        });
        }
        if (title == 'Update Account Type') {
          
        }
         if (title == 'Mac Binding') {
            showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              backgroundColor:notifier.getbgcolor,
                                              
                                              actions: [
                                                MacBinding(
                                                  subscriberId:
                                                  widget.subscriberDet!.id,
                                                  acctstatus:widget.subscriberDet!.acctstatus,
                                                  conn: widget.subscriberDet!.conn,
                                                  enablemac:widget.subscriberDet!.enablemac,
                                                  acctype:widget.subscriberDet!.acctype,
                                                  simultaneoususe: widget.subscriberDet!.simultaneoususe,
                                                  mac:widget.subscriberDet!.mac,
                                                ),
                                              ],
                                            ),
                                          ).then((val) => {
                                            // print('dialog--$val'),
                                            if (val) fetchData()
                                          });
        }
         if (title == 'Update Pack & Validity') {
          showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor:notifier.getbgcolor,
                                            
                                            actions: [
                                              UpdatePackAndValidity(
                                                subscriberId:
                                                widget.subscriberDet!.id, expiration:widget.subscriberDet!.expiration,
                                                resellerid:  widget.subscriberDet!.resellerid, packid: widget.subscriberDet!.packid,
                                                simultaneoususe: widget.subscriberDet!.simultaneoususe,

                                              ),
                                            ],
                                          ),
                                        ).then((val) => {
                                          // print('dialog--$val'),
                                          if (val) fetchData()
                                        });
        }
        
                                         if (title == 'View Password') {
           showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                          
                                           backgroundColor:notifier.getbgcolor,
                                            title:ListTile(
                                                    title:  Text(
                                                      'PASSWORD',
                                                      style: TextStyle(
                                                        fontSize: screenWidth * 0.05,
                         color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    trailing:  CircleAvatar(
                                                                        radius: 20,
                                                                        child: IconButton(
                                                                          onPressed: () {
                                                                            Navigator.of(
                                                                                context)
                                                                                .pop();
                                                                          },
                                                                          icon: const Icon(
                                                                            Icons
                                                                                .close_rounded,
                                                                                color: Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                  ),
                                          
                                            content: Text(
                                              "  Authentication:-  ${widget.subscriberDet?.authpsw ?? 'N/A'}",
                                             style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                            ),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                 backgroundColor: appMainColor
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.of(ctx).pop();
                                                  });
                                                },
                                                child: const Text('Ok',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        );
        }

          if (title == 'Update Profile Password') {
          showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor:notifier.getbgcolor,
                                            
                                            actions: [
                                               UpdateProfilePwd(
                                                subscriberId:
                                                widget.subscriberDet!.id,
                                              ),
                                            ],
                                          ),
                                        ).then((val) => {
                                          // print('dialog--$val'),
                                          if (val) fetchData()
                                        });
        }
         if (title == 'Update Auth Password') {
          showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor:notifier.getbgcolor,
                                            
                                            actions: [
                                              UpdateAuthPwd(
                                                subscriberId:
                                                widget.subscriberDet!.id,
                                              ),
                                            ],
                                          ),
                                        ).then((val) => {
                                          // print('dialog--$val'),
                                          if (val) fetchData()
                                        });
        }
         if (title == 'Update Profile ID') {
          showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor:notifier.getbgcolor,
                                            
                                            actions: [
                                              UpdateProID(
                                                subscriberId:
                                                widget.subscriberDet!.id,
                                                acctype:
                                                widget.subscriberDet!.acctype,
                                              ),
                                            ],
                                          ),
                                        ).then((val) => {
                                          // print('dialog--$val'),
                                          if (val) fetchData()
                                        });
        }
          if (title == 'Account Status') {
          showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor:notifier.getbgcolor,
                                            
                                            actions: [
                                             AccountStatus(
                                                subscriberId:
                                                widget.subscriberDet!.id,
                                                acctstatus: widget
                                                    .subscriberDet!.acctstatus,
                                              ),
                                            ],
                                          ),
                                        ).then((val) => {
                                          // print('dialog--$val'),
                                          if (val) fetchData()
                                        });
        }
          if (title == 'Live Graph') {
            showDialog(
                                          context: context,
                                          builder: (ctx) =>   Dialog.fullscreen(
                                                 backgroundColor:notifier.getbgcolor,
                                              child:Live_Graph(subscriberId:   widget.subscriberDet!.id)                                             ),
                                        );
        
        }
         if (title == 'Session Check/Stop') {
           showDialog(
                                               context: context,
                                               builder: (ctx) =>
                                                   Dialog.fullscreen(
                                                        backgroundColor:notifier.getbgcolor,
                                                     child:
                                                       Padding(
                                                         padding:  EdgeInsets.all(8.0),
                                                         child: SessionCheckStop(username:widget.subscriberDet!.username,

                                                     ),
                                                       ),

                                                   ),
                                             ).then((val) =>
                                             {
                                              //  print('dialog--$val'),
                                               if (val) fetchData()
                                             });
           
        
        }
         if (title == 'Upload Document') {
           showDialog(
                                          context: context,
                                          builder: (ctx) =>
                                              Dialog.fullscreen(
                                                   backgroundColor:notifier.getbgcolor,
                                                  child:DocUpload(subscriberId:   widget.subscriberDet!.id,isProfile:false, isDocum1:true, isDocum2: false, isSign: false,)                                                            ),
                                        ).then((val) => {
                                          // print('dialog--$val'),
                                          if (val) fetchData()
                                        });
          
        
        }
         if (title == 'Upload Document(Different Address)') {
           showDialog(
                                            context: context,
                                            builder: (ctx) =>
                                                Dialog.fullscreen(
                                                   backgroundColor:notifier.getbgcolor,
                                                    child:DocUpload(subscriberId:   widget.subscriberDet!.id,isProfile:false, isDocum1: false, isDocum2: true, isSign: false,)                                                            ),
                                          ).then((val) => {
                                            // print('dialog--$val'),
                                            if (val) fetchData()
                                          });
          
        
        }
         if (title == 'Upload Picture') {
           showDialog(
                                          context: context,
                                          builder: (ctx) =>
                                              Dialog.fullscreen(
                                                  backgroundColor:notifier.getbgcolor,
                                                  
                                                  child:DocUpload(subscriberId:   widget.subscriberDet!.id,isProfile:true, isDocum1: false, isDocum2: false, isSign: false,)                                                            ),
                                        ).then((val) => {
                                          // print('dialog--$val'),

                                        });
        
        }
         if (title == 'Upload Signature') {
           showDialog(
                                          context: context,
                                          builder: (ctx) =>
                                              Dialog.fullscreen(
                                                  backgroundColor:notifier.getbgcolor,
                                                 
                                                  child:DocUpload(subscriberId:   widget.subscriberDet!.id,isProfile:false, isDocum1: false, isDocum2: false, isSign:true,)                                                            ),
                                        ).then((val) => {
                                          // print('dialog--$val'),
                                        });
        
        }
        if (title == 'View Document') {
          showDialog(
                                          context: context,
                                          builder: (ctx) =>
                                              Dialog.fullscreen(
                                                
                                                 backgroundColor:notifier.getbgcolor,
                                                  child:ViewDocuments(subscriberId: widget.subscriberDet!.id,)                                                         ),
                                        ).then((val) => {
                                          // print('dialog--$val'),
                                        });
        }
         if (title == 'Complaints') {
           Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                           Complaints(subscriberId: widget.subscriberDet!.id, resellerID: widget.subscriberDet!.resellerid )                                                        ),
                                        ).then((val) => {
                                          // print('dialog--$val'),
           });
         
                        }
                      
                    
        
         
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 20, top: 12, right: 20),
        child: Stack(
          // alignment: Alignment.topRight, // Align badge to top right
          children: [
            Text(
              title,
              style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),
            ),
            if (title == 'Session Check/Stop') 
              Positioned(
                // top: -5, 
                right: -0.1,
                child: Badge(
                  label: Text(
                                              '${widget.subscriberDet!.soc}', 
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                      
                ),
              ),
          ],
        ),
      ),
    ),
  ]);
}
 
Widget _buildCommonListTile1({
  required String title,
  required String subtitle,
  Color? subtitleColor,
  Color? borderColor, // Optional border color parameter
}) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);

  return 
  Container(
    padding:const EdgeInsets.symmetric(vertical:2), // Control the gap between items
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
          child:Container(
                padding: const EdgeInsets.fromLTRB(3,0, 3,0), // Add padding for better visual appearance
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor ?? Colors.transparent), // Use provided border color or transparent if not provided
                  borderRadius: BorderRadius.circular(4), // Border radius
                ),
                child: Text(
                   textAlign: TextAlign.center,
                  subtitle,
                  style: mediumBlackTextStyle.copyWith(
                    color: subtitleColor ?? notifier.getMainText, // Use the provided color or the default color from notifier
                  ),
                ),
        )
        ),
        
      ],
    ),
  );
  
  
}Widget  _buildCommonListTile2({
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



}


class SampleWidget extends StatelessWidget {
  const SampleWidget({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Column(
        children: [
          Text(label),
          // Additional content that may require scrolling can be added here.
          // For example, a long list of items or text.
          SizedBox(height: 1000), // Simulate long content.
        ],
      ),
    );
  }
}
