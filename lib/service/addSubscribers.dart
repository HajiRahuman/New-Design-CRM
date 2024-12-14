import 'dart:async';
import '../model/addSubscriber.dart';
import './http.dart' as http;


Future <circleResp> circle(String apiUrl) async {
  var resp = await http.get('circle');
  return circleResp.toJson(resp);
}



Future <resellerResp> reseller() async {
  var resp = await http.get('reseller/list');
  return resellerResp.toJson(resp);
}

Future<resellerAliceResp>  resellerAlice(int id) async {
  var resp = await http.get('resellerAlice?resellerid=$id');
  return resellerAliceResp.toJson(resp);
}

Future<getResellerResp>  getresellerPack(int id) async {
  var resp = await http.get('getResellerPack?resellerid=$id');
  return getResellerResp.toJson(resp);
}


Future<Map<String, dynamic>> addSubscriber(body) async {
  final response = await http.post('subscriber',body);
  return response;
}

Future<getAllIpv4Resp>  getAllIpv4(int id) async {
  var resp = await http.get('getAllIpv4?resellerid=$id');
  return getAllIpv4Resp.toJson(resp);
}



Future<GetPackResp> getPack(int packid) async {
  var resp = await http.get('getpack/$packid');
  return GetPackResp.toJson(resp);
}



Future<PincodeResp> getPincode(int pincode) async {
  var resp = await http.get('area_pincode/$pincode');
  return PincodeResp.toJson(resp);
}


