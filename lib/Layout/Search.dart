
// import 'dart:convert';

// import 'package:crm/AppStaticData/AppStaticData.dart';
// import 'package:crm/AppStaticData/toaster.dart';
// import 'package:crm/Card/ListCard.dart';
// import 'package:crm/Hotel/ListHotel.dart';

// import 'package:crm/Providers/providercolors.dart';
// import 'package:crm/components/Subscriber/ViewSubscriber.dart';
// import 'package:crm/model/subscriber.dart';



// import 'package:crm/service/BottomNav.dart' as bottonNavSrv;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
// import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';
// import 'package:reactive_forms/reactive_forms.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:core';
// import '../model/BottomNav.dart';

// class Search extends StatefulWidget {
//   SubscriberFullDet? subscriberDet;

//   Search({Key? key}) : super(key: key);

//   @override
//   MyAppState createState() => MyAppState();
// }

// class MyAppState extends State<Search> {
//   TextEditingController Controller = TextEditingController();
//   bool isSearching = false;

//   String simul = '';
//   List<Map<String, dynamic>> fields = [
//   {'id': 1, 'label': 'Profile ID', 'key': 'profileid', 'hide': false},
//   {'id': 2, 'label': 'Account No', 'key': 'id', 'hide': false},
//   {'id': 3, 'label': 'UserName', 'key': 'fullname', 'hide': true},
//   {'id': 4, 'label': 'Email', 'key': 'emailpri', 'hide': true},
//   {'id': 5, 'label': 'Mobile', 'key': 'mobile', 'hide': true},
//   {'id': 6, 'label': 'Local IPV4', 'key': 'ipv4', 'hide': true},
//   {'id': 7, 'label': 'Public IPV4', 'key': 'ipaddr', 'hide': true},
//   {'id': 8, 'label': 'Mac Address', 'key': 'usermac', 'hide': true},
// ];

// // Add a function to filter fields based on the selected value
// List<Map<String, dynamic>> getFilteredFields() {
//   if (value == 4) {
//     // Hotel: Profile ID and Account No
//     return fields.where((field) => field['id'] == 1 || field['id'] == 2).toList();
//   } else if (value == 1) {
//     // Card: Profile ID and Account No
//     return fields.where((field) => field['id'] == 1 || field['id'] == 2).toList();
//   } else {
//     // Default: All fields
//     return fields;
//   }
// }


//   int selectedSearchType = 1;

//   String searchTypeLike = '';
//  List<DropdownMenuItem<int>> buildDropdownMenuItems() {
//   final filteredFields = getFilteredFields(); // Filter fields based on `value`
//   return filteredFields
//       .map((field) => DropdownMenuItem<int>(
//             value: field['id'],
//             child: Text(field['label']),
//           ))
//       .toList();
// }


//   List<SearchDet> search = [];
//   Future<void> searchFunction(String query) async {
//     try {
//       setState(() {
//         isSearching = true;
//       });
//       SearchResp resp = await bottonNavSrv.search(userType: value);
//       setState(() {
//         isSearching = false;
//         if (resp.error) {
//           alert(context, resp.msg);
//           search = [];
//         } else {
//           search = resp.data ?? [];
//         }
//       });
//     } catch (error) {
//       setState(() {
//         isSearching = false;
//         search = [];
//       });
//       print("Error during search: $error");
//     }
//   }

//   List<SearchPubIpDet> searchPubIp = [];
//   Future<void> SearchPublicIp(String query) async {
//     try {
//       setState(() {
//         isSearching = true;
//       });
//       SearchPubIpResp resp = await bottonNavSrv.searchPublicIp(
//         index: 0,
//         // limit: 25,
//         ipmode: 2,
//         usertype: 0,
//         like: searchTypeLike,
//         fieldType: selectedSearchType,
//       );
//       setState(() {
//         isSearching = false;
//         if (resp.error) {
//           alert(context, resp.msg);
//           searchPubIp = [];
//         } else {
//           searchPubIp = resp.data ?? [];
//         }
//       });
//     } catch (error) {
//       setState(() {
//         isSearching = false;
//         searchPubIp = [];
//       });
//       print("Error during search: $error");
//     }
//   }
//   List<SearchDet> searchlocalIp = [];
//   Future<void> SearchLocalIp(String query) async {
//     try {
//       setState(() {
//         isSearching = true;
//       });
//       SearchResp resp = await bottonNavSrv.searchLocalIp();
//       setState(() {
//         isSearching = false;
//         if (resp.error) {
//           alert(context, resp.msg);
//           searchlocalIp = [];
//         } else {
//           searchlocalIp = resp.data ?? [];
//         }
//       });
//     } catch (error) {
//       setState(() {
//         isSearching = false;
//         searchlocalIp = [];
//       });
//       print("Error during search: $error");
//     }
//   }
//   List<SearchUserMacDet> usermac = [];
//   Future<void> UserMAC(String query) async {
//     try {
//       setState(() {
//         isSearching = true;
//       });
//       SearchUserMacResp resp = await bottonNavSrv.userMac();
//       setState(() {
//         if (resp.error) {
//           alert(context, resp.msg);
//           usermac = [];
//         } else {
//           usermac = resp.data ?? [];
//         }
//       });
//     } catch (error) {
//       setState(() {
//         isSearching = false;
//         usermac = [];
//       });
//       print("Error during search: $error");
//     }
//   }
// // Somewhere in your widget tree (likely in `initState` or `build` method)
// final form = FormGroup({
//   'search': FormControl<SearchDet>(),
// });

