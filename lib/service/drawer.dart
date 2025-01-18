

import 'package:crm/model/drawer.dart';


import './http.dart' as http;

Future<DepositSummaryResp> getDepositSummaryData() async {
  var resp = await http.get('deposit/summary');
  return DepositSummaryResp.toJson(resp);
}