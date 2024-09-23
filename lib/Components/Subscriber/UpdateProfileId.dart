import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/Subscriber/SubscriberInvoice/SubscriberInvoice.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/model/subscriber.dart';

import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UpdateProID extends StatefulWidget {
  SubscriberFullDet? subscriberDet;

  final int subscriberId;
  final int acctype;

  UpdateProID({required this.subscriberId,required this.acctype});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<UpdateProID> {
  TextEditingController updateProIdController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;


  Future<void> updateProfileID(int acctype, int subscriberId, UpdateProId updateProId) async {
    final reqData = {
      'profileid': updateProId.profileid,
      'acctype': updateProId.acctype,
    };

    final resp = await subscriberSrv.updateProfileID(subscriberId, reqData);

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
      child:  Column(
          children: [
            const SizedBox(height: 15),
             Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Update Profile ID",
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
                                                                                color:notifier.getMainText,
                                                                          ),
                                                                        ),
                                                                      ),
                    ],
                  ),
                ),
              
            
            const SizedBox(height: 25),
            Center(
                child: TextFormField(
                    keyboardType: TextInputType.multiline,

                    textInputAction: TextInputAction.newline,
                    maxLines: 2,
                  controller: updateProIdController,
                  style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                             labelText: "Profile ID",
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
                      if (value == null ||
                          value.isEmpty) {
                        return 'ProfileID is required';
                      }
                      return null;}
                ),
              ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:ElevatedButton(
                  style: ElevatedButton.styleFrom(
                   backgroundColor: appMainColor
                  ),
                  onPressed: () async {
                    setState(() {
                      _isSubmitted = true;
                    });

                    if (_formKey.currentState!.validate()) {

                      int id = widget.subscriberId;

                      final result = await updateProfileID(
                        widget.acctype,
                        id,
                        UpdateProId(profileid: updateProIdController.text, acctype:widget.acctype ),
                      );

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
