


import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/Subscriber/ListSubscriber.dart';
import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/Controller/Drawer.dart';
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
// import 'package:timezone/timezone.dart' as tz;

class DashBoard extends StatefulWidget {
  static const String routeName = '/dashboard';
   SubscriberFullDet? subscriberDet;
  DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoard();
}

class _DashBoard extends State<DashBoard> with SingleTickerProviderStateMixin{
  
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  String email = '';
  String passwd = '';
  DateTime today = DateTime.now();
  
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
  int currentPage = 1;
  final int itemsPerPage = 5;
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

  

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen:true);
       final notifier = Provider.of<ColorNotifire>(context);
       double _calculateProgress(String? value, String? total) {
  int categoryValue = int.tryParse(value ?? '0') ?? 0;
  int totalValue = int.tryParse(total ?? '0') ?? 1; // Ensure total is at least 1 to avoid division by zero
  return totalValue > 0 ? categoryValue / totalValue : 0.0;
}
    return Scaffold(
      drawer: DarwerCode(), 
         key: _scaffoldKey,
      body: Form(
             key: formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: notifier.getbgcolor,
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
  Indicator: _buildIndicator(cardcolors[0], 1.0), // Full progress for total users
  maincolor: const Color(0xff2F3F95),
  progressValue: 1.0, 
   category: 'Total'// Full bar for total users
),
                        _buildcompo1(
  title: "Active",
  iconpath: "assets/user29.svg",
  Subscriber: subscriberSummary?.active ?? "0",
  Indicator: _buildIndicator(cardcolors[1], _calculateProgress(subscriberSummary?.active, subscriberSummary?.totalusers)),
  maincolor: const Color(0xff43A047),
  progressValue: _calculateProgress(subscriberSummary?.active, subscriberSummary?.totalusers),
   category: 'Active' // Add this line
),
                       
                     _buildcompo1(
  title: "Online",
  iconpath: "assets/wallet33.svg",
  Subscriber: subscriberSummary?.mainonline ?? "0",
  Indicator: _buildIndicator(cardcolors[2], _calculateProgress(subscriberSummary?.mainonline, subscriberSummary?.totalusers)),
  maincolor: const Color(0xff25D366),
  progressValue: _calculateProgress(subscriberSummary?.mainonline, subscriberSummary?.totalusers),
   category: 'Online' // Add progressValue here
),
_buildcompo1(
    title: "Offline",
  iconpath: "assets/coins29.svg",
 Subscriber: subscriberSummary?.offline ?? "0",
  Indicator: _buildIndicator(cardcolors[3], _calculateProgress(subscriberSummary?.offline, subscriberSummary?.totalusers)),
  maincolor: const Color(0xffFF6F00),
  progressValue: _calculateProgress(subscriberSummary?.offline, subscriberSummary?.totalusers), 
   category: 'Offline' // Add progressValue here
),
 _buildcompo1(
  title: "Expiry",
  iconpath: "assets/box-check33.svg",
  Subscriber: subscriberSummary?.deactive ?? "0",
  Indicator: _buildIndicator(cardcolors[3], _calculateProgress(subscriberSummary?.deactive, subscriberSummary?.totalusers)),
  maincolor: const Color(0xffE53935),
  progressValue: _calculateProgress(subscriberSummary?.deactive, subscriberSummary?.totalusers),
  category: 'Expired' // Add progressValue here
),
_buildcompo1(
  title: "Hold",
  iconpath: "assets/lock.svg",
  Subscriber: subscriberSummary?.hold ?? "0",
  Indicator: _buildIndicator(cardcolors[3], _calculateProgress(subscriberSummary?.hold, subscriberSummary?.totalusers)),
  maincolor: const Color(0xffFF4081),
  progressValue: _calculateProgress(subscriberSummary?.hold, subscriberSummary?.totalusers),
  category: 'Hold'  // Add progressValue here
),
                      
                        
                     _buildcompo2(width: constraints.maxWidth),
                        const SizedBoxx(),
          
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
                              child:  _buildcompo1(
  title: "Total",
  iconpath: "assets/users33.svg",
  Subscriber: subscriberSummary?.totalusers ?? "0",
  Indicator: _buildIndicator(cardcolors[0], 1.0), // Full progress for total users
  maincolor: const Color(0xff2F3F95),
  progressValue: 1.0,
    category: 'Total'
   // Full bar for total users
),
                            ),
                            Expanded(
                              child: _buildcompo1(
  title: "Active",
  iconpath: "assets/user29.svg",
  Subscriber: subscriberSummary?.active ?? "0",
  Indicator: _buildIndicator(cardcolors[1], _calculateProgress(subscriberSummary?.active, subscriberSummary?.totalusers)),
  maincolor: const Color(0xff43A047),
  progressValue: _calculateProgress(subscriberSummary?.active, subscriberSummary?.totalusers),
    category: 'Active' // Add this line
),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child:  _buildcompo1(
  title: "Online",
  iconpath: "assets/wallet33.svg",
  Subscriber: subscriberSummary?.mainonline ?? "0",
  Indicator: _buildIndicator(cardcolors[2], _calculateProgress(subscriberSummary?.mainonline, subscriberSummary?.totalusers)),
  maincolor: const Color(0xff25D366),
  progressValue: _calculateProgress(subscriberSummary?.mainonline, subscriberSummary?.totalusers),
    category: 'Online' // Add progressValue here
),
                            ),
                            Expanded(
                              child:_buildcompo1(
    title: "Offline",
  iconpath: "assets/coins29.svg",
 Subscriber: subscriberSummary?.offline ?? "0",
  Indicator: _buildIndicator(cardcolors[3], _calculateProgress(subscriberSummary?.offline, subscriberSummary?.totalusers)),
  maincolor: const Color(0xffFF6F00),
  progressValue: _calculateProgress(subscriberSummary?.offline, subscriberSummary?.totalusers), 
    category: 'Offline'// Add progressValue here
),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child:_buildcompo1(
  title: "Expiry",
  iconpath: "assets/box-check33.svg",
  Subscriber: subscriberSummary?.deactive ?? "0",
  Indicator: _buildIndicator(cardcolors[3], _calculateProgress(subscriberSummary?.deactive, subscriberSummary?.totalusers)),
  maincolor: const Color(0xffE53935),
  progressValue: _calculateProgress(subscriberSummary?.deactive, subscriberSummary?.totalusers), 
    category: 'Expired'// Add progressValue here
),
                            ),
            Expanded(child: _buildcompo1(
  title: "Hold",
  iconpath: "assets/lock.svg",
  Subscriber: subscriberSummary?.hold ?? "0",
  Indicator: _buildIndicator(cardcolors[3], _calculateProgress(subscriberSummary?.hold, subscriberSummary?.totalusers)),
  maincolor: const Color(0xffFF4081),
  progressValue: _calculateProgress(subscriberSummary?.hold, subscriberSummary?.totalusers),
    category: 'Hold' // Add progressValue here
),)
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
                              child:  _buildcompo1(
  title: "Total",
  iconpath: "assets/users33.svg",
  Subscriber: subscriberSummary?.totalusers ?? "0",
  Indicator: _buildIndicator(cardcolors[0], 1.0), // Full progress for total users
  maincolor: const Color(0xff2F3F95),
  progressValue: 1.0,
    category: 'Total' // Full bar for total users
),

                            ),
                            Expanded(
                              child: _buildcompo1(
  title: "Active",
  iconpath: "assets/user29.svg",
  Subscriber: subscriberSummary?.active ?? "0",
  Indicator: _buildIndicator(cardcolors[1], _calculateProgress(subscriberSummary?.active, subscriberSummary?.totalusers)),
  maincolor: const Color(0xff43A047),
  progressValue: _calculateProgress(subscriberSummary?.active, subscriberSummary?.totalusers), 
    category: 'Active'// Add this line
),
                            ),
                            Expanded(
                              child:  _buildcompo1(
  title: "Online",
  iconpath: "assets/wallet33.svg",
  Subscriber: subscriberSummary?.mainonline ?? "0",
  Indicator: _buildIndicator(cardcolors[2], _calculateProgress(subscriberSummary?.mainonline, subscriberSummary?.totalusers)),
  maincolor: const Color(0xff25D366),
  progressValue: _calculateProgress(subscriberSummary?.mainonline, subscriberSummary?.totalusers),
    category: 'Online'
   // Add progressValue here
),
                            ),
                            Expanded(
                              child:  _buildcompo1(
    title: "Offline",
  iconpath: "assets/coins29.svg",
 Subscriber: subscriberSummary?.offline ?? "0",
  Indicator: _buildIndicator(cardcolors[3], _calculateProgress(subscriberSummary?.offline, subscriberSummary?.totalusers)),
  maincolor: const Color(0xffFF6F00),
  progressValue: _calculateProgress(subscriberSummary?.offline, subscriberSummary?.totalusers), // Add progressValue here
    category: 'Offline'
),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child:

_buildcompo1(
  title: "Expiry",
  iconpath: "assets/box-check33.svg",
  Subscriber: subscriberSummary?.deactive ?? "0",
  Indicator: _buildIndicator(cardcolors[3], _calculateProgress(subscriberSummary?.deactive, subscriberSummary?.totalusers)),
  maincolor: const Color(0xffE53935),
  progressValue: _calculateProgress(subscriberSummary?.deactive, subscriberSummary?.totalusers), // Add progressValue here
    category: 'Expired'
),
                           ),
                           Expanded(child: _buildcompo1(
  title: "Hold",
  iconpath: "assets/lock.svg",
  Subscriber: subscriberSummary?.hold ?? "0",
  Indicator: _buildIndicator(cardcolors[3], _calculateProgress(subscriberSummary?.hold, subscriberSummary?.totalusers)),
  maincolor: const Color(0xffFF4081),
  progressValue: _calculateProgress(subscriberSummary?.hold, subscriberSummary?.totalusers), // Add progressValue here
    category: 'Hold'
),)
                          ],
                        ),

