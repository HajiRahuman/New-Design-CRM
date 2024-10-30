
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/Providers/providercolors.dart';

import 'package:flutter/material.dart';


import 'package:provider/provider.dart';
class ComunTitle extends StatefulWidget {
  final String title;
  final String path;
  const ComunTitle({super.key, required this.title, required this.path});

  @override
  State<ComunTitle> createState() => _ComunTitleState();
}

class _ComunTitleState extends State<ComunTitle> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer<ColorNotifire>(
          builder: (context, value, child) {
            final color = value.getMainText ?? Colors.black; // Fallback color
            return Padding(
              padding: const EdgeInsets.all(padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: constraints.maxWidth < 600
                        ? mainTextStyle.copyWith(
                            fontSize: 18,
                            color: color,
                          )
                        : mainTextStyle.copyWith(color: color),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Flexible(
                  //   child: Wrap(
                  //     runSpacing: 5,
                  //     crossAxisAlignment: WrapCrossAlignment.center,
                  //     children: [
                  //       Material(
                  //         color: Colors.transparent,
                  //         child: InkWell(
                  //           onTap: () {
                  //             // controller.changePage(0);
                  //           },
                  //           child: SvgPicture.asset(
                  //             "assets/home.svg",
                  //             height: constraints.maxWidth < 600 ? 14 : 16,
                  //             width: constraints.maxWidth < 600 ? 14 : 16,
                  //             color: color,
                  //           ),
                  //         ),
                  //       ),
                  //       Text(
                  //         '   /   ${widget.path}   /   ',
                  //         style: mediumBlackTextStyle.copyWith(
                  //           color: color,
                  //           fontSize: constraints.maxWidth < 600 ? 12 : 14,
                  //         ),
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //       Text(
                  //         widget.title,
                  //         style: mediumGreyTextStyle.copyWith(
                  //           color: appMainColor,
                  //           fontSize: constraints.maxWidth < 600 ? 12 : 14,
                  //         ),
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
