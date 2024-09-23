
import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/CommonBottBar.dart';

import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Providers/providercolors.dart';
 
import 'package:crm/Widgets/CommonTitle.dart';
import 'package:crm/Widgets/SizedBox.dart';
import 'package:crm/model/CompanyInfo.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../service/CompanyInfo.dart' as subscriberSrv;


class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _ListSubscriber();
}

class _ListSubscriber extends State<PrivacyPolicy> with SingleTickerProviderStateMixin {
 CompanyInfoDet? info;
  
bool ispresent = false;
  @override
  void initState() {
    super.initState();
    GetCompanyInfo();
    
  }

String cleanPrivacy='';
String removeHtmlTags(String htmlString) {
  final RegExp regExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
  return htmlString.replaceAll(regExp, '');
}
Future<void> GetCompanyInfo() async {
  final resp = await subscriberSrv.getCompanyInfo();
  if (resp.error == false) {
    setState(() {
      info = resp.summary;
      if (info != null) {
      
      cleanPrivacy = removeHtmlTags(info!.privacy);
      
      }
    });
  }
}



 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget build(BuildContext context) {
 
       final notifier = Provider.of<ColorNotifire>(context);
    return Scaffold(
      drawer: DarwerCode(), 
      key: _scaffoldKey,
      backgroundColor: notifier.getbgcolor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  
                  const SizedBoxx(),
                  const ComunTitle(title: 'Privacy Policy', path: "Support"),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, right: padding, left: padding, bottom: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: notifier.getcontiner,
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
      bottomNavigationBar:  BottomAppBar(
            shadowColor:notifier.getprimerycolor ,
             color: notifier.getprimerycolor,
             surfaceTintColor: notifier.getprimerycolor,
            child: BottomNavBar(scaffoldKey: _scaffoldKey),
            
          ),
    );
  }

 

  Widget _buildProfile1({required bool isphon}) {
    
   final notifier = Provider.of<ColorNotifire>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       if(info!=null)
          Container(
                             padding:const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                          ),
                             child:   Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                Text( cleanPrivacy.isNotEmpty 
                ? cleanPrivacy 
                : 'No privacy info available', style: mediumBlackTextStyle.copyWith(
              color: notifier.getMainText),
      ),
                               ]
                             )
                           ),
                        
        
                                      
                           const SizedBox(height: 10),  
               const ComunBottomBar1(),
               const SizedBox(height: 20), 
                   Align(
                    alignment: Alignment.bottomRight,
                     child: Padding(
                       padding: const EdgeInsets.only(right: 20),
                       child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: appMainColor
                                  ),
                                   onPressed: (){
                       Navigator.of(context).pop();
                       
                                 },child:const Text('OK',style:TextStyle(color: Colors.white)),),
                     ),
                   ),
             const SizedBox(height: 10),  
      ],
    );
  }

}
