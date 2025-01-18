import 'dart:convert';
// import 'dart:ui';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/components/Subscriber/SubscriberInvoice/SubsInvoicePayStatus.dart';
import 'package:crm/model/subscriber.dart';

import 'package:flutter/widgets.dart';



import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../service/subscriber.dart' as subscriberSrv;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:num_to_words/num_to_words.dart';


import 'package:flutter/services.dart' show rootBundle;




class SubscriberInvoice extends StatefulWidget {
  int? subscriberId;
  SubscriberInvoice({
    Key? key,
    required this.subscriberId,
  }) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<SubscriberInvoice> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isSearching = false;
  bool row = false;

  List<InvoiceDet> listSubsInvoive = [];
  bool isLoading = false;


  int currentPage = 1;


  bool _isMounted = false;

    FormGroup? form;
    
 int levelid = 0;
  bool isIspAdmin = false;
  int id=0;
  int selectedAmount = 0;
  bool isSubscriber=false;
 getMenuAccess() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    levelid = pref.getInt('level_id') as int;
    isIspAdmin = pref.getBool('isIspAdmin') as bool;
    id = pref.getInt('id') as int;
    isSubscriber = pref.getBool('isSubscriber') as bool;
    
  }

  void initializeForm() {
    form = FormGroup({
      'collectedid': FormControl<int>(),
      'invid': FormControl<int>(validators: [Validators.required]),
      'note': FormControl<String>(),
      'pay_status': FormControl<int>(validators: [Validators.required]),
      'pay_type': FormControl<int>(validators: [Validators.required]),
      'paydate': FormControl<String>(validators: [Validators.required]),
       'userpayedamt': FormControl<int>(validators: [Validators.required]),
      
    });
  }
 Map<String, int> pay_status = {
    'Unpaid': 1,
    'Paid': 2,
  };
   Map<String, int> paymentMode = {
    'User Paid(Cash)': 0,
    'User Paid(Online)': 1,
  };
  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> GetSubsInvoice() async {
      setState(() {
      isLoading = true; // Set loading to true when fetching data
    });
    InvoiceDetResp resp =
    await subscriberSrv.getInvoice(widget.subscriberId!);
    if (!_isMounted) return; // Check if the widget is still mounted
    setState(() {
      if (resp.error) alert(context, resp.msg);
      listSubsInvoive = resp.error ? [] : resp.data ?? [];
       isLoading = false;
    });
  }



  @override
  void initState() {
    super.initState();
    getMenuAccess();
    GetEmployeeList();
    initializeForm();
    _isMounted = true;
    GetSubsInvoice();
    getISP_Logo();
    

  }
List<EmployeeList> getEmployeeList = [];
 final int itemsPerPage = 5;
Future<void> GetEmployeeList() async {
  EmployeeListResp resp = await subscriberSrv.GetEmpList();
  if (!_isMounted) return;
  setState(() {
    if (resp.error) {
      alert(context, resp.msg);
    } else {
      getEmployeeList = resp.data ?? [];
    }
  });
}

String getServiceType(String? packtype, {String defaultValue = '---'}) {
  if (packtype == null || packtype.isEmpty) {
    return defaultValue;
  }

  switch (packtype) {
    case '1':
      return 'Internet';
    case '1,2':
      return 'Internet & Voice';
    case '1,3':
      return 'Internet & OTT';
    case '1,2,3':
      return 'All';
    default:
      return 'Unknown';
  }
}



  bool isExpanded1 = false;


  List<ISP_Logo> logo = [];

  Future<void> getISP_Logo() async {
    ISP_LogoResp resp = await subscriberSrv.getIsp_logo();
    if (!_isMounted) return;
    setState(() {
      if (resp.error) alert(context, resp.msg);
      logo = [resp.logo]; // Assigning resp.logo to logo
    });
  }

  double? taxPercentage;
      double? amount;
  int? taxMode;
  double? taxAmt = 0;
  late pw.Document pdf;
