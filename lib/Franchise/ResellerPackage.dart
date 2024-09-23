// ignore_for_file: deprecated_member_use

import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Franchise/ViewFranchise.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:flutter/material.dart';



import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';

import '../../model/reseller.dart';
import '../../service/reseller.dart' as resellerSrv;




class ResellerPackage extends StatefulWidget {
  int? resellerId;
  ResellerPackage({Key? key,
    required this.resellerId,
  }) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<ResellerPackage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  bool isSearching = false;
  bool row = false;
  String selectedValue1 = 'Subscriber ID';

  bool isLoading = false;

  int currentPage = 0;
  int limit = 5;

  List<ResellerPackData> ResellerPackPrice = [];
  Future<void> getViewResellerPackPrice() async {
    viewResellerPackPriceResp resp = await resellerSrv.ViewResellerPackPrice(widget.resellerId!, 1);
    setState(() {
      if (resp.error) alert(context, resp.msg);
      ResellerPackPrice = resp.error ? [] : resp.data ?? [];
    });
  }




  @override
  void initState() {
    super.initState();
    getViewResellerPackPrice();
    print('Reseller ID---${widget.resellerId}');
  
    
    
  }
 
 // Define the pack_mode array
  final List<Map<String, dynamic>> pack_mode = [
    {'id': 0, 'name': 'Unlimited'},
    {'id': 1, 'name': 'Unlimited With Time'},
    {'id': 2, 'name': 'Unlimited With Day'},
    {'id': 3, 'name': 'FUP'},
    {'id': 4, 'name': 'FUP With Time'},
    {'id': 5, 'name': 'FUP With Day'},
  ];

  // Method to get the pack mode name based on the id
  String getPackModeName(int id) {
    return pack_mode.firstWhere((mode) => mode['id'] == id)['name'];
  }

  final List<Map<String, dynamic>> tax_mode = [
    {'id': 0, 'name': 'Inclusive'},
    {'id': 1, 'name': 'Exclusive'},
  ];
String getTaxModeName(int id) {
    return tax_mode.firstWhere((mode) => mode['id'] == id)['name'];
  }

  void navigateToViewReseller(int resellerId, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewFranchise(resellerId: resellerId),
      ),
    );
  }
int _expandedTileIndex = -1;
int taxmode = 0; double amounts = 0; double tax = 0;
double getTaxBasedPrice(double price, double tax) {
  double total = 0;
  if (taxmode == 0) {
    total = price - tax;
  } else {
    total = price;
  }
  // print('Total---$total');
  return total;
}

double taxPercentage = 18;
  double amount = 0;
  int taxMode = 0;

