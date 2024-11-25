import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/model/subscriber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:provider/provider.dart';

class UpdateAccountType extends StatefulWidget {
  SubscriberFullDet? subscriberDet;
  final int subscriberId;
  final String username;
  final int enablemac;
  final String conn;
  final String acctstatus;
  final int acctype;

  UpdateAccountType(
      {Key? key,
      required this.subscriberId,
      required this.username,
      required this.enablemac,
      required this.conn,
      required this.acctstatus,
      required this.acctype})
      : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<UpdateAccountType> {
  TextEditingController macIdController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;
  String acctypeOpt = '';

  int selectedNumericValue = 0;
  Map<String, int> statusMap = {
    'Normal': 0,
    'Mac': 1,
  };
  void initState() {
    // Set the initial value based on widget.acctstatus
    switch (widget.acctype) {
      case 0:
        acctypeOpt = 'Normal';
        break;
      case 1:
        acctypeOpt = 'Mac';
        break;

      default:
        acctypeOpt = '';
    }
    super.initState();
  }

  String mac = '';

  Future<void> updateAcctType(int subscriberId,
      {required UpdateAccType updateAccTYP}) async {
    final reqData = {
      'id': subscriberId,
      'acctype': updateAccTYP.acctype,
      'mac': updateAccTYP.mac,
      'enablemac': updateAccTYP.enablemac,
      'username': updateAccTYP.username,
      'conn': updateAccTYP.conn
    };
    final resp = await subscriberSrv.updateAcctype(subscriberId, reqData);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
  final notifier = Provider.of<ColorNotifire>(context);
    return Form(
      key: _formKey,
      autovalidateMode:
          _isSubmitted ? AutovalidateMode.always : AutovalidateMode.disabled,
      child:  Column(
          children: [
            // Text(widget.acctstatus),
            // Text(widget.subscriberDet!.conn),
            const SizedBox(height: 15),
           Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Update Account\nType",
                     style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.04,),
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
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: notifier.getbgcolor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      ListTile(
                        title:  Text('Account Status',
                          style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.acctstatus == 'Active'
                                ? const Color(0xFFF43A047)
                                : const Color(0xFFFA63C58),
                          ),
                          child: Text(
                            widget.acctstatus ?? 'N/A',
                           style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      ListTile(
                        title: Text('Online Status',
                          style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.conn == 'Online'
                                ? const Color(0xFFF046A38)
                                : const Color(0xFFFA63C58),
                          ),
                          child: Text(
                            widget.conn ?? 'N/A',
                          style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: DropdownButtonFormField<String>(
                
                isExpanded: true,
                value: acctypeOpt,
                onChanged: (newValue) {
                  setState(() {
                    acctypeOpt = newValue!;
                    selectedNumericValue = statusMap[newValue] ?? 0;
                  });
                },
                items: statusMap.keys.map<DropdownMenuItem<String>>(
                  (String key) {
                    return DropdownMenuItem<String>(
                      value: key,
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
                                                                               labelText: 'Account Type',
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
            Visibility(
              visible: acctypeOpt == 'Mac',
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Center(
                    child: TextFormField(
                      maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onChanged: (value) {
                    setState(() {
                      mac = value;
                    });
                  },
                  controller: macIdController,
                
                                                         style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                              hintStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                              hintText: "xx:xx:xx:xx:xx:xx",
                    labelText: 'Mac ID',
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
                 
                    
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mac ID Required. \nMAC Address should be separated by colon(:)!';
                    }
                    final macAddressRegex =
                        RegExp(r'^([0-9A-Fa-f]{2}:){5}([0-9A-Fa-f]{2})$');
                    if (!macAddressRegex.hasMatch(value)) {
                      return 'Invalid MAC Address format.\n Use xx:xx:xx:xx:xx:xx';
                    }
                    return null;
                  },
                )),
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
                  setState(() {
                    _isSubmitted = true;
                  });
                  if (_formKey.currentState!.validate()) {
                    await updateAcctType(
                      widget.subscriberId,
                      updateAccTYP: UpdateAccType(
                        acctype: selectedNumericValue,
                        mac: macIdController.text,
                        id: widget.subscriberId,
                        username: widget.username,
                        conn: widget.conn,
                        enablemac: widget.enablemac,
                      ),
                    );
                  }
                },
                child:
                    const Text('Update', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
              ),
            ),
          ],
        ),
      
    );
  }
}
