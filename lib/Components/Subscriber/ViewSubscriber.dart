
import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:flutter/material.dart';
import 'package:crm/model/subscriber.dart';
import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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

  ColorNotifire notifire = ColorNotifire();

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
                  const ComunTitle(title: 'View Subscriber', path: "Users"),
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
                  const SizedBoxx(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfile1({required bool isphon}) {
     final notifier = Provider.of<ColorNotifire>(context);
   
    return 
    
     Column(
      children: [
       
        
        
        SizedBox(
          height:40,
          child: TabBar(
            dividerColor:Colors.transparent,
            isScrollable: true,
            controller: controller2,
            indicator: BoxDecoration(
              color: appMainColor,
              borderRadius: BorderRadius.circular(12),
            ),
            labelStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            unselectedLabelColor: appMainColor,
            labelColor: Colors.white,
            onTap: (value) {
              setState(() {
                tab2 = value;
              });
            },
            tabs: const [
              Tab(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Info"),
              )),
              Tab(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Invoice"),
              )),
              Tab(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Graph"),
              )),
            ],
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             
                                IconButton(onPressed: (){}, icon:const Icon(Icons.refresh, color: Colors.black),)
            ],
          ),
        Column(
          children: [
            const SizedBox(height: 10),
            tab2 == 0
                ? Row(
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
                                  ListTile(
                                    title: Text(
                                      'name',
                                      style: mediumBlackTextStyle.copyWith(color: notifire.getMainText),
                                    ),
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage("assets/avatar2.png"),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: _buildCommonListTile(title: "MOBILE: ", subtitle: 'mobile'),
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
                                        _buildCommonListTile(title: "PROFILE ID: ", subtitle: 'profileId'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "ACCOUNT TYPE: ", subtitle: 'normal'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "ACCOUNT STATUS: ", subtitle: 'active'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "ONLINE STATUS: ", subtitle: 'online'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "EXPIRY DATE: ", subtitle: 'status'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "IPV4 MODE: ", subtitle: 'status'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "RADIUS REJECTION MSG: ", subtitle: 'status'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "RADIUS REJECTION ON: ", subtitle: 'status'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "IP ADDRESS: ", subtitle: 'status'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "NAS IP ADDRESS: ", subtitle: 'status'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "LOGIN MAC: ", subtitle: 'status'),
                                        const SizedBox(height: 10),
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
                                                                                   
                                                                                    collapsedIconColor: notifire.getMainText,
                                                                                    iconColor: notifire.getMainText,
                                                                                    expandedAlignment: Alignment.topLeft,
                                                                                   
                                                                                    title:Text(
                                                                                      'PACK DETAILS',
                                                                                      style: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "ACTIVE PACK: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "MODE: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "RUNNING PACK: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "PRICE NAME: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                              
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
                                                                                   
                                                                                    collapsedIconColor: notifire.getMainText,
                                                                                    iconColor: notifire.getMainText,
                                                                                    expandedAlignment: Alignment.topLeft,
                                                                                   
                                                                                    title:Text(
                                                                                      'PERSONAL DETAILS',
                                                                                      style: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "NAME: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "ACCOUNT ID: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "CIRCLE: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "BRANCH: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "CONNECTION TYPE: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "CREATED DATE: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "MOBILE: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "EMAIL: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "GST: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                              
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
                                                                                   
                                                                                    collapsedIconColor: notifire.getMainText,
                                                                                    iconColor: notifire.getMainText,
                                                                                    expandedAlignment: Alignment.topLeft,
                                                                                   
                                                                                    title:Text(
                                                                                      'ADDRESS DETAILS',
                                                                                      style: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "STATE: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "DISTRICT: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "INSTALLATION ADDRESS: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "BILLING ADDRESS: ", subtitle: 'normal'),
                                                                                      const SizedBox(height: 10),
                                              
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
                : tab2 == 1
                    ? Center(
                      child: Text(
                          "Invoice Page.",
                          style: TextStyle(
                            fontSize: 14,
                            color: notifire.getMainText,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                    )
                    : Center(
                      child: Text(
                          "Graph Page.",
                          style: TextStyle(
                            fontSize: 14,
                            color: notifire.getMainText,
                            fontWeight: FontWeight.w100,
                          ),
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
            height: 700,
            width: 200,
            child: Center(
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(20),
                },
                children: [
                  row(title: 'Renewal', icon: Icons.refresh, index: 13),
                  row(title: 'Update', icon:Icons.update, index: 12),
                  row(title: 'Update Account Type', icon:Icons.update,index: 0),
                  row(
                      title: 'Mac Binding',
                      icon: Icons.subtitles,
                      index: 0),
                  row(title: 'Update Pack & Validity', icon: Icons.system_security_update_warning,index: 0),
                  row(
                      title: 'View Password',
                     icon:Icons.password,
                      index: 11),
                  row(title: 'Update Profile Password', icon:Icons.reset_tv,index: 26),
                   row(title: 'Update Auth Password',icon:  Icons.update,index: 26),
                     row(title: 'Update Profile ID', icon:Icons.fingerprint, index: 26),
                       row(title: 'Account Status', icon: Icons.account_box, index: 26),
                         row(title: 'Live Graph', icon: Icons.reset_tv, index: 26),
                           row(title: 'Session Check/Stop', icon:Icons.fact_check, index: 26),
                             row(title: 'Upload Document', icon:  Icons.upload_file,index: 26),
                               row(title: 'Upload Picture', icon:   Icons.people, index: 26),
                                 row(title: 'Upload Signature', icon:   Icons.edit,index: 26),
                                   row(title: 'View Document', icon:   Icons.edit,index: 26),
                                     row(title: 'Complaints', icon: Icons.note_add, index: 26),
                   
                 
                 
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
}