Future<void> generateInvoice(int invid) async {
    pdf = pw.Document();

    final invoice = listSubsInvoive.firstWhere((element) => element.invid == invid);
final customFont = pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Regular.ttf"));



pw.TextStyle commonTextStyle = pw.TextStyle(
  font: pw.Font.timesBold(), 
  fontFallback: [customFont], // Wrap in a list
);


    String serviceType = '';
    if (invoice.packtype == "1,2") {
      serviceType = 'Internet & Voice';
    } else if (invoice.packtype == "1,3") {
      serviceType = 'Internet & OTT';
    } else {
      serviceType = 'Internet';
    }
    double? tax() {

      if (taxMode == 0) {
        taxAmt = ( invoice.allamount * 9.0) / (100 + 9.0);
      } else {
        taxAmt = (invoice.allamount / 100) * 9.0;
      }
      taxAmt = double.parse(taxAmt!.toStringAsFixed(2));
      print("TaX Amount----$taxAmt");
      return taxAmt;
    }
    pw.Widget buildCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(text, style: pw.TextStyle(color: PdfColors.black)),
    );
  }

  pw.Widget buildHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      ),
    );
  }


  pw.Widget tableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(
        text,
       style: pw.TextStyle(font: pw.Font.timesBold()),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(
        text,
         style: pw.TextStyle(font: pw.Font.times()),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildCommonListTile({
  required String title,
  required String subtitle,
}) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);

  return 
  pw.Column(children: [
  pw.Container(
    padding: const pw.EdgeInsets.fromLTRB(5, 0, 5, 0), // Control the gap between items
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start, // Align children to start to handle long text
      children: [
        pw.Expanded(
          child: pw.Text(
            title,
           style: pw.TextStyle(font: pw.Font.times()),
          ),
        ),
      pw.SizedBox(width: 10), // Add some spacing between title and subtitle
        pw.Expanded(
          child: pw.Text(
            subtitle,
              style: commonTextStyle,
          
          ),
        ),
      ],
    ),
  ),
    pw.Divider()
  ]
  );
}

  pw.Widget _buildCommonListTile1({
  required String title,
  required String subtitle,
}) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);

  return 
  pw.Column(children: [
  pw.Container(
  padding: const pw.EdgeInsets.fromLTRB(5, 0, 5, 0),// Control the gap between items
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start, // Align children to start to handle long text
      children: [
        pw.Expanded(
          child: pw.Text(
            title,
           style: pw.TextStyle(font: pw.Font.times()),
          ),
        ),
      pw.SizedBox(width: 10), // Add some spacing between title and subtitle
        pw.Expanded(
          child: pw.Text(
            subtitle,
             style: commonTextStyle,
          
          ),
        ),
      ],
    ),
  ),
//  pw. Divider()
  ]
  );
}



  pw.Widget _buildCommonListTile3({required String title, required String subtitle}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.RichText(
          text: pw.TextSpan(
            children: [
               pw.TextSpan(text: title,  style: pw.TextStyle(font: pw.Font.times()),),
              pw.TextSpan(text: subtitle, style: pw.TextStyle(font: pw.Font.timesBold()),),
            ]
          ),
        ),
      ],
    );
  }

    pdf.addPage(
      pw.Page(
         
        build: (context) {
          return 
        
          pw.Container(
            //  padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          // borderRadius: pw.BorderRadius.circular(10),
          border: pw.Border.all(color: PdfColors.black), // Corrected color reference
        ),
            child: 
          
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Padding(
                   padding: const pw.EdgeInsets.all(8),
                child: 
            pw.Stack(children: [
         pw.Row(
          
          children: [   
    pw.Image(
      pw.MemoryImage(
        base64Decode(logo.first.ispLogo), // Assuming logo is fetched and stored as base64
      ),
      width: 80,
      height: 80,
    ),
    pw.SizedBox(width: 20),
    pw.RichText(
  text: pw.TextSpan(
    children: [
      pw.TextSpan(
        text: "Grey Sky Internet Services Pvt Ltd\n",
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: pw.Font.timesBold()),
      ),
      pw.TextSpan(
        text: "No.17/34e, Santhaiyadi Street, Udangudi,\nThoothukudi, Tamil Nadu, 628203,\n",
        style: pw.TextStyle(font: pw.Font.times()),
      ),
      pw.TextSpan(
        text: "bmssupport@gsisp.in\n",
        style: pw.TextStyle(font: pw.Font.times(), color: const PdfColor.fromInt(0xff0059E7),),
      ),
      pw.TextSpan(
        text: "9442887912\n",
        style: pw.TextStyle(font: pw.Font.times()),
      ),
      pw.TextSpan(
        text: "GSTIN : ",
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: pw.Font.times()),
      ),
      pw.TextSpan(
        text: "${invoice.supplierGst.isNotEmpty ? invoice.supplierGst : "33AAJCG9282G1ZC"}\n",
        style: pw.TextStyle(font: pw.Font.timesBold()),
      ),
       pw.TextSpan(
        text: "PAN : ",
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: pw.Font.times()),
      ),
      pw.TextSpan(
        text: "${invoice.buspan.isNotEmpty ? invoice.buspan : "AAJCG9282G"}\n",
        style: pw.TextStyle(font: pw.Font.timesBold()),
      ),
       pw.TextSpan(
        text: "HSN : ",
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: pw.Font.times()),
      ),
      pw.TextSpan(
        text: "${invoice.bushsn.isNotEmpty ? invoice.bushsn : "9984"}\n",
        style: pw.TextStyle(font: pw.Font.timesBold()),
      ),
    ],
  ),
),

   
         ]
         ),
    pw.Positioned(
            bottom: 8,
  right: 8,
              child: pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: "Tax Invoice\n",
            style: pw.TextStyle(fontSize: 18, font: pw.Font.timesBold()),
          ),
          pw.TextSpan(
            text: "Invoice# ",
            style: pw.TextStyle(font: pw.Font.times()),
          ),
           pw.TextSpan(
            text: invoice.invno,
            style: pw.TextStyle(font: pw.Font.timesBold()),
          ),
        ],
      ),
    ),
            ),
            
 
            ]
            ),
              ),
 pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0:const pw.FlexColumnWidth(2),
                  1:const pw.FlexColumnWidth(2),
                  2:const pw.FlexColumnWidth(1),
                  3:const pw.FlexColumnWidth(1),
                },
                children: [
                   pw.TableRow(
                    children: [
                      pw.Padding(
                         padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Column(children: [
                         _buildCommonListTile3(title: 'Invoice Date ',subtitle:': ${invoice.invdate.isNotEmpty  ? DateFormat.yMd().format(DateTime.parse(invoice.invdate).toLocal()) : "---"}'),
                         pw.SizedBox(height: 8),
                           _buildCommonListTile3(title: 'Billing Period ',subtitle:': ${invoice.invdate.isNotEmpty  ? DateFormat('MM-dd-yyyy').format(DateTime.parse(invoice.invdate).toLocal()): "---" } To ${invoice.expiration.isNotEmpty  ? DateFormat('MM-dd-yyyy').format(DateTime.parse(invoice.expiration).toLocal()):"---"}'),
                            pw.SizedBox(height: 8),
                            _buildCommonListTile3(title: 'Paid Status ',subtitle:': ${invoice.payStatus == 1 ? 'Unpaid' : 'Paid'}'),
                             if(invoice.payStatus==2)
                             pw.SizedBox(height: 8),
                            if(invoice.payStatus==2)
                              _buildCommonListTile3(title: 'Paid Date ',subtitle:': ${invoice.paydate.isNotEmpty  ? DateFormat.yMMMMd('en_US').format(DateTime.parse(invoice.paydate).toLocal()): "---" }'),
                               pw.SizedBox(height: 8),
                              _buildCommonListTile3(title: 'Customer Mobile ',subtitle:': ${invoice.mobile}'),
                        ])
                      

                      ),
pw.Padding(
    padding: const pw.EdgeInsets.all(8.0),
  child: 
  pw.Column(children: [
                         _buildCommonListTile3(title: 'Place Of Supply ',subtitle:': Tamil Nadu'),
                         pw.SizedBox(height: 8),
                          _buildCommonListTile3(title: 'Service Type',subtitle: ': ${getServiceType(invoice.packtype, defaultValue: "IP")}'),
                            pw.SizedBox(height: 8),
                            _buildCommonListTile3(title: 'Validity ',subtitle:': ${invoice.expiration.isNotEmpty  ? DateFormat.yMMMMd('en_US').add_jm() .format(DateTime.parse(invoice.expiration).toLocal()): "---" }'),
                            if(invoice.recipientGst.isNotEmpty)
                             pw.SizedBox(height: 8),
                             if(invoice.recipientGst.isNotEmpty)
                              _buildCommonListTile3(title: 'GST ',subtitle:': ${invoice.recipientGst}'),
                               pw.SizedBox(height: 8),
                              _buildCommonListTile3(title: 'State Code ',subtitle:': 33'),
                        ])
                      

     
),
                    ],
                  ),
                  // First row: Invoice and Billing details
                 
                  // Second Section: Bill To and Ship To
                  pw.TableRow(
                 
                    children: [
                      pw.Padding(
                        
                           padding: const pw.EdgeInsets.all(8.0),
                        child: 
                      pw.Text('Bill To',  style: pw.TextStyle(font: pw.Font.timesBold(),lineSpacing: 4, )),),

                      pw.Padding(
                           padding: const pw.EdgeInsets.all(8.0),
                        child: 
                     pw.Text('Ship To',  style: pw.TextStyle(font: pw.Font.timesBold(),lineSpacing: 4, )))
                     
                    ],
                  ),
                  pw.TableRow(
                    children: [
                     
                        pw.Column(
                          // mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: 
                      pw.Text('${invoice.subname}\nProfileID : ${invoice.subprofileid}',  style: pw.TextStyle(font: pw.Font.timesBold(),lineSpacing: 4, )),),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                        child: 
                       pw.Text(invoice.subbilladdress,  style: pw.TextStyle(font: pw.Font.times(),lineSpacing: 4, ))),
                    ]
                  ),
                      

                     pw.Column(
                           crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: 
                      pw.Text('${invoice.subname}\nProfileID : ${invoice.subprofileid}',  style: pw.TextStyle(font: pw.Font.timesBold(),lineSpacing: 4, )),),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                        child: 
                       pw.Text(invoice.subaddress,  style: pw.TextStyle(font: pw.Font.times(),lineSpacing: 4, ))),
                    ]
                  ),
                    ],
                  ),

                  
                ],
              ),
              // ignore: deprecated_member_use
              pw.Table.fromTextArray(
  context: context,
  border: pw.TableBorder.all(),
  headerStyle:pw.TextStyle(font: pw.Font.timesBold()),
  cellStyle: pw.TextStyle(font: pw.Font.times()),
  cellAlignment: pw.Alignment.center,
  headerAlignment: pw.Alignment.center,
  cellHeight: 30,
    cellAlignments: {
      0: pw.Alignment.center,
      1: pw.Alignment.center,
      2: pw.Alignment.center,
      3: pw.Alignment.center,
      4: pw.Alignment.center,
      5: pw.Alignment.center,
      6: pw.Alignment.center,
      7: pw.Alignment.center,
      8: pw.Alignment.center,
      9: pw.Alignment.center,
    },
  headers: ['#', 'Item', 'Rate', 'CGST\n%', 'CGST\nAmt', 'SGST\n%', 'SGST\nAmt', 'IGST\n%', 'IGST\nAmt', 'Total\nAmount'],
  data: [
    ['1', invoice.packname.isNotEmpty ? invoice.packname : invoice.additionalinfo, invoice.allamount.toString(), 
    invoice.cgst.toString().isNotEmpty == true ? invoice.cgst.toString() : "---",
     invoice.alltaxamt.toString(), 
     invoice.sgst.toString().isNotEmpty == true ? invoice.sgst.toString() : "---", 
     invoice.alltaxamt.toString(), 
     invoice.igst.toString().isNotEmpty == true ? invoice.igst.toString() : "---", 
     '--', invoice.totalamount.toString()],
    // Add more rows as needed
  ],
),

          pw.Spacer(),
 pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0:const pw.FlexColumnWidth(2),
                  1:const pw.FlexColumnWidth(2),
                  2:const pw.FlexColumnWidth(1),
                  3:const pw.FlexColumnWidth(1),
                },
                children: [
                   pw.TableRow(
                    children: [
                    pw.Padding(
    padding: const pw.EdgeInsets.all(8.0),
  child: 
      pw.RichText(
      text: pw.TextSpan(
        children: [
        
          pw.TextSpan(
            text: "Total In Words\n",
            style: pw.TextStyle(font: pw.Font.timesBold(),
               lineSpacing: 4, 
            ),
            
          ),
          pw.TextSpan(
             text: "Indian Rupees ${invoice.totalamount.toWords().toUpperCase()} Rupees Only\n",
            style: pw.TextStyle(font: pw.Font.times(),
               lineSpacing: 4, 
            ),
          ),
          // pw.TextSpan(
          //         text: 'Companys Bank Details:\n',
          //        style: pw.TextStyle(font: pw.Font.timesBold(),
          //      lineSpacing: 4, 
                
          //       ),
          //       ),
                 pw.TextSpan(
                  text: 'Account name : Grey Sky Internet Services Pvt Ltd\n',
                 style: pw.TextStyle(font: pw.Font.timesItalic(),
               lineSpacing: 4, 
                
                ),
                ),
                pw.TextSpan(
                  text: 'SBI Account No : 20509877576',
                 style: pw.TextStyle(font: pw.Font.timesItalic(),
               lineSpacing: 4, 
                
                ),
                ),
                
                pw.TextSpan(
                  text: '\nSBI IFSC Code : SBIN0002283',
                  style: pw.TextStyle(font: pw.Font.timesItalic(),
               lineSpacing: 4, 
                
                ),
                ),
              //    pw.TextSpan(
              //     text: '\nBRANCH : Branch',
              //     style: pw.TextStyle(font: pw.Font.timesItalic(),
              //  lineSpacing: 4, 
                
              //   ),
              //   ),
        ],
      ),
    ),
), 


     pw.Column(children: [
     
_buildCommonListTile(title: 'Sub Total\n(Tax Exclusive)',subtitle: invoice.allamount.toString()),

_buildCommonListTile(title: 'CGST (9%)',subtitle: invoice.alltaxamt.toString()),
_buildCommonListTile(title: 'SGST (9%)',subtitle: invoice.alltaxamt.toString()),
_buildCommonListTile(title: 'Total',subtitle: '₹ ${invoice.totalamount.toString()}'),
_buildCommonListTile1(title: 'Balance Due',subtitle:'₹ ${invoice.balancedue.toString()}'),

     ])

                    ],
                  ),                 
                ],
              ),          
              pw.SizedBox(height: 10),
          pw.Center(child:
              pw.Text('** This is computer generated invoice no signature required **',  style: pw.TextStyle(font: pw.Font.timesBold()))),
              pw.Divider(),
                 pw.Spacer(),
            ],
          ),
          );
        },
      ),
    );
    tax();
  }
