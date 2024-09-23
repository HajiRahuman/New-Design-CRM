
import 'package:crm/AppStaticData.dart';
import 'package:crm/Providers/providercolors.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';



class ComunBottomBar extends StatefulWidget {
  const ComunBottomBar({super.key});

  @override
  State<ComunBottomBar> createState() => _ComunBottomBarState();
}

class _ComunBottomBarState extends State<ComunBottomBar> {

  launchURLApp() async {
  var url = Uri.parse("https://www.gsisp.in/");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context);
    return Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              boxShadow: boxShadow, color: notifier.getprimerycolor),
          child:Center(
  child: RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "Copyright 2024 © ",
          style: TextStyle(color: notifier.getMainText),
        ),
        WidgetSpan(
          child: InkWell(
            onTap:  launchURLApp,
            child:const Text(
              "Grey Sky Networks.",
              style: TextStyle(color: appMainColor),
            ),
          ),
        ),
      ],
    ),
  ),
)

        );
     
  }
}



class ComunBottomBar1 extends StatefulWidget {
  const ComunBottomBar1({super.key});

  @override
  _ComunBottomBarState1 createState() => _ComunBottomBarState1();
}

class _ComunBottomBarState1 extends State<ComunBottomBar1> {

  launchURLApp() async {
  var url = Uri.parse("https://www.gsisp.in/");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context);
    return Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              boxShadow: boxShadow, color: notifier.getprimerycolor),
          child:Center(
  child: RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "For more information, visit our website ",
         style: mediumBlackTextStyle.copyWith(
                    color:  notifier.getMainText, // Use the provided color or the default color from notifier
                  ),
        ),
        WidgetSpan(
          child: InkWell(
            onTap:  launchURLApp,
            child:Text(
              "https://www.gsisp.in/",
             style: mediumBlackTextStyle.copyWith(
                    color: appMainColor, // Use the provided color or the default color from notifier
                  ),
            ),
          ),
        ),
      ],
    ),
  ),
)

        );
     
  }
}
