
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
    return Consumer<ColorNotifire>(
      builder: (BuildContext context, value, Widget? child) {
        return Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              boxShadow: boxShadow, color: notifire!.getprimerycolor),
          child:Center(
  child: RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: "Copyright 2024 © ",
          style: TextStyle(color: notifire!.getMainText),
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
      },
    );
  }
}