// // form.control('search').valueChanges.listen((value) {
// //   if (value != null) {
// //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
// //       return ViewSubscriber(subscriberId: (value as SearchDet).id);
// //     }));
// //   }
// // });


//    int levelid = 0;
//   bool isIspAdmin = false;
//   int id = 0;
//   int selectedAmount = 0;
//   bool isSubscriber = false;
//   String? menuIdString='';
//   bool isSuperAdmin=false;
// List<int> menuIdList = [];
//   getMenuAccess() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     levelid = pref.getInt('level_id') as int;
//     isIspAdmin = pref.getBool('isIspAdmin') as bool;
//     id = pref.getInt('id') as int;
//     isSubscriber = pref.getBool('isSubscriber') as bool;
//   isSuperAdmin=pref.getBool("isSuperAdmin")as bool;
//    print(isSubscriber);
//   print(isSuperAdmin);
//   }
// @override
// void initState() {
//   super.initState();
//    getMenuAccess();
//   searchFunction("query");

//   // Listen to changes in the 'search' FormControl
  // form.control('search').valueChanges.listen((value) {
  //   if (value != null) {
  //     if (this.value == 1) {
  //       // Navigate to ListCard if "Card" is selected
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) {
  //             return ListCard(id: (value as SearchDet).id,search: true);
  //           },
  //         ),
  //       );
  //     } else if (this.value == 4) {
  //       // Navigate to a Hotel-specific page
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) {
  //             return ListHotel(id: (value as SearchDet).id,search: true,);
  //           },
  //         ),
  //       );
  //     } else {
  //       // Default navigation to ViewSubscriber
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) {
  //             return ViewSubscriber(subscriberId: (value as SearchDet).id);
  //           },
  //         ),
  //       );
  //     }
  //   }
  // });
// }

//   Future<List<SearchDet>> fetchSearchResults(String filter) async {
//     List<SearchDet> results = [];

//     try {
//       results = search.where((item) {
//         return _getDisplayTextForSearchDet(item)
//             .toLowerCase()
//             .contains(filter.toLowerCase());
//       }).toList();
//     } catch (error) {
//       print("Error during search: $error");
//     }

//     return results;
//   }

//   String _getDisplayTextForSearchDet(SearchDet item) {
//     switch (selectedSearchType) {
//       case 1:
//         return item.profileid;
//       case 2:
//         return '${item.id}';
//       case 3:
//         return item.fullname;
//       case 4:
//         return item.emailpri;
//       case 5:
//         return item.mobile;
//       case 6:
//         return item.ipv4;
//       default:
//         return '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//        final notifier = Provider.of<ColorNotifire>(context);
//     return  ReactiveForm(
//       formGroup: form,
//       child: SingleChildScrollView(
//         child:  Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//                 const SizedBox(height:5),
//              Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Universal Search",
//                           style: TextStyle(
//                                       color: notifier.getMainText,
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 20),
//                         ),
//                         CircleAvatar(
//                             radius: 20,
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.close_rounded,
//                               color: notifier.getMainText,
//                             ), // Add the close icon
//                             onPressed: () {
//                               // Close the current tab
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
                  
//                 const SizedBox(height: 20),
              // Visibility(
              //   visible: (levelid<= 3 || isSuperAdmin || isIspAdmin),
              //   child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           CustomRadioButton("Broadband",0 ),
              //           const SizedBox(height: 5),
              //           CustomRadioButton("Hotel", 4),
              //            const SizedBox(height: 5),
              //           CustomRadioButton("Card", 1),
                        
                    
              //             ],
              //       ),
              // ),
                
