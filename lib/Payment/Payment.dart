import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/service/Payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Payment extends StatefulWidget {
  @override
  State<Payment> createState() => _MainScreenState();
}

class _MainScreenState extends State<Payment> {
  TextEditingController amountController = TextEditingController();

  final form = FormGroup({
    'online_amount': FormControl<int>(value: 1000, validators: [Validators.required]),
    'deposit_note': FormControl<String>(validators: [Validators.required]),
    'user_role': FormControl<int>(validators: [Validators.required]),
    'userid': FormControl<int>(validators: [Validators.required]),
  });


  getIdLevelID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    levelid = pref.getInt('level_id') as int;
    id = pref.getInt('id') as int;
    print('LevelId--$levelid');
    print('ID--$id');
  }

  int levelid = 0;
  bool isIspAdmin = false;
  int id = 0;
  int selectedAmount = 0;
  late Razorpay razorpay;

  @override
  void initState() {
    super.initState();
    razorpay = new Razorpay();
    getIdLevelID();
  }

  Future<void> WalletAmount(Map<String, dynamic> value) async {
    await PaymentService(razorpay: this.razorpay).payment(value);
    // await PaymentService(razorpay: this.razorpay).orderStatus(value);
  }

  @override
  Widget build(BuildContext context) {
      final notifier = Provider.of<ColorNotifire>(context);
       double screenWidth = MediaQuery.of(context).size.width;
    return ReactiveForm(
      formGroup: form,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
           Text(
                ' Wallet Recharge',
               style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.04,),
                                ),
            
              const SizedBox(height: 20),
              ReactiveTextField<int>(
                keyboardType: const TextInputType.numberWithOptions(),
                formControlName: 'online_amount',
                controller: amountController,
                  style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText: 'Amount',
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
                            selectedAmount++;
                            amountController.text = selectedAmount.toString();
                          });
                        },
                        child:Icon(
                          Icons.arrow_drop_up,
                          color: notifier.getMainText,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (selectedAmount > 0) {
                            setState(() {
                              selectedAmount--;
                              amountController.text = selectedAmount.toString();
                            });
                          }
                        },
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: notifier.getMainText,
                        ),
                      ),
                    ],
                  ),
                                                                            ),
               
              ),
              const SizedBox(height: 10),
              ReactiveTextField<String>(
                maxLines: 2,
                validationMessages: {
                  'required': (error) => 'Note Required!',
                },
                formControlName: 'deposit_note',
                // controller:  blockController,
                 style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                            contentPadding: const EdgeInsets.only(
                      left: 10, top: 8, right: 10, bottom: 8),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText: 'Note',
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
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                     style: ElevatedButton.styleFrom(backgroundColor: appMainColor),
                      onPressed: () {
                        Navigator.of(context).pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                     style: ElevatedButton.styleFrom(backgroundColor: appMainColor),
                      onPressed: () async {
                        form.control('user_role').value = levelid;
                        form.control('userid').value = id;
                        final value = {
                          ...form.value
                        }; // Create a copy of the map
                        WalletAmount(value);
                        if (form.valid) {
                        } else {
                          form.markAllAsTouched();
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Recharge',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
