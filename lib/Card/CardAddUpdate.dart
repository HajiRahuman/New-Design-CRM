
import 'dart:async';


import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Utils/Utils.dart';
import 'package:crm/model/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:crm/service/addSubscribers.dart' as addsubscriberSrv;
import 'package:crm/service/card.dart' as CardSrvs;
import '../../../model/addSubscriber.dart';





class CardAddUpdate extends StatefulWidget {
  UpadteCardUserDet? CardUserDet;
  CardDet? card;
 
  CardAddUpdate({required this.card});


  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<CardAddUpdate> {
    FormGroup? form;

  // final GlobalKey<ScaffoldState> _key = GlobalKey();
  final GlobalKey<MyAppState> packageAndIpKey = GlobalKey<MyAppState>();
  TextEditingController propswController  = TextEditingController();
  TextEditingController usernameController  = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController simuluserController  = TextEditingController();
  TextEditingController totLimitController  = TextEditingController();
  TextEditingController upLimitController  = TextEditingController();
  TextEditingController downLimitController  = TextEditingController();
  TextEditingController OnlineTimeSecondController  = TextEditingController();
  TextEditingController profileIDController = TextEditingController();
  int selectedIndex = 0;
  int selectedDownMbps = 0;
  int selectedUpMbps = 0;
  int selectedTotMbps = 0;
  int selectedOnlineTimeSeconds=0;




  @override
 @override
void initState() {
  super.initState();
  ResellerList();
  createForm();
  
  if (widget.card != null) {
     profileIDController.text = widget.card?.profileId ?? ''; // Set profileID
    getUpadteCardUserDet();
    
  }
  // print('CardDet: ${widget.card!.id}');
  // print('CardUserDet: ${widget.CardUserDet}');
}

@override
void dispose() {
  // Dispose of the controller when the widget is removed
  profileIDController.dispose();
  super.dispose();
}

 void createForm() {
  
  form = FormGroup({
    
    'resellerid': FormControl<int>(
     value: widget.card?.resellerId ?? 0,
      validators: [Validators.required],
    ),
    'cardtype': FormControl<int>(
      value: widget.card?.cardType ?? 2,
      validators: [Validators.required],
    ),
    'cardprice': FormControl<int>(
      value: widget.card?.cardPrice ?? 0,
      validators: [Validators.required,],
    ),
    'expiration': FormControl<String>(
      value: widget.card != null && widget.card!.expiration.isNotEmpty
          ? DateFormat('yyyy-MM-dd hh:mm:ss a').format(DateTime.parse(widget.card!.expiration).toLocal())
          : "---",
      validators: [Validators.required],
    ),
    'packid': FormControl<int>(
      value: widget.card?.packId?? 0,
      validators: [Validators.required],
    ),
    'dllimit': FormControl<int>(
      
    value: widget.card != null
      ? widget.card!.dlLimit ~/ (1024 * 1024)
      : 0,
      validators: [Validators.required,],
    ),
    'uplimit': FormControl<int>(
     value: widget.card != null
      ? widget.card!.upLimit ~/ (1024 * 1024)
      : 0,
      validators: [Validators.required,],
    ),
    'totallimit': FormControl<int>(
     value: widget.card != null
      ? widget.card!.totalLimit ~/ (1024 * 1024)
      : 0,
      validators: [Validators.required],
    ),
    'timelimit': FormControl<int>(
      value: widget.card != null
      ? widget.card!.timeLimit ~/ (1024 * 1024)
      : 0,
      validators: [Validators.required],
    ),
    'cardexpiry': FormControl<int>(
      value: widget.card?.cardExpiry ?? 0,
      validators: [Validators.required],
    ),
    'cardduration': FormControl<int>(
      value: widget.card?.cardDuration?? 0,
      validators: [Validators.required],
    ),
    'carddurationtype': FormControl<int>(
      value: widget.card?.cardDurationType ?? 0,
    ),
    'simultaneoususe': FormControl<int>(
      value: widget.card?.simultaneousUse ?? 0,
      validators: [Validators.required],
    ),
    'card_qty': FormControl<int>(
      value: 0,
      validators: [Validators.required],
    ),
    'prefix': FormControl<String>(
      validators: [Validators.required, Validators.minLength(4), Validators.maxLength(6)],
    ),
    'pin_len': FormControl<int>(
      value: 0,
      validators: [Validators.required, Validators.minLength(4)],
    ),
    'pwd_len': FormControl<int>(
      value: 0,
      validators: [Validators.required, Validators.minLength(4)],
    ),
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
   
Future<void> getUpadteCardUserDet() async {
    final resp = await  CardSrvs.upadteCardUserDet(widget.card!.id);
    if (resp.error == false) {
      setState(() {
         widget.CardUserDet = resp.data;
       createForm();
       
      });
    }

  // print(widget.CardUserDet!.resellerId);
      getReseller(widget.card!.resellerId);
     GetPack(widget.card!.packId);
  }

//Add Subscriber
  Future<void> AddCardUser(value) async {
    final resp = await CardSrvs.addCarduser(value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }

  Future<void> updateCardUser(value) async {
    final resp = await CardSrvs.updateCardUser(widget.CardUserDet!.id,value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }

Map<String, int> cardduration = {
    'Days': 0,
    'Month': 1,
    'Minutes': 2,
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHight = MediaQuery.of(context).size.height;
     final notifier = Provider.of<ColorNotifire>(context);
    return  Scaffold(
       backgroundColor:notifier.getbgcolor,
              body: SingleChildScrollView(
                child: ReactiveForm(
                  formGroup: form!,
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
                                        widget.card != null ?'Generate Card' : 'Generate Card',
                                         style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.04,),
                                        
                                      ),
                                    CircleAvatar(
                                                                        radius: 20,
                                                                        child: IconButton(
                                                                          onPressed: () {
                                                                            Navigator.of(
                                                                                context)
                                                                                .pop();
                                                                          },
                                                                          icon:const  Icon(
                                                                            Icons
                                                                                .close_rounded,
                                                                              color:Colors.black
                                                                          ),
                                                                        ),
                                                                      ),
                                    ],
                                  ),
                                ),
                           
                            const SizedBox(height: 20),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ReactiveDropdownField<int>(
                                readOnly: widget.card!=null,
                                focusColor: Colors.transparent,
                                formControlName: 'resellerid',
                                                                        validationMessages: {
                                              'required': (error) => 'Reseller Required!',
                                            },
                                isExpanded: true,
                                // controller: resellerDropdownController,
                                onChanged: (newValue) {
                                  setState(() {
                                    resellerAlice(int.parse(form!.value['resellerid']?.toString() ?? '0'));
                                    getReseller(int.parse(form!.value['resellerid']?.toString() ?? '0'));
                                  });
                                },
                                items: resellerOpt
                                    .where((item) => item.levelid == 18 )
                                    .map((item) {
                                  return DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Text(item.profileid),
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
                          Visibility(
                            visible: widget.card!=null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                readOnly: true,
                                controller: profileIDController,
                                // keyboardType: TextInputType.multiline,
                                style: TextStyle(color: notifier.getMainText),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  labelStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                                  labelText: "Profile ID",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black,
                                    ),
                                  ),
                                  suffixIconColor: notifier.getMainText,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'ProfileID is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                            Visibility(
                              visible: widget.card!=null,
                              child: const SizedBox(height: 10)),
                             Align(alignment:Alignment.topLeft,
                                child: Text('Card Type',  style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.04,),
                                        
                                      )),
                                      const SizedBox(height: 5),
                             Row(
                  children: [
                    Expanded(
                      child: ReactiveRadioListTile(
                        formControlName: 'cardtype',
                        value: 2,
                        title: Text('One Time', style:  mediumBlackTextStyle.copyWith(
              color: notifier.getMainText,
            ),),
                      ),
                    ),
                    Expanded(
                      child: ReactiveRadioListTile(
                    
                       formControlName: 'cardtype',
                        value: 3,
                        title: Text('Refill', style:  mediumBlackTextStyle.copyWith(
              color: notifier.getMainText,
            ),),
                      ),
                    ),
                  ],
                ),
                  const SizedBox(height: 10),
                    Align(alignment:Alignment.topLeft,
                                child: Text('Expiration',  style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.04,),
                                        
                                      )),
                                      const SizedBox(height: 5),
                    Row(
                  children: [
                    Expanded(
                      child: ReactiveRadioListTile<int>(
                        formControlName: 'cardexpiry',
                        value: 0,
                        title: Text('User Defined',style:  mediumBlackTextStyle.copyWith(
                                    color: notifier.getMainText,
                                  ),),
                                   onChanged: (value) {
     form!.control('cardexpiry').value = 0;  // Update value directly
  setState(() {});
  },
                      ),
                    ),
                    Expanded(
                      child: ReactiveRadioListTile<int>(
                        formControlName: 'cardexpiry',
                        value: 1,
                        title: Text('Calculate from card activation',style:  mediumBlackTextStyle.copyWith(
                                    color: notifier.getMainText,
                                  ),),
                                   onChanged: (value) {
     form!.control('cardexpiry').value = 1;  // Update value directly
  setState(() {});
  },
                      ),
                    ),
                  ],
                ),
                   const SizedBox(height: 10),

                                  ReactiveValueListenableBuilder<int>(
      formControlName: 'cardexpiry',
      builder: (context, value, child) {
        return Visibility(
            visible: value.value == 0, 
          child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                          child:
                                          ReactiveTextField<String>(
                                            validationMessages: {
                                              'required': (error) => 'Expiration Required!',
                                            },
                                            formControlName: 'expiration',
                                            controller: dateController,
                                            readOnly: true,
                                             style: TextStyle(color: notifier.getMainText),
                                                                              
                                                                             
                                                                               decoration: InputDecoration(
                                                                                 contentPadding:const EdgeInsets.only(left: 15),
                                                                    
                                                                                 
                                                                                  labelStyle: mediumGreyTextStyle.copyWith(
                                                fontSize: 13),
                                                                                labelText: 'Valid till(Expiry) *',
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
        );
                                    }
                                  ),
                 const SizedBox(height: 10),
                  ReactiveValueListenableBuilder<int>(
      formControlName: 'cardexpiry',
      builder: (context, value, child) {
        return Visibility(
          visible: value.value == 1, // Show only when "Calculate from card activation" is selected
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ReactiveSpinBox(
                  formControlName: 'carddurationtype',
                  min: 0,
                  max: double.infinity,
                  step: 1,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15),
                    hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                    hintText: 'Enter Duration to activate card',
                    labelStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                    labelText: 'Duration to activate card',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: notifier.isDark ? notifier.geticoncolor : Colors.black,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: notifier.isDark ? notifier.geticoncolor : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ReactiveDropdownField<int>(
                  focusColor: Colors.transparent,
                  formControlName: 'cardduration',
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {});
                  },
                  items: cardduration.keys
      .map<DropdownMenuItem<int>>((String key) {
    final newValue = cardduration[key];
    return DropdownMenuItem<int>(
      value: newValue,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(key),
      ),
    );
  }).toList(),
                  dropdownColor: notifier.getcontiner,
                  style: TextStyle(color: notifier.getMainText),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15),
                    labelStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                    labelText: 'Duration to activate card',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: notifier.isDark ? notifier.geticoncolor : Colors.black,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: notifier.isDark ? notifier.geticoncolor : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  
                
                            const SizedBox(height: 10),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: ReactiveDropdownField<int>(
                                focusColor: Colors.transparent,
                                formControlName: 'packid',
                               
                                isExpanded: true,
                                // controller: resellerDropdownController,
                                onChanged: (newValue) {
                                  setState(() {
                                    GetPack(form!.value['packid']);
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
                              Visibility(
                                           visible: (getPackOpt?.packmode ?? 0) >= 3 &&
           ((getPackOpt?.fupmode ?? -1) == 0 || (getPackOpt?.fupmode ?? -1) == 2),
                                          // visible:
                                          //  getPackOpt?.packmode == 3 &&
                                          //     (getPackOpt?.fupmode == 0 ||
                                          //         getPackOpt?.fupmode == 2),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child:
                                             ReactiveSpinBox(
                                    
                                    
                                   min: 0, 
max: double.infinity, 
                                    step: 1,
                                    
                    validationMessages: {
                                                   'required': (error) => 'Download Limit required..!',
                                                   },
                                              formControlName: 'dllimit',
                                         
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]')),
                                              ],
                                           
                                                         
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                                                                          hintText: 'Enter Download Limit',
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
                                                                    
                                                                                 ),
                                                                                 
                                           
                                  ),
                                            
                                         
                                          ),
                                        ),
                                        Visibility(
                                           visible: (getPackOpt?.packmode ?? 0) >= 3 &&
           ((getPackOpt?.fupmode ?? -1) == 0 || (getPackOpt?.fupmode ?? -1) == 2),
                                          child: const SizedBox(height: 10)),
                                        Visibility(
                                          visible: (getPackOpt?.packmode ?? 0) >= 3 &&
         ((getPackOpt?.fupmode ?? -1) == 1 || (getPackOpt?.fupmode ?? -1) == 2),

                            //               visible:
                            //                 getPackOpt!.packmode >= 3 &&
                            // (getPackOpt!.fupmode == 1 || getPackOpt!.fupmode == 2),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child:
                                            
                                              ReactiveSpinBox(
                                    
                                    
                                   min: 0, 
max: double.infinity, 
                                    step: 1,
                                    
                      validationMessages: {
                                                   'required': (error) => 'Upload Limit required..!',
                                                   },
                                              formControlName: 'uplimit',
                                             
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]')),
                                              ],
                                          
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                                                                          hintText: 'Enter Upload Limit',
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText:'Upload Limit(in Mbps)',
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
                                        Visibility(
                                             visible: (getPackOpt?.packmode ?? 0) >= 3 &&
         ((getPackOpt?.fupmode ?? -1) == 1 || (getPackOpt?.fupmode ?? -1) == 2),

                                          child: const SizedBox(height: 10)),
                                        Visibility(
                                         
visible: (getPackOpt?.packmode ?? 0) >= 3 &&
         (getPackOpt?.fupmode ?? -1) == 3,

                                          // visible:getPackOpt!.packmode >= 3 &&getPackOpt!.fupmode == 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child:
                                              ReactiveSpinBox(
                                    
                                    
                                    min: 0, 
max: double.infinity, 
                                    step: 1,
                                    
                      validationMessages: {
                                                   'required': (error) => 'Total Limit required..!',
                                                   },
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]')),
                                              ],
                                              formControlName: 'totallimit',
                                            
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                                                                          hintText: 'Enter Total Limit',
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText:'Total Limit(in Mbps)',
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
                                        // timelimit
                                        Visibility(
                                          visible: (getPackOpt?.packmode ?? 0) >= 3 &&
         (getPackOpt?.fupmode ?? -1) == 3,

                                          child: const SizedBox(height: 10)),
                                        Visibility(
                                          visible: (getPackOpt?.packmode == 1 ||getPackOpt?.packmode == 4),
                                             
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: 
                                             ReactiveSpinBox(
                                    
                                    
                                    min: 0, 
max: double.infinity, 
                                    step: 1,
                                    
                     validationMessages: {
                                                   'required': (error) => 'Online time required..!',
                                                   },
                                              
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]')),
                                              ],
                                              formControlName: 'timelimit',
                                           
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                                                                          hintText: 'Enter Online Time',
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText:'Online Time(Seconds))',
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
                            const SizedBox(height: 10),
                           Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ReactiveSpinBox(
                                    
                                      formControlName: 'simultaneoususe',
                                    min: 0, 
max: double.infinity, 
                                    step: 1,
                                    
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
                                visible: widget.card==null,
                               child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                   child: 
                                                   
                                                   
                                                   ReactiveSpinBox(
                                      
                                    min: 0, 
                               max: double.infinity, 
                                      step: 1,
                                      
                                   formControlName: 'card_qty',
                                                                            
                                                                            
                                                                           
                                                                             decoration: InputDecoration(
                                                                               contentPadding:const EdgeInsets.only(left: 15),
                                                                  hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                                                                            hintText: 'Enter Card Quantity',
                                                                                labelStyle: mediumGreyTextStyle.copyWith(
                                              fontSize: 13),
                                                                               labelText: 'Card Quantity *',
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
                           
                              Visibility(
                                  visible: widget.card==null,
                                child: const SizedBox(height: 10)),
                              Visibility(
                                  visible: widget.card==null,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: ReactiveSpinBox(
                                    min: 0, 
                                max: double.infinity, 
                                    step: 1,
                                    validationMessages: {
                                      'required': (error) => 'Card price required!',
                                    }, // Add validation messages here
                                    formControlName: 'cardprice',
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(left: 15),
                                      hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                                      hintText: 'Enter Price per card',
                                      labelStyle: mediumGreyTextStyle.copyWith(
                                        fontSize: 13,
                                      ),
                                      labelText: 'Price per card *',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: notifier.isDark
                                              ? notifier.geticoncolor
                                              : Colors.black,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                          color: notifier.isDark
                                              ? notifier.geticoncolor
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                             
                               Visibility(
                                  visible: widget.card==null,
                                child: const SizedBox(height: 10)),
                               Visibility(
                                  visible: widget.card==null,
                                 child: Padding(
                                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: ReactiveTextField(
                                       validationMessages: {
                                            'required': (error) => 'Prefix Length must be greater than 4 and less than 6 is required!',
                                          },
                                                      formControlName: 'prefix',
                                                       style: TextStyle(color: notifier.getMainText),
                                                                            
                                                                           
                                                                             decoration: InputDecoration(
                                                                               contentPadding:const EdgeInsets.only(left: 15),
                                                                  hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                                                                            hintText: 'Enter Perfix',
                                                                                labelStyle: mediumGreyTextStyle.copyWith(
                                              fontSize: 13),
                                                                               labelText: 'Prefix *',
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

                               
                                   Visibility(
                                      visible: widget.card==null,
                                    child: const SizedBox(height: 10)),
                                     Visibility(
                                        visible: widget.card==null,
                                       child: Padding(
                                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                         child: ReactiveSpinBox(
                                            validationMessages: {
                                            'required': (error) => 'Pin Length required!',
                                          },
                                          min: 0, 
                                       max: double.infinity, 
                                           step: 1,
                                               formControlName: 'pin_len',
                                                   
                                                                            
                                                                           
                                                                             decoration: InputDecoration(
                                                                               contentPadding:const EdgeInsets.only(left: 15),
                                                                  hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                                                                            hintText: 'Enter Pin Length',
                                                                                labelStyle: mediumGreyTextStyle.copyWith(
                                              fontSize: 13),
                                                                               labelText: 'Pin Length',
                                             enabledBorder: OutlineInputBorder(
                                               borderRadius: BorderRadius.circular(10.0),
                                               borderSide: BorderSide(
                                                 color: notifier.isDark
                                                     ? notifier.geticoncolor
                                                     : Colors.black,
                                               ),
                                             ),
                                             border: OutlineInputBorder(
                                               borderRadius: BorderRadius.circular(10.0),
                                               borderSide: BorderSide(
                                                 color: notifier.isDark
                                                     ? notifier.geticoncolor
                                                     : Colors.black,
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                     ),
 Visibility(
    visible: widget.card==null,
  child: const SizedBox(height: 10)),

                                                                  Visibility(
                                                                    visible: widget.card==null,
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                                      child: ReactiveSpinBox(
                                                                         validationMessages: {
                                                                                                              'required': (error) => 'Password Length required!',
                                                                                                            },
                                                                       min: 0, 
                                                                    max: double.infinity, 
                                                                        step: 1,
                                                                            formControlName: 'pwd_len',
                                                                                                                     
                                                                            
                                                                           
                                                                             decoration: InputDecoration(
                                                                               contentPadding:const EdgeInsets.only(left: 15),
                                                                                                                                    hintStyle: mediumGreyTextStyle.copyWith(fontSize: 13),
                                                                            hintText: 'Enter Password Length',
                                                                                labelStyle: mediumGreyTextStyle.copyWith(
                                                                                                                fontSize: 13),
                                                                               labelText: 'Password Length',
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                            borderSide: BorderSide(
                                                                              color: notifier.isDark
                                                                                  ? notifier.geticoncolor
                                                                                  : Colors.black,
                                                                            ),
                                                                          ),
                                                                          border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                            borderSide: BorderSide(
                                                                              color: notifier.isDark
                                                                                  ? notifier.geticoncolor
                                                                                  : Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                    const SizedBox(height: 20),

                                    Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                   backgroundColor: appMainColor
                  ),
                  onPressed: () async {
                    form!.control('expiration').patchValue(dateController.text);
                      final value = {...form!.value}; // Create a copy of the map
                    //  print('value--$value');
                      await widget.card != null ? updateCardUser(value) :  AddCardUser(value);
                    if (form!.valid) {

                    }else {
                      form!.markAllAsTouched();
                    }
                  },
                  child:  Text(widget.card != null ?'Update' : 'Submit',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],)
                              ],
                            ),

                        ),
                      ),
                    ),
                  ),
              ),
           
              );

  }


 String formattedDate = DateFormat('M/d/yyyy hh:mm:ss a').format(DateTime.now());

Future<void> _selectDate(BuildContext context) async {
  // Show the date picker first
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1950),
    lastDate: DateTime(2100),
  );

  if (pickedDate != null) {
    // Show the time picker after a date is selected
    TimeOfDay? pickedTime = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Combine the picked date and time
      final DateTime pickedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        // Format the combined date and time with AM/PM and seconds
        formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss a').format(pickedDateTime);
          dateController.text = formattedDate;
      });
    }
  }
}
}
