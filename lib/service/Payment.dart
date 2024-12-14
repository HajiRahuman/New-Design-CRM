import 'dart:convert';
import 'package:crm/AppStaticData/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';


class PaymentService {
  late Map<String, dynamic> options;
  final Razorpay razorpay;

  PaymentService({required this.razorpay}) {
    options = {
      'key': '',
      'amount': '',
      'currency': 'INR',
      'name': '',
      'description': '',
      'image': 'https://example.com/your_logo',
      'callback_url': '',
      'order_id': '',
      'handler': (res) => print(res),
      'redirect': false,
      // 'razorpay_payment_id':'',
      // 'razorpay_order_id':'',
      // 'razorpay_signature':'',
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _makePayment(String key, String id, String amount) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  final username = pref.getString('username') ?? '---'; // Fallback to 'Guest' if not found
  // final isSubscriber = pref.getBool('isSubscriber') ?? false;
  //  final company = pref.getString('company') ?? 'Admin'; 

  options['key'] = key;
  options['order_id'] = id;
  options['amount'] = amount;
  options['name'] = username; // Use username dynamically
  options['handler'] = '';
  options['description'] = '';

  razorpay.open(options);
}


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    logger.i('Payment is success');
    razorpay.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    logger.e(response.message);
    razorpay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    logger.i(jsonEncode(response));
    razorpay.clear();
  }


  Future<void> payment(Map<String, dynamic> body) async {
    final response = await http.post('razorPay', body);
    _makePayment(response['key'], response['id'], response['amount']);

  }
  
Future<void> Subpayment(Map<String, dynamic> body) async {
    final response = await http.post('razorpay/subscriber', body);
    print('Response------$response');
    _makePayment(response['key'].toString(), response['id'].toString(), response['amount'].toString());

  }

  // Future<void> orderStatus(Map<String, dynamic> body) async {
  //   final response = await http.post('razorpay/orderstatus', body);
  //   _makePayment(response['razorpay_payment_id'], response['razorpay_order_id'], response['razorpay_signature']);
  // }

  void openRazorpay() {
    razorpay.open(options);
  }
}






