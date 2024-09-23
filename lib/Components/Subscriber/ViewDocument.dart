
// import 'package:crm/AppStaticData.dart';
// import 'package:crm/AppStaticData/toaster.dart';


// import 'package:crm/Providers/providercolors.dart';

// import 'package:crm/model/aadhar.dart';
// import 'package:crm/service/aadhar.dart';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:crm/service/subscriber.dart' as subscriberSrv;
// import 'package:crm/service/aadhar.dart' as aadharSrv;
// import 'package:provider/provider.dart';
// import 'package:reactive_forms/reactive_forms.dart';
// import 'package:widget_zoom/widget_zoom.dart';
// import '../../model/subscriber.dart';


// class ViewDocuments extends StatefulWidget {
//   final int subscriberId;

//   ViewDocuments({Key? key, required this.subscriberId}) : super(key: key);

//   @override
//   State<ViewDocuments> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<ViewDocuments> {
//   @override
//   void initState() {
//     super.initState();
//     _isMounted = true;
//     GetDocDetail(widget.subscriberId);
//   }

//   final form = FormGroup({
//     'client_id': FormControl<String>(validators: [Validators.required]),
//     'otp': FormControl<int>(validators: [Validators.required]),
//   });

//   Future<void> SubmitOPT(value) async {
//     final resp = await aadharSrv.submitAadharOPT(viewDocList.first.uid, viewDocList.first.fileid, value);
//     if (resp['error'] == false) {
//       alert(context, resp['msg'], resp['error']);
//       Navigator.pop(context, true);
//     }
//   }
// List<ViewDocument> viewDocList = [];
// Future<void> GetDocDetail(int subscriberId) async {
//   final resp = await subscriberSrv.viewDocument(subscriberId);
//   setState(() {
//     // Modify the filtering condition to include both typeid == 1 and typeid == 2
//     final docDet = resp.data?.where((element) => element.typeid == 1 || element.typeid == 2);
//     viewDocList = List<ViewDocument>.from(docDet!);
//     print('View-----${docDet.first.docid}');
//     if (resp.error) alert(context, resp.msg);
//     getFileData();
//   });
// }


//   bool _isMounted = false;

// List<Uint8List> filesData = [];
//   List<bool> isPDF = [];

//   Future<void> getFileData() async {
//     viewDocList.asMap().forEach((key, value) async {
//       FileDataResp resp = await subscriberSrv.getFileData(value.fileid);
//       if (!_isMounted) return;
//       setState(() {
//         if (resp.error) {
//           alert(context, resp.msg);
//         } else {
//           filesData.add(resp.file);
//         }
//       });
//     });
//   }
//   AadharService aadharSrvs = AadharService();
// List<GetOPT> OTP = [];
// Future<void> GetOTP() async {
   
//   final resp = await aadharSrvs.getOTP(viewDocList.first.docid,widget.subscriberId,viewDocList.first.fileid, true);
//   if (!(resp.error)) {
//       double screenWidth = MediaQuery.of(context).size.width;
//        final notifier = Provider.of<ColorNotifire>(context);
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         backgroundColor: notifier.getbgcolor,
//         actions: [
//           const SizedBox(height: 25),
//           ListTile(
//                                           title:  Text('Enter OTP',
//                                                style: TextStyle(
//                           fontSize: screenWidth * 0.02,
//                           color: notifier.getMainText,
//                                     fontWeight: FontWeight.w700,
//                         ),),
//                                                     trailing:IconButton(
//                                                       icon: Icon(
//                                                         Icons.close_rounded,color:notifier.getMainText,), // Add the close ico
//                                                          onPressed: () {
//                                                           Navigator.of(context).pop();
//                                                            },
//                                                             ), 
//                                           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0),
//             child: ReactiveForm(
//               formGroup: form,
//               child: ReactiveTextField<int>(
//                 formControlName: 'otp',
              
//                                                          style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
//                                                                            decoration: InputDecoration(
//                                                                             suffixIconColor: notifier.getMainText,
//                                                                              contentPadding:const EdgeInsets.only(left: 15),
                                                                