double calculateTax(double price) {
  double taxAmt = 0;
  if (taxMode == 0) {
    taxAmt = (price * taxPercentage) / (100 + taxPercentage);
  } else {
    taxAmt = (price / 100) * taxPercentage;
  }
  // print('TaxAmount--$taxAmt');
  return taxAmt;
}


  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ColorNotifire>(context, listen: false);
     double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
            backgroundColor:notifier.getbgcolor,
            resizeToAvoidBottomInset: false,
            body:

            Padding(
              padding: const EdgeInsets.all(0),
              child:isLoading
                  ? const Padding(
                padding: EdgeInsets.only(top:150 ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : Column(
                children: [
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: ResellerPackPrice.length,
                      itemBuilder: (context, index) {
                        final reseller = ResellerPackPrice[index];
                          return  Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ExpansionPanelList(
expandIconColor: notifier.getMainText,
                                elevation: 1,
                                expandedHeaderPadding: EdgeInsets.all(8),
                              expansionCallback: (int item, bool status) {

                                  setState(() {
                                    _expandedTileIndex = (_expandedTileIndex == index) ? -1 : index;
                                    if (_expandedTileIndex != -1) {
                                      // GetComplaintLog(SubsComplaint.id);
                                    }
                                  });
                                },
                                children: [
                                  ExpansionPanel(
                                    backgroundColor:notifier.getbgcolor,
                                     isExpanded: _expandedTileIndex == index && reseller.plan.isNotEmpty ,
                                    headerBuilder: (BuildContext context, bool isExpanded) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                           
                                                  
                                                                                        _buildCommonListTile(title: 'ID', subtitle: ': ${reseller.packid}'),
                                                                                       
                                                                                          _buildCommonListTile(title: 'PACK', subtitle:': ${reseller.packname}'),
                                                                                       
                                                                                          
                                                                                          _buildCommonListTile(title: 'MODE', subtitle:': ${getPackModeName(reseller.packmode)}'),
                                                                                      
                                                                                         _buildCommonListTile(title: 'UPLOAD SPEED', subtitle: ': ${reseller.ulspeed}'),
                                                                                      
                                                                                          _buildCommonListTile(title: 'DOWNLOAD SPEED', subtitle: ': ${reseller.dlspeed}'),
                                                                                        
                                                                                                       
                                                                                                       
                                        
                                                          
                                                          
                                                        
                                                     
                                                 
                                                
                                                 
                                             
                                           
                                        
                                                   
                                             
                                                  const SizedBox(height: 10),                                   ],
                                                                    
                                          ),
                                      );
                                      
                                    },
                                   
                                    body: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                          
                                        
                                                 Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Divider(),
                                                      const SizedBox(height: 5),
                                                   
                                     SizedBox(
                                      height: 500,
                                      width: screenWidth,
                                       child: ListView(
                                         scrollDirection: Axis.horizontal,
                                        
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: SingleChildScrollView(
                                              child: Table(
                                               border: TableBorder.all(borderRadius: BorderRadius.circular(10),color: notifier.getMainText ),
                                                columnWidths: const {
                                                  0: FixedColumnWidth(150),
                                                  1: FixedColumnWidth(250),
                                                  2: FixedColumnWidth(150),
                                                  3: FixedColumnWidth(150),
                                                  4: FixedColumnWidth(150),
                                                  5: FixedColumnWidth(150),
                                                  6: FixedColumnWidth(150),
                                                  7: FixedColumnWidth(150),
                                                },
                                                children: [
                                                 TableRow(
                                                  
                                                    children: [
                                                      Text(
                                                        "ID",
                                                        textAlign: TextAlign.center,
                                                       style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                      ),
                                                      Text(
                                                        "PNAME",
                                                           textAlign: TextAlign.center,
                                                       style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                      ),
                                                      Text(
                                                        "TAX MODE",
                                                           textAlign: TextAlign.center,
                                                        style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                      ),
                                                      Text(
                                                        "PRICE",
                                                           textAlign: TextAlign.center,
                                                        style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                      ),
                                                      Text(
                                                        "TAX AMOUNT",
                                                           textAlign: TextAlign.center,
                                                      style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                      ),
                                                      Text(
                                                        "VALIDITY",
                                                           textAlign: TextAlign.center,
                                                      style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                      ),
                                                      Text(
                                                        "EXTRADAYS",
                                                           textAlign: TextAlign.center,
                                                      style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                      ),
                                                      Text(
                                                        "STATUS",
                                                           textAlign: TextAlign.center,
                                                      style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)
                                                      ),
                                                    ],
                                                  ),
                                                  // dividerRow(const Color(0xff7366ff)),
                                                  // ignore: unused_local_variable
                                                  for (var resellers in reseller.plan) ...[
                                                    
                                                    newRow(
                                                      id: ' ${resellers.id}',
                                                      pname: ' ${resellers.pname}',
                                                      taxmode: ' ${resellers.taxmode==0? 'Inclusive':'Exclusive'}',
                                                      price: ' ${resellers.price}',
                                                     taxamt: '${calculateTax(double.parse(resellers.price))}',
                                                      validity: ' ${resellers.timeunit}${resellers.unittype==0?' Days':' Month'}',
                                                      extradays: ' ${resellers.extradays}',
                                                      status: resellers.pricestatus.toString(), 
                                                    ),
                                                    // dividerRow(Colors.red),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                                                           ),
                                     ),
                                  
                                                      const SizedBox(height: 10),
                                            
                                                      // const Divider(),
                                                    ],
                                                  ),
                                                
                                            //   },
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          
                        },
                      ),
                    ),
                  ),
                 
                  const SizedBox(height: 10),
                ],
              ),
            )
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
  required String id,
  required String pname,
  required String taxmode,
  required String price,
  required String taxamt,
  required String validity,
  required String extradays,
  required String status, // Change this to String
}) {
  // Convert price and taxAmt to double
  double priceValue = double.parse(price);
  double taxValue = double.parse(taxamt);

  // Get the total using getTaxBasedPrice
  double totalPrice = getTaxBasedPrice(priceValue, taxValue);
final notifier = Provider.of<ColorNotifire>(context, listen: false);
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text("$id\n₹${totalPrice.toStringAsFixed(1)}", textAlign: TextAlign.center,style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(child: Text("₹${totalPrice.toStringAsFixed(1)}\n$pname", textAlign: TextAlign.center,style: mediumBlackTextStyle.copyWith(color: notifier.getMainText))),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text("$taxmode\n₹${totalPrice.toStringAsFixed(1)}", textAlign: TextAlign.center,style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
     Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text("${totalPrice.toStringAsFixed(1)}" , textAlign: TextAlign.center,style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text("₹${totalPrice.toStringAsFixed(1)}\n$taxamt", textAlign: TextAlign.center,style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text("₹${totalPrice.toStringAsFixed(1)}\n$validity", textAlign: TextAlign.center,style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text("₹${totalPrice.toStringAsFixed(1)}\n$extradays", textAlign: TextAlign.center,style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Text("₹${totalPrice.toStringAsFixed(1)}", textAlign: TextAlign.center,style: mediumBlackTextStyle.copyWith(color: notifier.getMainText)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: status == "true" 
                ? const Icon(Icons.check,color: Colors.green,)
                :const Icon(Icons.remove,color: Colors.red,),
            ),
          ],
        ),
      ),
    ],
  );
}






  
}
