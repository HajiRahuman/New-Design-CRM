import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/model/addSubscriber.dart';
import 'package:crm/model/subscriber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:crm/service/addSubscribers.dart' as UpadtePacksubscriberSrv;
import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'dart:core';

import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePackAndValidity extends StatefulWidget {
  SubscriberFullDet? subscriberDet;

  final int subscriberId;
  final int simultaneoususe;
  final int packid;
final String expiration;
  final int resellerid;


  UpdatePackAndValidity({Key? key, required this.subscriberId,
    required this.packid,required this.simultaneoususe,required this.resellerid,required this.expiration}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<UpdatePackAndValidity> {
  TextEditingController authPwdController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController simulUserController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;

  @override

  String pacval= '';
  String simul= '';

  int selectedNumber = 0;

  int selectedValue1 = 0;
  void initState() {
    super.initState();
    initializeForm();
    ResellerPack(widget.resellerid);
  }
  TextEditingController downLimitController = TextEditingController();
  TextEditingController upLimitController = TextEditingController();
  TextEditingController totLimitController = TextEditingController();
  TextEditingController onlineLimitController = TextEditingController();
  int selectedDownMbps = 0;
  int selectedUpMbps = 0;
  int selectedTotMbps = 0;
  int selectedOnlTime = 0;
    FormGroup? form;
    
 int levelid = 0;
  bool isIspAdmin = false;
  int id=0;
  int selectedAmount = 0;
  bool isSubscriber=false;
 getMenuAccess() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    levelid = pref.getInt('level_id') as int;
    isIspAdmin = pref.getBool('isIspAdmin') as bool;
    id = pref.getInt('id') as int;
    isSubscriber = pref.getBool('isSubscriber') as bool;
    
  }

  void initializeForm() {
    form = FormGroup({
      'id': FormControl<int>(value:widget.subscriberId,validators: [Validators.required]),
      'packid': FormControl<int>(value: widget.packid,validators: [Validators.required]),
      'expiration': FormControl<String>(value: widget.expiration),
      'simultaneoususe': FormControl<int>(validators: [Validators.required]),
      'dllimit': FormControl<int>(value: 0),
      'timelimit': FormControl<int>(value: 0),
       'totallimit': FormControl<int>(value: 0),
        'uplimit': FormControl<int>(value: 0),
        'remarks': FormControl<String>(validators: [Validators.required]),
      
    });
  }

GetPackDet? getPackOpt;
  Future<void> GetPack(packid) async {
    GetPackResp resp = await UpadtePacksubscriberSrv.getPack(packid);
    setState(() {
      if (resp.error) alert(context, resp.msg);
      // print('Response Data: ${resp}');
      getPackOpt = resp.error == true ? null : resp.data;
      // debugPrint('Pack----$getPackOpt');
    });
    // updateValidators();

  }


void updateValidators() {
  // 'dllimit' validator
  final dlLimitControl = form!.control('dllimit');
  if ((getPackOpt?.packmode ?? 0) >= 3 &&
           ((getPackOpt?.fupmode ?? -1) == 0 || (getPackOpt?.fupmode ?? -1) == 2)) {
    dlLimitControl.setValidators([Validators.required]);
  } else {
    dlLimitControl.setValidators([]);
  }
  dlLimitControl.updateValueAndValidity();

  // 'uplimit' validator
  final upLimitControl = form!.control('uplimit');
  if ((getPackOpt?.packmode ?? 0) >= 3 &&
         ((getPackOpt?.fupmode ?? -1) == 1 || (getPackOpt?.fupmode ?? -1) == 2)) {
    upLimitControl.setValidators([Validators.required]);
  } else {
    upLimitControl.setValidators([]);
  }
  upLimitControl.updateValueAndValidity();

  // 'timelimit' validator
  final timeLimitControl = form!.control('timelimit');
  if ((getPackOpt?.packmode == 1 ||getPackOpt?.packmode == 4)) {
    timeLimitControl.setValidators([Validators.required]);
  } else {
    timeLimitControl.setValidators([]);
  }
  timeLimitControl.updateValueAndValidity();
 final totLimitController = form!.control('totallimit');
  if ( (getPackOpt?.packmode ?? 0) >= 3 &&
         (getPackOpt?.fupmode ?? -1) == 3) {
    totLimitController.setValidators([Validators.required]);
  } else {
    totLimitController.setValidators([]);
  }
  totLimitController.updateValueAndValidity();

}
  Future<void>  UpdatePackAndValidity(value) async {
   
    final resp = await subscriberSrv.updatePacAndVal(widget.subscriberId,form!.value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }

  List<ResellerPackDet> resellerPack = [];
  Future<void> ResellerPack(int resellerId) async {
    ReseelerPackResp resp = await subscriberSrv.resellerPack(resellerId);
    setState(() {
      if (resp.error) {
        alert(context, resp.msg);
        resellerPack = [];
      } else {
        resellerPack = resp.data ?? [];
      }
    });
GetPack(widget.packid);
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
        form?.control('expiration').value = formattedDate;
      });
    }
  }
}
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
     final notifier = Provider.of<ColorNotifire>(context);
    return ReactiveForm(
      formGroup: form!,
     
      child:  Column(
          children: [
            const SizedBox(height: 15),
           Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Update Pack &\nValidity",
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
                                                                          icon: Icon(
                                                                            Icons
                                                                                .close_rounded,
                                                                                color: notifier.getMainText
                                                                          ),
                                                                        ),
                                                                      ),
                    ],
                  ),
                ),
             
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child:

             ReactiveDropdownField<int>(
                                            focusColor: Colors.transparent,
                                            formControlName: 'packid',
                                            validationMessages: {
  'required': (error) => 
      "Pack required!",
},

                                            isExpanded: true,
                                            items: resellerPack.map((item) {
                                              // Check if widget.updateSubsDet is null
                                              // final isDisabled = widget.updateSubsDet != null;
                                              return DropdownMenuItem<int>(
                                                value: item.packid,
                                                // Set enabled based on the condition
                                                // enabled: !isDisabled,
                                              
                                                child: Text(item.packname),
                                              );
                                            }).toList(),
                                            dropdownColor: notifier.getcontiner,
                                                         style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText: 'Pack Name',
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
                                            onChanged: (value) {
                                              setState(() {
                                                GetPack(form?.value['packid']);
                                              });
                                            },
                                         
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
                                            child: ReactiveTextField(
                                                validationMessages: {
        'required': (error) => 'Inavlid Download Limit..!',
      },
                                              formControlName: 'dllimit',
                                              controller: downLimitController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]')),
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
                               suffixIcon: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedDownMbps++;
                                                          downLimitController
                                                                  .text =
                                                              selectedDownMbps
                                                                  .toString();
                                                        });
                                                      },
                                                      child:  Icon(
                                                        Icons.arrow_drop_up,
                                                         color: notifier.getMainText
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (selectedDownMbps >
                                                            0) {
                                                          setState(() {
                                                            selectedDownMbps--;
                                                            downLimitController
                                                                    .text =
                                                                selectedDownMbps
                                                                    .toString();
                                                          });
                                                        }
                                                      },
                                                      child:  Icon(
                                                        Icons.arrow_drop_down,
                                                        color: notifier.getMainText
                                                      ),
                                                    ),
                                                  ]
                                                                            )
                                                                           )
                                              
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
                                            child: ReactiveTextField(
                                               validationMessages: {
        'required': (error) => 'Inavlid Download Limit..!',
      },
                                              formControlName: 'uplimit',
                                              controller: upLimitController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]')),
                                              ],
                                               style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
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
                                 suffixIcon: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedUpMbps++;
                                                          upLimitController.text =
                                                              selectedUpMbps
                                                                  .toString();
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
                                                            upLimitController
                                                                    .text =
                                                                selectedUpMbps
                                                                    .toString();
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
                                                                           )
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
                                            child: ReactiveTextField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]')),
                                              ],
                                              formControlName: 'totallimit',
                                              controller: totLimitController,
                                               style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
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
                                 suffixIcon: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedTotMbps++;
                                                          totLimitController
                                                                  .text =
                                                              selectedTotMbps
                                                                  .toString();
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
                                                            selectedTotMbps--;
                                                            totLimitController
                                                                    .text =
                                                                selectedTotMbps
                                                                    .toString();
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
                                                                           )
                                              
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
                                            child: ReactiveTextField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]')),
                                              ],
                                              formControlName: 'timelimit',
                                              controller:onlineLimitController,
                                               style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
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
                                 suffixIcon: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedOnlTime++;
                                                          onlineLimitController
                                                                  .text =
                                                              selectedOnlTime
                                                                  .toString();
                                                        });
                                                      },
                                                      child:  Icon(
                                                        Icons.arrow_drop_up,
                                                           color: notifier.getMainText
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (selectedOnlTime > 0) {
                                                          setState(() {
                                                            selectedOnlTime--;
                                                            onlineLimitController
                                                                    .text =
                                                                selectedOnlTime
                                                                    .toString();
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
                                                                           )
                                              
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                           visible: (getPackOpt?.packmode == 1 ||getPackOpt?.packmode == 4),
                                          child: const SizedBox(height: 10)),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Center(
                child: ReactiveTextField<String>(
                                            validationMessages: {
                                              'required': (error) =>
                                                  'Expiration required!',
                                            },
                                            formControlName: 'expiration',
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
                                                  Icons
                                                      .calendar_today, // You can use any icon you prefer
                                                  color: notifier.getMainText
                                                ),
                                              ),
                                              ),
                                          ),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: 
                   ReactiveTextField<int>(
                                            validationMessages: {
                                              'required': (error) =>
                                                  'Simultaneous User is Required!',
                                            },
                                            formControlName: 'simultaneoususe',
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
                                                                            )
                                          ),
            
            ),
              const SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.symmetric(
                horizontal: 20,),
              child: ReactiveTextField<String>(
                   validationMessages: {
                                              'required': (error) =>
                                                  'Remarks Required!',
                                            },
                        maxLines: 3,
                          formControlName: 'remarks',
                            style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                          contentPadding: const EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 10),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText: 'Remark',
                                                                            enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black)),
                          border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black)),
              
                                         
                                                                            ),
                           
                         
                        ),
            ),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.bottomRight,
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                   backgroundColor: appMainColor
                  ),
                  onPressed: () async {
  setState(() {
    _isSubmitted = true;
  });

  if (form!.invalid) {
    // Show validation errors
    form!.markAllAsTouched(); // Mark all fields as touched to trigger error display
    return;
  }

  // Proceed with form submission
  await UpdatePackAndValidity(form!.value);
},

                  child: const Text('Update', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                ),
              ),

            ),
          ],
        ),
      
    );
  }
}
