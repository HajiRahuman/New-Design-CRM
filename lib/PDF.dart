import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


import 'package:flutter/material.dart';
import 'dart:io';

import 'package:open_file/open_file.dart';
// Replace with the correct path
class PDF extends StatelessWidget {
  const PDF({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('PDF Generator')),
        body: const Center(
          child: PdfButton(),
        ),
      ),
    );
  }
}
 // 
class PdfButton extends StatelessWidget {
  const PdfButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Create a sample invoice
        final invoice = Invoice(
          info: InvoiceInfo(
            number: '123456',
            date: DateTime.now(),
            dueDate: DateTime.now().add(Duration(days: 7)),
            description: 'This is a test invoice.',
          ),
          supplier: Supplier(
            name: 'Supplier Co.',
            address: '123 Supplier St.',
            paymentInfo: 'PayPal: supplier@example.com',
          ),
          customer: Customer(
            name: 'Customer Name',
            address: '456 Customer Ave.',
          ),
          items: [
            InvoiceItem(
              description: 'Item 1',
              date: DateTime.now(),
              quantity: 2,
              unitPrice: 30.0,
              vat: 0.2,
            ),
            InvoiceItem(
              description: 'Item 2',
              date: DateTime.now(),
              quantity: 5,
              unitPrice: 15.0,
              vat: 0.2,
            ),
          ],
        );

        try {
          // Generate and save the PDF
          final file = await PdfInvoiceApi.generate(invoice);

          // Open the PDF
          await PdfApi.openFile(file);

          // Optionally show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDF saved to ${file.path}')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error generating PDF: $e')),
          );
        }
      },
      child: const Text('Generate PDF'),
    );
  }
}



class PdfApi {
  static Future<File> saveDocument({required String name, required pw.Document pdf}) async {
    final bytes = await pdf.save();

    final dir = Directory.systemTemp;
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<void> openFile(File pdfFile) async {
    final result = await OpenFile.open(pdfFile.path);
    if (result.type != ResultType.done) {
      print('Error opening file: ${result.message}');
    }
  }
}
class Utils {
  static String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }
}


class Customer {
  final String name;
  final String address;

  Customer({required this.name, required this.address});
}

class Supplier {
  final String name;
  final String address;
  final String paymentInfo;

  Supplier({required this.name, required this.address, required this.paymentInfo});
}

class InvoiceInfo {
  final String number;
  final DateTime date;
  final DateTime dueDate;
  final String description;

  InvoiceInfo({required this.number, required this.date, required this.dueDate, required this.description});
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double unitPrice;
  final double vat;

  InvoiceItem({
    required this.description,
    required this.date,
    required this.quantity,
    required this.unitPrice,
    required this.vat,
  });
}

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  Invoice({required this.info, required this.supplier, required this.customer, required this.items});
}

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        buildHeader(invoice),
        // pw.SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        pw.Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static pw.Widget buildHeader(Invoice invoice) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              pw.Container(
                height: 50,
                width: 50,
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static pw.Widget buildCustomerAddress(Customer customer) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(customer.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(customer.address),
        ],
      );

  static pw.Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>['Invoice Number:', 'Invoice Date:', 'Payment Terms:', 'Due Date:'];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static pw.Widget buildSupplierAddress(Supplier supplier) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(supplier.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Text(supplier.address),
        ],
      );

  static pw.Widget buildTitle(Invoice invoice) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'INVOICE',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
          pw.Text(invoice.info.description),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );
static pw.Widget buildInvoice(Invoice invoice) {
  final headers = ['Description', 'Date', 'Quantity', 'Unit Price', 'VAT', 'Total'];
  final data = invoice.items.map((item) {
    final total = item.unitPrice * item.quantity * (1 + item.vat);

    return [
      item.description,
      Utils.formatDate(item.date),
      '${item.quantity}',
      '\$ ${item.unitPrice}',
      '${item.vat} %',
      '\$ ${total.toStringAsFixed(2)}',
    ];
  }).toList();

  // ignore: deprecated_member_use
  return pw.Table.fromTextArray(
    headers: headers,
    data: data,
    border: pw.TableBorder.all(
      width: 1, // Thickness of the border
      color: PdfColors.black, // Color of the border
    ),
    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
    cellHeight: 30,
    cellAlignments: {
      0: pw.Alignment.centerLeft,
      1: pw.Alignment.centerRight,
      2: pw.Alignment.centerRight,
      3: pw.Alignment.centerRight,
      4: pw.Alignment.centerRight,
      5: pw.Alignment.centerRight,
    },
  );
}

  static pw.Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vatPercent = invoice.items.first.vat;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Row(
        children: [
          pw.Spacer(flex: 6),
          pw.Expanded(
            flex: 4,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'Vat ${vatPercent * 100} %',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),
                pw.Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                pw.SizedBox(height: 2 * PdfPageFormat.mm),
                pw.Container(height: 1, color: PdfColors.grey400),
                pw.SizedBox(height: 0.5 * PdfPageFormat.mm),
                pw.Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildFooter(Invoice invoice) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Divider(),
          pw.SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.supplier.address),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(title, style: style),
        pw.SizedBox(width: 2 * PdfPageFormat.mm),
        pw.Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    pw.TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Container(
      width: width,
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(title, style: style)),
          pw.Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
