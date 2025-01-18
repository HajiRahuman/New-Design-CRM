import 'package:crm/model/card.dart';
import './http.dart' as http;

Future<CardResp> listCard() async {
  final resp = await http.get('card');
  return CardResp.toJson((resp));
}

Future<CardResp> listCardSearch(int id) async {
  final resp = await http.get('card?id=$id');
  return CardResp.toJson((resp));
}


Future<UpadteCardUserDetResp> upadteCardUserDet(int id) async {
  var resp = await http.get('card/$id');
  return UpadteCardUserDetResp.toJson(resp);
}

Future<Map<String, dynamic>> updateProfilePwdCard(int subscriberId,body) async {
  final response = await http.put( 'subscriber/updateProfilePwd/${subscriberId}',body);
  return response;
}

Future<Map<String, dynamic>> updateAuthPwdCard(int subscriberId,body) async {
  final response = await http.put( 'subscriber/updateAuthPwd/${subscriberId}',body);
  return response;
}


Future<Map<String, dynamic>> addCarduser(body) async {
  final response = await http.post('card',body);
  return response;
}




Future<Map<String, dynamic>> updateCardUser(int id,body) async {
  final response = await http.put( 'card/${id}',body);
  return response;
}
