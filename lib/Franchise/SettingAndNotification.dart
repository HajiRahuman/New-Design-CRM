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
   ResellarDet? resellerDet;
  int? resellerId;
  SettingNotification({
    Key? key,
    required this.resellerId,
  }) : super(key: key);

  @override
  State<SettingNotification> createState() => _SettingNotificationState();
}

class _SettingNotificationState extends State<SettingNotification> {
  bool isLoading = false;

  void fetchData() async {
    final resp = await resellerSrv.fetchResellerDetail(0);
    setState(() {
      if (resp.error) {
        alert(context, resp.msg);
      } else {
        widget.resellerDet = resp.data;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final notifire = Provider.of<ColorNotifire>(context, listen: true);
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
                  const SizedBoxx(),
                  const ComunTitle(title: 'View Franchise', path: "Franchise"),
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: Container(
                      decoration: BoxDecoration(
                        color: notifire.getcontiner,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                      ),
                      child: Column(
                        children: [
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
                  ),
                  const SizedBoxx(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfile1({required bool isphon}) {
    final notifier = Provider.of<ColorNotifire>(context);

    return Column(
      children: [
        const SizedBox(height: 20),
        _buildSwitchListTile("Prefix", false),
        _buildSwitchListTile("Allow Unique Mobile Number", false),
        _buildSwitchListTile("Allow Unique Email", false),
        _buildSwitchListTile("Auto Mac Binding", false),
        _buildSwitchListTile("Allow Same Validity For Voice and Broadband", false),
        _buildSwitchListTile("Customer Registration SMS", false),
        _buildSwitchListTile("Registration Alert Email", false),
        _buildSwitchListTile("Customer Renewal SMS", false),
        _buildSwitchListTile("Renew Alert Email", false),
        _buildSwitchListTile("Customer Auto Renewal SMS", false),
        _buildSwitchListTile("Auto Renew Alert Email", false),
        _buildSwitchListTile("Customer Invoice SMS", false),
        _buildSwitchListTile("Invoice Generated Alert Email", false),
        _buildSwitchListTile("Customer Bill Paid SMS", false),
        _buildSwitchListTile("Bill Paid Alert Email", false),
        _buildSwitchListTile("Customer Extra Data SMS", false),
        _buildSwitchListTile("Extra Data Limit Credit Alert Email", false),
        _buildSwitchListTile("Customer Suspend SMS", false),
        _buildSwitchListTile("Temporary Suspended If Not Paid Alert Email", false),
        _buildSwitchListTile("Customer Terminate SMS", true),
        _buildSwitchListTile("Expiry Alert Email", true),
        _buildSwitchListTile("Customer Top-up SMS", true),
        _buildSwitchListTile("Amount Credit Add Alert Email", true),
        _buildSwitchListTile("Customer Cancel Renewal SMS", true),
        _buildSwitchListTile("Package Cancel Alert Email", true),
        _buildSwitchListTile("Customer Hold SMS", true),
        _buildSwitchListTile("Hold Alert Email", true),
      ],
    );
  }

  Widget _buildSwitchListTile(String title, bool value) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
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
