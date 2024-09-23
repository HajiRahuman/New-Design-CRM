
import 'dart:async';


import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';



import 'package:crm/model/subscriber.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:crm/service/addSubscribers.dart' as addsubscriberSrv;
import 'package:crm/service/hotel.dart' as HotelUserSrv;
import '../../../model/addSubscriber.dart';

import '../../model/hotel.dart';
import '../../service/crypto.dart';




class HotelAddUser extends StatefulWidget {
  SubscriberFullDet? subscriberDet;
  HotelDet? hotel;
  HotelAddUser({required this.hotel});


  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<HotelAddUser> {
  late  FormGroup form;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<MyAppState> packageAndIpKey = GlobalKey<MyAppState>();
  TextEditingController propswController  = TextEditingController();
  TextEditingController usernameController  = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController simuluserController  = TextEditingController();
  TextEditingController totLimitController  = TextEditingController();
  TextEditingController upLimitController  = TextEditingController();
  TextEditingController downLimitController  = TextEditingController();
  TextEditingController OnlineTimeSecondController  = TextEditingController();
  int selectedIndex = 0;
  int selectedDownMbps = 0;
  int selectedUpMbps = 0;
  int selectedTotMbps = 0;
  int selectedOnlineTimeSeconds=0;




  @override
  void initState() {
    super.initState();
    ResellerList();
   createForm();
  }
  createForm(){
    form = FormGroup({
      'id': FormControl<int>(value:widget.hotel != null ? widget.hotel?.id : null , validators: [Validators.required]),
      'resellerid': FormControl<int>(value:widget.hotel != null ? widget.hotel?.resellerid : null ,validators: [Validators.required]),
      'profileid': FormControl<String>(value:widget.hotel != null ? widget.hotel?.profileid : '' ,validators: [Validators.required]),
      'packid': FormControl<int>(validators: [Validators.required]),
      'dllimit': FormControl<String>(validators: [Validators.required]),
      'uplimit': FormControl<String>(validators: [Validators.required]),
      'totallimit': FormControl<String>(validators: [Validators.required]),
      'timelimit': FormControl<String>(validators: [Validators.required]),
      'simultaneoususe': FormControl<int>(value:widget.hotel != null ? widget.hotel?.simultaneoususe : null ,validators: [Validators.required]),
      'password': FormControl<String>(value:widget.hotel != null ? widget.hotel?.authpsw: '' ,validators: [Validators.required]),
      'expiration': FormControl<String>(value:widget.hotel != null ? widget.hotel?.expiration : '' ,validators: [Validators.requiredTrue]),
    });
  }

  List<resellerDet> resellerOpt = [];
  Future<void> ResellerList() async {
    resellerResp resp = (await addsubscriberSrv.reseller());
    setState(() {
      resellerOpt = resp.error == true ? [] : resp.data ?? [];
    });
  }

  List<getResellerDet> resellerList = [];
  Future<void> getReseller(int id) async {
    getResellerResp resp = (await addsubscriberSrv.getresellerPack(id));
    setState(() {
      resellerList = resp.error == true ? [] : resp.data ?? [];
    });
  }


  List<resellerAliceDet> reselleralice = [];
  Future<void> resellerAlice(int id) async {
    resellerAliceResp resp = (await addsubscriberSrv.resellerAlice(id));
    setState(() {
      reselleralice = resp.error == true ? [] : resp.data ?? [];
    });
  }

  GetPackDet? getPackOpt = null;
  Future<void> GetPack(packid) async {
    GetPackResp resp = await addsubscriberSrv.getPack(packid);
    setState(() {
      getPackOpt = resp.error == true ? null : resp.data;
    });

  }


//Add Subscriber
  Future<void> AddHotelUser(value) async {
    final resp = await HotelUserSrv.addHoteluser(value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }

  Future<void> updateHotelUser(value) async {
    final resp = await HotelUserSrv.updateHotelUser(widget.hotel!.id,value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHight = MediaQuery.of(context).size.height;
     final notifier = Provider.of<ColorNotifire>(context);
    return  Scaffold(
       backgroundColor:notifier.getbgcolor,
              body: SingleChildScrollView(
                child: ReactiveForm(
                  formGroup: form,
                  child: Padding(padding: const EdgeInsets.all(8),
                    child: SafeArea(
                      child: Padding(padding: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.hotel != null ?'Customer Activation' : 'Add User',
                                         style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.02,),
                                        
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
                                                                              color: notifier.getMainText
                                                                          ),
                                                                        ),
                                                                      ),
                                    ],
                                  ),
                                ),
                           
                            const SizedBox(height: 20),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ReactiveDropdownField<int>(
                                formControlName: 'resellerid',
                            
                                isExpanded: true,
                                // controller: resellerDropdownController,
                                onChanged: (newValue) {
                                  setState(() {
                                    resellerAlice(int.parse(form.value['resellerid']?.toString() ?? '0'));
                                    getReseller(int.parse(form.value['resellerid']?.toString() ?? '0'));
                                  });
                                },
                                items: resellerOpt
                                    .where((item) => item.levelid == 14)
                                    .map((item) {
                                  return DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Text(item.company),
                                  );
                                }).toList(),
                                dropdownColor: notifier.getcontiner,
                                                       style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                             labelText: 'Reseller',
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
                            const SizedBox(height: 10),
                            Align(alignment:Alignment.topLeft,
                                child: Text('Individual',  style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.02,),
                                        
                                      )),
                            const SizedBox(height: 15),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                          child:ReactiveTextField<String>(
                                            validationMessages: {
                                              'required': (error) => 'profile ID is Required!',
                                            },
                                            formControlName: 'profileid',
                                            controller:  usernameController,
                                            
                                                       style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                          labelText: 'Profile ID',
                                                                           
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
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child:ReactiveTextField<String>(
                                      validationMessages: {
                                        'required': (error) => 'Password is Required!',
                                      },
                                      formControlName: 'password',
                                      controller:  propswController,
                                       style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                           labelText: 'Password',
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
                                      onChanged: (_) {

                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child:ReactiveTextField<String>(
                                      validationMessages: {
                                        'required': (error) => 'Expiration User is Required!',
                                      },
                                      formControlName: 'expiration',
                                      controller: dateController,
                                      readOnly: true,
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
                                                              suffixIcon: GestureDetector(
                                          onTap: () => _selectDate(context),
                                          child:  Icon(
                                            Icons.calendar_today,  // You can use any icon you prefer
                                            color: notifier.getMainText
                                          ),
                                        ),
                                                                         ),
                                      
                                    ),
                                  ),
                            const SizedBox(height: 10),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ReactiveDropdownField<int>(
                                formControlName: 'packid',
                               
                                isExpanded: true,
                                // controller: resellerDropdownController,
                                onChanged: (newValue) {
                                  setState(() {
                                    GetPack(form.value['packid']);
                                  });
                                },
                                items:resellerList.map((item) {
                                  return DropdownMenuItem<int>(
                                    value: item.packid,
                                    child: Text(item.packname),
                                  );
                                }).toList(),
                                dropdownColor: notifier.getcontiner,
                                                       style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                          suffixIconColor:   notifier.getMainText,
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                          labelText: 'Associated Package',
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
                            const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child:ReactiveTextField<int>(
                                      validationMessages: {
                                        'required': (error) => 'Simultaneous User is Required!',
                                      },
                                      formControlName: 'simultaneoususe',
                                      controller:  simuluserController,
                                    
                                                       style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                           labelText: 'Simultaneous User',
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
                            const SizedBox(height: 10),
                            Visibility(
                              visible: getPackOpt?.packmode == 3 && (getPackOpt?.fupmode == 1 || getPackOpt?.fupmode == 2),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: ReactiveTextField(
                                  formControlName: 'uplimit',
                                  controller: upLimitController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  
                                                       style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                            labelText: 'Upload Limit(in Mbps)',
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
                                                              suffixIconColor:  notifier.getMainText,
                                                               suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedUpMbps++;
                                              upLimitController.text = selectedUpMbps.toString();
                                            });
                                          },
                                          child:  Icon(
                                            Icons.arrow_drop_up,
                                             color: notifier.getMainText
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (selectedUpMbps > 0) {
                                              setState(() {
                                                selectedUpMbps--;
                                                upLimitController.text = selectedUpMbps.toString();
                                              });
                                            }
                                          },
                                          child:  Icon(
                                            Icons.arrow_drop_down,
                                            color: notifier.getMainText
                                          ),
                                        ),
                                      ],
                                    ),
                                                                          ),
                                  
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Visibility(
                              visible: getPackOpt?.packmode == 4 && (getPackOpt?.fupmode == 0 || getPackOpt?.fupmode == 2),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: ReactiveTextField(
                                  formControlName: 'dllimit',
                                  controller: downLimitController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                   style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                             labelText: 'Download Limit(in Mbps)',
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
                                                              suffixIconColor:notifier.getMainText,
                                                             suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedDownMbps++;
                                              downLimitController.text = selectedDownMbps.toString();
                                            });
                                          },
                                          child:  Icon(
                                            Icons.arrow_drop_up,
                                          color: notifier.getMainText
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (selectedDownMbps > 0) {
                                              setState(() {
                                                selectedDownMbps--;
                                                downLimitController.text = selectedDownMbps.toString();
                                              });
                                            }
                                          },
                                          child:  Icon(
                                            Icons.arrow_drop_down,
                                           color: notifier.getMainText
                                          ),
                                        ),
                                      ],
                                    ),
                                                                          ),
                                  
                                 
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Visibility(
                              visible:(getPackOpt?.packmode == 3 || getPackOpt?.packmode == 4 || getPackOpt?.packmode == 5) && getPackOpt?.fupmode == 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: ReactiveTextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  formControlName: 'totallimit',
                                  controller: totLimitController,
                                   style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                             labelText: 'Total Limit(in Mbps)',
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
                                                             suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children:[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedTotMbps++;
                                              totLimitController.text = selectedTotMbps.toString();
                                            });
                                          },
                                          child:Icon(
                                            Icons.arrow_drop_up,
                                          color: notifier.getMainText
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (selectedUpMbps > 0) {
                                              setState(() {
                                                selectedTotMbps--;
                                                totLimitController.text = selectedTotMbps.toString();
                                              });
                                            }
                                          },
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            color: notifier.getMainText
                                          ),
                                        ),
                                      ],
                                    ),
                                                                          ),
                                 
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Visibility(
                              visible: getPackOpt?.packmode == 4 && (getPackOpt?.fupmode == 0 || getPackOpt?.fupmode == 2),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: ReactiveTextField(
                                  formControlName: 'timelimit',
                                  controller: OnlineTimeSecondController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                   style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                            labelText: 'Online Time(Seconds)',
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
                                                              suffixIconColor:  notifier.getMainText,
                                                             suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedOnlineTimeSeconds++;
                                              OnlineTimeSecondController.text =selectedOnlineTimeSeconds.toString();
                                            });
                                          },
                                          child:  Icon(
                                            Icons.arrow_drop_up,
                                             color: notifier.getMainText
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (selectedOnlineTimeSeconds > 0) {
                                              setState(() {
                                                selectedOnlineTimeSeconds--;
                                                OnlineTimeSecondController.text = selectedOnlineTimeSeconds.toString();
                                              });
                                            }
                                          },
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                          color: notifier.getMainText
                                          ),
                                        ),
                                      ],
                                    ),
                                                                          ),
                                 
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                              ],
                            ),

                        ),
                      ),
                    ),
                  ),
              ),
            floatingActionButton:Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                   backgroundColor: appMainColor
                  ),
                  onPressed: () async {
                    form.control('expiration').patchValue(dateController.text);
                      final value = {...form.value}; // Create a copy of the map
                      final encryptPwd = await encryptPasswordAndSubmit(value);
                      value['password'] = encryptPwd;
                      await widget.hotel != null ? updateHotelUser(value) :  AddHotelUser(value);
                    if (form.valid) {

                    }else {
                      form.markAllAsTouched();
                    }
                  },
                  child:  Text(widget.hotel != null ?'Update' : 'Submit',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],)
              );

  }

  Future<String> encryptPasswordAndSubmit(value) async {
    final encryptedPwdResp = await getEncryptPassword(value['password']);
    final encryptedPwd = encryptedPwdResp['password'];
    return encryptedPwd;
    // form.control('profilepsw').value = encryptedPwd;
  }
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(picked);
        dateController.text = formattedDate;
      });
    }
  }

}
