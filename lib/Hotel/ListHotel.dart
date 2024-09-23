import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Hotel/ChangeAuthPwdHotel.dart';
import 'package:crm/Hotel/HotelAddUser.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/StaticData.dart';
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/model/hotel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../../service/hotel.dart' as hotelSrv;

class ListHotel extends StatefulWidget {
  const ListHotel({super.key});

  @override
  State<ListHotel> createState() => _ListHotel();
}

class _ListHotel extends State<ListHotel> with SingleTickerProviderStateMixin {
  bool isSearching = false;
  bool row = false;
  String selectedValue1 = 'Subscriber ID';
  
  final int itemsPerPage = 5;
  bool isLoading = false;

  List<HotelDet> listHotel = [];
  int currentPage = 1;
  int limit = 5;

  Future<void> getListHotel() async {
    HotelResp resp = await hotelSrv.listHotel();
    setState(() {
      if (resp.error) alert(context, resp.msg);
      listHotel = resp.error == true ? [] : resp.data ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    getListHotel();

  }



  String obscurePassword(String password) {
    return _obscurePassword ? '*' * password.length : password;
  }
  final bool _obscurePassword = true;
  int selectedHotelIndex = -1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBoxx(),
                  const ComunTitle(title: 'List Hotel', path: "Hotel"),
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
  final endIndex = (startIndex + itemsPerPage <  listHotel.length)
      ? startIndex + itemsPerPage
      :  listHotel.length;

  final paginatedList =  listHotel.sublist(startIndex, endIndex);
     final notifier = Provider.of<ColorNotifire>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
            alignment: Alignment.topRight,
              child: ElevatedButton(
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
                                
                                 backgroundColor:notifier.getbgcolor,
                                  child:HotelAddUser(hotel: null)                                                             ),
                        ).then((val) => {
                          print('dialog--$val'),
                          if (val)  getListHotel(),
                        });
                      },
                                child: Text(
                                  "Add",
                                  style: mediumBlackTextStyle.copyWith(
                                      color: Colors.white),
                                )),
            ),
            
                                IconButton( onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        setState(() {
                          isLoading = true; // Set loading to true before fetching data
                        });
                         getListHotel().then((_) {
                          setState(() {
                            isLoading = false; // Set loading to false after data is fetched
                          });
                      
                        });
                       
                      }, icon: Icon(Icons.refresh, color: notifier.getMainText),)
          ],
        ),
        const SizedBoxx(),
        Row(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paginatedList.length,
                itemBuilder: (context, index) {
                  final hotelsubs = paginatedList[index];
                    final isHotelSelected = index == selectedHotelIndex;
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
                             
                  //          ListTile(
                                   
                  //                   // leading: const CircleAvatar(
                  //                   //   backgroundColor: Colors.transparent,
                  //                   //   backgroundImage: AssetImage("assets/avatar2.png"),
                  //                   // ),
                  //                   subtitle: Padding(
                  //                     padding: const EdgeInsets.only(top: 6),
                  //                     child:  _buildCommonListTile(title: "LOGIN ID : ", subtitle:hotelsubs.profileid),
                                 
                  //                   ),
                  //                    trailing: PopupMenuButton(
                  //                     iconColor:notifier.geticoncolor ,
                  //                      color: notifier.getcontiner,
                  // shadowColor: Colors.grey.withOpacity(0.5),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(12)),
                  //                     itemBuilder: (BuildContext context){
                                        
                  //                       return[
                  //                       _buildPopupAdminMenuItem(hotelsubs),
                  //                     ];})
                                     
                                   
                  //                 ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: isphon ? 10 : padding),
                              child: Column(
                                children: [
                                  
                                  _buildCommonListTile2(title:hotelsubs.profileid,subtitle: PopupMenuButton(
                                      iconColor: notifier.geticoncolor ,
                                       color: notifier.getcontiner,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                                      itemBuilder: (BuildContext context){
                                        
                                        return[
                                        _buildPopupAdminMenuItem(hotelsubs),
                                      ];}) ),
                                  _buildCommonListTile(title: "ACCOUNT", subtitle: ": ${hotelsubs.acctstatus}"),
                                   
                                  _buildCommonListTile(title: "STATUS", subtitle:": ${hotelsubs.conn}"),
                                  
                          
                                    _buildCommonListTile(title: "PASSWORD", subtitle: ': ${isHotelSelected
                                                    ? hotelsubs.authpsw
                                                    : obscurePassword(hotelsubs.authpsw)}'),
                                 
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
 PopupMenuItem _buildPopupAdminMenuItem(HotelDet hotelsubs) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);
  return PopupMenuItem(
    enabled: false,
    padding: const EdgeInsets.all(0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          width: 200,
          child: Center(
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(20),
              },
              children: [
                row1(title: 'Activation', icon: Icons.edit, hotelsubs: hotelsubs),
                row1(title: 'Change Auth PWD', icon: Icons.key, hotelsubs: hotelsubs),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

bool light1 = true;
TableRow row1({required String title, required IconData icon, required HotelDet hotelsubs}) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);
  return TableRow(children: [
    TableRowInkWell(
      onTap: () {
        if (title == 'Activation') {
          showDialog(
            context: context,
            builder: (ctx) =>
                Dialog.fullscreen(
                  backgroundColor: notifier.getbgcolor,
                  child: HotelAddUser(hotel: hotelsubs),
                ),
          ).then((val) => {
            print('dialog--$val'),
            if (val) getListHotel(),
          }); // Call logout function when Logout is clicked
        }
        if (title == 'Change Auth PWD') {
          showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  backgroundColor: notifier.getbgcolor,
                  actions: [ChangeAuthPwdHotel(hotel: hotelsubs)],
                ),
          ).then((val) => {
            print('dialog--$val'),
            if (val) getListHotel(),
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Icon(icon, color: notifier.geticoncolor),
      ),
    ),
    TableRowInkWell(
      onTap: () {
        if (title == 'Activation') {
          showDialog(
            context: context,
            builder: (ctx) =>
                Dialog.fullscreen(
                  backgroundColor: notifier.getbgcolor,
                  child: HotelAddUser(hotel: hotelsubs),
                ),
          ).then((val) => {
            print('dialog--$val'),
            if (val) getListHotel(),
          }); //
        }
        if (title == 'Change Auth PWD') {
          showDialog(
            context: context,
            builder: (ctx) =>
                AlertDialog(
                  backgroundColor: notifier.getbgcolor,
                  actions: [ChangeAuthPwdHotel(hotel: hotelsubs)],
                ),
          ).then((val) => {
            print('dialog--$val'),
            if (val) getListHotel(),
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5, left: 20, top: 12, right: 20),
        child: Text(title,
            style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
    ),
  ]);
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
    final totalPages = (  listHotel.length / itemsPerPage).ceil();
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
