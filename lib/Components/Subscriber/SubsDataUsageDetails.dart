import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/components/DashBoard/SubscriberDashBoard.dart';
import 'package:crm/main.dart';
import 'package:crm/model/subscriber.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/subscriber.dart' as subscriberSrv;
import 'package:crm/Utils/Utils.dart';
class SubsDataUsageDetails extends StatefulWidget {
  const SubsDataUsageDetails({super.key});

  @override
  State<SubsDataUsageDetails> createState() => _SubsDataUsageDetailsState();
}

class _SubsDataUsageDetailsState extends State<SubsDataUsageDetails> {


   List<SessionRpt> listSessionRpt = [];
  bool isLoading = false;
    int currentPage = 1;
    int index=0;
  final int itemsPerPage = 5;
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
    GetSessionRpt();
  }

   @override
     void initState() {
    super.initState();
    getMenuAccess();
  }
  int limit = 5;
  Future<void> GetSessionRpt() async {
  // Format the selected start and end dates
  String startDateStr = _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : '';
  String endDateStr = _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '';

  // Make the API call with the selected dates
  SessionRptResp resp = await subscriberSrv.sessionRpt(
    id,
    index,
    5,
    false,
    startDate: startDateStr,
    endDate: endDateStr,
  );

  setState(() {
    if (resp.error) alert(context, resp.msg);
    listSessionRpt = resp.error == true ? [] : resp.data ?? [];
  });
}


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
DateTime? _startDate;
  DateTime? _endDate;
  final bool _switchValue = false;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != (_startDate ?? _endDate)) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
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
        
        backgroundColor: notifier.getbgcolor,
        title:Text('Data Usage Details',style: mainTextStyle.copyWith(color: appMainColor,fontWeight: FontWeight.bold),),
       
        leading: IconButton(icon:const Icon(Icons.arrow_back,color: appMainColor,), onPressed: (){
           Navigator.pushAndRemoveUntil(
                      navigatorKey.currentContext as BuildContext,
                      MaterialPageRoute(
                          builder: (context) => SubscriberDashBoard(subscriberId:id  ,)),
                      (Route<dynamic> route) => false,
                  );
        },),
      ),
      
        drawer: DarwerCode(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // The tab buttons for week, month, year
              // Padding(
              //   padding: const EdgeInsets.all(16.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       _buildTabButton('Week', isSelected: true),
              //       _buildTabButton('Month'),
              //       _buildTabButton('Year'),
              //     ],
              //   ),
              // ),
          
              // // Line chart for data usage
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     height: 200.0,
              //     child: LineChart(
              //       _buildLineChartData(),
              //     ),
              //   ),
              // ),
          const SizedBox(height: 10),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                        decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                          labelText: "Start Date",
                                                                            hintStyle: mediumGreyTextStyle.copyWith(),
                        hintText: _startDate != null
                            ? "${_startDate!.day}-${_startDate!.month}-${_startDate!.year}"
                            : "Select Start Date",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today,color: notifier.geticoncolor,),
                          onPressed: () => _selectDate(context, true),
                        ),
                                                                            enabledBorder: OutlineInputBorder(
                                  borderRadius:BorderRadius .circular(10.0),
                                  borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black)),
                                                      border: OutlineInputBorder(
                                  borderRadius:BorderRadius .circular(10.0),
                                  borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black)),
                                                                            ),
                     
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                       style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                            labelText: "End Date",
                                                                              hintStyle: mediumGreyTextStyle.copyWith(),
                        hintText: _endDate != null
                            ? "${_endDate!.day}-${_endDate!.month}-${_endDate!.year}"
                            : "Select End Date",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today,color:  notifier.geticoncolor,),
                          onPressed: () => _selectDate(context, false),
                        ),
                                                                            enabledBorder: OutlineInputBorder(
                                  borderRadius:BorderRadius .circular(10.0),
                                  borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black)),
                                                      border: OutlineInputBorder(
                                  borderRadius:BorderRadius .circular(10.0),
                                  borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black)),
                                                                            ),
                     
                    ),
                  ),
                ],
              ),
           ),
            const SizedBox(height: 10),
           TextButton.icon(
  style: TextButton.styleFrom(
    backgroundColor: appMainColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  onPressed: () {
    if (_startDate == null || _endDate == null) {
      alert(context, 'Please select both start and end dates');
    } else {
      // Call the GetSessionRpt with the selected dates
      GetSessionRpt();
    }
  },
  icon: const Icon(Icons.sync, color:Colors.white),
  label: const Text('Search', style: TextStyle(color:Colors.white, fontSize: 14)),
),

                          const SizedBox(height: 10),
              // Data table for upload/download/total details
              Padding(
                      padding: const EdgeInsets.only(top: 0, right: padding, left: padding, bottom: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: notifier.getcontiner,
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
            ],
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
 LineChartData _buildLineChartData() {
  final notifier = Provider.of<ColorNotifire>(context);
  
  // Define your data points here
  List<FlSpot> points = [
    const FlSpot(0, 0.24),
    const FlSpot(1, 4.27),
    const FlSpot(2, 0.24),
    const FlSpot(3, 6.7),
    const FlSpot(4, 0.2),
    const FlSpot(5, 1.01),
    // Add more points as needed
  ];

  return LineChartData(
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor:Colors.white,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map(
            (LineBarSpot touchedSpot) {
              const textStyle = TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              );
              return LineTooltipItem(
                points[touchedSpot.spotIndex].y.toStringAsFixed(2),
                textStyle,
              );
            },
          ).toList();
        },
      ),
    ),
    titlesData: FlTitlesData(
      leftTitles: SideTitles(
        getTextStyles: (context, value) => mediumBlackTextStyle.copyWith(
          color: notifier.getMainText,
        ),
        showTitles: true,
        reservedSize: 40,
        // showTitles: (value) {
        //   if (value % 5 == 0) {
        //     return '${value.toInt()} GB'; // Y-axis labels
        //   }
        //   return '';
        // },
      ),
      bottomTitles: SideTitles(
        getTextStyles: (context, value) => mediumBlackTextStyle.copyWith(
          color: notifier.getMainText,
        ),
        showTitles: true,
        reservedSize: 30,
        getTitles: (value) {
          if (value == 0) return '0';
          if (value == 1) return '1';
          if (value == 2) return '2';
          if (value == 3) return '3';
          if (value == 4) return '4';
          if (value == 5) return '5';
          return ''; // Ensure no duplicates
        },
      ),
      topTitles: SideTitles(showTitles: false),
      rightTitles: SideTitles(showTitles: false),
    ),
    borderData: FlBorderData(show: true,
      border: Border(
        bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
        left: BorderSide(color: Colors.grey.withOpacity(0.3)),
        right: BorderSide(color: Colors.grey.withOpacity(0.3)),
        top: BorderSide(color: Colors.grey.withOpacity(0.3)),
      ),
    ),
    lineBarsData: [
      LineChartBarData(
        spots: points, // Use the points defined earlier
        isCurved: true,
        colors: [appMainColor],
        barWidth: 4,
        belowBarData: BarAreaData(show: false),
      ),
    ],
    minY: 0,
    maxY: 50,
    minX: 0, // Set minimum X value
    maxX: 5, // Set maximum X value based on your data
  );
}


 

  Widget _buildProfile1({required bool isphon}) {
  final totalItems = listSessionRpt.length;
  final totalPages = (totalItems / itemsPerPage).ceil();

  // Ensure currentPage stays within valid bounds
  if (currentPage < 1) {
    currentPage = 1;
  } else if (currentPage > totalPages) {
    currentPage = totalPages;
  }

  // Calculate the start and end index of the items for the current page
  final startIndex = (currentPage - 1) * itemsPerPage;
  final endIndex = startIndex + itemsPerPage > totalItems ? totalItems : startIndex + itemsPerPage;

  // Ensure startIndex is not out of bounds and adjust accordingly
  if (startIndex >= totalItems || totalItems == 0) {
    return const Center(child: Text('No more items to display.'));
  }

  final paginatedList = listSessionRpt.sublist(startIndex, endIndex);
  final notifier = Provider.of<ColorNotifire>(context);
// String formatBytes(int bytes) {
//   if (bytes <= 0) return "--"; // Handle invalid or zero values
//   const k = 1024;
//   const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  
//   // Determine the size index using logarithm
//   final i = (log(bytes) / log(k)).floor();
  
//   // Calculate the value in the determined size
//   final value = bytes / pow(k, i);
  
//   return "${value.toStringAsFixed(2)} ${sizes[i]}";
// }

String extractNumericValue(String value) {
  // Remove any non-numeric characters and spaces, e.g. "549 MB" -> "549"
  return value.replaceAll(RegExp(r'[^0-9]'), '');
}

  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paginatedList.length,
              itemBuilder: (context, index) {
                final session = paginatedList[index];
                final uploadSize = int.parse(extractNumericValue(session.acctinputoctets));
                final downloadSize = int.parse(extractNumericValue(session.acctoutputoctets));
                final totalSize = uploadSize + downloadSize;
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: isphon ? 10 : padding),
                            child: Column(
                              children: [
                                _buildCommonListTile(title: "Start AT", subtitle: ": ${session.acctstarttime.isNotEmpty ? DateFormat.yMd().add_jm().format(DateTime.parse(session.acctstarttime)) : "---"}"),
                                _buildCommonListTile(title: "End On", subtitle: ": ${session.acctstoptime.isNotEmpty ? DateFormat.yMd().add_jm().format(DateTime.parse(session.acctstoptime)) : "---"}"),
                                _buildCommonListTile(
                                  title: "Upload",
                                  subtitle: ": ${formatBytes(uploadSize)}",
                                ),
                                _buildCommonListTile(
                                  title: "Download",
                                  subtitle: ": ${formatBytes(downloadSize)}",
                                ),
                                _buildCommonListTile(
                                  title: "Total",
                                  subtitle: ": ${formatBytes(totalSize)}",
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
          ),
        ],
      ),
      _buildPaginationControls(),
    ],
  );
}