Future<void> _checkAndSavePDF(int invid) async {
  // Check for permission
  bool isGranted = await _checkPermission();

  // If permission is granted, proceed to save and open the PDF
  if (isGranted) {
    generateInvoice(invid);
    final filePath = await savePDF(invid);

    // Automatically open the PDF after saving it
    OpenFile.open(filePath);
  } else {
    // If permission is denied, show a message (optional)
     CherryToast.error(
        enableIconAnimation: false,
        animationType: AnimationType.fromRight,
        animationDuration: const Duration(milliseconds: 1000),
        autoDismiss: true,
        title: const Text('Permission denied.'),
      ).show(context);
  }
}

Future<bool> _checkPermission() async {
     return await Permission.photos.request().isGranted;
}


Future<String> savePDF(int invid) async {
  Directory? output;
  if (Platform.isAndroid || Platform.isIOS) {
    output = await getExternalStorageDirectory();
  } else {
    print('Unsupported platform');
    return '';
  }

  final now = DateTime.now();
  final timestamp = '${now.day}-${now.month}-${now.year}-${now.hour}-${now.minute}-${now.second}';
  const fileName = "Tax Invoice.pdf";

  final file = File("${output!.path}/$fileName");
  await file.writeAsBytes(await pdf.save());

  return file.path;  // Return the file path so it can be opened
}