//                         Row(children: [Expanded(child: _buildcompo1(
//   title: "Hold",
//   iconpath: "assets/lock.svg",
//   Subscriber: subscriberSummary?.hold ?? "0",
//   Indicator: _buildIndicator(cardcolors[3], _calculateProgress(subscriberSummary?.hold, subscriberSummary?.totalusers)),
//   maincolor: const Color(0xffFF4081),
//   progressValue: _calculateProgress(subscriberSummary?.hold, subscriberSummary?.totalusers), // Add progressValue here
// ),)],),
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
       bottomNavigationBar:  BottomAppBar(
            shadowColor:notifier.getprimerycolor ,
             color: notifier.getprimerycolor,
             surfaceTintColor: notifier.getprimerycolor,
            child: BottomNavBar(scaffoldKey: _scaffoldKey),
            
          ),
    );
  }
Widget _buildcompo1({
  required String title,
  required String iconpath,
  required String Subscriber,
  required Widget Indicator,
  required Color maincolor,
  required double progressValue,
  String? category, // Add this parameter
}) {
  final notifier = Provider.of<ColorNotifire>(context);
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          // Trigger the getListSubscriber function with category parameter
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                                    return  ListSubscriber(category: category);
                                  }));
         
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: notifier.getcontiner,
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
                  style: mainTextStyle.copyWith(color: notifier.getMainText),
                ),
              ),
              _buildIndicator(maincolor, progressValue), // Pass progress value
            ],
          ),
        ),
      ),
    ),
  );
}
  Widget _buildIndicator(Color color, double progressValue) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 8,
        child: LinearProgressIndicator(
          value: progressValue, // Set progress value (0.0 to 1.0)
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: Colors.grey[300],
        ),
      ),
    ),
  );
}

