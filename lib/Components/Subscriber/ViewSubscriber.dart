// import 'package:flutter/material.dart';

// class ViewSubscriber extends StatefulWidget {
//  int? subscriberId;, required , required subscriberId, required int subscriberId, required int subscriberId, required int subscriberId, required int SubsID, required int subscriberId, required int subscriberId, required int subscriberId, required int subscriberId, required int subscriberId, required int subscriberId, required int subscriberId, required int subscriberIdint subscriberId
//   ViewSubscriber({super.key, 
//     required this.subscriberId,
//   });

//   @override
//   State<ViewSubscriber> createState() => _ViewSubscriber();
// }

// class _ViewSubscriber extends State<ViewSubscriber> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Column(children: [Text('View Subscriber')],),
//     );
//   }
// }



import 'package:crm/AppStaticData/toaster.dart';
import 'package:flutter/material.dart';


import 'package:crm/model/subscriber.dart';
import 'package:crm/service/subscriber.dart' as subscriberSrv;

import 'package:shared_preferences/shared_preferences.dart';

class ViewSubscriber extends StatefulWidget {
  SubscriberFullDet? subscriberDet;
  UpdateUserDataDet?  subscriberUpdateDet;
int? subscriberId;
  ViewSubscriber({Key? key, 
    required this.subscriberId,
  }) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<ViewSubscriber> {
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
      print('Error loading data: $e');
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

//  Future<void> refreshData() async {
//    setState(() {
//       isLoading = true;
//     });
//   try {
//     if (selectedIndex == 0) {
//       print('Selecetedvalue1-----$selectedIndex');
//       await fetchData();
//       circle();
//       reseller();
//     } else if (selectedIndex == 1) {
//      setState(() {
//       isLoading = true;
//     });
//      SubscriberInvoice(subscriberId: widget.subscriberDet!.id);
//     } else if(selectedIndex == 2) {
//     setState(() {
//       isLoading = true;
//     });
//        SubscriberGraph(
//         subscriberId: widget.subscriberDet!.id,
//         Username: widget.subscriberDet!.username,
//       );
//     }
//   } catch (e, stackTrace) {
//     print('Exception occurred: $e');
//     // print('Stack trace: $stackTrace');
//   } finally {
    
//     setState(() {
//       isLoading =false;
//     });
//   }
// }


  Future<void> circle() async {
    String apiUrl = 'circle';
    CircleResp resp = (await subscriberSrv.circle(apiUrl)) ;

    setState(() {
      idAndNames = resp.error == true ? [] : resp.data ?? [];
    });
  }

  Future<void> reseller() async {
    String apiUrl = 'resellerAlice';
    BranchResp resp = (await subscriberSrv.resellerAlice(apiUrl)) ;
    setState(() {
      reselleralice = resp.error == true ? [] : resp.data ?? [];
    });
  }

 int levelid = 0;
  bool isIspAdmin = false;
  int id=0;
  int selectedAmount = 0;
  bool isSubscriber=false;


  getMenuAccess() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    levelid = pref.getInt('level_id') as int;
    isIspAdmin = pref.getBool('isIspAdmin') as bool;
    id = pref.getInt('id') as int;
    isSubscriber = pref.getBool('isSubscriber') as bool;
    // print('IsSubscriber----${isSubscriber}');
    if(!isIspAdmin && levelid > 4) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
     double screenWidth = MediaQuery.of(context).size.width;
    double screenHigh = MediaQuery.of(context).size.height;
    return Scaffold(
body: Center(child: Text('View Subscriber'),),

    );  }
}
