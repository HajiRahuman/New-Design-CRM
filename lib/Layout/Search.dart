
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';

import 'package:crm/Providers/providercolors.dart';
import 'package:crm/components/Subscriber/ViewSubscriber.dart';
import 'package:crm/model/subscriber.dart';



import 'package:crm/service/BottomNav.dart' as bottonNavSrv;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'dart:core';
import '../model/BottomNav.dart';

class Search extends StatefulWidget {
  SubscriberFullDet? subscriberDet;

  Search({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<Search> {
  TextEditingController Controller = TextEditingController();
  bool isSearching = false;

  String simul = '';
  List<Map<String, dynamic>> fields = [
    {'id': 1, 'label': 'Profile ID', 'key': 'profileid', 'hide': false},
    {'id': 2, 'label': 'Account No', 'key': 'id', 'hide': false},
    {'id': 3, 'label': 'UserName', 'key': 'fullname', 'hide': true},
    {'id': 4, 'label': 'Email', 'key': 'emailpri', 'hide': true},
    {'id': 5, 'label': 'Mobile', 'key': 'mobile', 'hide': true},
    {'id': 6, 'label': 'Local IPV4', 'key': 'ipv4', 'hide': true},
    {'id': 7, 'label': 'Public IPV4', 'key': 'ipaddr', 'hide': true},
    {'id': 8, 'label': 'Mac Address', 'key': 'usermac', 'hide': true},
  ];

  int selectedSearchType = 1;

  String searchTypeLike = '';
  List<DropdownMenuItem<int>> buildDropdownMenuItems() {
    return fields
        .map((field) => DropdownMenuItem<int>(
      value: field['id'],
      child: Text(field['label']),
    ))
        .toList();
  }

  List<SearchDet> search = [];
  Future<void> searchFunction(String query) async {
    try {
      setState(() {
        isSearching = true;
      });
      SearchResp resp = await bottonNavSrv.search();
      setState(() {
        isSearching = false;
        if (resp.error) {
          alert(context, resp.msg);
          search = [];
        } else {
          search = resp.data ?? [];
        }
      });
    } catch (error) {
      setState(() {
        isSearching = false;
        search = [];
      });
      print("Error during search: $error");
    }
  }

  List<SearchPubIpDet> searchPubIp = [];
  Future<void> SearchPublicIp(String query) async {
    try {
      setState(() {
        isSearching = true;
      });
      SearchPubIpResp resp = await bottonNavSrv.searchPublicIp(
        index: 0,
        // limit: 25,
        ipmode: 2,
        usertype: 0,
        like: searchTypeLike,
        fieldType: selectedSearchType,
      );
      setState(() {
        isSearching = false;
        if (resp.error) {
          alert(context, resp.msg);
          searchPubIp = [];
        } else {
          searchPubIp = resp.data ?? [];
        }
      });
    } catch (error) {
      setState(() {
        isSearching = false;
        searchPubIp = [];
      });
      print("Error during search: $error");
    }
  }
  List<SearchDet> searchlocalIp = [];
  Future<void> SearchLocalIp(String query) async {
    try {
      setState(() {
        isSearching = true;
      });
      SearchResp resp = await bottonNavSrv.searchLocalIp();
      setState(() {
        isSearching = false;
        if (resp.error) {
          alert(context, resp.msg);
          searchlocalIp = [];
        } else {
          searchlocalIp = resp.data ?? [];
        }
      });
    } catch (error) {
      setState(() {
        isSearching = false;
        searchlocalIp = [];
      });
      print("Error during search: $error");
    }
  }
  List<SearchUserMacDet> usermac = [];
  Future<void> UserMAC(String query) async {
    try {
      setState(() {
        isSearching = true;
      });
      SearchUserMacResp resp = await bottonNavSrv.userMac();
      setState(() {
        if (resp.error) {
          alert(context, resp.msg);
          usermac = [];
        } else {
          usermac = resp.data ?? [];
        }
      });
    } catch (error) {
      setState(() {
        isSearching = false;
        usermac = [];
      });
      print("Error during search: $error");
    }
  }
// Somewhere in your widget tree (likely in `initState` or `build` method)
final form = FormGroup({
  'search': FormControl<SearchDet>(),
});

// form.control('search').valueChanges.listen((value) {
//   if (value != null) {
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
//       return ViewSubscriber(subscriberId: (value as SearchDet).id);
//     }));
//   }
// });


  @override
  // void initState() {
  //   super.initState();
  //   searchFunction("query");
  //}
void initState() {
    super.initState();
 searchFunction("query");
    // Listen to changes in the 'search' FormControl
    form.control('search').valueChanges.listen((value) {
      if (value != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
          return ViewSubscriber(subscriberId: (value as SearchDet).id);
        }));
      }
    });
  }