//                 const SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Text(
              //       '  Search Type',
              //      style: mediumBlackTextStyle.copyWith(color:notifier.getMainText,fontWeight: FontWeight.bold,fontSize: 16)
              //     ),
              //   ],
              // ),
//               const SizedBox(height: 5),
//             Padding(
//                  padding: const EdgeInsets.symmetric(
//                   horizontal: 20,),
//               child: DropdownButtonFormField<int>(
//                        focusColor: Colors.transparent,
//                         value: selectedSearchType,
//                         onChanged: (newValue) async {
//                           setState(() {
//                             selectedSearchType = newValue!;
                            
//                           });
//                           switch (selectedSearchType) {
//                             case 1:
//                             case 2:
//                             case 3:
//                             case 4:
//                             case 5:
//                               await searchFunction("currentQuery");
//                               break;
//                             case 6:
//                               await SearchLocalIp('query');
//                               break;
//                             case 7:
//                               await SearchPublicIp('query');
//                               break;
//                             case 8:
//                               await UserMAC('query');
//                               break;
//                             default:
//                           }
//                         },
//                         items: buildDropdownMenuItems(),
//                          dropdownColor: notifier.getcontiner,
//                                                            style: TextStyle(color: notifier.getMainText),
                                                                            
                                                                           
//                                                                              decoration: InputDecoration(
//                                                                                contentPadding:const EdgeInsets.only(left: 15),
                                                                  
//                                                                               enabledBorder: OutlineInputBorder(
//                                     borderRadius:BorderRadius .circular(10.0),
//                                     borderSide: BorderSide(
//                                         color: notifier.isDark
//                                             ? notifier.geticoncolor
//                                             : Colors.black)),
//                             border: OutlineInputBorder(
//                                     borderRadius:BorderRadius .circular(10.0),
//                                     borderSide: BorderSide(
//                                         color: notifier.isDark
//                                             ? notifier.geticoncolor
//                                             : Colors.black)),
//                                                                               ),
//                       ),
//             ),
      
                
              
//               const SizedBox(height: 30),
              
//               Padding(
//                  padding: const EdgeInsets.symmetric(
//                   horizontal: 20,),
//                 child: ReactiveDropdownSearch<SearchDet, SearchDet>(
                  
//         formControlName: 'search', // Specify the form control name
         
//         dropdownDecoratorProps: DropDownDecoratorProps(
//       dropdownSearchDecoration: InputDecoration(
//       focusColor: Colors.transparent,
//         contentPadding: const EdgeInsets.only(left: 15),
//         hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
//         hintText: 'Search',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: BorderSide(
//             width: 2.0,
//             color: Colors.grey.withOpacity(0.3),
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//           borderSide: BorderSide(
//             width: 2.0,
//             color: Colors.grey.withOpacity(0.3),
//           ),
//         ),
//       ),
//         ),
//         asyncItems: (String filter) async {
//       return fetchSearchResults(filter);
//         },
//         popupProps:const PopupProps.menu(
//     showSearchBox: true,
//     isFilterOnline: true,
//     searchFieldProps: TextFieldProps(
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.only(left: 15),
//         hintText: 'Search Subscriber',
//       ),
//     ),
//   ),
//         itemAsString: (dynamic item) => _getDisplayTextForSearchDet(item as SearchDet),
//       ),
      
      
//               ),
              
//               const SizedBox(height: 20),
      
//               // You can add more Text widgets with different sentences here
//             ],
//           ),
        
//       ),
//     );
//   }
//   int value = 0;
//  Widget CustomRadioButton(String text, int index) {
//      final notifier = Provider.of<ColorNotifire>(context);
//   return OutlinedButton(
//     onPressed: () {
//       setState(() {
//         value = index; // Update value based on selected button
//       });
//       searchFunction(value.toString()); // Call search function
//     },
//     style: OutlinedButton.styleFrom(
//       backgroundColor:(value == index) ? appMainColor : appWhiteColor ,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//         side: BorderSide(
//           color: (value == index) ? appMainColor : appGreyColor,
//         ),
//       ),
//     ),
//     child: Text(
//       text,
//       style: TextStyle(
//         color: (value == index) ? appWhiteColor :Colors.black,
//       ),
//     ),
//   );
// // }

