import 'dart:convert';
// import 'dart:ui';
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


  int currentPage = 0;
  int limit = 3;

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

  Future<void> GetSubsInvoice(int index, int limit) async {
    InvoiceDetResp resp =
    await subscriberSrv.getInvoice(index, limit, widget.subscriberId!);
    if (!_isMounted) return; // Check if the widget is still mounted
    setState(() {
      if (resp.error) alert(context, resp.msg);
      listSubsInvoive = resp.error ? [] : resp.data ?? [];
    });
  }



  @override
  void initState() {
    super.initState();
    getMenuAccess();
    GetEmployeeList();
    initializeForm();
    _isMounted = true;
    GetSubsInvoice(currentPage, limit);
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

  void generateInvoice(int invid) {
    pdf = pw.Document();

    final invoice = listSubsInvoive.firstWhere((element) => element.invid == invid);
      DateTime expirationDate = DateTime.parse(invoice.expiration); // Parse the date string
String expiryDate = DateFormat('MMM d, yyyy, h:mm:ss a').format(expirationDate);
 DateTime InvoiceDate = DateTime.parse(invoice.createdon); // Parse the date string
String inviDate = DateFormat('MMM d, yyyy, h:mm:ss a').format(expirationDate);

DateTime PayedDate = DateTime.parse(invoice.paydate); // Parse the date string
String payDate = DateFormat('MMM d, yyyy, h:mm:ss a').format(expirationDate);

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
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Tax Invoice', style:  pw.TextStyle(fontSize: 20,fontWeight: pw.FontWeight.bold)),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  
                  pw.Text('Grey Sky Internet Services Pvt Ltd.\n'
                      'GSTIN 33AAJCG9282G1ZC\n'
                      'No.17/34e, Santhaiyadi Street, Udangudi,\n'
                      'Thoothukudi, Tamil Nadu, 628203,\n'
                      'Mobile: 9442887912'),
                  pw.Image(
                    pw.MemoryImage(
                      base64Decode(logo.first.ispLogo), // Assuming logo is fetched and stored as base64
                    ),
                    width: 200,
                    height: 200,
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                    width: 200,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Shipping Address:-', style:  pw.TextStyle(fontSize: 15,fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 10),
                        pw.Text('${invoice.subname}\n ${invoice.subaddress}'),
                        pw.SizedBox(height: 50),
                        pw.Text('Billing Address:-', style:  pw.TextStyle(fontSize: 15,fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 10),
                        pw.Text('Billing Address:\n${invoice.subname}\n ${invoice.subbilladdress}'),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 100),
                  pw.Align(
                    alignment: pw.Alignment.topRight,
                    child: pw.Expanded(
                      child: pw.Container(
                        width: 250,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            // pw.Text('Invoice ID: ${invoice.invid}'),
                            //  pw.SizedBox(height: 10),
                            pw.Text('Invoice: ${invoice.invno}'),
                             pw.SizedBox(height: 10),
                            // pw.Text('Dated: ${inviDate.isNotEmpty  ? DateFormat.yMd().add_jm().format(DateTime.parse(inviDate)) : "---"}'),
                            //  pw.SizedBox(height: 10),
                            // pw.Text('Billing Period: ${'Billing Period'}'),
                            //  pw.SizedBox(height: 10),
                            pw.Text('Paid Status: ${invoice.payStatus == 1 ? 'Unpaid' : 'Paid'}'),
                             pw.SizedBox(height: 10),
                            //   pw.Text('Paid Date: ${'Paid Date'}'),
                            //  pw.SizedBox(height: 10),
                            pw.Text('ProfileID: ${invoice.subname}'),
                             pw.SizedBox(height: 10),
                            pw.Text('Service Type: ${serviceType}'),
                            //  pw.SizedBox(height: 10),
                            // pw.Text('Validity: ${expiryDate.isNotEmpty  ? DateFormat.yMd().add_jm().format(DateTime.parse(expiryDate)) : "---"}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Center(child:
              pw.Text('Item Details',  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold,decoration: pw.TextDecoration.underline))),
              pw.SizedBox(height: 10),
             pw.Table(
              border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('Item', style:  pw.TextStyle(fontSize: 15,fontWeight: pw.FontWeight.bold))),
                      ),
                      pw.Container(
                      height: 40,
                        child: pw.Center(child: pw.Text('Item Value', style:  pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold))),
                      ),
                       pw.Container(
                      height: 40,
                        child: pw.Center(child: pw.Text('Tax Type', style:  pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold))),
                      ),
                       pw.Container(
                      height: 40,
                        child: pw.Center(child: pw.Text('Tax Rate', style:  pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold))),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('Tax Amount', style:  pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold))),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text('Amount', style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold))),
                      ),
                    ],
                  ), 
                  pw.TableRow(
                    children: [
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text(invoice.packname, style: const pw.TextStyle(fontSize: 15))),
                      ),
                      pw.Container(
                         height: 40,
                        child: pw.Center(child: pw.Text(invoice.allamount.toString(), style: const pw.TextStyle(fontSize: 15))),
                      ),
                       pw.Container(
                         height: 40,
                        child: pw.Center(child: pw.Text('CGST\nSGST', style: const pw.TextStyle(fontSize: 15))),
                      ),
                       pw.Container(
                         height: 40,
                        child: pw.Center(child: pw.Text('9%\n9%', style: const pw.TextStyle(fontSize: 15))),
                      ),
                      pw.Container(
                        height: 40,
                        child: pw.Center(child: pw.Text(invoice.alltaxamt.toString(), style: const pw.TextStyle(fontSize: 15))),
                      ),
                      pw.Container(
                      height: 40,
                        child: pw.Center(child: pw.Text(invoice.totalamount.toString(), style: const pw.TextStyle(fontSize: 15))),
                      ),
                    ],
                  ),
]
              ),



              pw.SizedBox(height: 10),
              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Column(
                    children: [
                  pw.Text('Taxable Amount: ${invoice.allamount}',style: const pw.TextStyle(fontSize: 15)),
                  pw.SizedBox(height: 5),
                  pw.Text('CGST 9% & SGST 9%: ${taxAmt!+taxAmt!}',style: const pw.TextStyle(fontSize: 15)),
                    
                      pw.SizedBox(height:10),
                  pw.Text('Grand Total: ${invoice.totalamount}',style:  const pw.TextStyle(fontSize: 20, color: PdfColors.green) ),
                ])
              ),
              pw.Divider(),
              pw.Center(child:
          pw.Text(
          'Amount Chargeable (in words) INR ${invoice.totalamount.toWords().toUpperCase()} Rupee Only',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
              ),
              pw.Divider(),
               pw.SizedBox(height: 5),
                        pw.Align(
                          alignment: pw.Alignment.bottomLeft,
                          child:
              pw.RichText(
            text:  pw.TextSpan(
              children: <pw.TextSpan>[
               pw.TextSpan(
                  text: 'Company`s Bank Details:',
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)
                ),
                const pw.TextSpan(
                  text: '\nAccount name : Grey Sky Internet Services Pvt Ltd',
                   style: pw.TextStyle(fontSize: 12)
                ),
               const pw.TextSpan(
                  text: '\nSBI Account No : 20509877576',
                  style: pw.TextStyle(
                
                    fontSize: 12,
                   
                  ),
                ),
                
                const pw.TextSpan(
                  text: '\nSBI IFSC Code : SBIN0002283',
                  style: pw.TextStyle(
                
                    fontSize: 12,
                   
                  ),
                ),
              ],
            ),
          ),
        ),
      
              pw.SizedBox(height: 5),
          pw.Center(child:
              pw.Text('*** This is a Computer Generated Invoice ***',  style: pw.TextStyle(fontSize: 12))),
            ],
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
    ScaffoldMessenger.of(context).showSnackBar(
  const  SnackBar(content: Text('Permission to access storage is required to save and open the PDF.')),
    );
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
  final fileName = "Invoice_$timestamp.pdf";

  final file = File("${output!.path}/$fileName");
  await file.writeAsBytes(await pdf.save());

  return file.path;  // Return the file path so it can be opened
}
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: false);
     double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
            backgroundColor:notifier.getbgcolor,
            key: _key,
            resizeToAvoidBottomInset: false,
            body:isLoading
                  ? const Padding(
                padding: EdgeInsets.only(top:150 ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                                    children: [
                                     
                    Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: listSubsInvoive .length,
                          itemBuilder: (context, index) {
                            final invoice =  listSubsInvoive[index];
                    //                         
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
                                                  if (val)   GetSubsInvoice(currentPage, limit)
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
                                                          },
                                                          children: [
                                                             TableRow(
                                                            
                                                              children: [
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
                                                                Text(
                                                                  "COUPON",
                                                                     textAlign: TextAlign.center,
                                                                   style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                ),
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
                                                                  "INVOICE DATE",
                                                                     textAlign: TextAlign.center,
                                                                style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                ),
                                                                Text(
                                                                  "PAYMENT TYPE",
                                                                     textAlign: TextAlign.center,
                                                                style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                ),
                                                                 Text(
                                                                  "PAYMENT VALIDITY",
                                                                     textAlign: TextAlign.center,
                                                                style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                                ),
                                                              ],
                                                            ),
                                                            // dividerRow(const Color(0xff7366ff)),
                                                            // ignore: unused_local_variable
                                                            // for (var invoices in  listSubsInvoive) ...[
                                                              
                                                              newRow(
                                                                 amount:'${invoice.allamount}',
                                                                  tax:'${invoice.alltaxamt}',
                                                                  coupon:'${'coupon'}',
                                                                  total:'${invoice.totalamount}',
                                                                  status:invoice.invstatus == 1 ? 'Active':'Cancelled',
                                                                  type:invoice.invtype == 1 ? 'Normal':'GST',
                                                                  inviDate: invoice.invdate.isNotEmpty  ? "${DateFormat.yMd().add_jm().format(DateTime.parse(invoice.invdate))}" : "---",
                                                                  payType:invoice.payStatus == 1 ? 'Unpaid':'Paid',
                                                                  payVali:invoice.invdate.isNotEmpty  ? "${DateFormat.yMd().add_jm().format(DateTime.parse(invoice.paydate))}" : "---",//
                                                            
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
                                        
                                        _buildCommonListTile(title: 'PACK TYPE', subtitle: ': ${invoice.packtype == "1,2" ? 'Internet & Voice' : (invoice.packtype == "1,3" ? 'Internet & OTT' : 'Internet')}'),
                                       
                                        _buildCommonListTile(title: 'PACK NAME', subtitle:': ${invoice.packname}'),
                                        
                                     _buildCommonListTile(title: 'PRICE NAME', subtitle: ': ${invoice.pricename}'),
                                       
                                    _buildCommonListTile(title: 'VALIDITY DATE', subtitle:': ${invoice.invdate.isNotEmpty  ? "${DateFormat.yMd().add_jm().format(DateTime.parse(invoice.expiration))}" : "---"}'),
                                      
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
            style: mediumGreyTextStyle,
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
  required String amount,
  required String tax,
  required String coupon,
  required String total,
  required String status,
  required String type,
  required String inviDate,
  required String payType,
  required String payVali, // Change this to String
}) {
  // Convert price and taxAmt to double
  
final notifier = Provider.of<ColorNotifire>(context, listen: false);
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(amount, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(child: Text(tax, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText))),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text("coupon", textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
     Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text("$total" , textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
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
        child: Text(inviDate, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(payType, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
       Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(payVali, textAlign: TextAlign.center,  style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
    ],
  );
}
  String formattedDate =
      DateFormat('yyyy-MM-dd').format(DateTime.now());
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        formattedDate = DateFormat('yyyy-MM-dd').format(picked);
        form?.control('paydate').value = formattedDate;
      });
    }
  }

}
