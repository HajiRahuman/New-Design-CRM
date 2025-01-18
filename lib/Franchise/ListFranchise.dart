import 'package:crm/AppBar.dart';

import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';

import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Franchise/ViewFranchise.dart';
import 'package:crm/Providers/providercolors.dart';

import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/model/reseller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/reseller.dart' as resellerSrv;

class ListFranchise extends StatefulWidget {
  const ListFranchise({super.key});

  @override
  State<ListFranchise> createState() => _ListFranchise();
}

class _ListFranchise extends State<ListFranchise> with SingleTickerProviderStateMixin {
 
  int currentPage = 1;
  final int itemsPerPage = 5;
   bool isSearching = false;
  bool row = false;
  String selectedValue1 = 'Subscriber ID';

  List<ResellerList> listResller = [];
  bool isLoading = false;

  
  int limit = 5;
  Future<void> getListResller() async {
    ResellerListResp resp = await resellerSrv.resellerList();
    setState(() {
      if (resp.error) alert(context, resp.msg);
      listResller = resp.error == true ? [] : resp.data ?? [];
    });
  }
 bool isIspAdmin = false;
 
  
  int id=0;
  getIdLevelID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getInt('id') as int;
       isIspAdmin = pref.getBool('isIspAdmin') as bool;
  }

  @override
  void initState() {
    super.initState();
    getListResller();
    getIdLevelID();
  }



  void navigateToViewReseller(int resellerId, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewFranchise (resellerId: resellerId),
      ),
    );
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
   notifire = Provider.of<ColorNotifire>(context, listen:true);
       final notifier = Provider.of<ColorNotifire>(context);
    return Scaffold(
       key: _scaffoldKey,
     drawer: DarwerCode(), 
      backgroundColor:notifier.getbgcolor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      
                      const SizedBoxx(),
                      const ComunTitle(title: 'List Franchise', path: "Franchise"),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, right: padding, left: padding, bottom: 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color:notifier.getcontiner,
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
                ),
                 if (isLoading) 
                           Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(
                          
                          ),
                        ),
                      ),
                    ), 
              ],
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
  final endIndex = (startIndex + itemsPerPage <  listResller.length)
      ? startIndex + itemsPerPage
      :  listResller.length;

  final paginatedList =  listResller.sublist(startIndex, endIndex);
   final notifier = Provider.of<ColorNotifire>(context);
    return Column(
      children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if(isIspAdmin==false)
                IconButton(onPressed: () async {
                      navigateToViewReseller(
                          id, context);
                    }, icon: Icon(Icons.visibility,color: notifier.getMainText)),
              IconButton(  onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await getListResller();
                      setState(() {
                        isLoading = false;
                      });
                    }, icon:Icon(Icons.refresh, color: notifier.getMainText,)),
              
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
                  final reseller = paginatedList[index];
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
                                    
                                  _buildCommonListTile2(title: reseller.fullName,subtitle: InkWell(
                                child: SvgPicture.asset(
                                  "assets/settings.svg",
                                  height: 18,
                                  width: 18,
                                  color: notifier.geticoncolor,
                                ),
                                onTap: (){
                                   

                                  navigateToViewReseller(
                                                    reseller.id, context);
                                },
                              ), ),
                                   _buildCommonListTile(title: "NAME", subtitle:': ${reseller.fullName}'),
                                                                  
                                   _buildCommonListTile(title: "MOBILE", subtitle:': ${reseller.mobile}'),
                                                                   
                                  _buildCommonListTile(title: "PROFILE ID", subtitle:': ${reseller.profileId}'),
                                  
                                  _buildCommonListTile(title: "COMPANY", subtitle:': ${reseller.company}'),
                                 
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
      ],
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
          style: mediumBlackTextStyle.copyWith(
              color: notifier.getMainText,
            ),
        ),
       
        subtitle
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
            style: mediumBlackTextStyle.copyWith(
              color: notifier.getMainText,
            ),
          
          ),
        ),
        const SizedBox(width: 10), // Add some spacing between title and subtitle
        Expanded(
          child: Text(
            subtitle,
             style:  mediumBlackTextStyle.copyWith(
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
    final totalPages = (listResller.length / itemsPerPage).ceil();
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
        Text("Page $currentPage of $totalPages",style:  mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
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