// Utility function to get the label for invmode
String getInvoiceModeLabel(int invmode) {
  const invoiceModes = [
    {'id': 1, 'label': 'Pack'},
    {'id': 2, 'label': 'Data'},
    {'id': 3, 'label': 'IP'},
  ];

  final mode = invoiceModes.firstWhere(
    (mode) => mode['id'] == invmode,
    orElse: () => {'id': 0, 'label': 'Unknown'}, // Default value for unknown modes
  );

  return mode['label'] as String;
}
String getRenewalTypeLabel(int renewType) {
  const renewalType = [
    {'id': 1, 'label': 'Reseller Renewal'},
    {'id': 2, 'label': 'Reseller Schedule'},
    {'id': 3, 'label': 'Subscriber Online Renewal'},
    {'id': 4, 'label': 'Subscriber Online Schedule'},
  ];

  final type = renewalType.firstWhere(
    (type) => type['id'] == renewType,
    orElse: () => {'id': 0, 'label': 'Unknown'}, // Default value for unknown modes
  );

  return type['label'] as String;
}

String getLocalityLabel(int local) {
  const renewalType = [
    {'id': 0, 'label': 'Urban(City)'},
    {'id': 1, 'label': 'Rural(Village)'},
  
  ];

  final locali = renewalType.firstWhere(
    (locali) => locali['id'] == local,
    orElse: () => {'id': 0, 'label': 'Unknown'}, // Default value for unknown modes
  );

  return locali['label'] as String;
}

  @override
  Widget build(BuildContext context) {
      final startIndex = (currentPage - 1) * itemsPerPage;
  final endIndex = (startIndex + itemsPerPage <  listSubsInvoive.length)
      ? startIndex + itemsPerPage
      :  listSubsInvoive.length;

  final paginatedList =  listSubsInvoive.sublist(startIndex, endIndex);
   final notifier = Provider.of<ColorNotifire>(context);
    
     double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
            backgroundColor:notifier.getbgcolor,
            key: _key,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                                        children: [
                                           Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                               children: [
                                                 IconButton(
                                                               onPressed: () async {
                                                                 GetSubsInvoice();
                                                               },
                                                               icon: Icon(Icons.refresh, color: notifier.getMainText),
                                                             ),
                                               ],
                                             ),
                                           ),
                                         
                        Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                             itemCount: paginatedList.length,
                              itemBuilder: (context, index) {
                          
                               final invoice = paginatedList[index];                 
                                return Column(
                                  children: [
                                    Container(
                                       padding:const EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                                            ),
                                      child: Column(
                                        children: [
                                           
                                          Padding(
                                            padding: const EdgeInsets.all(0),
                                            
                                              child: ExpansionTile(
                                                collapsedIconColor:  notifier.getMainText ,
                                                iconColor: notifier.getMainText ,
                                                expandedAlignment:
                                                Alignment.topLeft,
                                                leading:  Text(
                                                  'INVOICE ID',
                                                  textScaleFactor: 1,
                                               style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                ),
                                                title:
                                                Row(
                                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(invoice.invid.toString(),
                                                        textScaleFactor: 1,
                                                          style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                    ),
                                                    IconButton(
                                                      icon:  Icon(Icons.download,color: notifier.getMainText ,),
                                                      onPressed: () {
                                                // Check and save the PDF
                                                 generateInvoice(invoice.invid);
                                                 _checkAndSavePDF(invoice.invid);
                                              },
                                                      // onPressed: () {
                                                      //   generateInvoice(invoice.invid);
                                                      //   savePDF(invoice.invid);
                                                      // },
                                                    ),
                                      
                                                    Visibility(
                                                      visible:invoice.payStatus ==1 && isSubscriber==false,
                                                      child: IconButton(
                                                        icon:  Icon(Icons.currency_rupee,color: notifier.getMainText ),
                                                        onPressed: () {
                                          //                                         
                                                          showDialog(
                                                    context: context,
                                                    builder: (ctx) =>
                                                         Dialog.fullscreen(
                                                         
                                                       
                                                         child: InvoicePaymentStatus(invoiceId: invoice.invid, totAmt: invoice.totalamount) as Widget,
                                      
                                                         
                                      
                                                        ),
                                                  ).then((val) => {
                                                      // print('dialog--$val'),
                                                      if (val)   GetSubsInvoice()
                                                    });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                children: [
                                                  Column(
                                                    children: [
                                                       SizedBox(
                                                  height: 150,
                                                  width: screenWidth,
                                                   child: ListView(
                                                     scrollDirection: Axis.horizontal,
                                                    
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.topLeft,
                                                        child: SingleChildScrollView(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Table(
                                                              border: TableBorder.all(borderRadius: BorderRadius.circular(10),color: notifier.getMainText ),
                                                              columnWidths: const {
                                                                0: FixedColumnWidth(150),
                                                                1: FixedColumnWidth(150),
                                                                2: FixedColumnWidth(150),
                                                                3: FixedColumnWidth(150),
                                                                4: FixedColumnWidth(150),
                                                                5: FixedColumnWidth(150),
                                                                6: FixedColumnWidth(150),
                                                                7: FixedColumnWidth(150),
                                                                 8: FixedColumnWidth(150),
                                                                 9: FixedColumnWidth(150),
                                                                 10: FixedColumnWidth(150),
                                                                 11: FixedColumnWidth(150),
                                                                 12: FixedColumnWidth(150),
                                                                 13: FixedColumnWidth(150),
                                                                 14: FixedColumnWidth(150),
                                                              },
                                                              children: [
                                                                 TableRow(
                                                                
                                                                  children: [
                                                                    Text(
                                                                      "IGST",
                                                                      textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                     Text(
                                                                      "CGST",
                                                                      textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                     Text(
                                                                      "SGST",
                                                                      textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "AMOUNT",
                                                                      textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "TAX",
                                                                         textAlign: TextAlign.center,
                                                                      style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    // Text(
                                                                    //   "COUPON",
                                                                    //      textAlign: TextAlign.center,
                                                                    //    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    // ),
                                                                    Text(
                                                                      "TOTAL",
                                                                         textAlign: TextAlign.center,
                                                                      style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "STATUS",
                                                                         textAlign: TextAlign.center,
                                                                    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "TYPE",
                                                                         textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "MODE",
                                                                         textAlign: TextAlign.center,
                                                                     style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "INVOICE DATE",
                                                                         textAlign: TextAlign.center,
                                                                    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "DUE DATE",
                                                                         textAlign: TextAlign.center,
                                                                    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                    Text(
                                                                      "PAYMENT TYPE",
                                                                         textAlign: TextAlign.center,
                                                                    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                      Text(
                                                                      "PAYMENT DATE",
                                                                         textAlign: TextAlign.center,
                                                                    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                     
                                                                     Text(
                                                                      "RENEWAL TYPE",
                                                                         textAlign: TextAlign.center,
                                                                    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                     Text(
                                                                      "LOCALITY",
                                                                         textAlign: TextAlign.center,
                                                                    style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                    ),
                                                                  ],
                                                                ),
                                                                // dividerRow(const Color(0xff7366ff)),
                                                                // ignore: unused_local_variable
                                                                // for (var invoices in  listSubsInvoive) ...[
                                                                  
                                                                  newRow(
                                                                    igst:invoice.igst,
                                                                      cgst:invoice.cgst,
                                                                        sgst:invoice.sgst,
                                                                     amount:'₹${invoice.allamount}',
                                                                      tax:'₹${invoice.alltaxamt}',
                                                                      // coupon:'${'coupon'}',
                                                                      total:'₹${invoice.totalamount}',
                                                                      status:invoice.invstatus == 1 ? 'Active':'Cancelled',
                                                                      type:invoice.invtype == 1 ? 'NON-GST':'GST',
                                                                       invmode: invoice.invmode,
                                                                      inviDate: invoice.invdate.isNotEmpty  ? DateFormat.yMMMMd('en_US').format(DateTime.parse(invoice.invdate).toLocal()): "---",
                                                                        payVali:invoice.expiration.isNotEmpty  ? DateFormat.yMMMMd('en_US').add_jm() .format(DateTime.parse(invoice.expiration).toLocal()): "---",//
                                                                      payType:invoice.payStatus == 1 ? 'Unpaid':'Paid',
                                                                      payDate:invoice.payStatus == 2 ? DateFormat.yMMMMd('en_US').add_jm() .format(DateTime.parse(invoice.paydate).toLocal()): "---",
                                                                    
                                                                        // payVali:invoice.invdate.isNotEmpty  ? "${DateFormat.yMd().add_jm().format(DateTime.parse(invoice.paydate))}" : "---",//
                                                                        renewType: invoice.renewalThrough,
                                                                        locality:invoice.locality,
                                                                
                                                                
                                                                  ),
                                                                  // dividerRow(Colors.red),
                                                                // ],
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                                                       ),
                                                 ),
                                                    
                                                     
                                                    ],
                                                  ),
                                                ],
                                              
                                            ),
                                          ),
                                         Divider(color: Colors.grey.withOpacity(0.3)),
                                            _buildCommonListTile(title: 'INVOICE NO', subtitle: ': ${invoice.invno}'),
                                            
                                            _buildCommonListTile(title: 'PACK TYPE',subtitle: ': ${getServiceType(invoice.packtype, defaultValue: "---")}',),
                
                                            _buildCommonListTile(title: 'PACK NAME', subtitle:': ${invoice.packname.isNotEmpty? invoice.packname: "---"}'),
                                            
                                         _buildCommonListTile(title: 'PRICE NAME', subtitle: ': ${invoice.pricename.isNotEmpty? invoice.pricename: "---"}'),
                                           
                                        _buildCommonListTile(title: 'VALIDITY DATE', subtitle:': ${invoice.expiration.isNotEmpty  ? DateFormat.yMMMMd('en_US').add_jm().format(DateTime.parse(invoice.expiration).toLocal()): "---" }'),
                                          
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                     
                                  ],
                                );
                              },
                            )),
                        const SizedBox(height: 15),
                        _buildPaginationControls() 
                                        ],
                                      ),
                      ),
                       if (isLoading) // Show circular progress indicator if isLoading is true
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

  
  Widget _buildPaginationControls() {
     final notifier = Provider.of<ColorNotifire>(context);
    final totalPages = (listSubsInvoive.length / itemsPerPage).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back,color: notifier.geticoncolor,),
          onPressed: currentPage > 1
              ? () {
                  setState(() {
                    currentPage--;
                  });
                }
              : null,
        ),
        Text("Page $currentPage of $totalPages",style:  mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
        IconButton(
          icon:Icon(Icons.arrow_forward,      color: notifier.geticoncolor),
          onPressed: currentPage < totalPages
              ? () {
                  setState(() {
                    currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }
Widget _buildCommonListTile({
  required String title,
  required String subtitle,
}) {
  final notifier = Provider.of<ColorNotifire>(context, listen: false);

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 3), // Control the gap between items
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align children to start to handle long text
      children: [
        Expanded(
          child: Text(
            title,
           style: mediumBlackTextStyle.copyWith(
              color: notifier.getMainText,
            ),
          ),
        ),
        const SizedBox(width: 10), // Add some spacing between title and subtitle
        Expanded(
          child: Text(
            subtitle,
            style: mediumBlackTextStyle.copyWith(
              color: notifier.getMainText,
            ),
          
          ),
        ),
      ],
    ),
  );
}
TableRow newRow({
  required int igst,
  required int cgst,
  required int sgst,
  required int invmode,
  required String amount,
  required String tax,
  // required String coupon,
  required String total,
  required String status,
  required String type,
  required String inviDate,
  required String payType,
  required String payVali,
  required int renewType,
  required int locality,
  required String payDate,
  // Change this to String
}) {
  // Convert price and taxAmt to double
  
final notifier = Provider.of<ColorNotifire>(context, listen: false);
  return TableRow(
    children: [
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text( "$igst%", textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
        Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text( "$cgst%", textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
        Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text( "$sgst%", textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(amount, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(child: Text(tax, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText))),
      ),
      // Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 5),
      //   child: Text("coupon", textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      // ),
     Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(total , textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(status, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(type, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(getInvoiceModeLabel(invmode), textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(inviDate, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
        Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(payVali, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(payType, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(payDate, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
     
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(getRenewalTypeLabel(renewType), textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(getLocalityLabel(locality), textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
    ],
  );
}
 

}
