// // import 'package:crm/AppBar.dart';
// // import 'package:crm/AppStaticData.dart';
// // import 'package:crm/Drawer.dart';
// // import 'package:crm/StaticData.dart';
// // import 'package:crm/providercolors.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:provider/provider.dart';

// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});

// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   AppConst obj = AppConst();
// //   final AppConst controller = Get.put(AppConst());

// //   @override
// //   Widget build(BuildContext context) {
// //     notifire = Provider.of<ColorNotifire>(context, listen: false);
// //     RxDouble? screenwidth = Get.width.obs;
// //     double? breakpoint = 600.0;
// //     if (screenwidth >= breakpoint) {
// //       return GetBuilder<AppConst>(builder: (controller) {
// //         return Scaffold(
// //           body: Column(
// //             children: [
// //               Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   controller.showDrawer
// //                       ? SizedBox(
// //                           height: MediaQuery.of(context).size.height,
// //                           width: 260,
// //                           child: const DarwerCode())
// //                       : const SizedBox(),
// //                   Expanded(
// //                     child: SizedBox(
// //                       height: MediaQuery.of(context).size.height,
// //                       width: MediaQuery.of(context).size.width,
// //                       child: Column(
// //                         children: [
// //                           const AppBarCode(),
// //                           Expanded(
// //                             child: Obx(() {
// //                               Widget selectedPage = controller
// //                                   .page[controller.pageselecter.value];
// //                               return selectedPage;
// //                             }),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         );
// //       });
// //     } else {
// //       return GetBuilder<AppConst>(builder: (controller) {
// //         return Scaffold(
// //           appBar: const AppBarCode(),
// //           drawer: const Drawer(width: 260, child: DarwerCode()),
// //           body: SizedBox(
// //             height: MediaQuery.of(context).size.height,
// //             width: MediaQuery.of(context).size.width,
// //             child: Obx(() {
// //               Widget selectedPage =
// //                   controller.page[controller.pageselecter.value];
// //               return selectedPage;
// //             }),
// //           ),

// //         );
// //       });
// //     }
// //   }
// // }
// import 'package:crm/AppBar.dart'; // Assuming you have a BottomAppBar equivalent
// import 'package:crm/AppStaticData.dart';
// import 'package:crm/AppStaticData/routes.dart';
// import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
// import 'package:crm/Controller/Drawer.dart';

// import 'package:crm/Providers/providercolors.dart';
// import 'package:crm/StaticData.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   AppConst obj = AppConst();
//   final AppConst controller = Get.put(AppConst());

//   @override
//   Widget build(BuildContext context) {
    // notifire = Provider.of<ColorNotifire>(context, listen: false);
    //    final notifier = Provider.of<ColorNotifire>(context);
//     RxDouble? screenwidth = Get.width.obs;
//     double? breakpoint = 600.0;
//     if (screenwidth >= breakpoint) {
//       return GetBuilder<AppConst>(builder: (controller) {
//         return Scaffold(
//            backgroundColor: notifire!.getbgcolor,
//           body: Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   controller.showDrawer
//                       ? SizedBox(
//                           height: MediaQuery.of(context).size.height,
//                           width: 260,
//                           child: const DarwerCode())
//                       : const SizedBox(),
//                   Expanded(
//                     child: SizedBox(
//                       height: MediaQuery.of(context).size.height,
//                       width: MediaQuery.of(context).size.width,
//                       child: Column(
//                         children: [
//                           // Remove the AppBar here
//                           Expanded(
//                             child: Obx(() {
//                               Widget selectedPage = controller
//                                   .page[controller.pageselecter.value];
//                               return selectedPage;
//                               // switch (controller.pageselecter.value) {
//                               //   case 0:
//                               //     return 
//                               //       Get.offAllNamed(Routes.homepage);
//                               // //  
//                               //   case 1:
//                               //     return Center(
//                               //       child: Text('Dashboard Page'),
//                               //     );
//                               //   case 2:
//                               //     return ViewSubscriber(
//                               //         subscriberId: controller.dynamicId.value);

//                               //   default:
//                               //     return Center(
//                               //       child: Text('Unknown Page'),
//                               //     );
//                               // }
//                             }),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           bottomNavigationBar:  BottomAppBar(
//                shadowColor:notifier.getprimerycolor ,
//              color: notifier.getprimerycolor,
//              surfaceTintColor: notifier.getprimerycolor,
//             child:const SizedBox(
//               // height: 60,
//               child: BottomAppBar(),
//             ),
//           ),
//         );
//       });
//     } else {
//       return GetBuilder<AppConst>(builder: (controller) {
       
//         return Scaffold(
//            backgroundColor: notifire!.getbgcolor,
//           // Remove the AppBar here
//           drawer: const Drawer(width: 260, child: DarwerCode()),
//           body: SizedBox(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: Obx(() {
//               Widget selectedPage = controller
//                                   .page[controller.pageselecter.value];
//                               return selectedPage;
//             }),
//           ),
          // bottomNavigationBar:  BottomAppBar(
          //   shadowColor:notifier.getprimerycolor ,
          //    color: notifier.getprimerycolor,
          //    surfaceTintColor: notifier.getprimerycolor,
          //   child:const AppBarCode(),
            
          // ),
//         );
//       });
//     }
//   }
// }