String extractNumericValue(String value) {
  // Remove any non-numeric characters and spaces, e.g. "549 MB" -> "549"
  return value.replaceAll(RegExp(r'[^0-9]'), '');
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
Widget _buildPaginationControls() {
    final notifier = Provider.of<ColorNotifire>(context);
    final totalPages = (listSessionRpt.length / itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios, color: notifier.geticoncolor),
          onPressed: 
               () {
                  setState(() {
                    currentPage--;
                    // Decrease the index by itemsPerPage when going to the previous page
                    index = index - itemsPerPage;
                    GetSessionRpt();  // Fetch the new session data based on the updated index
                  });
                }
             
        ),
        const SizedBox(width: 10),
        // Text(
        //   "Page $currentPage of $totalPages",
        //   style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),
        // ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios, color: notifier.geticoncolor),
          onPressed: 
              () {
                  setState(() {
                    currentPage++;
                    // Increase the index by itemsPerPage when going to the next page
                    index = index + itemsPerPage;
                    GetSessionRpt();  // Fetch the new session data based on the updated index
                  });
                }
              
        ),
      ],
    );
}

  // Helper method to build tab buttons
  Widget _buildTabButton(String title, {bool isSelected = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? appMainColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // Helper method to build each row in the DataTable
  DataRow _buildDataRow(String date, String upload, String download, String total) {
    return DataRow(
      cells: [
        DataCell(Text(date)),
        DataCell(Text(upload)),
        DataCell(Text(download)),
        DataCell(Text(total)),
      ],
    );
  }

}