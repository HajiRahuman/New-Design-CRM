import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/Subscriber/AddSubscriber/AddSubscriber.dart';
import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/StaticData.dart';
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/model/subscriber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../../service/subscriber.dart' as subscriberSrv;

class ListSubscriber extends StatefulWidget {
  const ListSubscriber({super.key});

  @override
  State<ListSubscriber> createState() => _ListSubscriber();
}

class _ListSubscriber extends State<ListSubscriber> with SingleTickerProviderStateMixin {
  ColorNotifire notifire = ColorNotifire();
  int currentPage = 1;
  final int itemsPerPage = 5;
   bool isSearching = false;
  bool row = false;
  String selectedValue1 = 'Subscriber ID';
  
  List<SubscriberDet> listSubscriber = [];
  bool isLoading = false;
  
  int limit = 5;
  Future<void> getListSubscriber() async {
    ListSubscriberResp resp = await subscriberSrv.listSubscriber();
    setState(() {
      if (resp.error) alert(context, resp.msg);
      listSubscriber = resp.error == true ? [] : resp.data ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    getListSubscriber();
  }




  void navigateToViewSubscriber(int subscriberId, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewSubscriber(subscriberId: subscriberId),
      ),
    );
  }
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen:true);
       final notifier = Provider.of<ColorNotifire>(context);
    return Scaffold(
      drawer: DarwerCode(), 
      key: _scaffoldKey,
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
                  const ComunTitle(title: 'List Subscriber', path: "Subscriber"),
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
      bottomNavigationBar:  BottomAppBar(
            shadowColor:notifier.getprimerycolor ,
             color: notifier.getprimerycolor,
             surfaceTintColor: notifier.getprimerycolor,
            child: BottomNavBar(scaffoldKey: _scaffoldKey),
            
          ),
    );
  }

 

  Widget _buildProfile1({required bool isphon}) {
       final startIndex = (currentPage - 1) * itemsPerPage;
  final endIndex = (startIndex + itemsPerPage <  listSubscriber.length)
      ? startIndex + itemsPerPage
      :  listSubscriber.length;

  final paginatedList =  listSubscriber.sublist(startIndex, endIndex);
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
                                onPressed: () {
                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
                        return AddSubscriber();
                      }));
                                },
                                child: Text(
                                  "Add",
                                  style: mediumBlackTextStyle.copyWith(
                                      color: Colors.white),
                                )),
                                IconButton( onPressed: () async {
                     getListSubscriber();
                    }, icon:Icon(Icons.refresh, color: notifier.getMainText),)
            ],
          ),
          const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paginatedList.length,
                itemBuilder: (context, index) {
                  final subscriber = paginatedList[index];
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
                            //       ListTile(
                            //   title: Text(
                            //     subscriber.fullname,
                            //     style: mediumBlackTextStyle.copyWith(color: notifire.getMainText),
                            //   ),
            
                            //   trailing: InkWell(
                            //     child: SvgPicture.asset(
                            //       "assets/settings.svg",
                            //       height: 18,
                            //       width: 18,
                            //       color: appGreyColor,
                            //     ),
                            //      onTap: () {
                            //                     navigateToViewSubscriber(
                            //                         subscriber.id, context);
                            //                   },
                            //   ),
                            // ),
                   _buildCommonListTile2(title:   subscriber.fullname, subtitle: InkWell(
                                child: SvgPicture.asset(
                                  "assets/settings.svg",
                                  height: 18,
                                  width: 18,
                                  color: appGreyColor,
                                ),
                                 onTap: () {
                                                navigateToViewSubscriber(
                                                    subscriber.id, context);
                                              },
                              ),),
                     _buildCommonListTile(title: "MOBILE", subtitle: ": ${subscriber.mobile}"),
                                  _buildCommonListTile(title: "PROFILE", subtitle:  ": ${subscriber.profileid}"),
                                                                     
  _buildCommonListTile1(
                                  title: "ACCOUNT",
                                  subtitle:  " ${subscriber.acctstatus}",
                                  subtitleColor: subscriber.acctstatus == 'Active'
                                      ? const Color(0xff43A047) // Green for Active
                                      : const Color(0xFFEE4B2B), // Red for Inactive
                                  borderColor: subscriber.acctstatus == 'Active'
                                      ? const Color(0xff43A047) // Green border for Active
                                      : const Color(0xFFEE4B2B), // Red border for Inactive
                                ),
                                
                                _buildCommonListTile1(
                                  title: "STATUS",
                                  subtitle:  " ${subscriber.conn}",
                                  subtitleColor: subscriber.conn == 'Online'
                                      ? const Color(0xff25D366) // Green for Online
                                      : const Color(0xFFEE4B2B), // Red for Offline
                                  borderColor: subscriber.conn == 'Online'
                                      ? const Color(0xff25D366) // Green border for Online
                                      : const Color(0xFFEE4B2B), // Red border for Offline
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
        _buildPaginationControls()
      ],
    );
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
          style: mediumGreyTextStyle,
        ),
       
        subtitle
      ],
    ),
  );
}
  Widget _buildPaginationControls() {
    final notifier = Provider.of<ColorNotifire>(context);
    final totalPages = (listSubscriber.length / itemsPerPage).ceil();
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
