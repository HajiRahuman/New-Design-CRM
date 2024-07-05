import 'package:intl/intl.dart';
import '../model/dashboard.dart';
import '../model/subscriber.dart';
import './http.dart' as http;

Future<ExpirySubscribersResp> getExpirySubscriberByDate(
    DateTime selectedDate) async {
  var resp = await http.get(
      'subscriber/expiry?expiration=${DateFormat('yyyy-MM-dd').format(selectedDate.toLocal())}');
  return ExpirySubscribersResp.toJson(resp);
}

Future<SubscriberSummaryResp> getSubscriberSummaryData(String url) async {
  var resp = await http.get('subscriber/summary');
  return SubscriberSummaryResp.toJson(resp);
}

Future<Map<String, dynamic>> packRenewal(String apiUrl) async {
  var resp = await http.get('pack');
  return resp;
}
