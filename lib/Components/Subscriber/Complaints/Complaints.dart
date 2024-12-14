import 'package:crm/AppBar.dart';

import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/Subscriber/Complaints/AddComplaints.dart';


import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Widgets/CommonTitle.dart';

import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/model/BottomNav.dart';
import 'package:crm/model/addSubscriber.dart';
import 'package:crm/model/subscriber.dart';
import 'package:crm/service/subscriber.dart';
import 'package:flutter/material.dart';
import 'package:crm/service/addSubscribers.dart' as addsubscriberSrv;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crm/service/subscriber.dart'as  subscriberSrvs;

class Complaints extends StatefulWidget {
   final int subscriberId;
  final int resellerID;
  Complaints({Key? key, required this.subscriberId, required this.resellerID}) : super(key: key);

  @override
  State<Complaints> createState() => _Complaints();
}

class _Complaints extends State<Complaints> with SingleTickerProviderStateMixin {
  ColorNotifire notifire = ColorNotifire();
  int currentPage = 1;
  final int itemsPerPage = 5;
   bool isLoading = false;
   FormGroup? form;
    bool ispresent = false;
  
 void initState() {
    super.initState();
    getMenuAccess();
  // GetComplaintType();
  
  //  GetListSubsComplaint();
  // ResellerList();
  
  }

 int levelid = 0;
  bool isIspAdmin = false;
  int id=0;
  int selectedAmount = 0;
  bool isSubscriber=false;
getMenuAccess() async{
  //  setState(() {
  //   isLoading = true; // Set loading to true when fetching data
  // });
    SharedPreferences pref = await SharedPreferences.getInstance();
    levelid = pref.getInt('level_id') as int;
    isIspAdmin = pref.getBool('isIspAdmin') as bool;
    id = pref.getInt('id') as int;
    isSubscriber = pref.getBool('isSubscriber') as bool; 
    GetComplaintType();
  
   GetListSubsComplaint();
  ResellerList();
    // isLoading = false; 
  }



List<resellerDet> resellerOpt = [];
  Future<void> ResellerList() async {
     setState(() {
    isLoading = true; // Set loading to true when fetching data
  });
    resellerResp resp = (await addsubscriberSrv.reseller());
    setState(() {
      resellerOpt = resp.error == true ? [] : resp.data ?? [];
    });
  }

  
List<SubsComplaintDet> SubsComplaints = [];

Future<void> GetListSubsComplaint() async {
  setState(() {
    isLoading = true; // Set loading to true when fetching data
  });
  SubsComplaintResp complaintsResp;

  if (isSubscriber) {
    complaintsResp = await subscriberSrvs.subsComplaints(widget.subscriberId);
    setState(() {
    isLoading = true; // Set loading to true when fetching data
  });
  // ignore: dead_code
  } else {
    complaintsResp = await subscriberSrvs.GetTotComplaints();
    setState(() {
    isLoading = true; // Set loading to true when fetching data
  });
  }

  setState(() {
    if (complaintsResp.error) {

      alert(context, complaintsResp.msg);
      
isLoading = false;
    } else {
      SubsComplaints = complaintsResp.data ?? [];
      isLoading = false;
    }
    isLoading = false;
  });
}


SubscriberComplaintService subscriberSrv = SubscriberComplaintService();
List<ComplaintTypeDet> ComplaintsTypes= [];
  Future<void> GetComplaintType() async {
     setState(() {
    isLoading = true; // Set loading to true when fetching data
  });
    String apiUrl = 'complaintsType';
  ComplaintTypeResp resp = (await subscriberSrv.complaintType(apiUrl));
    setState(() {
     ComplaintsTypes = resp.error == true ? [] : resp.data ?? [];
     isLoading = false;
    });
  }

Future<void> AddComplaints(value) async {
   
    final resp = await subscriberSrvs.addComplaint(form!.value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);

    }
  }


List<SubsComplaintLogDet> ComplaintsLog= [];
  Future<void> GetComplaintLog(int id) async {
  setState(() {
    isLoading = true; // Set loading to true when fetching data
  });
  SubsComplaintLogResp resp = (await subscriberSrvs.GetSubsComplaintLog(id));
    setState(() {
     ComplaintsLog = resp.error == true ? [] : resp.data ?? [];
      isLoading = false;
    });
  }
  SubscriberInfoComplaint subscriberInfoSrv = SubscriberInfoComplaint();
List<SearchDet> search = [];
  Future<void> SubcriberInfo(int id) async {
  setState(() {
    isLoading = true; // Set loading to true when fetching data
  });
  SearchResp  resp = (await subscriberInfoSrv.subsInfo(id));
    setState(() {
     search = resp.error == true ? [] : resp.data ?? [];
      isLoading = false;
    });
  }
  int _expandedTileIndex = -1;
  
  String getStatusText(int status) {
  switch (status) {
    case 0:
      return "Open";
    case 1:
      return "In Progress";
    case 2:
      return "Closed";
    case 3:
      return "Not issue";
    case 4:
      return "Re-Open";
    default:
      return "Unknown Status";
  }
}
   
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
 @override