  Future<List<SearchDet>> fetchSearchResults(String filter) async {
    List<SearchDet> results = [];

    try {
      results = search.where((item) {
        return _getDisplayTextForSearchDet(item)
            .toLowerCase()
            .contains(filter.toLowerCase());
      }).toList();
    } catch (error) {
      print("Error during search: $error");
    }

    return results;
  }

  String _getDisplayTextForSearchDet(SearchDet item) {
    switch (selectedSearchType) {
      case 1:
        return item.profileid;
      case 2:
        return '${item.id}';
      case 3:
        return item.fullname;
      case 4:
        return item.emailpri;
      case 5:
        return item.mobile;
      case 6:
        return item.ipv4;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
       final notifier = Provider.of<ColorNotifire>(context);
    return  ReactiveForm(
      formGroup: form,
      child: SingleChildScrollView(
        child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const SizedBox(height:5),
             Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Universal Search",
                          style: TextStyle(
                                      color: notifier.getMainText,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                        ),
                        CircleAvatar(
                            radius: 20,
                          child: IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: notifier.getMainText,
                            ), // Add the close icon
                            onPressed: () {
                              // Close the current tab
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  
                const SizedBox(height: 20),
              
              
              Text(
                '  Search Type',
               style: mediumBlackTextStyle.copyWith(color:notifier.getMainText,fontWeight: FontWeight.bold,fontSize: 16)
              ),
              const SizedBox(height: 5),
            Padding(
                 padding: const EdgeInsets.symmetric(
                  horizontal: 20,),
              child: DropdownButtonFormField<int>(
                       
                        value: selectedSearchType,
                        onChanged: (newValue) async {
                          setState(() {
                            selectedSearchType = newValue!;
                          });
                          switch (selectedSearchType) {
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                              await searchFunction("currentQuery");
                              break;
                            case 6:
                              await SearchLocalIp('query');
                              break;
                            case 7:
                              await SearchPublicIp('query');
                              break;
                            case 8:
                              await UserMAC('query');
                              break;
                            default:
                          }
                        },
                        items: buildDropdownMenuItems(),
                         dropdownColor: notifier.getcontiner,
                                                           style: TextStyle(color: notifier.getMainText),
                                                                            
                                                                           
                                                                             decoration: InputDecoration(
                                                                               contentPadding:const EdgeInsets.only(left: 15),
                                                                  
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
      
                
              
              const SizedBox(height: 30),
              
              Padding(
                 padding: const EdgeInsets.symmetric(
                  horizontal: 20,),
                child: ReactiveDropdownSearch<SearchDet, SearchDet>(
        formControlName: 'search', // Specify the form control name
         
        dropdownDecoratorProps: DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
      
        contentPadding: const EdgeInsets.only(left: 15),
        hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 2.0,
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
      ),
        ),
        asyncItems: (String filter) async {
      return fetchSearchResults(filter);
        },
        popupProps:const PopupProps.menu(
    showSearchBox: true,
    isFilterOnline: true,
    searchFieldProps: TextFieldProps(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 15),
        hintText: 'Search Subscriber',
      ),
    ),
  ),
        itemAsString: (dynamic item) => _getDisplayTextForSearchDet(item as SearchDet),
      ),
      
      
              ),
              
              const SizedBox(height: 20),
      
              // You can add more Text widgets with different sentences here
            ],
          ),
        
      ),
    );
  }
}
