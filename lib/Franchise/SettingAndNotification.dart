
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/model/reseller.dart';

import 'package:flutter/material.dart';
import 'package:crm/service/reseller.dart' as resellerSrv;
import 'package:provider/provider.dart';

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
    fetchData();
  }

  Future<void> fetchData() async {
    final resp = await resellerSrv.fetchResellerDetail(widget.resellerId!);
    if (resp.error) {
      alert(context, resp.msg);
    }
    setState(() {
      resellerDet = resp.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorNotifire>(
      builder: (context, notifire, child) {
        return Scaffold(
          backgroundColor: notifire.getbgcolor,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(padding),
                        child: Column(
                          children: [
                            if (resellerDet != null)
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(padding),
                                      child: _buildProfile1(isphon: true),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBoxx(),
                    ],
                  ),
                );
              },
            ),
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
          padding: EdgeInsets.all(isphon ? 10 : padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              _buildSwitchListTile("Prefix", resellerDet!.settings.broadbandPrefixStatus),
            ],
          ),
        ),

        const SizedBox(height: 10),
           Container(
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
            
               _buildSwitchListTile("Check Overdue Invoices", false),

            ],
          )),
          const SizedBox(height: 10),
 Container(
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              
               _buildSwitchListTile("SMS Gateway", false),

            ],
          )),
          const SizedBox(height: 10),
          Container(
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
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
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
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
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
             
              _buildSwitchListTile("Check Due Invoices",false),

            ],
          )),
          const SizedBox(height: 10),
            Container(
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
             
            _buildSwitchListTile("Allow Same Validity For Voice and Broadband", false),

            ],
          )),
          const SizedBox(height: 10),
          Container(
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
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
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
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
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
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
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Invoice Generated Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS",false),
                _buildSwitchListTile("EAMIL",false),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
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
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
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
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Temporary Suspended If Not Paid Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS",false),
                _buildSwitchListTile("EAMIL",false),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Expiry Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS",false),
                _buildSwitchListTile("EAMIL",false),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Amount Credit Add Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS",false),
                _buildSwitchListTile("EAMIL",false),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Package Cancel Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS",false),
                _buildSwitchListTile("EAMIL",false),

            ],
          )),
           const SizedBox(height: 10),
          Container(
      
           padding: EdgeInsets.all(isphon ? 10 : padding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
          child: Column(
            children: [
              Text('Customer Hold Alert',style: mediumBlackTextStyle.copyWith(color:notifier.getMainText)),
               _buildSwitchListTile("SMS",false),
                _buildSwitchListTile("EAMIL",false),

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