import 'dart:core';

import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Providers/providercolors.dart';

import 'package:crm/model/subscriber.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:reactive_forms/reactive_forms.dart';
import '../../../service/subscriber.dart' as subscriberSrv;

class InvoicePaymentStatus extends StatefulWidget {
  int invoiceId;
  dynamic totAmt;
  

  InvoicePaymentStatus(
      {Key? key,
     required this.invoiceId,
     required this.totAmt,
      })
      : super(key: key);
  @override
  State<InvoicePaymentStatus> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<InvoicePaymentStatus> {

  FormGroup? form;

  void initializeForm() {
    form = FormGroup({
      'collectedid': FormControl<int>(),
      'invid': FormControl<int>(value: widget.invoiceId,   validators: [Validators.required]),
      'note': FormControl<String>(),
      'pay_status': FormControl<int>(validators: [Validators.required]),
      'pay_type': FormControl<int>(validators: [Validators.required]),
      'paydate': FormControl<String>(validators: [Validators.required]),
       'userpayedamt': FormControl<int>(value: widget.totAmt, validators: [Validators.required]),
      
    });
  }
   bool _isMounted = false;

   List<EmployeeList> getEmployeeList = [];

Future<void> GetEmployeeList() async {
  EmployeeListResp resp = await subscriberSrv.GetEmpList();
  if (!_isMounted) return;
  setState(() {
    if (resp.error) {
      alert(context, resp.msg);
    } else {
      getEmployeeList = resp.data ?? [];
    }
  });
}
Map<String, int> pay_status = {
    'Unpaid': 1,
    'Paid': 2,
  };
 Map<String, int> paymentMode = {
  'User Paid(Cash)': 0,
  'From Reseller Side User Balance': 1,
  'User Wallet': 2,
  'User paid by Demand Pay': 3,
  'User Paid(Online)': 4,
  'User Paid(Cheque)': 5,
  'User Paid(Internet Banking)': 6,
  'User Paid(Other)': 999,
};

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

@override
  void initState() {
    super.initState();
    GetEmployeeList();
    initializeForm();
    _isMounted = true;
     print(widget.invoiceId);
    print(widget.totAmt);
   
    

  }
   Future<void> UpdatePaySt(int invid,value) async {
    final resp = await subscriberSrv.updatePaySts(invid, value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }
  @override
  Widget build(BuildContext context) {
      notifire = Provider.of<ColorNotifire>(context, listen:true);
       final notifier = Provider.of<ColorNotifire>(context);
     double screenWidth = MediaQuery.of(context).size.width;
    return   Scaffold(
        // key: _scaffoldKey ,
              // drawer: DarwerCode(),
               backgroundColor: notifier.getbgcolor,
      body: Padding(
                                                  padding:  EdgeInsets.all(8.0),
                                                  child:ReactiveForm(
                                                    formGroup: form!,
                                                    child: SingleChildScrollView(
                                                      child: Column(children: [
                                                        const SizedBox(height: 15),
                                                                 Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "Invoice Payment",
                                                                              style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.05,),
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
                                                      
                                                        Padding(
                                                         padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                          child: ReactiveDropdownField<
                                                                    int>(
                                                              formControlName:
                                                                  'pay_status',
                                                           
                                                                                        
                                                                                         style: TextStyle(color: notifier.getMainText),
                                                                              dropdownColor: notifier.getcontiner,
                                                                           
                                                                             decoration: InputDecoration(
                                                                               contentPadding: EdgeInsets.only(left: 15),
                                                                  
                                                                                hintStyle: mediumGreyTextStyle.copyWith(
                                                                                                fontSize: 13),
                                                                                hintText: 'Payment Status',
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
                                                          
                                                              isExpanded: true,
                                                              items: pay_status.keys.map<
                                                                  DropdownMenuItem<
                                                                      int>>(
                                                                (String key) {
                                                                  final value =
                                                                      pay_status[key];
                                                                  return DropdownMenuItem<
                                                                      int>(
                                                                    value: value,
                                                                    child: Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                              left:
                                                                                  10),
                                                                      child:
                                                                          Text(key),
                                                                    ),
                                                                  );
                                                                },
                                                              ).toList(),
                                                            
                                                            ),
                                                        ),
                                                          const SizedBox(height: 10),
                                                          Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                                              child:ReactiveTextField<int>(
                                                                                formControlName: 'userpayedamt',
                                                                                
                                                                                         style: TextStyle(color: notifier.getMainText),
                                                                            
                                                                           
                                                                             decoration: InputDecoration(
                                                                               contentPadding:const EdgeInsets.only(left: 15),
                                                                  
                                                                                hintStyle: mediumGreyTextStyle.copyWith(
                                                                                                fontSize: 13),
                                                                                hintText: 'Amount',
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
                                                                            const SizedBox(height:10),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                                              child:ReactiveTextField<String>(
                                                                                formControlName: 'paydate',
                                                                                readOnly: true,
                                                                                
                                                                                         style: TextStyle(color: notifier.getMainText),
                                                                            
                                                                           
                                                                             decoration: InputDecoration(
                                                                               
                                                                  
                                                                                hintStyle: mediumGreyTextStyle.copyWith(
                                                                                                fontSize: 13),
                                                                                hintText: 'Payment Date',
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
                                                                    contentPadding: const EdgeInsets.only(left: 15),
                                                                                    suffixIcon: GestureDetector(
                                                                                    onTap: () =>_selectDate(context),
                                                                                    child:Icon(
                                                                                      Icons.calendar_today,  // You can use any icon you prefer
                                                                                      color:notifier.geticoncolor,
                                                                                    ),
                                                                                  ),
                                                                              ),
                                                                                 
                                                                              ),
                                                                            ),
                                                                           
                                                                            const SizedBox(height: 10),
                                                                            Padding(
                                                         padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                          child: ReactiveDropdownField<
                                                                    int>(
                                                              formControlName:
                                                                  'pay_type',
                                                           
                                                                                        
                                                                                         
                                                          
                                                              isExpanded: true,
                                                              items: paymentMode.keys.map<
                                                                  DropdownMenuItem<
                                                                      int>>(
                                                                (String key) {
                                                                  final value =
                                                                      paymentMode[key];
                                                                  return DropdownMenuItem<
                                                                      int>(
                                                                    value: value,
                                                                    child: Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                              left:
                                                                                  10),
                                                                      child:
                                                                          Text(key),
                                                                    ),
                                                                  );
                                                                },
                                                              ).toList(),
                                                                dropdownColor: notifier.getcontiner,
                                                           style: TextStyle(color: notifier.getMainText),
                                                                            
                                                                           
                                                                             decoration: InputDecoration(
                                                                               contentPadding:const EdgeInsets.only(left: 15),
                                                                  
                                                                                hintStyle: mediumGreyTextStyle.copyWith(
                                                                                                fontSize: 13),
                                                                                hintText: 'Payment Mode',
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
                                                         padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                          child: ReactiveDropdownField<
                                                                    int>(
                                                              formControlName:
                                                                  'collectedid',
                                                           
                                                                                        
                                                                                        
                                                          
                                                              isExpanded: true,
                                                               items: getEmployeeList.map((item) {
                                                                                return DropdownMenuItem<int>(
                                                                                  value: item!.id,
                                                                                  child: Text(item.profileId),
                                                                                );
                                                                              }).toList(),
                                                                                 dropdownColor: notifier.getcontiner,
                                                           style: TextStyle(color: notifier.getMainText),
                                                                            
                                                                           
                                                                             decoration: InputDecoration(
                                                                               contentPadding:const EdgeInsets.only(left: 15),
                                                                  
                                                                                hintStyle: mediumGreyTextStyle.copyWith(
                                                                                                fontSize: 13),
                                                                                hintText: 'Amount Collected By',
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
                                                                                                    horizontal: 20.0),
                                                                                                child: ReactiveTextField<String>(
                                                                                                   keyboardType: TextInputType.multiline,
                                                                      textInputAction: TextInputAction.newline,
                                                                      maxLines: 3,
                                                                                                  formControlName: 'note',
                                                                                                   
                                                           style: TextStyle(color: notifier.getMainText),
                                                                            
                                                                           
                                                                             decoration: InputDecoration(
                                                                               hintText: "Notes",
                                                                                  hintStyle: mediumGreyTextStyle,
                                                                                   contentPadding:const EdgeInsets.only(left: 10,top:10,right: 10,bottom: 10),
                                                                  
                                                                            
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
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Align(
                                                                              alignment: Alignment.bottomRight,
                                                                              child: ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(backgroundColor: appMainColor),
                                                                                child: const Text(
                                                                                  'Submit',
                                                                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                                                                ),
                                                                                onPressed: () async {
                                                                                  if (form!.valid) {
                                                      
                                                      
                                                      UpdatePaySt(widget .invoiceId,form!.value);
                                                      
                                                                                  } else {
                                                                                    form!.markAllAsTouched();
                                                                                     
                                                                                  }
                                                                                 
                                                                                  
                                                                                
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),         
                                                      
                                                      
                                                      
                                                      
                                                      ],),
                                                    ))
                                                ),
    );
  }
  String formattedDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now());
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        form?.control('paydate').value = formattedDate;
      });
    }
  }
}