
import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/model/subscriber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:widget_zoom/widget_zoom.dart';
import '../../service/subscriber.dart' as subscriberSrv;
import 'dart:io';
import 'package:flutter/widgets.dart';

class SubscriberGraph extends StatefulWidget {
  int? subscriberId;
  String? Username;
  SubscriberGraph({
    Key? key,
    required this.subscriberId,
    required this.Username,
  }) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<SubscriberGraph> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
    bool isSearching = false;
  bool row = false;
  bool isLoading = false;
  int currentPage = 0;
  int limit = 5;

  @override
  void initState() {
    super.initState();
    getRD_Graph();
    // print('UserName---${widget.Username}');
  }

  bool isExpanded1 = false;

  List<RD_Graph> rdGraph = [];

  Future<void> getRD_Graph() async {
     setState(() {
      isLoading = true; // Set loading to true when fetching data
    });
    RD_GraphResp resp = await subscriberSrv.getRD_Graph(widget.Username!);
    setState(() {
      if (resp.error) alert(context, resp.msg);
      rdGraph = [resp.rd_grap];
      isLoading = false;
    });

  }
Future<String> _createFolder() async {
  const folderName = "CRM";
  final directory = Directory('/storage/emulated/0/Download');  // Using Download directory for visibility
  final path = Directory('${directory.path}/$folderName');

  if (await path.exists()) {
    print("Folder already exists");
  } else {
    try {
      await path.create(recursive: true);
      print("Folder created successfully");
    } catch (e) {
      print("Error creating folder: $e");
    }
  }

  return path.path;
}


Future<void> _downloadImage(String base64Image, String folderPath) async {
  try {
    if (await _checkPermission()) {
      Uint8List bytes = base64Decode(base64Image);

      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final File imageFile = File('$folderPath/$fileName.jpg');
      await imageFile.writeAsBytes(bytes);

      final result = await ImageGallerySaver.saveFile(imageFile.path);
      if (result != null) {
        CherryToast.success(
          enableIconAnimation: false,
          animationType: AnimationType.fromRight,
          animationDuration: const Duration(milliseconds: 1000),
          autoDismiss: true,
          title: const Text('Image saved to gallery.'),
        ).show(context);
      } else {
        CherryToast.error(
          enableIconAnimation: false,
          animationType: AnimationType.fromRight,
          animationDuration: const Duration(milliseconds: 1000),
          autoDismiss: true,
          title: const Text('Failed to save image to gallery.'),
        ).show(context);
      }
    } else {
      CherryToast.error(
        enableIconAnimation: false,
        animationType: AnimationType.fromRight,
        animationDuration: const Duration(milliseconds: 1000),
        autoDismiss: true,
        title: const Text('Permission denied.'),
      ).show(context);
    }
  } on PlatformException catch (e) {
    print("Failed to save image: '$e'.");
  }
}
// Future<bool> _checkPermission() async {
//   if (await Permission.storage.request().isGranted) {
//     return true;
//   } else {
//     return false;
//   }
// }
  void _saveImageToFolder(String base64Image) async {
    final folderPath = await _createFolder();
    await _downloadImage(base64Image, folderPath);
  }
  @override
  
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: false);
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
       backgroundColor: notifier.getbgcolor,
      key: _key,
      resizeToAvoidBottomInset: false,
      body:Stack(
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
                          getRD_Graph();
                        },
                        icon: Icon(Icons.refresh, color: notifier.getMainText),
                      ),
                   ],
                 ),
               ),
              Expanded(
                child:
                
                 ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: rdGraph.length,
                  itemBuilder: (context, index) {
                    final graph = rdGraph[index];
                    return Column(
                        children: [
                          if (graph.d.isNotEmpty)
                          Stack(children: [
                            Padding(
                               padding: const EdgeInsets.all(10),
                              child:  
                                  WidgetZoom(
                                   zoomWidget:  
                                  Image.memory(
                                    base64Decode(graph.d),
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                  ), heroAnimationTag: 'tag',
                                  )
                                
                              
                            ),
                                if (graph.d.isNotEmpty)
                             Positioned(
                              right: 5,
                              bottom: 5,
                              child: 
                            IconButton(
            onPressed: () async {
              // final folderPath = await _createFolder();
              // _downloadImage(graph.d, folderPath);
             _saveImageToFolder(graph.d);
            },
            icon:  Icon(Icons.download,color: notifier.getMainText,),
          ),
                             )
                          ]
                          ),
                          if (graph.w.isNotEmpty)
                          Stack(children: [
                            Padding(
                            padding: const EdgeInsets.all(10),
                              child:  WidgetZoom(
                                   zoomWidget:  
                                  Image.memory(
                                    base64Decode(graph.w),
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                  ), heroAnimationTag: 'tag',
                                  )
                                
          
                            ),
                             if (graph.w.isNotEmpty)
                             Positioned(
                             right: 5,
                              bottom: 5,
                              child: 
                            IconButton(onPressed: () async {
                              //  final folderPath = await _createFolder();
                              //   _downloadImage(graph.w,folderPath);
                               _saveImageToFolder(graph.w);
                            }, icon: Icon(Icons.download,color: notifier.getMainText,)),),
           ],
                      ),
          
                          if (graph.m.isNotEmpty)
                          Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child:   WidgetZoom(
                                   zoomWidget:  
                                  Image.memory(
                                    base64Decode(graph.m),
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                  ), heroAnimationTag: 'tag',
                                  )
                                 
                            ),
                             if (graph.m.isNotEmpty)
                             Positioned(
                             right: 5,
                              bottom: 5,
                              child: 
                            IconButton(onPressed: () async {
                              //  final folderPath = await _createFolder();
                              //   _downloadImage(graph.m,folderPath);
                               _saveImageToFolder(graph.m);
                            }, icon:Icon(Icons.download,color: notifier.getMainText,)),)
                          ]),
                          if (graph.y.isNotEmpty)
                          Stack(children: [
                          
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child:   WidgetZoom(
                                   zoomWidget:  
                                  Image.memory(
                                    base64Decode(graph.y),
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                  ), heroAnimationTag: 'tag',
                                  )
                                
                            ),
                             if (graph.y.isNotEmpty)
                            Positioned(
                             right: 5,
                              bottom: 5,
                              child: 
                            IconButton(onPressed: () async {
                              //  final folderPath = await _createFolder();
                              //   _downloadImage(graph.y,folderPath);
                               _saveImageToFolder(graph.y);
                            }, icon:Icon(Icons.download,color: notifier.getMainText,)),
                            ),
                          ]),
                          const SizedBox(height: 10),
              //           ElevatedButton(
              //   onPressed: () {
              //     _createFolder();
              //   },
              //   child: Text('Create Folder'),
              // ),
                        ]
                    );
                  
                  }
                )
              ),
              const SizedBox(height: 15),
            ],
          ),
            if (isLoading) 
                           Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(
                          
                          ),
                        ),
                      ),
                    ), 
        ],
      ),
    );
  }

   Future<bool> _checkPermission() async { 
      return await Permission.photos.request().isGranted;
    }
  
  }

  