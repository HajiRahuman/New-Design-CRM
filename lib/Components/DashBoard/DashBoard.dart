


import 'package:crm/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/model/dashboard.dart';
import 'package:crm/model/subscriber.dart';
import 'package:crm/service/dashboard.dart'  as dashboardSrv;
import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
   SubscriberFullDet? subscriberDet;
  DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoard();
}

class _DashBoard extends State<DashBoard> {
  
  @override
  void dispose() {
    super.dispose();
  }

  List cardcolors = [
    const Color(0xff1a7cbc),
    const Color(0xfff07521),
    const Color(0xff4caf50),
    const Color(0xff18a0fb),
  ];

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final formKey = GlobalKey<FormState>();
  String email = '';
  String passwd = '';
  DateTime today = DateTime.now();
  int touchedIndex = -1;
  TextEditingController dateInput = TextEditingController();
  String selectedDate = '';
  bool isSearching = false;
  List<ExpirySubscriber> apiDataList = [];
  SubscriberSummary? subscriberSummary;
  List<Map<String, dynamic>> renewal = [];

  String formattedDate = DateFormat('MMM d, yyyy').format(DateTime.now());

  double rotationAngle = 0.0;
  List<String> data = [];

  Future<void> getSubscriberSummary() async {
    String apiUrl = 'subscriber/summary'; // Define the URL
    final resp = await  dashboardSrv.getSubscriberSummaryData(apiUrl);
    if (resp.error == false) {
      setState(() {
        subscriberSummary = resp.summary;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSubscriberSummary();
    getExpirySubscriber(today); // Fetch data for today's date
  }

  void navigateToViewSubscriber(int subscriberId, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewSubscriber(subscriberId: subscriberId),
      ),
    );
  }

  Future<void> fetchData(id) async {    
    final resp = await subscriberSrv.fetchSubscriberDetail(id);
    setState(() {
      if (resp.error) alert(context, resp.msg);
      widget.subscriberDet = resp.data;
    });
  }

  ColorNotifire notifire = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      body: Form(
             key: formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: notifire.getbgcolor,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                           const SizedBoxx(),
                        const ComunTitle(title: 'Dashboard', path: "Default"),
                        _buildcompo1(
                          title: "Total",
                          iconpath: "assets/users33.svg",
                          Subscriber: subscriberSummary?.totalusers ?? "0",
                          Indicator: _buildIndicator(cardcolors[0]),
                          maincolor: Colors.blueAccent,
                        ),
                        _buildcompo1(
                          title: "Active",
                          iconpath: "assets/users33.svg",
                          Subscriber: subscriberSummary?.active ?? "0",
                          Indicator: _buildIndicator(cardcolors[1]),
                            maincolor: Colors.pinkAccent,
                        ),
                        _buildcompo1(
                          title: "Expiry",
                          iconpath: "assets/box-check33.svg",
                          Subscriber: subscriberSummary?.deactive ?? "0",
                          Indicator: _buildIndicator(cardcolors[2]),
                          maincolor: Colors.deepOrangeAccent,
          
                        ),
                        _buildcompo1(
                          title: "Online",
                          iconpath: "assets/wallet33.svg",
                          Subscriber: subscriberSummary?.mainonline ?? "0",
                          Indicator: _buildIndicator(cardcolors[3]),
                           maincolor: Colors.deepPurpleAccent,
                        ),
                        _buildcompo1(
                          title: "Offline",
                          iconpath: "assets/coins29.svg",
                          Subscriber: subscriberSummary?.offline ?? "0",
                          Indicator: _buildIndicator(cardcolors[0]),
                            maincolor: const Color(0xff0CAF60),
                        ),
                        
                     _buildcompo2(width: constraints.maxWidth),
                        const SizedBoxx(),
                          // ElevatedButton(onPressed: (){
      //                      Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ListSubscriber(),
      //   ),
      // );
      //                   }, child: Text('click'))
                      ],
                    ),
                  );
                } else if (constraints.maxWidth < 1000) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                           const SizedBoxx(),
                     const ComunTitle(title: 'Dashboard', path: "Default"),
                        Row(
                          children: [
                            Expanded(
                              child: _buildcompo1(
                                title: "Total",
                                iconpath: "assets/dollar-circle33.svg",
                                Subscriber: subscriberSummary?.totalusers ?? "0",
                                Indicator: _buildIndicator(cardcolors[0]),
                                maincolor: Colors.blueAccent,
                              ),
                            ),
                            Expanded(
                              child: _buildcompo1(
                                title: "Active",
                                iconpath: "assets/users33.svg",
                                Subscriber: subscriberSummary?.active ?? "0",
                                Indicator: _buildIndicator(cardcolors[1]),
                                  maincolor: Colors.pinkAccent,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildcompo1(
                                title: "Expiry",
                                iconpath: "assets/box-check33.svg",
                                Subscriber: subscriberSummary?.deactive ?? "0",
                                Indicator: _buildIndicator(cardcolors[2]),
                                 maincolor: Colors.deepOrangeAccent,
                              ),
                            ),
                            Expanded(
                              child: _buildcompo1(
                                title: "Online",
                                iconpath: "assets/wallet33.svg",
                                Subscriber: subscriberSummary?.mainonline ?? "0",
                                Indicator: _buildIndicator(cardcolors[3]),
                                 maincolor: Colors.deepPurpleAccent,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildcompo1(
                                title: "Offline",
                                iconpath: "assets/coins29.svg",
                                Subscriber: subscriberSummary?.offline ?? "0",
                                Indicator: _buildIndicator(cardcolors[0]),
                                
                            maincolor: const Color(0xff0CAF60),
                              ),
                            ),
            
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: _buildcompo2(width: constraints.maxWidth)),
                          
                          ],
                        ),
                        const SizedBoxx(),
                      ],
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                           const SizedBoxx(),
                         const ComunTitle(title: 'Dashboard', path: "Default"),
                        Row(
                          children: [
                            Expanded(
                              child: _buildcompo1(
                                title: "Total",
                                iconpath: subscriberSummary?.totalusers ?? "0",
                                Subscriber: " 200",
                                Indicator: _buildIndicator(cardcolors[0]),
                                maincolor: Colors.blueAccent,
                              ),
                            ),
                            Expanded(
                              child: _buildcompo1(
                                title: "Active",
                                iconpath: "assets/users33.svg",
                                Subscriber: subscriberSummary?.active ?? "0",
                                Indicator: _buildIndicator(cardcolors[1]),
                                 maincolor: Colors.pinkAccent,
                              ),
                            ),
                            Expanded(
                              child: _buildcompo1(
                                title: "Expiry",
                                iconpath: "assets/box-check33.svg",
                                Subscriber: subscriberSummary?.deactive ?? "0",
                                Indicator: _buildIndicator(cardcolors[2]),
                                 maincolor: Colors.deepOrangeAccent,
                              ),
                            ),
                            Expanded(
                              child: _buildcompo1(
                                title: "Online",
                                iconpath: "assets/wallet33.svg",
                                Subscriber: subscriberSummary?.mainonline ?? "0",
                                Indicator: _buildIndicator(cardcolors[3]),
                                maincolor: Colors.deepPurpleAccent,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildcompo1(
                                title: "Offline",
                                iconpath: "assets/coins29.svg",
                                Subscriber: subscriberSummary?.offline ?? "0",
                                Indicator: _buildIndicator(cardcolors[0]),
                                 maincolor: const Color(0xff0CAF60),
                              ),
                            ),
                           
                          ],
                        ),
                         Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildcompo2(width: constraints.maxWidth),
                            ),
                          ],
                        ),
                        const SizedBoxx(),
                      
                      
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
    );
  }