// }
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Card/ListCard.dart';
import 'package:crm/Hotel/ListHotel.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/components/Subscriber/ViewSubscriber.dart';
import 'package:crm/model/subscriber.dart';
import 'package:crm/service/BottomNav.dart' as bottonNavSrv;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import '../model/BottomNav.dart';

// ignore: must_be_immutable
class Search extends StatefulWidget {
  SubscriberFullDet? subscriberDet;

  Search({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<Search> {
  
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

  List<Map<String, dynamic>> setUserType = [
    {'level': 2, 'level_role': [14, 15], 'name': 'Hotel'},
    {'level': 3, 'level_role': [18, 19], 'name': 'Card'},
  ];
List<Map<String, dynamic>> allFields = [];
  int userType = 1;
  int fieldType = 1;
  String searchUser = '';
  int levelId = 0;
  bool isSuperAdmin = false;
  bool isIspAdmin = false;

  int selectedSearchType = 1;

  String searchTypeLike = '';
 List<DropdownMenuItem<int>> buildDropdownMenuItems() {
  return fields
      .where((field) => field['id'] != null) // Ensure id is not null
      .map((field) => DropdownMenuItem<int>(
            value: field['id'],
            child: Text(field['label']),
          ))
      .toList();
}


  List<SearchDet> search = [];
  Future<void> searchFunction(int query) async {
    setState(() => isSearching = true);
// print(query);
    // Determine search parameters based on `userType`
    Map<String, dynamic> searchParams = {};
    if (userType == 2) {
      searchParams = {'ipmode': 1, 'usertype': 4}; // Hotel Users
    } else if (userType == 3) {
      searchParams = {'ipmode': 2, 'usertype': 1}; // Card Users
    } else {
      searchParams = {'ipmode': 0, 'usertype': 0}; // Broadband Users
    }

    try {
    int userTypeValue = searchParams['usertype'] ?? query;
    // print(userTypeValue); // Default to 0 if not provided
SearchResp resp = await bottonNavSrv.search(userType: userTypeValue);
      if (resp.error) {
        alert(context, resp.msg);
      } else {
        setState(() => search = resp.data ?? []);
      }
    } catch (error) {
      // print("Error during search: $error");
    } finally {
      setState(() => isSearching = false);
    }
  }

  List<SearchPubIpDet> searchPubIp = [];
  // ignore: non_constant_identifier_names
  Future<void> SearchPublicIp(String query) async {
    try {
      setState(() {
        isSearching = true;
      });
      SearchPubIpResp resp = await bottonNavSrv.searchPublicIp(
        index: 0,
        // limit: 25,
        ipmode: 2,
       
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
  // List<SearchDet> searchlocalIp = [];
  // ignore: non_constant_identifier_names
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
          search = [];
        } else {
          search= resp.data ?? [];
        }
      });
    } catch (error) {
      setState(() {
        isSearching = false;
        search= [];
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

  Future<void> initializeUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    levelId = pref.getInt('level_id') ?? 0;
    isSuperAdmin = pref.getBool('isSuperAdmin') ?? false;
    isIspAdmin = pref.getBool('isIspAdmin') ?? false;

    if (levelId > 3) {
      userType = setUserType.firstWhere(
              (user) => (user['level_role'] as List<int>).contains(levelId),
              orElse: () => {'level': 1})['level']!;
      getUserFields(userType);
    }

    filterFields();
     
     if((levelId <= 3 || isSuperAdmin || isIspAdmin)) {
      value = 1;
       getUserFields(value);
     }
  }
  
 void getUserFields(int type) {
    fieldType = 1;
    searchUser = '';
    userType = type;

    fields = (type == 2 || type == 3)
        ? fields.where((field) => !field['hide']).toList()
        :allFields;
// print("Fields---$fields");
    if (levelId > 4) {
      fields = fields.where((field) => field['id'] != 8).toList();
    }
     searchFunction(type);
    
  }
   void filterFields() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int cardLimit = pref.getInt('cardlimit') ?? 0;
    int hotelLimit = pref.getInt('hotellimit') ?? 0;

    if (!isSuperAdmin) {
      if (cardLimit == -1 && hotelLimit == -1) {
        fields = fields
            .where((field) =>
                field['label'] != 'Card' && field['label'] != 'Hotel')
            .toList();
      } else {
        if (cardLimit == -1) {
          fields = fields.where((field) => field['label'] != 'Card').toList();
        }
        if (hotelLimit == -1) {
          fields = fields.where((field) => field['label'] != 'Hotel').toList();
        }
      }
    }
  }

@override
  void initState() {
    super.initState();
     allFields = List<Map<String, dynamic>>.from(fields);
    initializeUser() ;
//  searchFunction(0);
    
      form.control('search').valueChanges.listen((value) {
    if (value != null) {
      if (userType == 3) {
        // Navigate to ListCard if "Card" is selected
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) {
              return ListCard(id: (value as SearchDet).id,search: true);
            },
          ),
        );
      } else if (userType == 2) {
        // Navigate to a Hotel-specific page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) {
              return ListHotel(id: (value as SearchDet).id,search: true,);
            },
          ),
        );
      } else {
        // Default navigation to ViewSubscriber
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) {
              return ViewSubscriber(subscriberId: (value as SearchDet).id);
            },
          ),
        );
      }
    }
  });
  }
