import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData.dart';
import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/StaticData.dart';
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class Complaints extends StatefulWidget {
  const Complaints({super.key});

  @override
  State<Complaints> createState() => _Complaints();
}

class _Complaints extends State<Complaints> with SingleTickerProviderStateMixin {
  ColorNotifire notifire = ColorNotifire();
  int currentPage = 1;
  final int itemsPerPage = 5;
  final List<Map<String, String>> subscribers = List.generate(20, (index) {
    return {
      "name": "RAHMAN $index",
      "mobile": "739377399",
      "profileId": "rahman",
      "account": "Active",
      "status": "Online",
    };
  });
 AppConst obj = AppConst();
  final AppConst controller = Get.put(AppConst());
   int _expandedTileIndex = -1;
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
                  const ComunTitle(title: 'List Complaints', path: "Complaints"),
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
                  _buildPaginationControls(),
                  const SizedBoxx(),
                  
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Map<String, String>> getItemsForCurrentPage() {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return subscribers.sublist(
      startIndex,
      endIndex > subscribers.length ? subscribers.length : endIndex,
    );
  }

  Widget _buildProfile1({required bool isphon}) {
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
                                onPressed: () {},
                                child: Text(
                                  "Add",
                                  style: mediumBlackTextStyle.copyWith(
                                      color: Colors.white),
                                )),
                                IconButton(onPressed: (){}, icon:const Icon(Icons.refresh, color: appGreyColor,),)
            ],
          ),
        
        Row(
          children: [
            Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        // itemCount: SubsComplaints.length,
                         itemCount:1,
                        itemBuilder: (BuildContext context, int index) {
                          // final  SubsComplaint = SubsComplaints[index];
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ExpansionPanelList(
                                  expandIconColor:    appGreyColor,
                                elevation: 1,
                                expandedHeaderPadding: EdgeInsets.all(8),
                                expansionCallback: (int item, bool status) {
                                  setState(() {
                                    _expandedTileIndex = (_expandedTileIndex == index) ? -1 : index;
                                    if (_expandedTileIndex != -1) {
                                      // GetComplaintLog(SubsComplaint.id);
                                    }
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                      backgroundColor: notifire.getcontiner,
                                    headerBuilder: (BuildContext context, bool isExpanded) {
                                      return ListTile(
                                        leading: 
                                        CircleAvatar(
                                          radius: 20,
                                          child: IconButton(
                                                     onPressed: () {
                                                       
                                                       if (!isSubscriber!=false) {
                                                        //  showDialog(
                                                        //    context: context,
                                                        //    builder: (ctx) => Dialog.fullscreen(
                                                        //      backgroundColor: AppColors.backgroundColor,
                                                        //      child: AddComplaint(SubComplaints: SubsComplaint, resellerid:widget.resellerID, subsID:widget.subscriberId,),
                                                        //    ),
                                                        //  ).then((val) => {
                                                        //    print('dialog--$val'),
                                                        //  });
                                                       }
                                                       },
                                                     
                                                      icon:  isSubscriber ? Icon(Icons.person) :Icon(Icons.edit) 
                                                   ),
                                        ),
                                                 
                                                                                         
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                      
                                                 
                                                                                         
                                        title: _buildCommonListTile(title: "ID: ", subtitle: 'Id'),
                                            ),
                                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: isphon ? 10 : padding),
                              child: Column(
                                children: [
                                  
                                  _buildCommonListTile(title: "PROFILE ID: ", subtitle: 'profileId'),
                                  const SizedBox(height: 10),
                                  _buildCommonListTile(title: "STATUS: ", subtitle: 'status'),
                                  const SizedBox(height: 10),
                                  _buildCommonListTile(title: "TYPE: ", subtitle:'type'),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                                           const SizedBox(height: 10),                                          ],
                                        ),
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
                                            itemCount: 1,
                                            // itemCount: ComplaintsLog.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              // final ComplaintsLogs =ComplaintsLog[index];
                                              // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(ComplaintsLogs.createdon);
                                          
                                              return Padding(
                                                padding: EdgeInsets.symmetric(horizontal: isphon ? 10 : padding),
                                                child: Column(children: [
                                                  _buildCommonListTile(title: "DATE: ", subtitle: 'date'),
                                                                                  const SizedBox(height: 10),
                                                                                    _buildCommonListTile(title: "COMMENTS: ", subtitle: 'status'),
                                                                                  const SizedBox(height: 10),
                                                                                  _buildCommonListTile(title: "ASSIGNEE: ", subtitle: 'status'),
                                                                                  const SizedBox(height: 10),
                                                                                  _buildCommonListTile(title: "STATUS: ", subtitle:'type'),
                                                                                  const SizedBox(height: 10),
                                                
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
                            );
                          
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
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

  Widget _buildPaginationControls() {
    final notifier = Provider.of<ColorNotifire>(context);
    final totalPages = (subscribers.length / itemsPerPage).ceil();
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