//                                                                               labelStyle: mediumGreyTextStyle.copyWith(
//                                             fontSize: 13),
//                                                                                labelText: 'Enter OPT',
//                                                                             enabledBorder: OutlineInputBorder(
//                                   borderRadius:BorderRadius .circular(10.0),
//                                   borderSide: BorderSide(
//                                       color: notifier.isDark
//                                           ? notifier.geticoncolor
//                                           : Colors.black)),
//                                                       border: OutlineInputBorder(
//                                   borderRadius:BorderRadius .circular(10.0),
//                                   borderSide: BorderSide(
//                                       color: notifier.isDark
//                                           ? notifier.geticoncolor
//                                           : Colors.black)),
//                                                                             ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child:ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                  backgroundColor: appMainColor,
//               ),
//               onPressed: () async {
//                 if (form.valid) {} else {
//                   form.markAllAsTouched();
//                     }
//                 await SubmitOPT(form.value);
//                  Navigator.of(context).pop();
//               },
//               child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
//             ),
//           ),
//         ],
//       ),
//     );
//   } else {
//     // Handle error case, maybe show an error message
//   }
//   setState(() {
//     form.control('client_id').patchValue(resp.clientId);
//   });
// }

// TextEditingController aadharController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//      final notifier = Provider.of<ColorNotifire>(context);
//     double screenWidth = MediaQuery.of(context).size.width;
//     return ReactiveForm(
//       formGroup: form,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//            Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                      Text(
//                         'View Document',
//                          style: TextStyle(
//                           fontSize: screenWidth * 0.04,
//                           color: notifier.getMainText,
//                                     fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                        CircleAvatar(
//                                                                         radius: 20,
//                                                                         child: IconButton(
//                                                                           onPressed: () {
//                                                                             Navigator.of(
//                                                                                 context)
//                                                                                 .pop();
//                                                                           },
//                                                                           icon: Icon(
//                                                                             Icons
//                                                                                 .close_rounded,
//                                                                                 color:notifier.getMainText,
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                     ],
//                   ),
//                 ),
              
//             const SizedBox(height: 25),
//            Text('Address Proof',
//                 style: TextStyle(
//                           fontSize: screenWidth * 0.04,
//                           color: notifier.getMainText,
//                                     fontWeight: FontWeight.w700,
//                         ),),
//             const SizedBox(height: 25),
            
//             Expanded(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 physics: const BouncingScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 itemCount: filesData.length,
//                 itemBuilder: (context, index) {
//                   final file = filesData[index];
//                   return Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Column(
//                         children: [
//                           if (filesData.isNotEmpty)
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 8.0),
//                               child: WidgetZoom(
//                                zoomWidget:  
//                               Image.memory(
//                                 file,
//                                 width: screenWidth,
//                                 fit: BoxFit.cover,
//                               ), heroAnimationTag: 'tag',
//                               )
                                
                                
                                
                              
//                             ),
//                           const SizedBox(height: 10),
//                         ],
//                       ),
                    