Future<List<dynamic>> fetchSearchResults(String filter) async {
  List<dynamic> results = [];

  try {
    // Combine the lists
    List<dynamic> combinedList = [];
    combinedList.addAll(searchPubIp);  // Add searchPubIp list
    combinedList.addAll(usermac);      // Add usermac list
    combinedList.addAll(search);       // Add search list

    // Filter the combined list
    results = combinedList.where((item) {
      return _getDisplayTextForSearchDet(item)
          .toLowerCase()
          .contains(filter.toLowerCase());
    }).toList();
  } catch (error) {
    print("Error during search: $error");
  }

  return results;
}

String _getDisplayTextForSearchDet(dynamic item) {
  if (item is SearchDet) {
    // Handle SearchDet
  
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
  } else if (item is SearchPubIpDet) {
    // Handle SearchPubIpDet
    switch (selectedSearchType) {
      case 7:
        return item.ipaddr;
      default:
        return '';
    }
  } else if (item is SearchUserMacDet) {
    // Handle SearchUserMacDet
    switch (selectedSearchType) {
      case 8:
        return item.usermac;
      default:
        return '';
    }
  }
  return '';
}

  int value = 0;
 Widget CustomRadioButton(String text, int index) {
    final notifier = Provider.of<ColorNotifire>(context);
    return OutlinedButton(
      onPressed: () {
        setState(() {
          value = index; // Update value based on selected button
        });
        // searchFunction(value); 
        getUserFields(value);// Call search function
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: (value == index) ? appMainColor : appWhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: (value == index) ? appMainColor : appGreyColor,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: (value == index) ? appWhiteColor : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
       final notifier = Provider.of<ColorNotifire>(context);
    return  ReactiveForm(
      formGroup: form,
      child: SingleChildScrollView(
        child:  Column(
             mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
              
                Visibility(
            visible:  fields.length > 1 &&(levelId <= 3 || isSuperAdmin || isIspAdmin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomRadioButton("Broadband", 1),
                const SizedBox(height: 5),
                CustomRadioButton("Hotel", 2),
                const SizedBox(height: 5),
                CustomRadioButton("Card", 3),
              ],
            ),
          ),
              const SizedBox(height: 20),
 Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '  Search Type',
                   style: mediumBlackTextStyle.copyWith(color:notifier.getMainText,fontWeight: FontWeight.bold,fontSize: 16)
                  ),
                ],
              ),
              const SizedBox(height: 5),
            Padding(
                 padding: const EdgeInsets.symmetric(
                  horizontal: 20,),
              child: DropdownButtonFormField<int>(
                       focusColor: Colors.transparent,
                        value: fields.any((field) => field['id'] == selectedSearchType)
      ? selectedSearchType
      : fields.first['id'], // Use a valid value from the fields list
                        onChanged: (newValue) async {
                          setState(() {
                            selectedSearchType = newValue!;
                             search.clear();
                            //  searchlocalIp.clear();
                             searchPubIp.clear();
                             usermac.clear();
                          });
                          switch (selectedSearchType) {
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                              await searchFunction(0);
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
                child:ReactiveDropdownSearch<dynamic, dynamic>(
  formControlName: 'search', // Specify the form control name

  dropdownDecoratorProps: DropDownDecoratorProps(
    dropdownSearchDecoration: InputDecoration(
      focusColor: Colors.transparent,
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
    return fetchSearchResults(filter); // Ensure this returns a List<dynamic>
  },
  popupProps: const PopupProps.menu(
    showSearchBox: true,
    isFilterOnline: true,
    searchFieldProps: TextFieldProps(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 15),
        hintText: 'Search Subscriber',
      ),
    ),
  ),
  itemAsString: (dynamic item) => _getDisplayTextForSearchDet(item),
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