
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/model/reseller.dart';

import 'package:flutter/material.dart';
import 'package:crm/service/reseller.dart' as resellerSrv;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingNotification extends StatefulWidget {
  final int? resellerId;

  SettingNotification({
    Key? key,
    required this.resellerId,
  }) : super(key: key);

  @override
  State<SettingNotification> createState() => _SettingNotificationState();
}

class _SettingNotificationState extends State<SettingNotification> {
  ResellarDet? resellerDet;

  @override
  void initState() {
    super.initState();
    getMenuAccess();
  }
  bool isLoading = false;
Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Set loading to true when fetching data
    });
  final resp = await resellerSrv.fetchResellerDetail(id);
  if (resp.error) {
    alert(context, resp.msg);
  }
  // Ensure the widget is still mounted before calling setState
  if (!mounted) return;

  setState(() {
    resellerDet = resp.data;
      isLoading = false;
  });
}

  int levelid = 0;
  bool isIspAdmin = false;
  int id = 0;
  bool isSubscriber = false;
  getMenuAccess() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    levelid = pref.getInt('level_id') as int;
    isIspAdmin = pref.getBool('isIspAdmin') as bool;
    id = pref.getInt('id') as int;
    isSubscriber = pref.getBool('isSubscriber') as bool;
    print('LevelId----${levelid}');
    if (isSubscriber == false) {
      fetchData();
    
    }
  
  }
  @override
  Widget build(BuildContext context) {
       final notifier = Provider.of<ColorNotifire>(context);
    return Consumer<ColorNotifire>(
      builder: (context, notifire, child) {
        return Scaffold(
          backgroundColor: notifire.getbgcolor,
          body: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                              children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                               children: [
                                                 IconButton(
                                                               onPressed: () async {
                                                                 fetchData();
                                                               },
                                                               icon: Icon(Icons.refresh, color: notifier.getMainText),
                                                             ),
                                               ],
                                             ),
                                  ),
                                if (resellerDet != null)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: _buildProfile1(isphon: true),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          
                          const SizedBoxx(),
                        ],
                      ),
                    );
                  },
                ),
              ),
               if (isLoading) // Show circular progress indicator if isLoading is true
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Center(
                            child: CircularProgressIndicator(
                            
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfile1({required bool isphon}) {
     final notifier = Provider.of<ColorNotifire>(context);
    return Column(
      children: [
        Container(
        
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              _buildSwitchListTile("BroadBand Prefix", resellerDet!.settings.broadbandPrefixStatus),
            ],
          ),
        ),

        const SizedBox(height: 10),
           Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
            
               _buildSwitchListTile("Check Overdue Invoices",  resellerDet!.settings.overdue == 1),

            ],
          )),
          const SizedBox(height: 10),
 Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              
               _buildSwitchListTile("SMS Gateway", resellerDet!.settings.smsgwid==0?false:true),

            ],
          )),
          const SizedBox(height: 10),
          Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
             
               _buildSwitchListTile("Allow Unique Mobile Number", resellerDet!.settings.uniqueMobileStatus),

            ],
          )),
          const SizedBox(height: 10),
           Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
             
              _buildSwitchListTile("Allow Unique Email ID",resellerDet!.settings.uniqueEmailStatus),

            ],
          )),
          const SizedBox(height: 10),
           Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
             
              _buildSwitchListTile("Check Due Invoices", resellerDet!.settings.paydue == 1),

            ],
          )),
          const SizedBox(height: 10),
            Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
             
              _buildSwitchListTile("Auto Mac Binding",resellerDet!.settings.usermac_autoupdate),

            ],
          )),
          const SizedBox(height: 10),
            Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
             
            _buildSwitchListTile("Allow Same Validity For Voice and Broadband",resellerDet!.settings.voiceExpDefer),

            ],
          )),
          const SizedBox(height: 10),
          Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Registration Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS", resellerDet!.settings.registerSms),
                _buildSwitchListTile("EAMIL", resellerDet!.settings.registerEmail),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Renew Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS", resellerDet!.settings.renewalSms),
                _buildSwitchListTile("EAMIL", resellerDet!.settings.renewalEmail),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Auto Renew Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS", resellerDet!.settings.autoRenewalSms),
                _buildSwitchListTile("EAMIL", resellerDet!.settings.autoRenewalEmail),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Invoice Generated Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS",resellerDet!.settings.invoiceSms),
                _buildSwitchListTile("EAMIL",resellerDet!.settings.invoiceEmail),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Bill Paid Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS", resellerDet!.settings.paidSms),
                _buildSwitchListTile("EAMIL", resellerDet!.settings.paidEmail),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Extra Data Limit Credit Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS", resellerDet!.settings.extraDataSms),
                _buildSwitchListTile("EAMIL",resellerDet!.settings.extraDataEmail),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Temporary Suspended If Not Paid Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS",resellerDet!.settings.suspendSms),
                _buildSwitchListTile("EAMIL",resellerDet!.settings.suspendEmail),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Expiry Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS",resellerDet!.settings.terminateSms),
                _buildSwitchListTile("EAMIL",resellerDet!.settings.terminateEmail),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Amount Credit Add Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS",resellerDet!.settings.topupSms),
                _buildSwitchListTile("EAMIL",resellerDet!.settings.topupEmail),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Package Cancel Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS",resellerDet!.settings.cancelRenewalSms),
                _buildSwitchListTile("EAMIL",resellerDet!.settings.cancelRenewalEmail),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
          
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Hold Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS",resellerDet!.settings.holdSms),
                _buildSwitchListTile("EAMIL",resellerDet!.settings.holdEmail),

            ],
          )),
   
      ],
    );
  }

  Widget _buildSwitchListTile(String title, bool value) {
    return SwitchListTile(
      title: Text(
        title,
        style: mediumBlackTextStyle.copyWith(color: Provider.of<ColorNotifire>(context).getMainText),
      ),
      value: value,
      onChanged: (val) {
        setState(() {
          // Handle the switch change
        });
      },
    );
  }
}