Widget build(BuildContext context) {
  notifire = Provider.of<ColorNotifire>(context, listen: true);
  final notifier = Provider.of<ColorNotifire>(context);

  return Scaffold(
    key: _scaffoldKey,
    backgroundColor: notifire.getbgcolor,
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
                    const SizedBoxx(),
                    const ComunTitle(title: 'List Complaints', path: "Complaints"),
                    Container(
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
                    const SizedBoxx(),
                  ],
                ),
              );
            },
          ),
        ),
        // Loading Indicator
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
    drawer: DarwerCode(),
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
  final endIndex = (startIndex + itemsPerPage <    SubsComplaints.length)
      ? startIndex + itemsPerPage
      :  SubsComplaints.length;

  final paginatedList =  SubsComplaints..sublist(startIndex, endIndex);
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
                              onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (ctx) =>
                              Dialog.fullscreen(
                                  backgroundColor: notifier.getbgcolor,
                                  child: AddComplaint(SubComplaints: null,resellerid:widget.resellerID, subsID: widget.subscriberId,)                                                         ),
                        ).then((val) => {
                          print('dialog--$val'),
                          // if (val)  getListHotel(0,5),
                        });
                      },
                                child: Text(
                                  "Add",
                                  style: mediumBlackTextStyle.copyWith(
                                      color: Colors.white),
                                )),
                                IconButton( onPressed: () async {
                    getMenuAccess();
  
                }, icon:Icon(Icons.refresh, color:notifier.getMainText,),)
            ],
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        
                         itemCount:paginatedList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final  SubsComplaint = paginatedList[index];
                          return  Column(
                            children: [
                              ExpansionPanelList(
                                      expandIconColor:    appGreyColor,
                                    elevation: 1,
                                    expandedHeaderPadding: EdgeInsets.all(8),
                                    expansionCallback: (int item, bool status) {
                                      setState(() {
                                        _expandedTileIndex = (_expandedTileIndex == index) ? -1 : index;
                                        if (_expandedTileIndex != -1) {
                                          GetComplaintLog(SubsComplaint.id);
                                        }
                                      });
                                    },
                                    children: [
                                      ExpansionPanel(
                                          backgroundColor: notifire.getcontiner,
                                        headerBuilder: (BuildContext context, bool isExpanded) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(children: [
                                              ListTile(
                                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('ID : ${SubsComplaint.id}',
                                      
                                        style: mediumBlackTextStyle.copyWith(color: notifier.getMainText,fontWeight: FontWeight.bold,fontSize: 16,fontFamily: "Gilroy",),
                                                  ),
                                                   CircleAvatar(
                                              radius: 20,
                                              child: IconButton(
                                                         onPressed: () {
                                                           
                                                           if (!isSubscriber!=false) {
                                                             showDialog(
                                                               context: context,
                                                               builder: (ctx) => Dialog.fullscreen(
                                                                 backgroundColor: notifire.getbgcolor,
                                                                 child: AddComplaint(SubComplaints: SubsComplaint, resellerid:widget.resellerID, subsID:widget.subscriberId,)
                                                               ),
                                                             ).then((val) => {
                                                               print('dialog--$val'),
                                                             });
                                                           }
                                                           },
                                                         
                                                          icon:  isSubscriber ? Icon(Icons.person) :Icon(Icons.edit) 
                                              )
                                                 ),
                                    ],
                                  ),
                                              ),
                                          
                                                                                               _buildCommonListTile(title: 'PROFILE ID', subtitle:": ${SubsComplaint.profileid}"),
                                                                                             
                                                                                               _buildCommonListTile(title: 'STATUS', subtitle:": ${getStatusText(SubsComplaint.status)}"),
                                                                                              
                                                                                              _buildCommonListTile(title: 'TYPE', subtitle:": ${ComplaintsTypes.firstWhere(
                                                                            (comType) => comType.id == SubsComplaint.type,
                                                                            orElse: () => ComplaintTypeDet(id: 0, name: ''),
                                                                          ).name}",),
                                                                  
                                            
                                            ],),
                                          );
                                          
                               
                                        },
                                        isExpanded: _expandedTileIndex == index,
                                        body: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                          const  Divider(),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                 itemCount: ComplaintsLog.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  final ComplaintsLogs =ComplaintsLog[index];
                                                      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(ComplaintsLogs.createdon);
                                              
                                                  return Padding(
                                                    padding:const EdgeInsets.all(8),
                                                    child: Column(children: [
                                                      
                                                      _buildCommonListTile(title: "DATE", subtitle:': ${DateFormat.yMd().add_jm().format(dateTime)}'),
                                                                                      
                                                                                        _buildCommonListTile(title: "COMMENTS", subtitle:": ${ComplaintsLogs.comments}"),
                                                                                      
                                                                                      _buildCommonListTile(title: "ASSIGNEE", subtitle:': ${resellerOpt.firstWhere(
                                                                                  (resellerType) => resellerType.id ==  ComplaintsLogs.assignee,
                                                                                  orElse: () => resellerDet(
                                                                                    id: 0,
                                                                                    full_name: '',
                                                                                    profileid: '',
                                                                                    company: '',
                                                                                    mobile: '',
                                                                                    email: '',
                                                                                    levelid: 0,
                                                                                    level_role: 0,
                                                                                    circle: 0,
                                                                                  ),
                                                                                ).company}'),
                                                                                     
                                                                                      _buildCommonListTile(title: "STATUS", subtitle:': ${getStatusText(  ComplaintsLogs.status)}'),
                                                                                     
                                                                                      _buildDivider()
                                                    
                                                    ],),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height:10)
                            ],
                          );
                          
                        },
                      ),
                    ),
                  ),
          ],
        ),
         _buildPaginationControls(),
      ],
    );
  }
Widget _buildDivider() {
    final notifier = Provider.of<ColorNotifire>(context);
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
              color:  appGreyColor,
              height:5,
            ),
          
        
      
      ],
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
             style: mediumBlackTextStyle.copyWith(
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
  Widget _buildPaginationControls() {
    final notifier = Provider.of<ColorNotifire>(context);
    final totalPages = (SubsComplaints.length / itemsPerPage).ceil();
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
        Text("Page $currentPage of $totalPages",style:  mediumBlackTextStyle.copyWith(color: notifire.getMainText)),
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
