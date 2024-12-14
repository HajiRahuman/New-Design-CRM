import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/model/reseller.dart';
import 'package:crm/model/subscriber.dart';
import 'package:crm/service/Payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:crm/service/reseller.dart' as resellerSrv;
import 'package:shared_preferences/shared_preferences.dart';


class SubscriberRenewal extends StatefulWidget {
  ResellarDet? resellerDet;
   int? resellerid;
   int? uid;
   int? srvusermode;
   int? packid;
   int? subscriberId;
   String? expiration;
   int? voiceid;


  SubscriberRenewal({this.resellerid, this.uid, this.srvusermode, this.packid,this.subscriberId, this.expiration,this.voiceid,});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<SubscriberRenewal> {
  String dropdownvalue = 'Item 1';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String packNameOpt = 'UL 20 MB';
  String BroadBandPlanOpt = '30 Days';
  String ottPlanOpt = 'Test0001';
   int? expiryMode;
   int? voice;
   int? ott;
   bool? voiceValidityMode;



  Map<String, int> paymentStsOpt = {
    'Unpaid': 1,
    'Paid': 2,
  };
  int selectedAmount = 0;
  late FormGroup form;
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
  void initializeForm() {
    form = FormGroup({
      'uid': FormControl<int>(value: widget.uid),
      'resellerid': FormControl<int>(value: widget.resellerid),
      'packid': FormControl<int>(value: widget.packid, validators: [Validators.required]),
      'ottpackid': FormControl<int>(),
      'coupon_code': FormControl<String>(),
      'priceid': FormControl<int>(validators: [Validators.required]),
      'renewal_through': FormControl<int>(),
      'userpayedamt': FormControl<int>(),
      'schedule_dt': FormControl<String>(value: widget.expiration,),
      'paydate': FormControl<String>(),
      'comment1': FormControl<String>(),
      'pay_status': FormControl<int>(),
      'pay_type': FormControl<int>(),
      'vpackid': FormControl<int>(validators: [Validators.required]),
    });
  }

  List<GetRenewalPackDet> renewPack = [];
  Future<void> GetRenewalPack(int subscriberID) async {
    GetRenewalPackResp resp = await subscriberSrv.getRenewPak(widget.resellerid!,widget.uid!, widget.srvusermode!);
    setState(() {
      if (resp.error) {
        alert(context, resp.msg);
        renewPack = [];
      } else {
        renewPack = resp.data ?? [];

      }
    });
     GetRenewalPrice(widget.resellerid!);

  }

  List<GetRenewalOttDet> renewOtt = [];
  Future<void> GetRenewalOtt(int subscriberID) async {
    GetRenewalOttResp resp = await subscriberSrv.getRenewOtt(widget.resellerid!);
    setState(() {
      if (resp.error) {
        alert(context, resp.msg);
        renewOtt  = [];
      } else {
        renewOtt  = resp.data ?? [];

      }
    });

  }

  List<GetRenewalPriceDet> renewPrice = [];
  Future<void> GetRenewalPrice(int  resellerId) async {
    int resellerId = widget.resellerid!;
    int packId = int.parse(form.value['packid'].toString());
    var packDet = renewPack.firstWhere((val) => val.packid == packId);
    // print('pack-- $packDet');
    this.expiryMode = packDet.expreset ?? 0;
    // GetRenewalPriceResp resp = await subscriberSrv.getRenewPrice({resellerId, packId,expiration:this.expiration,expreset:packDet.expreset});
GetRenewalPriceResp resp = await subscriberSrv.getRenewPrice(
  resellerId,
  packId,
  widget.expiration ?? '',
  packDet.expreset
);

    setState(() {
      if (resp.error) {
        alert(context, resp.msg);
        renewPrice  = [];
      } else {
        renewPrice = resp.data ?? [];

      }
    });

  }

  
  List<GetRenewalPriceDet> voiceList = [];
  Future<void> getVoice(id) async {
    //  print('id--$id');
GetRenewalPriceResp resp = await subscriberSrv.getRenewalVoice(
  id,
  widget.expiration ?? ''
 );
// print('resp---$resp');
    setState(() {
      if (resp.error) {
        alert(context, resp.msg);
        voiceList  = [];
      } else {
        voiceList = resp.data ?? [];

      }
    });
    // print('voice-- $voiceList');

  }
  void initState() {
   super.initState();
    razorpay = new Razorpay();
    GetRenewalPack(widget.uid!);
    // GetRenewalOtt(widget.uid!);
    getReseller(widget.resellerid);
        getVoice(widget.resellerid);
    initializeForm();
    getMenuAccess();
    //  print('resellerid-- ${widget.resellerid}');
    //     print('uid-- ${widget.uid}');
    //        print('srvusermode-- ${widget.srvusermode}');
    //           print('packid-- ${widget.packid}');
    //              print('subsid-- ${widget.subscriberId}');
    //                 print('expiration-- ${widget.expiration}');
    //                    print('voiceid-- ${widget.voiceid}');

  }
  int levelid = 0;
  bool isIspAdmin = false;
  int id=0;
  bool isSubscriber=false;
  getMenuAccess() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    levelid = pref.getInt('level_id') as int;
    isIspAdmin = pref.getBool('isIspAdmin') as bool;
    id = pref.getInt('id') as int;
    isSubscriber = pref.getBool('isSubscriber') as bool;
  
    resellerOpts = isSubscriber
      ? {
          'Subscriber Online Renewal': 3,
          'Subscriber Online Schedule': 4,
        }
      : {
          'Reseller Renewal': 1,
          'Reseller Schedule': 2,
        };
       
    
  }

