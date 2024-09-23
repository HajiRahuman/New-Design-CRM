

import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:crm/service/hotel.dart' as HotelUserSrv;
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../model/hotel.dart';

class ChangeAuthPwdHotel extends StatefulWidget {
  HotelDet? hotel;
  ChangeAuthPwdHotel({required this.hotel});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<ChangeAuthPwdHotel> {
  TextEditingController authPwdController = TextEditingController();

  final form = FormGroup({
    'authpsw': FormControl<String>(validators: [Validators.required]),
  });

  Future<void> UpdateAuthPwdHotel(value) async {
    final resp =
    await HotelUserSrv.updateAuthPwdHotel(widget.hotel!.id, value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }




  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
     final notifier = Provider.of<ColorNotifire>(context);
    return ReactiveForm(
      formGroup: form,
      child: Column(
        children: [
          const SizedBox(height: 15),
         Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Update Authentication Password",
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
          Center(
            child: ReactiveTextField(
              formControlName: 'authpsw',
              validationMessages: {
                'required': (error) => 'Password is Required!',
              },
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: 2,
              controller: authPwdController,
               style: TextStyle(color: notifier.getMainText),
                                                                        
                                                                       
                                                                         decoration: InputDecoration(
                                                                           contentPadding:
                const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                prefixIconColor: notifier.getMainText,
                suffixIconColor: notifier.getMainText,
                                                                        
                                                              
                                                                            labelStyle: mediumGreyTextStyle.copyWith(
                                          fontSize: 13),
                                          labelText: 'New Password',
                                                                           
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
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                 backgroundColor: appMainColor
                ),
                onPressed: () async {
                  final value = {...form.value};
                  await UpdateAuthPwdHotel(value);
                  if (form.valid) {
                  } else {
                    form.markAllAsTouched();
                  }
                },
                child: const Text('Update',style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
