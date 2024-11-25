

import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/service/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../model/subscriber.dart';

import 'package:crm/service/subscriber.dart' as subscriberSrv;


class AccountStatus  extends StatefulWidget {
  SubscriberFullDet? subscriberDet;

  final int subscriberId;
  final String acctstatus;

  AccountStatus({required this.subscriberId,required this.acctstatus});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<AccountStatus > {


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;
  bool _obscurePassword = true;


  TextEditingController remarksController = TextEditingController();
  TextEditingController acctstatusController = TextEditingController();

  bool isSearching = false;
  void fetchData() async {
    final resp =
    await subscriberSrv.fetchSubscriberDetail(widget.subscriberId!);
    setState(() {
      if (resp.error) alert(context, resp.msg);
      widget.subscriberDet = resp.data;
    });
  }
  String acctStatusOpt= '';

  int selectedNumericValue = 0;
  Map<String, int> statusMap = {
    'Disable': 0,
    'Enable': 1,
    'Hold': 2,
    'Suspend': 3,
    'Terminate': 4,
  };

  @override
  void initState() {
    // Set the initial value based on widget.acctstatus
    switch (widget.acctstatus) {
      case 'Active':
      case 'Expired':
      acctStatusOpt = 'Enable';
        break;
      case 'Disable':
        acctStatusOpt = 'Disable';
        break;
      case 'Hold':
        acctStatusOpt = 'Hold';
        break;
      case 'Suspend':
        acctStatusOpt = 'Suspend';
        break;
      case 'Terminate':
        acctStatusOpt = 'Terminate';
        break;
      default:
        acctStatusOpt = '';
    }
    super.initState();
  }

  Future<Map<String, dynamic>> updateAccountStatus(UpdateAccountSts updateAccount) async {
    final url = 'subscriber/updateAccountStatus/${widget.subscriberId}';
    final resp = await http.put(url, {
      'acctstatus': updateAccount.acctstatus,
      'id': widget.subscriberId,
      'remarks': updateAccount.remarks,
    });
    return resp;
  }




  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
      final notifier = Provider.of<ColorNotifire>(context);
    return Form(
      key: _formKey,
      autovalidateMode: _isSubmitted
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child:  Column(
          children: [
            const SizedBox(height: 15),
           Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Account Status",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                        ),
                      ),
                     CircleAvatar(
                                                                        radius: 20,
                                                                        child: IconButton(
                                                                          onPressed: () {
                                                                            Navigator.of(
                                                                                context)
                                                                                .pop();
                                                                          },
                                                                          icon:  Icon(
                                                                            Icons
                                                                                .close_rounded,
                                                                                color:notifier.getMainText,
                                                                          ),
                                                                        ),
                                                                      ),
                    ],
                  ),
                ),
            
            const SizedBox(height: 10),
            Center(
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child:
                  DropdownButtonFormField<String>(
                    
                    isExpanded: true,
                    value: acctStatusOpt,
                    onChanged: (newValue) {
                      setState(() {
                        acctStatusOpt = newValue!;
                        selectedNumericValue = statusMap[newValue] ?? 0;
                      });
                    },
                    items: statusMap.keys.map<DropdownMenuItem<String>>(
                          (String key) {
                        return DropdownMenuItem<String>(
                          value: key,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(key),
                          ),
                        );
                      },
                    ).toList(),
                   dropdownColor: notifier.getcontiner,
                                                         style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                            suffixIconColor: notifier.getMainText,
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText: 'Account Status',
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
            ),
           const SizedBox(height: 5),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: 3,
               
                controller:remarksController,
                 style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 10,top:10,right: 10,bottom: 10),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                             labelText: "Remarks",
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
                                          suffixIconColor: notifier.getMainText,
                                          
                                                                            ),
                
                
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Remarks is required';
                  }
                  return null;},
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                 backgroundColor: appMainColor
                ),
                onPressed: () async {
                  setState(() {
                    _isSubmitted = true;
                  });
                  if (_formKey.currentState!.validate()) {
                    int id = widget.subscriberId;
                    final result = await updateAccountStatus(
                      UpdateAccountSts(
                        acctstatus: selectedNumericValue,
                        remarks: remarksController.text, id: widget.subscriberId,
                      ),
                    );
                    if (result['error'] == false) {
                      alert(context, result['msg'], result['error']);
                      Navigator.pop(context,true);
                    }
                  }

                },
                child: const Text('Update', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
              ),
            ),
                                              ],
                                            ),
      
                                      );
  }
}