  getReseller(id) async {
    final user = await resellerSrv.fetchResellerDetail(id);
  if(!user.error) widget.resellerDet =user.data ;
  // print('resellerssssssssssss-- ${resellerDet}');
  voice = widget.resellerDet?.voiceType;
  // print('Voice---${voice}');
  ott = widget.resellerDet?.ottType;
  voiceValidityMode = widget.resellerDet?.settings.voiceExpDefer;
  }
late Razorpay razorpay;

  Future<void> SubscriberRenewal(Map<String, dynamic> value) async {
    await PaymentService(razorpay: this.razorpay).Subpayment(value);
    // await PaymentService(razorpay: this.razorpay).orderStatus(value);
  }  

  // Future<void> SubscriberRenewal() async {
  //   final resp = await subscriberSrv.renewalSubscriber(form.value);
  //   if (resp['error'] == false) {
  //     alert(context, resp['msg'], resp['error']);
  //     Navigator.pop(context, true);
  //   }
  // }

 Future<void> ResellerSubscriberRenewal() async {
    final resp = await subscriberSrv.resellerRenewalSubs(form.value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }

  late double bbprice=0.0;
  late int bbtaxmode=0;
  late int Iunittype=0;
  late int Itimeunit=0;
  late int Iextradays =0;
  String packValidity = '';
  double bbpaidtax = 0;
  double bbpaidamount = 0;
  double toPayAmount = 0;
  double? totalAmount;
  double? totalTax;
  bool itemSelected = false;
  int expMode = 0;
  void getPriceInfo() {
    final filteredPrice = this.renewPrice.firstWhere(
          (item) => this.form.value['priceid'] == item.id);

    final price = filteredPrice.price;
    final taxmode = filteredPrice.taxmode;
    final validity = filteredPrice.validity;
    final unittype = filteredPrice.unittype;
    final timeunit = filteredPrice.timeunit;
    final extradays = filteredPrice.extradays;
    this.packValidity = validity;
    // this.packValidity = this.expMode != 0
    //     ? this.calculateValidityOnExpiryMode(validity)
    //     : validity;

    this.bbprice = price;
    this.bbtaxmode = taxmode;
    this.Iunittype = unittype;
    this.Itimeunit = timeunit;
    this.Iextradays = extradays;
    // print('validity----${validity}');
    }

     late double voprice=0.0;
  late int votaxmode=0;
  late int Vunittype=0;
  late int Vtimeunit=0;
  late int Vextradays =0;
  String voiceValidity = '';
  double vopaidtax = 0;
  double vopaidamount = 0;
  bool voiceitemSelected = false;
 
  void getVoiceInfo() {
    final filteredPrice = this.voiceList.firstWhere(
          (item) => this.form.value['vpackid'] == item.id);

    final price = filteredPrice.price;
    final taxmode = filteredPrice.taxmode;
    final validity = filteredPrice.validity;
    final unittype = filteredPrice.unittype;
    final timeunit = filteredPrice.timeunit;
    final extradays = filteredPrice.extradays;
    voiceValidity = validity;
    // this.packValidity = this.expMode != 0
    //     ? this.calculateValidityOnExpiryMode(validity)
    //     : validity;

    voprice = price;
    votaxmode = taxmode;
    Vunittype = unittype;
    Vtimeunit = timeunit;
    Vextradays = extradays;
    // print('validity----${validity}');
    }


  DateTime? schedulePackValidity, scheduleVoiceValidity;
  void calculateScheduleValidityDate() {


    if ([2,4].contains(form.value['renewal_through'])) {
      schedulePackValidity =  DateTime.parse(form.value['schedule_dt'] as String);
      schedulePackValidity = addDaysOrMonths(
        schedulePackValidity!,
        Iunittype,
        Itimeunit,
        Iextradays,
      );
// print('schedulepavali---${schedulePackValidity}');
    }
  }


  DateTime addDaysOrMonths(
      DateTime validity,
      int unittype,
      int timeunit,
      int extradays,
      ) {
    if (unittype == 0) {
      // Days
      final daysToAdd = timeunit + extradays;
      validity = validity.add(Duration(days: daysToAdd));
    }
    if (unittype == 1) {
      // Months
      final daysToAdd = extradays;
      final monthsToAdd = timeunit;
      validity = DateTime(validity.year, validity.month + monthsToAdd, validity.day);
      if (daysToAdd != 0) {
        validity = validity.add(Duration(days: daysToAdd));
        print('Validiyy----$validity');
      }
    }
    return validity;
  }
// Constants
   List<Map<String, dynamic>> taxMode = [
    {
      'id': 0,
      'label': 'Inclusive',
    },
    {
      'id': 1,
      'label': 'Exclusive',
    },
  ];

   List<Map<String, dynamic>> timeUnit = [
    {
      'id': 0,
      'label': 'Day',
    },
    {
      'id': 1,
      'label': 'Month',
    },
  ];
// Tax Calculation Function
  double tax(double taxPercentage, double amount, int taxMode) {
    double taxAmt = 0;
    if (taxMode == 0) {
    
      taxAmt = (amount * taxPercentage) / (100 + taxPercentage);
        } else {
      taxAmt = (amount / 100) * taxPercentage;
    }
  
    return taxAmt;
  }
  
// Function to Get Tax-Based Price
  double getTaxBasedPrice(int taxMode, double amount, double tax) {
    double total = 0;
    if (taxMode == 0) {
      total = amount - tax;
    } else {
      total = amount;
    }
    return total;
  }

  // Flutter Methods
  void clearPay() {
    form.control('pay_status').value=1;
    // ctrl.userpayedamt.setValue(null);
    form.control('paydate').value='';
    // paymentValidation();
  }

  void setInternetAmount() {
    bbpaidamount = 0;
    bbpaidtax = 0;
    bbpaidtax = double.parse(
        tax(18, bbprice, bbtaxmode).toStringAsFixed(3)
    );
    bbpaidamount = double.parse(
        getTaxBasedPrice(
            bbtaxmode,
            bbprice,
            bbpaidtax
        ).toStringAsFixed(3)
    );
    //  totalAmount = bbpaidamount + bbpaidtax;
    // print('Internet====$bbpaidamount');
    // print('Tax2====$bbpaidtax');
    // print('Total Amount====$totalAmount');
  setPaidAmount();
  }

  void setVoiceAmount() {
    vopaidamount = 0;
    vopaidtax = 0;
    vopaidtax = double.parse(
        tax(18, voprice, votaxmode).toStringAsFixed(3)
    );
    vopaidamount = double.parse(
        getTaxBasedPrice(
            votaxmode,
            voprice,
            vopaidtax
        ).toStringAsFixed(3)
    );
    setPaidAmount();

  }

 



  void setPaidAmount() {
    form.control('userpayedamt').value=null;
    totalAmount = bbpaidamount + (vopaidamount ?? 0);
    totalTax = bbpaidtax + (vopaidtax ?? 0);
    toPayAmount = (totalAmount ?? 0) + (totalTax ?? 0);
    if (form.value['pay_status']== 2) {
     form.control('userpayedamt').value = toPayAmount.toInt(); // Cast to int
      // print('Grand Total2====$toPayAmount');
    }
  }
  bool showSheduleDate = false;
  bool showValidity=true;

  @override
  Widget build(BuildContext context) {
     final notifier = Provider.of<ColorNotifire>(context);
     final screenWidth = MediaQuery.of(context).size.width;
    return ReactiveForm(
      formGroup: form,
      child: Container(
            decoration:  BoxDecoration(
              color: notifier.getbgcolor
              // borderRadius: BorderRadius.circular(10)
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  verticalDirection: VerticalDirection.down,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                           Text(
                                "Renewal",
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
                      
                    ),
                    const SizedBox(height: 20),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:ReactiveDropdownField<int>(
                        formControlName: 'packid', // Provide a unique form control name
                        items: renewPack.map((item) {
                          return DropdownMenuItem<int>(
                            value: item.packid,
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
                        
                       onChanged: (newValue) {
                          setState(() {
                            GetRenewalPrice(widget.resellerid!);

                          });
                        },
                      ),
                    ),
                  
                    const SizedBox(height: 10),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ReactiveDropdownField<int>(
                        formControlName: 'priceid',
                       
                        isExpanded: true,
                        // controller: resellerDropdownController,
                        onChanged: (newValue) {
                          setState(() {
                            getPriceInfo();
                            clearPay();
                            setInternetAmount();
                            itemSelected = true;
                          });
                        },
                        items: renewPrice.map((item) {
                          return DropdownMenuItem<int>(
                            value: item.id,
                            child: Text(item.pname),
                          );
                        }).toList(),
                         dropdownColor: notifier.getcontiner,
                                                       style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                             labelText: 'Broadband Plan',
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
                     const SizedBox(height: 10),
                        Visibility(
                      visible: voice !=-1 && widget.voiceid !=0,
                   child : Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ReactiveDropdownField<int>(
                        formControlName: 'vpackid',
                       
                        isExpanded: true,
                        // controller: resellerDropdownController,
                        onChanged: (newValue) {
                          setState(() {
                            getVoiceInfo();
                            clearPay();
                            setVoiceAmount();
                            voiceitemSelected = !voiceitemSelected;
                          });
                        },
                        items: voiceList.map((item) {
                          return DropdownMenuItem<int>(
                            value: item.id,
                            child: Text(item.pname),
                          );
                        }).toList(),
                          dropdownColor: notifier.getcontiner,
                                                       style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                             labelText: 'Voice Plan',
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
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child:ReactiveDropdownField<int>(
                        formControlName: 'renewal_through',
                       
                        isExpanded: true,
                        items: resellerOpts.keys.map<DropdownMenuItem<int>>(
                              (String key) {
                            final value=resellerOpts[key];
                            return DropdownMenuItem<int>(
                              value: value,
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
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                             labelText: 'Reseller Type',
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
                         onChanged: (value) {
    setState(() {
      if (form.value['renewal_through'] == 1 || form.value['renewal_through']  == 3) {
        // If "Subscriber Online Renewal" or "Subscriber Online Schedule" is selected, show validity
        showSheduleDate = false;
        showValidity=true;
      } else if (form.value['renewal_through']  == 2 || form.value['renewal_through']  == 4) {
        // If "Reseller Renewal" or "Reseller Schedule" is selected, handle accordingly
        showSheduleDate = true;
        showValidity=false;
      }
      calculateScheduleValidityDate();
    });
  },
                        // onChanged: (value) {
                        //   setState(() {
                        //     if (form.value['renewal_through'] == 3) {
                        //       // If "Reseller Renewal" is selected, hide the validity text
                        //       showValidity = true;
                        //     } else if (form.value['renewal_through'] == 4){
                        //       // Otherwise, show the validity text
                        //       showValidity = false;

                        //     }
                        //     calculateScheduleValidityDate();
                        //   });
                        // },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: showSheduleDate,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child:ReactiveTextField<String>(
                          formControlName: 'schedule_dt',
                            
                                                       style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                             labelText: 'Schedule Date',
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
                                        suffixIcon: GestureDetector(
                              onTap: () {
                                _selectDate(context, 'schedule_dt');
                              },
                              child:  Icon(
                                Icons.calendar_today,
                                color: notifier.getMainText
                              ),
                            ),
                                                                          ),
                        
                         
                          // onChanged: (_){
                          //   print('Checking');
                          //   calculateScheduleValidityDate();
                          // },
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10),
                    //
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //   child:ReactiveTextField<String>(
                    //     formControlName: 'coupon_code',
                    //     controller: dateController,
                    //     readOnly: true,
                    //     decoration: InputDecoration(
                    //       labelText: 'Add Coupon Code',
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //         borderSide: const BorderSide(
                    //           color: AppColors.userDetailsBackgroundColor,
                    //         ),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //         borderSide: const BorderSide(
                    //           width: 2.0,
                    //           color: AppColors.userDetailsBackgroundColor,
                    //         ),
                    //       ),
                    //       contentPadding: const EdgeInsets.only(left: 10),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child:ReactiveDropdownField<int>(
                    //     formControlName: 'ottpackid', // Provide a unique form control name
                    //     items: renewOtt.map((item) {
                    //       return DropdownMenuItem<int>(
                    //         value: item.ottId,
                    //         child: Text(item.planName),
                    //       );
                    //     }).toList(),
                    //     dropdownColor: notifier.getcontiner,
                    //                                    style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                    //                                                      decoration: InputDecoration(
                    //                                                        contentPadding:const EdgeInsets.only(left: 15),
                                                              
                    //                                                         labelStyle: mediumGreyTextStyle.copyWith(
                    //                       fontSize: 13),
                    //                                                          labelText: 'OTT Plan',
                    //                                                       enabledBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(10),
                    //             borderSide: BorderSide(
                    //                 color: notifier.isDark
                    //                     ? notifier.geticoncolor
                    //                     : Colors.black)),
                    //     border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(10),
                    //             borderSide: BorderSide(
                    //                 color: notifier.isDark
                    //                     ? notifier.geticoncolor
                    //                     : Colors.black)),
                    //                                                       ),
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible:isSubscriber==false,
                      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                        child:ReactiveDropdownField<int>(
                          formControlName: 'pay_status', // Provide a unique form control name
                          items: paymentStsOpt.keys.map<DropdownMenuItem<int>>(
                                (String key) {
                              final newValue=paymentStsOpt[key];
                              return DropdownMenuItem<int>(
                                value: newValue,
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
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText: 'Payment Status',
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
                          onChanged: (_){
                            setState(() {
                              setPaidAmount();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: form.value['pay_status'] == paymentStsOpt['Paid'],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ReactiveTextField<int>(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          formControlName: 'userpayedamt',
                          
                                                       style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                             labelText: 'Amount',
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
                                        suffixIconColor:  notifier.getMainText,

suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children:[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAmount++;
                                      form.control('userpayedamt').value = selectedAmount.toString();
                                    });
                                  },
                                  child:Icon(
                                    Icons.arrow_drop_up,
                                        color: notifier.getMainText
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (selectedAmount > 0) {
                                      setState(() {
                                        selectedAmount--;
                                        form.control('userpayedamt').value = selectedAmount.toString();
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
                      visible: form.value['pay_status'] == paymentStsOpt['Paid'],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child:ReactiveDropdownField<
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
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: form.value['pay_status'] == paymentStsOpt['Paid'],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child:ReactiveTextField<String>(
                          formControlName: 'paydate',
                          readOnly: true,
                         
                                                       style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:const EdgeInsets.only(left: 15),
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                                                             labelText: 'Payment date',
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

                                         suffixIcon: GestureDetector(
                              onTap: () => _selectDate(context, 'paydate'),
                              child: Icon(
                                Icons.calendar_today,  // You can use any icon you prefer
                                color:notifier.getMainText
                              ),
                            ),
                                                                          ),
                         
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child:ReactiveTextField<String>(
                      maxLines: 3,
                        formControlName: 'comment1',
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
                  
        
                    const SizedBox(height: 15),
                    if (itemSelected)
                 
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: TextStyle(
              color: notifier.getMainText,
              fontWeight: FontWeight.w700,
              fontSize: screenWidth * 0.04,
            ),
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: showValidity,
            child: _buildTableRow("VALIDITY", DateFormat.yMMMMd('en_US').add_jm().format(DateTime.parse(packValidity).toLocal()),screenWidth),
          ),
          if ([2, 4].contains(form.value['renewal_through'])) ...[
        const SizedBox(height: 10),
        _buildTableRow(
          "VALIDITY : ",
          schedulePackValidity != null
              ? DateFormat.yMMMMd('en_US').add_jm().format(schedulePackValidity!.toLocal())
              : "Not available",
          screenWidth,
        ),
      ],
          const SizedBox(height: 10),
          _buildTableRow("TOTAL AMOUNT", "₹ $totalAmount", screenWidth),
          const SizedBox(height: 10),
          _buildTableRow("TAX", "₹ $totalTax", screenWidth),
          const SizedBox(height: 10),
          _buildTableRow("TAXABLE AMOUNT", "₹ $toPayAmount", screenWidth),
          const SizedBox(height: 10),
        ],
      ),
    ),

                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                           backgroundColor: appMainColor
                            ),
                          
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                          onPressed: () async {
                            if (form.valid) {} else {
                              form.markAllAsTouched();
                               
                            }
                           if (isSubscriber) {
                             final value = {
                          ...form.value
                        };
                               await SubscriberRenewal(value);
                            } else {
                              await ResellerSubscriberRenewal();
                              }
                            
                          
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
    );
  }
  late Map<String, int> resellerOpts = {};


// Helper function to create a table row with title and subtitle
Widget _buildTableRow(String title, String subtitle, double screenWidth) {
final notifier = Provider.of<ColorNotifire>(context);
  return Table(
    border: TableBorder.all(borderRadius: BorderRadius.circular(10),color: notifier.getMainText ),
    columnWidths: const {
      0: FlexColumnWidth(2),  // Adjust the width ratios as needed
      1: FlexColumnWidth(3),
    },
    children: [
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
             style: mediumGreyTextStyle.copyWith(fontWeight: FontWeight.bold)
             
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
             style: mediumBlackTextStyle.copyWith(color: notifier.getMainText,fontWeight: FontWeight.bold)
            ),
          ),
        ],
      ),
    ],
  );
}


  String formattedDateschedule_dt = '';
  String formattedDatepaydate = '';
   Future<void> _selectDate(BuildContext context, String field) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        ).toLocal();
        
        String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(fullDateTime);
        
        setState(() {
          if (field == 'schedule_dt') {
            formattedDateschedule_dt = formattedDate;
            form.control('schedule_dt').value = formattedDateschedule_dt;
          } else if (field == 'paydate') {
            formattedDatepaydate = formattedDate;
            form.control('paydate').value = formattedDatepaydate;
          }
          calculateScheduleValidityDate();
        });
      }
    }
  }

}