Widget _buildcompo2({required double width}) {
   final startIndex = (currentPage - 1) * itemsPerPage;
  final endIndex = (startIndex + itemsPerPage <  apiDataList.length)
      ? startIndex + itemsPerPage
      :  apiDataList.length;

  final paginatedList =  apiDataList.sublist(startIndex, endIndex);
   final notifier = Provider.of<ColorNotifire>(context);
  return Padding(
    padding: const EdgeInsets.all(padding),
    child: Container(
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: notifier.getcontiner,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent, 
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            key: Key('ExpansionTile_${apiDataList.isNotEmpty}'),
            initiallyExpanded: apiDataList.isNotEmpty,
            collapsedIconColor: notifier.getMainText,
            iconColor: notifier.getMainText,
            expandedAlignment: Alignment.topLeft,
            leading: Text(
              'Expiry',
              style: mainTextStyle.copyWith(color: notifier.getMainText),
            ),
            title: TextField(
              controller: dateInput,
              style:  mainTextStyle1.copyWith(color: notifier.getMainText),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle:  mainTextStyle1.copyWith(color: notifier.getMainText),
                hintText: formattedDate.toString(),
              ),
              readOnly: true,
              onTap: () => pickDate(context),
            ),
            children: apiDataList.isNotEmpty
                ? [
          ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: paginatedList.length,
  itemBuilder: (context, index) {
    final expirySubs = paginatedList[index];
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    _buildCommonListTile(
                      title: "PROFILE ID",
                      subtitle:": ${expirySubs.profileid}",
                      subtitleStyle: mediumBlackTextStyle.copyWith(
                    color: appMainColor,
                  ), // Customize style if needed
                      onSubtitleTap: () {
                        // Navigate to viewSubscriber when profileid is tapped
                         navigateToViewSubscriber(
                                    expirySubs.uid, context);
                      },
                    ),
                    
                    _buildCommonListTile(title: "PACKAGE", subtitle: ': ${expirySubs.packname}'),
                   
                    _buildCommonListTile(title: "NAME", subtitle: ': ${expirySubs.fullname}'),
                    
                    _buildCommonListTile(title: "MOBILE", subtitle: ': ${expirySubs.mobile}'),
                  
//                    _buildCommonListTile(
//   title: "EXPIRY TIME",
//   subtitle: ': ${expirySubs.expiration.isNotEmpty
//       ? DateFormat.jm().format(
//           tz.TZDateTime.from(
//             DateTime.parse(expirySubs.expiration), 
//             tz.getLocation('Asia/Kolkata') // IST timezone location
//           )
//         )
//       : "---"}',
// ),
_buildCommonListTile(
  title: "EXPIRY TIME",
  subtitle: ': ${expirySubs.expiration.isNotEmpty
      ? DateFormat.jm().format(DateTime.parse(expirySubs.expiration).toLocal())
      : "---"}',
),

                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  },
),

              _buildPaginationControls()
          ]
                : [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'No records found.',
                  
                  style: mainTextStyle.copyWith(color: notifire!.getMainText, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildCommonListTile({
 required String title,
  required String subtitle,
  TextStyle? subtitleStyle,
  VoidCallback? onSubtitleTap, 
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
            // style: mediumGreyTextStyle,
          ),
        ),
        const SizedBox(width: 10), // Add some spacing between title and subtitle
        Expanded(
          child:  GestureDetector(
                onTap: onSubtitleTap,  // Tapping will trigger this function
                child: Text(
                  subtitle,
                  style: subtitleStyle ?? mediumBlackTextStyle.copyWith(
                    color: notifier.getMainText,
                  ),
                ),
              ),
        ),
      ],
    ),
  );
}



Widget _buildPaginationControls() {
  final notifier = Provider.of<ColorNotifire>(context);
  final totalPages = (apiDataList.length / itemsPerPage).ceil();
  
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        icon: Icon(Icons.arrow_back, color: notifier.geticoncolor),
        onPressed: currentPage > 1
            ? () {
                setState(() {
                  currentPage--;
                });
              }
            : null,
      ),
      Text(
        "Page $currentPage of $totalPages",
        style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),
      ),
      IconButton(
        icon: Icon(Icons.arrow_forward, color: notifier.geticoncolor),
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
