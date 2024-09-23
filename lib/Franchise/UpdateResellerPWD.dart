import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/Subscriber/SubscriberInvoice/SubscriberInvoice.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/model/reseller.dart';
import 'package:crm/service/crypto.dart';

import 'package:crm/service/reseller.dart' as resellerSrv;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../model/subscriber.dart';

class UpdateResellerPwd extends StatefulWidget {
  SubscriberFullDet? subscriberDet;

  final int resellerId;

  UpdateResellerPwd({Key? key, required this.resellerId}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<UpdateResellerPwd> {



  String pro='';

  final form = FormGroup({
    'password': FormControl<String>(validators: [Validators.required]),
  });


  bool showSpinner = false;
  Future<void> updateResellerPwd(
      int resellerId) async {
    setState(() {
      showSpinner = true;
    });
    final encryptedPwdResp = await getEncryptPassword(form.value['password'].toString());
    final encryptedPwd = encryptedPwdResp['password'];
    final reqData = {
      'password': encryptedPwd,
    };
    final resp =
    await resellerSrv.updateResellerPwd(resellerId, reqData);

    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
     final notifier = Provider.of<ColorNotifire>(context);
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      color: notifier.getbgcolor,
      child: ReactiveForm(
        formGroup:form,
        child: Container(
          width: screenWidth,
          child: Column(
            children: [
              const SizedBox(height: 15),
              Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Update Password",
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
                                                                          icon:Icon(
                                                                            Icons
                                                                                .close_rounded,
                                                                                color:notifier.getMainText,
                                                                          ),
                                                                        ),
                                                                      ),
                      ],
                    ),
                  ),
                
              const SizedBox(height: 25),
              Center(
                child: ReactiveTextField<String>(
                  validationMessages: {
                    'password': (error) => 'Password is required',
                  },
                  formControlName: 'password',
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: 2,
                  style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                         contentPadding:const EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 10),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                             labelText: "New Password",
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
                    if (form.valid) {} else {
                      form.markAllAsTouched();
                    }
                    updateResellerPwd(widget.resellerId);
                  },

                  child:
                  const Text('Update', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
