import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/service/crypto.dart';
import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../model/subscriber.dart';

class UpdateProfilePwd extends StatefulWidget {
  SubscriberFullDet? subscriberDet;

  final int subscriberId;

  UpdateProfilePwd({Key? key, required this.subscriberId}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<UpdateProfilePwd> {
  TextEditingController profilePwdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;
  String pro='';

  Future<void> updateProfilePwd(
      int subscriberId, UpdateProPWD updateProPWD) async {
    final encryptedPwdResp = await getEncryptPassword(updateProPWD.profilepsw);
    final encryptedPwd = encryptedPwdResp['password'];
    final reqData = {
      'profilepsw': encryptedPwd,
    };
    final resp =
    await subscriberSrv.updateProfilePwd(subscriberId, reqData);

    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
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
      child: Column(
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Update Profile\nPassword",
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
              
            ),
            const SizedBox(height: 25),
            Center(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,

                  textInputAction: TextInputAction.newline,
                  maxLines: 2,
                  controller: profilePwdController,
                  style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Password Minimum 8 character!New Password *';
                    }
                    return null;
                  },
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
                    setState(() {
                      _isSubmitted = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      int id = widget.subscriberId;
                      final result = await updateProfilePwd(id, UpdateProPWD(profilepsw: profilePwdController.text));
                    }
                  },
                  child:
                      const Text('Update', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      
    );
  }
}