Widget _buildcompo1({
  required String title,
  required String iconpath,
  required String Subscriber,
  required Widget Indicator,
  required Color maincolor,
}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Material(
      color: Colors.transparent,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: notifire.getcontiner,
          boxShadow: boxShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              dense: true,
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: maincolor.withOpacity(0.2),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconpath,
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
              title: Text(
                title,
                style: mediumGreyTextStyle,
              ),
              subtitle: Text(
                Subscriber,
                style: mainTextStyle.copyWith(color: notifire.getMainText),
              ),
            ),
            SizedBox(height: 8),
            Indicator,
          ],
        ),
      ),
    ),
  );
}


  Widget _buildIndicator(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: ClipRRect(
         borderRadius: BorderRadius.circular(8),
        child: SizedBox(
             height: 8,
          child: LinearProgressIndicator(
            value: 0.7,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: Colors.grey[300],
          ),
        ),
      ),
    );
  }
 TableRow divider({required Color color}) {
  return TableRow(
    children: List.generate(5, (index) => Divider(color: color, height: 30,)),
  );
}

TableRow newRow({
  required String profileid,
  required String package,
  required String mobile,
  required String name,
  required String expiryTime,
}) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(profileid, style: TextStyle(color: notifire.getMainText),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          package,
          // style: mediumBlackTextStyle.copyWith(color: notifire.getMainText),
          style: TextStyle(color: notifire.getMainText),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          mobile,
          style: mediumBlackTextStyle.copyWith(color: notifire.getMainText),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          name,
          style: mediumBlackTextStyle.copyWith(color: notifire.getMainText),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          expiryTime,
          style: mediumBlackTextStyle.copyWith(color: notifire.getMainText),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    ],
  );
}   


 Widget _buildcompo2({required double width}) {
  return Padding(
    padding: const EdgeInsets.all(padding),
    child: Container(
      // height: 500,
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: notifire.getcontiner,
        boxShadow: boxShadow,
      ),
      child: Material(
        // Added Material widget here
        color: Colors.transparent, 
        child: ExpansionTile(
  key: Key('ExpansionTile_${apiDataList.isNotEmpty}'), // Add a unique key
  initiallyExpanded: apiDataList.isNotEmpty,
  collapsedIconColor: notifire.getMainText,
  iconColor: notifire.getMainText,
  expandedAlignment: Alignment.topLeft,
  leading: Text(
    'Expiry Details',
    style: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
  ),
  title: TextField(
    controller: dateInput,
    style: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintStyle: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
      hintText: formattedDate.toString(),
    ),
    readOnly: true,
    onTap: () => pickDate(context),
  ),
  children: apiDataList.isNotEmpty
      ? [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1, // Ensure the table header is shown once
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(
                    height: 380,
                    width: width,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: width < 1220 ? 500 : width,
                          child: SingleChildScrollView(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Table(
                                          columnWidths: const {
                                            0: FixedColumnWidth(100),
                                            1: FixedColumnWidth(100),
                                            2: FixedColumnWidth(100),
                                            3: FixedColumnWidth(100),
                                            4: FixedColumnWidth(100),
                                          },
                                          children: [
                                            TableRow(
                                              children: [
                                                Text(
                                                  "Profile ID",
                                                  style: mediumBlackTextStyle.copyWith(fontSize: 16, color: appMainColor),
                                                ),
                                                Text(
                                                  "Package",
                                                  style: mediumBlackTextStyle.copyWith(fontSize: 16, color: appMainColor),
                                                ),
                                                Text(
                                                  "Mobile",
                                                  style: mediumBlackTextStyle.copyWith(fontSize: 16, color: appMainColor),
                                                ),
                                                Text(
                                                  "Name",
                                                  style: mediumBlackTextStyle.copyWith(fontSize: 16, color: appMainColor),
                                                ),
                                                Text(
                                                  "Expiry",
                                                  style: mediumBlackTextStyle.copyWith(fontSize: 16, color: appMainColor),
                                                ),
                                              ],
                                            ),
                                            dividerRow(const Color(0xff7366ff)),
                                            for (var apiData in apiDataList) ...[
                                              newRow(
                                                profileid: ' ${apiData.profileid}',
                                                package: ' ${apiData.packname}',
                                                mobile: ' ${apiData.mobile}',
                                                name: ' ${apiData.fullname}',
                                                expiryTime: ' ${apiData.expiration}',
                                              ),
                                              dividerRow(Colors.red),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ]
      : [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'No data available. Try again later or add some data.',
              style: mainTextStyle.copyWith(color: notifire.getMainText, fontSize: 18),
            ),
          ),
        ],
)
      ),
    ),
  );
}
TableRow dividerRow(Color color) {
  return TableRow(
    children: [
      SizedBox(height: 10, child: Divider(color: color)),
      SizedBox(height: 10, child: Divider(color: color)),
      SizedBox(height: 10, child: Divider(color: color)),
      SizedBox(height: 10, child: Divider(color: color)),
      SizedBox(height: 10, child: Divider(color: color)),
    ],
  );
}


  
  void getExpirySubscriber(DateTime date) async {
    String formattedDate = DateFormat('MMM d, yyyy').format(date);
    final resp = await dashboardSrv.getExpirySubscriberByDate(date);
    setState(() {
      this.selectedDate = formattedDate;
      dateInput.text = formattedDate;
      apiDataList = resp.data ?? [];
      if (resp.error) alert(context, resp.msg);
    });
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      getExpirySubscriber(pickedDate);
    }
  }


}
