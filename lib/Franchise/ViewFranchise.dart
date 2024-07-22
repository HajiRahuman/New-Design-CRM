
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

class ViewFranchise extends StatefulWidget {
  SubscriberFullDet? subscriberDet;
  UpdateUserDataDet? subscriberUpdateDet;
  int? resellerId;

  ViewFranchise({Key? key, required this.resellerId}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<ViewFranchise> with SingleTickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController authPwdController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // loadData();
    // getMenuAccess();
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
      // await fetchData();
      // await fetchData1();
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
      // fetchData();
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
                  const ComunTitle(title: 'View Franchise', path: "Franchise"),
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
Widget _buildProfile({required bool isphon}) {
    return Column(
      children: [
          
        Row(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
               
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                           
                        
                                  _buildCommonListTile(title: "ID: ", subtitle: 'id'),
                                  const SizedBox(height: 10),
                                  _buildCommonListTile(title: "PACK: ", subtitle:'pack'),
                                  const SizedBox(height: 10),
                                    _buildCommonListTile(title: "MODE: ", subtitle:'mode'),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            
                         
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildProfile1({required bool isphon}) {
     final notifier = Provider.of<ColorNotifire>(context);
   
    return 
    
     Column(
      children: [
        SizedBox(
          height: 55,
          child: TabBar(
            dividerColor:Colors.transparent,
            isScrollable: true,
            controller: controller2,
            indicator: BoxDecoration(
              color: appMainColor,
              borderRadius: BorderRadius.circular(12),
            ),
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                child: Text("Settings & \nNotification"),
              )),
              Tab(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Packages"),
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
                                        _buildCommonListTile(title: "ACCOUNT ID: ", subtitle: 'account id'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "ROLE: ", subtitle: 'role'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "CIRCLE: ", subtitle: 'circle'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "PROFILE ID: ", subtitle: 'profile id'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "BUSINESS: ", subtitle: 'business'),
                                        const SizedBox(height: 10),
                                        _buildCommonListTile(title: "EMAIL: ", subtitle: 'email'),
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
                                                                                      'BUISNESS DETAILS',
                                                                                      style: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "BUSINESS: ", subtitle: 'business'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "NAS: ", subtitle: 'nas'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "GST: ", subtitle: 'gst'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "VOICE: ", subtitle: 'voice'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "OTT: ", subtitle: 'ott'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "CARD: ", subtitle: 'card'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "ADD ON: ", subtitle: 'add on'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "VPN: ", subtitle: 'vpn'),
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
                                                                                      'BRANCH DETAILS',
                                                                                      style: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "NAME: ", subtitle: 'location'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "PRIMARY: ", subtitle: 'prinmary addr'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "SECONDARY: ", subtitle: 'secom addr'),
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
                                                                                      'AGREEMENT DETAILS',
                                                                                      style: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "STATUS: ", subtitle: 'status'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "START DATE: ", subtitle: 'st Date'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "END DATE: ", subtitle: 'end Date'),
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
                                                                                      'OTT SHARE',
                                                                                      style: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "TYPR: ", subtitle: 'type'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "ISP: ", subtitle: 'isp'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "DISTRIBUTOR: ", subtitle: 'dis'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "SUB DISTRIBUTOR: ", subtitle: 'sub dis'),
                                                                                      const SizedBox(height: 10),
                                              
                                                _buildCommonListTile(title: "RESELLER: ", subtitle: 'reseller'),
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
                                                                                      'VOICE SHARE',
                                                                                      style: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "TYPR: ", subtitle: 'type'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "ISP: ", subtitle: 'isp'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "DISTRIBUTOR: ", subtitle: 'dis'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "SUB DISTRIBUTOR: ", subtitle: 'sub dis'),
                                                                                      const SizedBox(height: 10),
                                              
                                                _buildCommonListTile(title: "RESELLER: ", subtitle: 'reseller'),
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
                                                                                      'BROADBAND SHARE',
                                                                                      style: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
                                                                                    ),
                                                                                    children:
                                                                                        [
                                              _buildCommonListTile(title: "TYPR: ", subtitle: 'type'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "ISP: ", subtitle: 'isp'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "DISTRIBUTOR: ", subtitle: 'dis'),
                                                                                      const SizedBox(height: 10),
                                                                                      _buildCommonListTile(title: "SUB DISTRIBUTOR: ", subtitle: 'sub dis'),
                                                                                      const SizedBox(height: 10),
                                              
                                                _buildCommonListTile(title: "RESELLER: ", subtitle: 'reseller'),
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
                      child:  Column(
                        children: [
                          _buildSwitchListTile("Prefix", false),
                           _buildSwitchListTile("Allow Unique Mobile Number", false),
        _buildSwitchListTile("Allow Unique Email", false),
        _buildSwitchListTile("Auto Mac Binding", false),
        _buildSwitchListTile("Allow Same Validity For Voice and Broadband", false),
        _buildSwitchListTile("Customer Registration SMS", false),
        _buildSwitchListTile("Registration Alert Email", false),
        _buildSwitchListTile("Customer Renewal SMS", false),
        _buildSwitchListTile("Renew Alert Email", false),
        _buildSwitchListTile("Customer Auto Renewal SMS", false),
        _buildSwitchListTile("Auto Renew Alert Email", false),
        _buildSwitchListTile("Customer Invoice SMS", false),
        _buildSwitchListTile("Invoice Generated Alert Email", false),
        _buildSwitchListTile("Customer Bill Paid SMS", false),
        _buildSwitchListTile("Bill Paid Alert Email", false),
        _buildSwitchListTile("Customer Extra Data SMS", false),
        _buildSwitchListTile("Extra Data Limit Credit Alert Email", false),
        _buildSwitchListTile("Customer Suspend SMS", false),
        _buildSwitchListTile("Temporary Suspended If Not Paid Alert Email", false),
        _buildSwitchListTile("Customer Terminate SMS", true),
        _buildSwitchListTile("Expiry Alert Email", true),
        _buildSwitchListTile("Customer Top-up SMS", true),
        _buildSwitchListTile("Amount Credit Add Alert Email", true),
        _buildSwitchListTile("Customer Cancel Renewal SMS", true),
        _buildSwitchListTile("Package Cancel Alert Email", true),
        _buildSwitchListTile("Customer Hold SMS", true),
        _buildSwitchListTile("Hold Alert Email", true),
                        ],
                      ),
                    )
                    : Padding(
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
                                  child: _buildProfile(isphon: true),
                                ),
                              ),
                            ],
                          ),
                          
                        ],
                      ),
                    ),
                    
                    ),
                    
          ],
        ),
      ],
    );
  }
  Widget _buildSwitchListTile(String title, bool value) {
    return SwitchListTile(
       activeColor: appMainColor,
      title: Text(
        title,
         style:
                    mediumBlackTextStyle.copyWith(color: notifire.getMainText),
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
    return PopupMenuItem(
      enabled: false,
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Center(
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(20),
                },
                children: [
                
                  row(title: 'Update', icon:Icons.update, index: 12),
               
                  row(title: 'Update Password', icon:Icons.reset_tv,index: 26),
                
                               row(title: 'Upload Logo', icon:   Icons.people, index: 26),
                                 row(title: 'Upload Signature', icon:   Icons.edit,index: 26),
                                  
                   
                 
                 
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