//                   );
//                 },
//               ),
//             ),
           
          
//             Visibility(
//   visible: viewDocList.isNotEmpty && viewDocList.first.verifymode < 1,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                    backgroundColor: appMainColor,
//                   ),
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (ctx) => AlertDialog(
//                         backgroundColor: notifier.getbgcolor,
//                         actions: [
//                           Column(
//                             children: viewDocList.map((document) {
//                               return Column(
//                                 children: [
//                                   ListTile(
//                                     title:  Text('Confirmation',
//                                         style: TextStyle(
//                           fontSize: screenWidth * 0.02,
//                           color: notifier.getMainText,
//                                     fontWeight: FontWeight.w700,
//                         ),),
//                                                       trailing:IconButton(
//                                                             icon:  Icon(
//                                                               Icons.close_rounded,color: notifier.getMainText,), // Add the close ico
//                                                                onPressed: () {
//                                                                 Navigator.of(context).pop();
//                                                                  },
//                                                                   ), 
                                    
//                                     onTap: () {
//                                       // Perform action when a document is tapped
//                                     },
//                                   ),
                              
//                                   Text('Aadhar Number:${document.docid}',
//                                     style: TextStyle(
//                           fontSize: screenWidth * 0.02,
//                           color: notifier.getMainText,
//                                     fontWeight: FontWeight.w700,
//                         ),),
//                                 ],
//                               );
//                             }).toList(),
//                           ),
//                               const SizedBox(height: 20),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                   backgroundColor: appMainColor,
//                                   ),
//                                   onPressed: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (ctx) => AlertDialog(
//                                         backgroundColor: notifier.getbgcolor,
//                                         actions: [
//                                            const SizedBox(height: 25),
//                                            Align(
//                                             alignment: Alignment.topLeft,
//                                             child: ListTile(
//                                             title:  Text('Enter Aadhar Number',
//                                                  style: TextStyle(
//                           fontSize: screenWidth * 0.02,
//                           color: notifier.getMainText,
//                                     fontWeight: FontWeight.w700,
//                         ),),
//                                                       trailing:IconButton(
//                                                         icon:   Icon(
//                                                           Icons.close_rounded,color: notifier.getMainText,), // Add the close ico
//                                                            onPressed: () {
//                                                             Navigator.of(context).pop();
//                                                              },
//                                                               ), 
//                                             ),
//                                           ),
//                                           const SizedBox(height: 15),
//                                           Align(
//                                             alignment: Alignment.topLeft,
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 controller: aadharController,
                                              
//                                                          style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
//                                                                            decoration: InputDecoration(
//                                                                             suffixIconColor: notifier.getMainText,
//                                                                              contentPadding:const EdgeInsets.only(left: 15),
                                                                
//                                                                               labelStyle: mediumGreyTextStyle.copyWith(
//                                             fontSize: 13),
//                                                                                labelText: 'Enter Aadhar Number',
//                                                                             enabledBorder: OutlineInputBorder(
//                                   borderRadius:BorderRadius .circular(10.0),
//                                   borderSide: BorderSide(
//                                       color: notifier.isDark
//                                           ? notifier.geticoncolor
//                                           : Colors.black)),
//                                                       border: OutlineInputBorder(
//                                   borderRadius:BorderRadius .circular(10.0),
//                                   borderSide: BorderSide(
//                                       color: notifier.isDark
//                                           ? notifier.geticoncolor
//                                           : Colors.black)),
//                                                                             ),),
//                                                         ),
//                                                         ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child:ElevatedButton(
//                                               style: ElevatedButton.styleFrom(
//                                                backgroundColor: appMainColor,
//                                                   ),
//                                                   onPressed: () async {
//                                                     if (aadharController.text.isNotEmpty) {
//                                                        viewDocList.first.docid = aadharController.text;
//                                                        await GetOTP();
//                                                        }},
//                                                        child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
//                                                        ),
//                                           ),
//                                         ],
//                                       ),
                                      
//                                     );
                                         
//                                   },
//                                   child: const Text('Update',
//                                                   style: TextStyle(
//                                                 color: Colors.white,
                                                  
//                                                   fontWeight: FontWeight.bold,
//                                                   ),),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child:ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                   backgroundColor: appMainColor,
//                                        ),
//                                        onPressed: () async {
//                                         if (form.valid) {
 
//                                         } else {
//                                           form.markAllAsTouched();}
//                                          await GetOTP();
//                                           },
//                                           child: const Text('Get OTP', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white))
//                                           ),
//                                           ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
                    
//                   },
//                   child: const Text('Verify Using Aadhar EKYCA', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:crm/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';


import 'package:crm/Providers/providercolors.dart';

import 'package:crm/model/aadhar.dart';
import 'package:crm/service/aadhar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:crm/service/subscriber.dart' as subscriberSrv;
import 'package:crm/service/aadhar.dart' as aadharSrv;
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:widget_zoom/widget_zoom.dart';
import '../../model/subscriber.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;
import 'package:mime/mime.dart';


class ViewDocuments extends StatefulWidget {
  final int subscriberId;

  ViewDocuments({Key? key, required this.subscriberId}) : super(key: key);

  @override
  State<ViewDocuments> createState() => _MainScreenState();
}

class _MainScreenState extends State<ViewDocuments> {
  @override
  void initState() {
    super.initState();
    _isMounted = true;
      fetchData();
    GetDocDetail(widget.subscriberId);
  }
  bool isLoading = false;
Future<void> fetchData() async {
    setState(() {
      isLoading = true; // Start loading
    });

    // Simulate a network call or data fetching
    await Future.delayed(Duration(seconds: 2)); // Replace with your data fetching logic

    setState(() {
      isLoading = false; // Stop loading
    });
  }
  final form = FormGroup({
    'client_id': FormControl<String>(validators: [Validators.required]),
    'otp': FormControl<int>(validators: [Validators.required]),
  });

  Future<void> SubmitOPT(value) async {
    final resp = await aadharSrv.submitAadharOPT(viewDocList.first.uid, viewDocList.first.fileid, value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }
List<Uint8List> filesData = [];
  Map<int, String> pdfTextMap = {}; // Store text extracted from PDFs
  bool _isMounted = false;

  @override
  
  List<ViewDocument> viewDocList = [];
  Future<void> GetDocDetail(int subscriberId) async {
    final resp = await subscriberSrv.viewDocument(subscriberId);
    setState(() {
      final docDet = resp.data?.where((element) => element.typeid == 1 || element.typeid == 2);
      viewDocList = List<ViewDocument>.from(docDet!);
      if (resp.error) alert(context, resp.msg);
      getFileData();
    });
  }
Future<void> getFileData() async {
  for (var value in viewDocList) {
    FileDataResp resp = await subscriberSrv.getFileData(value.fileid);
    if (!_isMounted) return;
    setState(() {
      if (resp.error) {
        alert(context, resp.msg);
      } else {
        filesData.add(resp.file);
        // Detect the MIME type of the file
        final mimeType = lookupMimeType('', headerBytes: resp.file);
        
        // Extract text from the PDF if it's a PDF file
        if (mimeType != null && mimeType == 'application/pdf') {
          final pdf = pw.Document();
          pdf.addPage(pw.Page(
            build: (pw.Context context) => pw.Text('Example text')
          ));
          final pdfText = extractTextFromPdf(pdf);
          pdfTextMap[value.fileid] = pdfText;
        }
      }
    });
  }
}

  String extractTextFromPdf(pw.Document pdf) {
    return "PDF";
  }  AadharService aadharSrvs = AadharService();
List<GetOPT> OTP = [];

Future<void> GetOTP() async {
   
  final resp = await aadharSrvs.getOTP(viewDocList.first.docid,widget.subscriberId,viewDocList.first.fileid, true);
  if (!(resp.error)) {
      double screenWidth = MediaQuery.of(context).size.width;
       final notifier = Provider.of<ColorNotifire>(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: notifier.getbgcolor,
        actions: [
          const SizedBox(height: 25),
          ListTile(
                                          title:  Text('Enter OTP',
                                               style: TextStyle(
                          fontSize: screenWidth * 0.02,
                          color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                        ),),
                                                    trailing:IconButton(
                                                      icon: Icon(
                                                        Icons.close_rounded,color:notifier.getMainText,), // Add the close ico
                                                         onPressed: () {
                                                          Navigator.of(context).pop();
                                                           },
                                                            ), 
                                          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ReactiveForm(
              formGroup: form,
              child: ReactiveTextField<int>(
                formControlName: 'otp',
              
                                                         style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                            suffixIconColor: notifier.getMainText,
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText: 'Enter OPT',
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
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                 backgroundColor: appMainColor,
              ),
              onPressed: () async {
                if (form.valid) {} else {
                  form.markAllAsTouched();
                    }
                await SubmitOPT(form.value);
                 Navigator.of(context).pop();
              },
              child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  } else {
    // Handle error case, maybe show an error message
  }
  setState(() {
    form.control('client_id').patchValue(resp.clientId);
  });
}

TextEditingController aadharController = TextEditingController();
  @override
  Widget build(BuildContext context) {
     final notifier = Provider.of<ColorNotifire>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return ReactiveForm(
      formGroup: form,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text(
                        'View Document',
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
                                                                          icon: Icon(
                                                                            Icons
                                                                                .close_rounded,
                                                                                color:notifier.getMainText,
                                                                          ),
                                                                        ),
                                                                      ),
                    ],
                  ),
                ),
              
            const SizedBox(height: 25),
           Text('Address Proof',
                style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                        ),),
            const SizedBox(height: 25),
         if (isLoading)
             const  CircularProgressIndicator(color: appMainColor,)
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: filesData.length,
                  itemBuilder: (context, index) {
                    final file = filesData[index];
                    final fileId = viewDocList[index].fileid;
                    final mimeType = lookupMimeType('', headerBytes: file); // Detect MIME type
                    final isPDF = mimeType == 'application/pdf';

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          if (isPDF)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: appMainColor),
                              child: Text(
                                pdfTextMap[fileId] ?? 'No text available',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => Dialog.fullscreen(
                                    backgroundColor: notifier.getbgcolor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PDFViewScreen(file: file),
                                    ),
                                  ),
                                );
                              },
                            ),

                          // Display images for other MIME types
                          if (!isPDF && mimeType != null && mimeType.startsWith('image/'))
                            Image.memory(
                              file,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),


            Visibility(
  visible: viewDocList.isNotEmpty && viewDocList.first.verifymode < 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                   backgroundColor: appMainColor,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: notifier.getbgcolor,
                        actions: [
                          Column(
                            children: viewDocList.map((document) {
                              return Column(
                                children: [
                                  ListTile(
                                    title:  Text('Confirmation',
                                        style: TextStyle(
                          fontSize: screenWidth * 0.02,
                          color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                        ),),
                                                      trailing:IconButton(
                                                            icon:  Icon(
                                                              Icons.close_rounded,color: notifier.getMainText,), // Add the close ico
                                                               onPressed: () {
                                                                Navigator.of(context).pop();
                                                                 },
                                                                  ), 
                                    
                                    onTap: () {
                                      // Perform action when a document is tapped
                                    },
                                  ),
                              
                                  Text('Aadhar Number:${document.docid}',
                                    style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                        ),),
                                ],
                              );
                            }).toList(),
                          ),
                              const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  backgroundColor: appMainColor,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        backgroundColor: notifier.getbgcolor,
                                        actions: [
                                           const SizedBox(height: 25),
                                           Align(
                                            alignment: Alignment.topLeft,
                                            child: ListTile(
                                            title:  Text('Enter Aadhar Number',
                                                 style: TextStyle(
                          fontSize: screenWidth * 0.02,
                          color: notifier.getMainText,
                                    fontWeight: FontWeight.w700,
                        ),),
                                                      trailing:IconButton(
                                                        icon:   Icon(
                                                          Icons.close_rounded,color: notifier.getMainText,), // Add the close ico
                                                           onPressed: () {
                                                            Navigator.of(context).pop();
                                                             },
                                                              ), 
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller: aadharController,
                                              
                                                         style: TextStyle(color: notifier.getMainText),
                                                                          
                                                                         
                                                                           decoration: InputDecoration(
                                                                            suffixIconColor: notifier.getMainText,
                                                                             contentPadding:const EdgeInsets.only(left: 15),
                                                                
                                                                              labelStyle: mediumGreyTextStyle.copyWith(
                                            fontSize: 13),
                                                                               labelText: 'Enter Aadhar Number',
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
                                                                            ),),
                                                        ),
                                                        ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                               backgroundColor: appMainColor,
                                                  ),
                                                  onPressed: () async {
                                                    if (aadharController.text.isNotEmpty) {
                                                       viewDocList.first.docid = aadharController.text;
                                                       await GetOTP();
                                                       }},
                                                       child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                                       ),
                                          ),
                                        ],
                                      ),
                                      
                                    );
                                         
                                  },
                                  child: const Text('Update',
                                                  style: TextStyle(
                                                color: Colors.white,
                                                  
                                                  fontWeight: FontWeight.bold,
                                                  ),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                  backgroundColor: appMainColor,
                                       ),
                                       onPressed: () async {
                                        if (form.valid) {
 
                                        } else {
                                          form.markAllAsTouched();}
                                         await GetOTP();
                                          },
                                          child: const Text('Get OTP', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white))
                                          ),
                                          ),
                            ],
                          ),
                        ],
                      ),
                    );
                    
                  },
                  child: const Text('Verify Using Aadhar EKYCA', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFViewScreen extends StatelessWidget {
  final Uint8List file;

  PDFViewScreen({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context);
    return Scaffold(
      backgroundColor: notifier.getbgcolor,
      appBar: AppBar(
        title:const Text('View Document'),
      ),
      body: PDFView(
        pdfData: file,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: true,
        onRender: (_pages) {},
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appMainColor,
        onPressed: (){

          Navigator.of(context).pop();
        },child:const Text('OK',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),),
    );
  }
}