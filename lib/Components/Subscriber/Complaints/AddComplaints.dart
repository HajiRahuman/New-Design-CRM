import 'dart:async';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/model/BottomNav.dart';
import 'package:crm/service/subscriber.dart';


import 'package:crm/model/subscriber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:crm/service/addSubscribers.dart' as addsubscriberSrv;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/addSubscriber.dart';

import 'package:crm/service/subscriber.dart' as subscriberSrvs;

class AddComplaint extends StatefulWidget {
  final SubsComplaintDet? SubComplaints;
  final int? resellerid;
  final int? subsID;

  AddComplaint({ this.SubComplaints,  this.resellerid, this.subsID});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<AddComplaint> {
  late FormGroup form;

  int levelid = 0;
  bool isIspAdmin = false;
  int id = 0;
  bool isSubscriber = false;
  List<resellerDet> resellerOpt = [];
  List<ComplaintTypeDet> ComplaintsTypes = [];
  List<SearchDet> search = [];
  final SubscriberComplaintService subscriberSrv = SubscriberComplaintService();
  final SubscriberInfoComplaint subscriberInfoSrv = SubscriberInfoComplaint();

  @override
  void initState() {
    super.initState();
    getMenuAccess();
    GetComplaintType();
    ComplaintForm();
    ResellerList();
    // print('SUbsis--${widget.subsID}');
    //   print('Resellid--${widget.resellerid}');
  }

  Future<void> getMenuAccess() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      levelid = pref.getInt('level_id') ?? 0;
      isIspAdmin = pref.getBool('isIspAdmin') ?? false;
      id = pref.getInt('id') ?? 0;
      isSubscriber = pref.getBool('isSubscriber') ?? false;
    });
  }

  void ComplaintForm() {
    form = FormGroup({
      'status': FormControl<int>(value: widget.SubComplaints?.status ?? 0),
      'type': FormControl<int>(value: widget.SubComplaints?.type ?? 0),
      'assignee': FormControl<int>(value: widget.SubComplaints?.assignee ?? 0),
      'subscriber': FormControl<int>(value: widget.SubComplaints?.subscriber ??widget.subsID),
      'reseller': FormControl<int>(value: widget.SubComplaints?.reseller ?? widget.resellerid),
      'complaint_step': FormGroup({
        'status': FormControl<int>(value: widget.SubComplaints?.status ?? 0),
        'comments': FormControl<String>(value: widget.SubComplaints?.comments ?? ''),
        'assignee': FormControl<int>(value: widget.SubComplaints?.assignee ?? 0),
        'attachment': FormControl<String>(),
      }),
    });
  }

  Future<void> ResellerList() async {
    resellerResp resp = await addsubscriberSrv.reseller();
    setState(() {
      resellerOpt = resp.error == true ? [] : resp.data ?? [];
    });
  }

  Future<void> GetComplaintType() async {
    ComplaintTypeResp resp = await subscriberSrv.complaintType('complaintsType');
    setState(() {
      ComplaintsTypes = resp.error == true ? [] : resp.data ?? [];
    });
  }

  Future<void> SubcriberInfo(int id) async {
    SearchResp resp = await subscriberInfoSrv.subsInfo(id);
    setState(() {
      search = resp.error == true ? [] : resp.data ?? [];
    });
  }

  Future<void> AddComplaints(value) async {
    final resp = await subscriberSrvs.addComplaint(form.value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }

  Future<void> AddResellerComplaints(int ids, value) async {
    final resp = await subscriberSrvs.addResellerComplaint(ids, form.value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }

  final List<Map<String, dynamic>> statusOptions = [
    {'value': 0, 'label': 'Open'},
    {'value': 1, 'label': 'In Progress'},
    {'value': 2, 'label': 'Closed'},
    {'value': 3, 'label': 'Not issue'},
    {'value': 4, 'label': 'Re-Open'},
  ];
int? resellerId;


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final notifier = Provider.of<ColorNotifire>(context);
    return Scaffold(
    backgroundColor: notifier.getbgcolor,
      body: SingleChildScrollView(
        child: ReactiveForm(
          formGroup: form,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                   Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Add Complaints',
                               style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                              ),
                            CircleAvatar(
                                                                        radius: 20,
                                                                        child: IconButton(
                                                                          onPressed: () {
                                                                            Navigator.of(
                                                                                context)
                                                                                .pop();
                                                                          },
                                                                          icon: const Icon(
                                                                            Icons
                                                                                .close_rounded,
                                                                                color: Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                            ],
                          ),
                        ),
                     
                    const SizedBox(height: 25),
                    Visibility(
                      visible: !isSubscriber,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ReactiveDropdownField<int>(
                              formControlName: 'reseller',
                              
                               style: TextStyle(color: notifier.getMainText),
                                                                          dropdownColor: notifier.getcontiner,
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding: EdgeInsets.only(left: 15),
                                                              
                                                                            hintStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                            hintText: 'Reseller',
                                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                 color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                                          ),
                                                        
                              isExpanded: true,
                                onChanged: (value) {
            setState(() {
              resellerId = form.control('reseller').value;
              
               SubcriberInfo(widget.SubComplaints?.reseller ??  resellerId!);
             
            });
          },
                              // onChanged: (newValue) {
                              //   SubcriberInfo(widget.SubComplaints?.reseller ?? widget.resellerid!);
                              // },
                              items: resellerOpt
                                  // .where((item) =>
                                  //     item.id == widget.SubComplaints?.reseller ?? widget.resellerid)
                                  .map((item) {
                                return DropdownMenuItem<int>(
                                  value: item.id,
                                  child: Text(item.company),
                                );
                              }).toList(),
                             
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ReactiveDropdownSearch<int, int>(
  formControlName: 'subscriber',
  
  dropdownDecoratorProps: DropDownDecoratorProps(
    dropdownSearchDecoration: InputDecoration(
    
      contentPadding: const EdgeInsets.only(left: 15),
      hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
      hintText: 'Subscriber',
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
  dropdownBuilder: (context, selectedItem) {
    // Find the item based on its ID and display the profileid instead of the ID
    if (selectedItem == null) {
      return Text(
        'Subscriber',
        style: TextStyle(color: notifier.getMainText),
      );
    }
    
    final selectedProfile = search.firstWhere((item) => item.id == selectedItem);
    
    return Text(
      selectedProfile.profileid,  // Display the profileid in the dropdown
      style: TextStyle(color: notifier.getMainText),
    );
  },
  popupProps:const PopupProps.menu(
    showSearchBox: true,
    isFilterOnline: true,
    searchFieldProps: TextFieldProps(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 15),
        hintText: 'Search Subscriber',
      ),
    ),
  ),
  asyncItems: (String filter) async {
    // Return filtered list of IDs based on search input
    if (filter.isEmpty) {
      return search.map((item) => item.id).toList();
    } else {
      return search
          .where((item) => item.profileid.toLowerCase().contains(filter.toLowerCase()))
          .map((filteredItem) => filteredItem.id)
          .toList();
    }
  },
  itemAsString: (int item) {
    // Find the item based on its ID and display the profileid
    final selectedItem = search.firstWhere((element) => element.id == item);
    return selectedItem.profileid;
  },
  // onChanged: (newValue) {
  //   // Handle selection changes
  //   print('Selected ID: $newValue');
  // },
)


                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ReactiveDropdownField<int>(
                              formControlName: 'complaint_step.assignee',
                                style: TextStyle(color: notifier.getMainText),
                                                                          dropdownColor: notifier.getcontiner,
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding: EdgeInsets.only(left: 15),
                                                              
                                                                            hintStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                            hintText: 'Assignee',
                                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                 color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                                          ),
                              isExpanded: true,
                              onChanged: (newValue) {},
                              items: resellerOpt.map((item) {
                                return DropdownMenuItem<int>(
                                  value: item.id,
                                  child: Text(item.company),
                                );
                              }).toList(),
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ReactiveDropdownField<int>(
                        formControlName: 'type',
                        style: TextStyle(color: notifier.getMainText),
                                                                          dropdownColor: notifier.getcontiner,
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding: EdgeInsets.only(left: 15),
                                                              
                                                                            hintStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                            hintText: 'Type',
                                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                 color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                                          ),
                        isExpanded: true,
                        onChanged: (newValue) {},
                        items: ComplaintsTypes.map((item) {
                          return DropdownMenuItem<int>(
                            value: item.id,
                            child: Text(item.name),
                          );
                        }).toList(),
                      
                      ),
                    ),
                    Visibility(
                      visible: !isSubscriber,
                      child: const SizedBox(height: 10),
                    ),
                    Visibility(
                      visible: !isSubscriber,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ReactiveDropdownField<int>(
                          formControlName: 'complaint_step.status',
                        style: TextStyle(color: notifier.getMainText),
                                                                          dropdownColor: notifier.getcontiner,
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding: EdgeInsets.only(left: 15),
                                                              
                                                                            hintStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                            hintText: 'Status',
                                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                 color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                                          ),
                          isExpanded: true,
                          onChanged: (newValue) {},
                          items: statusOptions.map((option) {
                            return DropdownMenuItem<int>(
                              value: option['value'],
                              child: Text(option['label']),
                            );
                          }).toList(),
                          
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ReactiveTextField<String>(
                         style: TextStyle(color: notifier.getMainText),
                                                                      
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 5,
                        formControlName: 'complaint_step.comments',
                       decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15,top: 10,right: 15,bottom: 10),
                                                              
                                                                            hintStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                            hintText: 'Comments',
                                                                            border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                 color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(10.0),
                                                                borderSide: BorderSide(
                                                                  width: 2.0,
                                                                color: Colors.grey.withOpacity(0.3)
                                                                ),
                                        
                                                              ),
                                                                          ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: appMainColor),
                          onPressed: () async {
                            if (isSubscriber) {
                              await AddComplaints(form.value);
                            } else {
                              await AddResellerComplaints(widget.SubComplaints?.id ?? 0, form.value);
                            }
                            Navigator.of(context).pop();
                          },
                          child: const Text('Submit',  style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: appMainColor),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel',  style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
