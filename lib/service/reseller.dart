import 'package:crm/model/reseller.dart';
import './http.dart' as http;
import 'package:dio/dio.dart' as dio ;


Future<ResellerListResp> resellerList() async {
  final resp = await http.get('reseller/list');
  return ResellerListResp.toJson((resp));
}


Future<ResellerDetResp> fetchResellerDetail(int resellerId) async {
  final response = await http.get('reseller/$resellerId');
  return ResellerDetResp.toJson(response);
}
Future<ResellerAmountDetResp> fetchResellerAmount() async {
  final response = await http.get('reseller');
  return ResellerAmountDetResp.toJson(response);
}


Future<Map<String, dynamic>> updateResellerPwd(int resellerId,body) async {
  final response = await http.put( 'reseller/updatePassword/${resellerId}',body);
  return response;
}


Future<Map<String, dynamic>> uploadResellerDocument(int id,bool isLogo,bool isUpdate   ,dio.FormData body) async {
  final response = await http.putFile('reseller/$id/file/$isLogo/$isUpdate', body);
  return response;
}


Future <LevelDetResp> level(String apiUrl) async {
  var resp = await http.get('level');
  return LevelDetResp.toJson(resp);
}


Future <LevelDetResp> getLevel() async {
  var resp = await http.get('/reseller/type');
  print('serice  --$resp');
  return LevelDetResp.toJson(resp);
}



Future <viewResellerPackPriceResp> ViewResellerPackPrice(int resellerid,int showallpack) async {
  var resp = await http.get('viewResellerPackPrice?showallpack=$showallpack&resellerid=$resellerid');
  return viewResellerPackPriceResp.toJson(resp);
}
