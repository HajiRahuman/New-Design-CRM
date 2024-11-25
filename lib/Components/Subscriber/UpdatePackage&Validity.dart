import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/model/subscriber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:intl/intl.dart';
import 'dart:core';

import 'package:provider/provider.dart';

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
    ResellerPack(widget.resellerid);
  }


  Future<void>  UpdatePackAndValidity(int subscriberId, {required UpdatePacandVal updatePackAndValidity}) async {
    final reqData = {
      'packid': updatePackAndValidity.packid,
      'expiration':  updatePackAndValidity.expiration,
      'simultaneoususe': updatePackAndValidity.simultaneoususe,
    };

    final resp = await subscriberSrv.updatePacAndVal(subscriberId, reqData);

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

  }

  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != formattedDate) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(picked);
        dateController.text = formattedDate;
      });
    }
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

              DropdownButtonFormField<int>(
              
                isExpanded: true,
                value: widget.packid,
                onChanged: (newValue) {
                  setState(() {
                    selectedValue1 = newValue!;
                  });
                },
                items: resellerPack.map((item) {
                  return DropdownMenuItem<int>(
                    value: item.packid,
                    child: Text(item.packname),
                  );
                }).toList(),

                dropdownColor: notifier.getcontiner,
                                                         style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                            suffixIconColor: notifier.getMainText,
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
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Center(
                child: TextFormField(
                  controller: dateController,
                  readOnly: true,
                  
                                                         style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              hintStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                             hintText: widget.expiration,
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
                                           suffixIcon: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Icon(
                        Icons.calendar_today,  // You can use any icon you prefer
                        color: notifier.getMainText
                      ),
                    ),
                                                                            ),
                 
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty) {
                      return 'Date is required';
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Center(
                child:
                  TextFormField(
                    controller: simulUserController,
               // controller: dateController,
              readOnly: true,
              
                                                         style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                             hintStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                             hintText:'${widget.simultaneoususe}',
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
                                          suffixIconColor: notifier.getMainText,
                                          suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedNumber++;
                          simulUserController.text = selectedNumber.toString();
                        });
                      },
                      child:  Icon(
                        Icons.arrow_drop_up,
                       color: notifier.getMainText,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (selectedNumber > 0) {
                          setState(() {
                            selectedNumber--;
                            simulUserController.text = selectedNumber.toString();
                          });
                        }
                      },
                      child:  Icon(
                        Icons.arrow_drop_down,
                  color: notifier.getMainText,
                      ),
                    ),
                  ]
                                                                            ),
                                                                           ),
              

            validator: (value) {
        if (value == null ||
            value.isEmpty) {
          return 'Choose Simultaneous User';
        }
            }
            )
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
                    if (_formKey.currentState?.validate() ?? false) {
                      UpdatePacandVal updatePackAndValidity = UpdatePacandVal(
                        packid: selectedValue1,
                        expiration: formattedDate,
                        simultaneoususe: simulUserController.text,
                      );

                      await UpdatePackAndValidity(widget.subscriberId, updatePackAndValidity: updatePackAndValidity);
                    }
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
