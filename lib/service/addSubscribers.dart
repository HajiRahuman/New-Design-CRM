import 'dart:async';
import '../model/addSubscriber.dart';
import './http.dart' as http;


Future <circleResp> circle(String apiUrl) async {
  var resp = await http.get('circle');
  return circleResp.toJson(resp);
}



Future <resellerResp> reseller() async {
  var resp = await http.get('reseller');
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

//  async listLevel(){
//     const resp = await lastValueFrom(this.http.get<LevelsResp>('/level'));
//     const user = this.currentUser.getData();
//     const level = resp.data.filter(x=> {
//       return user.isIspAdmin || user.isSuperAdmin || x.level_role < user.level_role
//     });
//     this.levelStore.setData(level)
//   }
Future<GetLevelDetResp> getLevel() async {
  final resp = await http.get('level');
  return GetLevelDetResp.toJson(resp);
}

