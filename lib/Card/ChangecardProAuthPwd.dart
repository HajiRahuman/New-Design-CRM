

import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/model/card.dart';
import 'package:crm/service/crypto.dart';
import 'package:flutter/material.dart';
import 'package:crm/service/card.dart' as cardSrvs;
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';


class ChangeCardProAuthPwd extends StatefulWidget {
  CardDet? card;
  final String title;
  ChangeCardProAuthPwd({super.key, required this.card, required this.title});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<ChangeCardProAuthPwd> {
  TextEditingController authPwdController = TextEditingController();
 
 
 late FormGroup form;

  @override
  void initState() {
    super.initState();
    form = FormGroup({
      "id":FormControl<int>(value: widget.card!.id),
      'authpsw': FormControl<String>(
          validators: widget.title == 'Update Authentication PWD' ? [Validators.required] : []),
      'profilepsw': FormControl<String>(
          validators: widget.title == 'Update Profile PWD' ? [Validators.required] : []),
    });
  }
Future<void> updatePassword(String value) async {
    try {
        // Encrypt the password only if the title is 'Update Profile PWD'
        late Map<String, dynamic> encryptedPwdResp;

        if (widget.title == 'Update Profile PWD') {
            encryptedPwdResp = await getEncryptPassword(value);
            
            if (encryptedPwdResp['error'] == true) {
                throw Exception('Encryption failed');
            }
        }

        // Prepare the payload based on the title
        Map<String, dynamic> payload = {
              'id': widget.card!.id,
            widget.title == 'Update Profile PWD' ? 'profilepsw' : 'authpsw': 
                widget.title == 'Update Profile PWD' ? encryptedPwdResp['password'] : value
        };

        Map<String, dynamic> resp;

        // Call the relevant service based on the title
        if (widget.title == 'Update Profile PWD') {
            resp = await cardSrvs.updateProfilePwdCard(widget.card!.id, payload);
        } else if (widget.title == 'Update Authentication PWD') {
            resp = await cardSrvs.updateAuthPwdCard(widget.card!.id, payload);
        } else {
            throw Exception('Invalid title');
        }

        if (resp['error'] == false) {
            alert(context, resp['msg'], resp['error']);
            Navigator.pop(context, true);
        } else {
            alert(context, resp['msg'], resp['error']);
        }
    } catch (e) {
        alert(context, 'An error occurred: ${e.toString()}', true);
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
                      widget.title == 'Update Profile PWD' ? "Update Profile Password":"Update Authentication Password",
                        style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.03,),
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
           if (widget.title == 'Update Authentication PWD')
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
           if (widget.title == 'Update Profile PWD')
           Center(
            child: ReactiveTextField(
              formControlName: 'profilepsw',
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
                onPressed: () {
                  if (form.valid) {
                    final value = widget.title == 'Update Profile PWD'
                        ? form.control('profilepsw').value
                        : form.control('authpsw').value;
                    updatePassword(value!);
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
