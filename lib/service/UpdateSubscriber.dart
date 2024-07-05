
import 'dart:async';
import 'package:crm/model/UpdateSubscriber.dart';
import './http.dart' as http;

Future<UpdateSubsResp> updateSubscriber(int id) async {
  var resp = await http.get('subscriber/$id');
  return UpdateSubsResp.toJson(resp);
}


Future<Map<String, dynamic>> UpdateSubscribers(int id,body) async {
  final response = await http.put('subscriber/$id',body);
  return response;
}
