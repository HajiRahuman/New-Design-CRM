



import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/Subscriber/SubsDataUsageDetails.dart';
import 'package:crm/Components/Subscriber/SubscriberRenewal.dart';
import 'package:crm/Controller/Drawer.dart';

import 'package:crm/Providers/providercolors.dart';

import 'package:crm/components/Subscriber/SubscriberGraph.dart';
import 'package:crm/components/Subscriber/SubscriberInvoice/SubscriberInvoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crm/model/subscriber.dart';
import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriberDashBoard extends StatefulWidget {
  SubscriberFullDet? subscriberDet;
  UpdateUserDataDet? subscriberUpdateDet;
  int? subscriberId;

  SubscriberDashBoard({Key? key, required this.subscriberId}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<SubscriberDashBoard> with SingleTickerProviderStateMixin {
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

  return Scaffold(
       backgroundColor: notifier.getbgcolor,
    key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: notifier.getbgcolor,
        title:Text('GREY SKY',style: mainTextStyle.copyWith(color: appMainColor,fontWeight: FontWeight.bold),),
        // actions: [
        //   IconButton(
        //     icon:const Icon(Icons.person,color: appMainColor,),
        //     onPressed: () {},
        //   )
        // ],
        // leading:const Icon(Icons.logout,color: appMainColor,),
      ),
       drawer: DarwerCode(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.subscriberDet != null)
              Text(
                ' ${widget.subscriberDet!.info!.fullname ??'---'}',
                style:  mediumGreyTextStyle.copyWith(fontSize: 18),
              ),
            const  SizedBox(height: 20),
              
              // Plan Information
              Card(
                color: notifier.getcontiner,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            const  Text('PLAN', style: TextStyle(color:appMainColor,fontWeight: FontWeight.bold,fontFamily: "Gilroy",fontSize: 14)),
                              Text(' ${widget.subscriberDet?.packname ??'---'}',style:  mediumGreyTextStyle.copyWith(fontSize: 16),),
                            ],
                          ),
                          
  //                         TextButton.icon(
  //                           style: TextButton.styleFrom(
  
  //   backgroundColor: notifier.getbgcolor, 
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(10), 
  //   ),
  // ),
  //                           onPressed: () {},
  //                           icon:const Icon(Icons.sync, color: appMainColor),
  //                           label:const Text('Change Plan', style: TextStyle(color: appMainColor,fontSize: 14)),
  //                         ),
                        ],
                      ),
                   const   SizedBox(height: 10),
                      Row(
                        children: [
                         const Text('PLAN TYPE', style: TextStyle(color:appMainColor,fontWeight: FontWeight.bold,fontFamily: "Gilroy",fontSize: 14)),
                         const SizedBox(width: 20),
                          Text('PREPAID-30 DAYS',style:  mediumGreyTextStyle.copyWith(fontSize: 16),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
             const SizedBox(height: 20),
              
              // Days Left & Pay Amount
              Card(
                color: notifier.getcontiner,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Column(
                        children: [
                           
                         CircularPercentIndicator(
            radius: 60.0, // Adjust the size of the circle
            lineWidth: 10.0, // Thickness of the progress arc
            animation: true,
            percent: 3 / 30, // 27 days out of 30
            center: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text('27', style: TextStyle(fontSize: 22, color:appMainColor,fontFamily: "Gilroy",fontWeight: FontWeight.bold)),
                    // SizedBox(height: 10),
                         Text('Days Left', style: TextStyle(fontSize: 14,color: appMainColor,fontFamily: "Gilroy",fontWeight: FontWeight.bold)),
              ],
            ),
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: Colors.grey[400]!,
            progressColor: appMainColor, // Pink progress color
          ),
        
                        ],
                      ),
                      Column(
                        children: [
                      //      Text('Amount Payable',style:  mediumGreyTextStyle.copyWith(fontSize: 16),),
                      //       const   SizedBox(height: 10),
                      // Text('₹ 0.00', style:  mediumBlackTextStyle.copyWith(color: notifier.getMainText,fontSize: 24),),

                          ElevatedButton(
                            onPressed: () {
                                showDialog(
                                        context: context,
                                        builder: (ctx) =>
                                             Dialog.fullscreen(
                                              backgroundColor:notifier.getbgcolor,
                                             
                                              child:
                                              Padding(
                                                padding:const  EdgeInsets.all(8.0),
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
                            },
                            style: ElevatedButton.styleFrom(backgroundColor:appMainColor,
                               shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:const EdgeInsets.all(8),
                            ),
                            child:const Text('Renewal',style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
             const SizedBox(height: 20),
              
              // Expiry & Data Used
              Card(
                color: notifier.getcontiner,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                            const  Text('EXPIRY', style: TextStyle(color:appMainColor,fontWeight: FontWeight.bold,fontFamily: "Gilroy",fontSize: 14)),
                             const   SizedBox(height: 10),
                            if (widget.subscriberDet != null)
                            Text(widget.subscriberDet!.expiration.isNotEmpty  ? DateFormat.yMd().add_jm().format(DateTime.parse(widget.subscriberDet!.expiration)) : "---",style:  mediumGreyTextStyle.copyWith(fontSize: 16),),
                            ],
                          ),
                  //         ElevatedButton(
                  //   style: ElevatedButton
                  //       .styleFrom(
                  //     backgroundColor: widget.subscriberDet?.acctstatus ==
                  //         'Active'
                  //         ? const Color(0xFFF43A047)
                  //         : const Color(
                  //         0xFFFA63C58),
                  //   ),
                  //   child: Text(
                  //     widget.subscriberDet?.acctstatus ??
                  //         'N/A',
                  //     style:
                  //     const TextStyle(
                  //         color: Colors
                  //             .white),
                  //     textAlign: TextAlign
                  //         .center,
                  //   ),
                  //   onPressed: () {},
                  // ),
                        ],
                      ),
                   
                    ],
                  ),
                ),
              ),
                const SizedBox(height: 20),
              
              // Expiry & Data Used
              Card(
                color: notifier.getcontiner,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                            const  Text('DATA USED', style: TextStyle(color:appMainColor,fontWeight: FontWeight.bold,fontFamily: "Gilroy",fontSize: 14)),
                             const   SizedBox(height: 5),
                            if (widget.subscriberDet != null)
                               Text('14.67 GB / ${widget.subscriberDet?.packmode??'---'}',style:  mediumGreyTextStyle.copyWith(fontSize: 16),),
                                const   SizedBox(height: 10),
                             LinearProgressIndicator(
                              minHeight: 5,
                              borderRadius: BorderRadius.circular(8),

          value:1.0, // Set progress value (0.0 to 1.0)
          valueColor: const AlwaysStoppedAnimation<Color>(appMainColor),
          backgroundColor: Colors.grey[300],
        ),
      
                         
                            ],
                          ),
                           const   SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                             TextButton(
  onPressed: () {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
      return SubsDataUsageDetails();
    }));
  },
  style: TextButton.styleFrom(
  backgroundColor: notifier.getbgcolor, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), 
    ),
  ),
  child:const Text(
    'View Usage Details',
    style: TextStyle(color: appMainColor),
  ),
)

                            ],
                          ),
                      
                   
                    ],
                  ),
                ),
              ),
            ],
          ),
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

}