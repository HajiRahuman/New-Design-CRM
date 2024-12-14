import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/subscriber.dart';

class SessionCheckStop extends StatefulWidget {
  SubscriberFullDet? subscriberDet;

  final String username;

  SessionCheckStop({required this.username});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<SessionCheckStop> {
  TextEditingController remarksController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;
  String pro = '';

  List<SessionDet> session = [];
  Future<void> Sessions(String username) async {
    SessionResp resp = await subscriberSrv.Session(username);
    setState(() {
      if (resp.error) {
        alert(context, resp.msg);
        session = [];
      } else {
        session = resp.data ?? [];
      }
    });
  }

  void initState() {
    super.initState();
    Sessions(widget.username);
  }

  Future<void> CheckandStop(String username,
      {required SessionCheckandStop Checkstop}) async {
    final reqData = {
      'radacctid': Checkstop.radacctid,
      'remarks': Checkstop.remarks,
      'isDisconnect': Checkstop.isDisconnect,
      'uid': Checkstop.uid,
    };

    final resp = await subscriberSrv.sessionCheckandStop(
        Checkstop.uid, Checkstop.radacctid, Checkstop.isDisconnect, reqData);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
      final notifier = Provider.of<ColorNotifire>(context);
    return Form(
      key: _formKey,
      autovalidateMode:
          _isSubmitted ? AutovalidateMode.always : AutovalidateMode.disabled,
      child:  Container(
        width: 15,
        child: Column(children: [
          const SizedBox(height: 15),
         Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Stop/Check Online Session",
                       style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.04),
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
                                                                                color: notifier.getMainText,
                                                                          ),
                                                                        ),
                                                                      ),
                  ],
                ),
              ),
         
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                style:  ElevatedButton.styleFrom(
                 backgroundColor: appMainColor
                ),
                onPressed: () {  },
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_off,
                      color: Colors.white,
                    ),
                 SizedBox(width: 8), // Add spacing between icon and text
                    Text('Log Off All', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: screenWidth,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount:
                            session.length, // Set the item count based on your data
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                padding:const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                                child:  Column(
                                    children: [
                                      const SizedBox(height: 5),
                                     Row(
                                       children: [
                                         const SizedBox(width: 15),
                                           Text('ACTION',
                                                  textScaleFactor: 1.1,
                                                 style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
                                           const SizedBox(width:10),
                                           Align(
                                                    alignment: Alignment.topLeft,
                                                    child: SizedBox(
                                                      // width: 80,
                                                      height: 38,
                                                      child: ElevatedButton(
                                                        style:  ElevatedButton.styleFrom(
                                                          backgroundColor: appMainColor
                                                        ),
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) => AlertDialog(
                                                              backgroundColor:notifier.getbgcolor,
                                                                 
                                                              actions: [
                                                                ListTile(
                                                                    title:  Text(
                                                                      'Disconnect User Session',
                                                                        style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.03),
                                                                    ),
                                                                    trailing: IconButton(
                                                                      icon:  Icon(
                                                                        Icons.close_rounded,
                                                                        color: notifier.getMainText,
                                                                      ),
                                                                      onPressed: () {
                                                                        Sessions(widget.username);
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                  ),
                                                                
                                                                const SizedBox(height: 20),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                          horizontal: 15),
                                                                  child: TextFormField(
                                                                    keyboardType:
                                                                        TextInputType.multiline,
                                                                    textInputAction:
                                                                        TextInputAction.newline,
                                                                    maxLines: 3,
                                                                   
                                                                    controller: remarksController,
                                                                   style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 10,top:10,right: 10,bottom: 10),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                             labelText: "Remarks",
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
                                                                        return 'Remarks is required';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                SizedBox(height: 20),
                                                                Align(
                                                                  alignment:
                                                                      Alignment.bottomRight,
                                                                  child:ElevatedButton(
                                                        style:  ElevatedButton.styleFrom(
                                                          backgroundColor: appMainColor
                                                        ),
                                                                    onPressed: () async {
                                                                      setState(() {
                                                                        _isSubmitted = true;
                                                                      });
                                                                      Navigator.of(context).pop();
                                                                      if (_formKey.currentState
                                                                              ?.validate() ??
                                                                          false) {
                                                                        showDialog(
                                                                            context: context,
                                                                            builder:
                                                                                (ctx) =>
                                                                                    AlertDialog(
                                                                                      backgroundColor:notifier.getbgcolor,
                                                                                          
                                                                                      actions: [
                                                                                       
                                                                                              ListTile(
                                                                                            title:
                                                                                                 Text(
                                                                                              'Disconnect User Session',
                                                                                              style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.03),
                                                                                            ),
                                                                                            trailing:
                                                                                                IconButton(
                                                                                              icon:
                                                                                                Icon(
                                                                                                Icons.close_rounded,
                                                                                                color: notifier.getMainText,
                                                                                              ),
                                                                                              onPressed:
                                                                                                  () {
                                                                                                    Sessions(widget.username);
                                                                                                    Navigator.of(context).pop();
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        
                                                                                        const SizedBox(
                                                                                            height:
                                                                                                20),
                                                                                         Align(
                                                                                            alignment: Alignment
                                                                                                .centerLeft,
                                                                                            child:
                                                                                                Text(
                                                                                              'Are you sure want to Refresh User Session',
                                                                                                style: mediumBlackTextStyle.copyWith(color: notifier.getMainText),
                                                                                            )),
                                                                                        const SizedBox(
                                                                                            height:
                                                                                                20),
                                                                                        Row(
                                                                                          mainAxisAlignment:
                                                                                              MainAxisAlignment.end,
                                                                                          children: [
                                                                                            ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(
                                                                                               backgroundColor: appMainColor,
                                                                                               
                                                                                              ),
                                                                                              onPressed:
                                                                                                  () async {
                                                                                                Sessions(widget.username);
                                                                                              },
                                                                                              child:
                                                                                                Text('Do not Disconnect',
                                                                                                      style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.04),)
                                                                                            ),
                                                                                            const SizedBox(
                                                                                                width: 20),
                                                                                           ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(
                                                                                               backgroundColor: appMainColor,
                                                                                               
                                                                                              ),
                                                                                              onPressed:
                                                                                                  () async {
                                                                                                setState(() {
                                                                                                  _isSubmitted = true;
                                                                                                });
                                                                                                if (_formKey.currentState?.validate() ?? false) {
                                                                                                  SessionCheckandStop checkstop = SessionCheckandStop(
                                                                                                      radacctid: session.isNotEmpty ? session.first.radacctid : 0,
                                                                                                      remarks: remarksController.text,
                                                                                                      isDisconnect: true,
                                                                                                      uid: session.isNotEmpty ? session.first.uid : 0);

                                                                                                  await CheckandStop(widget.username, Checkstop: checkstop);
                                                                                                }
                                                                                              },
                                                                                              child:
                                                                                                  const Text('yes,Disconnect', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ));
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        'Disconnect',
                                                                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        child:
                                                            // Add spacing between icon and text
                                                            const Text(
                                                          'Log Off',
                                                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Align(
                                                    alignment: Alignment.topLeft,
                                                    child: SizedBox(
                                                      // width: 80,
                                                      height: 38,
                                                      child: ElevatedButton(
                                                        style:  ElevatedButton.styleFrom(
                                                         backgroundColor: appMainColor
                                                        ),
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (ctx) => AlertDialog(
                                                              backgroundColor:notifier.getbgcolor,
                                                                
                                                              actions: [
                                                                 ListTile(
                                                                    title:  Text(
                                                                      'Refresh User Session',
                                                                         style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.03)
                                                                    ),
                                                                    trailing: IconButton(
                                                                      icon:  Icon(
                                                                        Icons.close_rounded,
                                                                        color:notifier.getMainText ,
                                                                      ),
                                                                      onPressed: () {
                                                                        Sessions(widget.username);
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                    ),
                                                                  ),
                                                                
                                                                const SizedBox(height: 20),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                          horizontal: 15),
                                                                  child: TextFormField(
                                                                    keyboardType:
                                                                        TextInputType.multiline,
                                                                    textInputAction:
                                                                        TextInputAction.newline,
                                                                    maxLines: 3,
                                                                   
                                                                    controller: remarksController,
                                                                    style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 10,top:10,right: 10,bottom: 10),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                             labelText: "Remarks",
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
                                                                        return 'Remarks is required';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 20),
                                                                Align(
                                                                  alignment:
                                                                      Alignment.bottomRight,
                                                                  child:ElevatedButton(
                                                        style:  ElevatedButton.styleFrom(
                                                         backgroundColor: appMainColor
                                                        ),
                                                                    onPressed: () async {
                                                                      setState(() {
                                                                        _isSubmitted = true;
                                                                      });
                                                                      Navigator.of(context).pop();
                                                                      if (_formKey.currentState
                                                                              ?.validate() ??
                                                                          false) {
                                                                        showDialog(
                                                                            context: context,
                                                                            builder:
                                                                                (ctx) =>
                                                                                    AlertDialog(
                                                                                      backgroundColor:notifier.getbgcolor,
                                                                                        
                                                                                      actions: [
                                                                                      
                                                                                              ListTile(
                                                                                            title:
                                                                                                 Text(
                                                                                              'Refresh User Session',
                                                                                               style: TextStyle(
                                    color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.03)
                                                                                            ),
                                                                                            trailing:
                                                                                                IconButton(
                                                                                              icon:
                                                                                                 Icon(
                                                                                                Icons.close_rounded,
                                                                                              color: notifier.getMainText,
                                                                                              ),
                                                                                              onPressed:
                                                                                                  () {
                                                                                                    Sessions(widget.username);
                                                                                                    Navigator.of(context).pop();
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        
                                                                                        const SizedBox(
                                                                                            height:
                                                                                                20),
                                                                                         Align(
                                                                                            alignment: Alignment
                                                                                                .centerLeft,
                                                                                            child:
                                                                                                Text(
                                                                                              'Are you sure want to Refresh User Session',
                                                                                              style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                                            )),
                                                                                        const SizedBox(
                                                                                            height:
                                                                                                20),
                                                                                        Row(
                                                                                          mainAxisAlignment:
                                                                                              MainAxisAlignment.end,
                                                                                          children: [
                                                                                           ElevatedButton(
                                                        style:  ElevatedButton.styleFrom(
                                                         backgroundColor: appMainColor
                                                        ),
                                                                                              onPressed:
                                                                                                  () async {
                                                                                                Sessions(widget.username);
                                                                                              },
                                                                                              child:
                                                                                                  const Text('Do not Refresh', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                                                                            ),
                                                                                            const SizedBox(
                                                                                                width: 20),
                                                                                           ElevatedButton(
                                                        style:  ElevatedButton.styleFrom(
                                                         backgroundColor: appMainColor
                                                        ),
                                                                                              onPressed:
                                                                                                  () async {
                                                                                                setState(() {
                                                                                                  _isSubmitted = true;
                                                                                                });
                                                                                                if (_formKey.currentState?.validate() ?? false) {
                                                                                                  SessionCheckandStop checkstop = SessionCheckandStop(
                                                                                                      radacctid: session.isNotEmpty ? session.first.radacctid : 0,
                                                                                                      remarks: remarksController.text,
                                                                                                      isDisconnect: false,
                                                                                                      uid: session.isNotEmpty ? session.first.uid : 0);

                                                                                                  await CheckandStop(widget.username, Checkstop: checkstop);
                                                                                                }
                                                                                              },
                                                                                              child:
                                                                                                  const Text('yes,Refresh', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      ],
                                                                                    ));
                                                                      }
                                                                    },
                                                                    child: const Text('Refresh',
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,color: Colors.white)),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        child: const Text(
                                                          'Close Session',
                                                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),


                                       ],
                                     ),

                                      const SizedBox(height: 10),
                                       _buildCommonListTile(title: "START TIME : ", subtitle: session.isNotEmpty
                                                  ?DateFormat('yMd') .format(
                                                DateTime.parse(session.first.acctstarttime),
                                              )
                                                  : 'N/A'),
                                  const SizedBox(height: 10),
                                   _buildCommonListTile(title: "END TIME : ", subtitle: session.isNotEmpty
                                                ? session.first.acctstoptime
                                                : 'N/A'),
                                  const SizedBox(height: 10),
                                  _buildCommonListTile(title: "CALLING STATION ID : ", subtitle:session.isNotEmpty
                                                ? session.first.callingstationid
                                                : 'N/A'),
                                  const SizedBox(height: 10),
                                  
                                  _buildCommonListTile(title: "FRAMED IP ADDRESS : ", subtitle:  session.isNotEmpty
                                                ? session.first.framedipaddress
                                                : 'N/A'),
                                  const SizedBox(height: 10),
                                  
                                      
                                     
                                     

                                    ],
                                  ),
                                
                              ),
                            const  SizedBox(height: 10),
                            ],
                          );
                        }),
                  ),

                ],
              ),
          ),

        ]),
      )
    );
  }
  
  Widget _buildCommonListTile({required String title, required String subtitle}) {
     final notifier = Provider.of<ColorNotifire>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: title, style: mediumGreyTextStyle),
              TextSpan(text: subtitle, style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
            ],
          ),
        ),
      ],
    );
  }
}
