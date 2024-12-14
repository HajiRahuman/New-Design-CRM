import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/model/subscriber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';



class MacBinding extends StatefulWidget {
  SubscriberFullDet? subscriberDet;

  final int subscriberId;
  final String acctstatus;
  final String  conn;
  final int enablemac;
  final  int acctype ;
  final  int simultaneoususe ;
  final String mac;

  MacBinding({required this.subscriberId,required this.acctstatus,required
  this.conn,required
  this.enablemac,required
  this.acctype,required
  this.simultaneoususe,
  required this.mac});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MacBinding> {
  TextEditingController macBindingController = TextEditingController();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;

  bool status = false;
  String mac='';
  bool showTextField = false;

  Future<void> updateMACBinding(int subscriberId, {required UpdateMacBinding updateMAC}) async {
    final reqData = {
      'id': subscriberId,
      'enablemac': updateMAC.enablemac,
      'acctype': updateMAC.acctype,
      'simultaneoususe': updateMAC.simultaneoususe,
      'mac': updateMAC.mac,
    };

    final resp = await subscriberSrv.updateMacBinding(subscriberId, reqData);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }
  List<UserMacDet> usermac = [];

  Widget buildUserMacList() {
    return ListView.builder(
      itemCount: usermac.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(usermac[index].usermac),
        );
      },
    );
  }

  Future<void> UserMAC(int subscriberId) async {
    UserMacResp resp = await subscriberSrv.userMac(subscriberId);
    setState(() {
      if (resp.error) {
        alert(context, resp.msg);
        usermac = [];
      } else {
        usermac = resp.data ?? [];
        if (usermac.isNotEmpty && widget.enablemac == 1) {

          String concatenatedUserMacs = usermac.map((e) => e.usermac).join(', ');
          macBindingController.text = concatenatedUserMacs;
        }
      }
    });
  }

  void initState() {
    super.initState();

    status = widget.enablemac == 1;
    showTextField = widget.enablemac == 1;
    UserMAC(widget.subscriberId);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;
        
  final notifier = Provider.of<ColorNotifire>(context);
    return Form(
      key: _formKey,
      autovalidateMode: _isSubmitted
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
             Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mac Binding",
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
                                                                                color: notifier.getMainText,
                                                                          ),
                                                                        ),
                                                                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 25),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton
                        .styleFrom(
                      backgroundColor: widget
                          .acctstatus ==
                          'Active'
                          ? const Color(0xFFF43A047)
                          : const Color(
                          0xFFFA63C58),
                    ),
                    child: Text(
                      widget.acctstatus,
                      style:
                      const TextStyle(
                          color: Colors
                              .white),
                      textAlign: TextAlign
                          .center,
                    ),
                    onPressed: () {},
                  ),
          const Spacer(),
              ElevatedButton(
                style: ElevatedButton
                    .styleFrom(
                  backgroundColor: widget
                      .conn
                      ==
                      'Online'
                      ?const Color(0xFFF046A38)
                      : const Color(
                      0xFFFA63C58),
                ),
                child: Text(
                  widget.conn,
                  style:
                  const TextStyle(
                      color: Colors
                          .white),
                  textAlign: TextAlign
                      .center,
                ),
                onPressed: () {},
              ),
                ],
              ),


              const SizedBox(height: 20),
               Text("Enable Mac", style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),

                  FlutterSwitch(
                    activeColor: Colors.green,
                    width: 70.0,
                    height: 30.0,
                    valueFontSize: 12.0,
                    toggleSize: 45.0,
                    value: status,
                    borderRadius: 30.0,
                    padding: 8.0,
                    showOnOff: true,
                    onToggle: (val) {
                      setState(() {
                        status = val;
                        showTextField = val; // Set showTextField to true when the switch is toggled
                      });
                    },
                  ),
              const SizedBox(height: 10),
              if (showTextField)
                Center(
                    child:TextFormField(
                      keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 2,
                        controller: macBindingController,
                    
                                                         style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                             contentPadding:const EdgeInsets.only(left: 10,top: 10,right: 10,bottom: 10),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText: 'Mac',
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
                            return 'Mac ID Required. MAC Address should be separated by colon(:)!';
                          }
                          return null;
                        },
                      )

                  ),


              const SizedBox(height: 5),
              if (showTextField)
            Text('Enter Comma After Each MAC Address', style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
             const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                   backgroundColor: appMainColor,
                  ),
                  onPressed: () async {
                    setState(() {
                      _isSubmitted = true;
                    });

                    if (_formKey.currentState!.validate()) {
                      int id = widget.subscriberId;
                      List<String> macAddresses = macBindingController.text.split(',');
                      UpdateMacBinding updateMAC = UpdateMacBinding(
                        id: widget.subscriberId,
                        enablemac: status ? 1 : 0, // Use 1 for true and 0 for false
                        acctype: widget.acctype,
                        simultaneoususe: widget.simultaneoususe,
                        mac: macAddresses,
                      );
                      await updateMACBinding(id, updateMAC: updateMAC);
                    }
                  },
                  child:
                  const Text('Update', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}
