import 'package:crm/model/BottomNav.dart';
import './http.dart' as http;


// Future<SearchResp> search({int index = 0, int limit = 25, int userType = 0}) async {
//   final response = await http.get('subscriber/info?index=$index&limit=$limit&usertype=$userType');
//   return SearchResp.toJson(response);
// }
Future<SearchResp> search({int index = 0, int userType = 0}) async {
  final response = await http.get('subscriber/info?index=$index&usertype=$userType');
  return SearchResp.toJson(response);
}


Future<SearchPubIpResp> searchPublicIp({int index = 0, int ipmode=2, int userType = 0, required int usertype, required String like, required int fieldType}) async {
  final response = await http.get('subscriber/publicip?index=$index&ipmode=$ipmode&usertype=$userType');
  return SearchPubIpResp.toJson(response);
}

Future<SearchResp> searchLocalIp({int index = 0, int ipmode=1, int userType = 0}) async {
  final response = await http.get('subscriber/info?index=$index&ipmode=$ipmode&usertype=$userType');
  return SearchResp.toJson(response);
}
Future<SearchUserMacResp> userMac({int index = 0, int userType = 0}) async {
  final response = await http.get('usermac?index=$index&usertype=$userType');
  return SearchUserMacResp.toJson(response);
}


Future<SearchResp> typeSearch({int index = 0,required String like, int userType = 0, required int usertype, required int fieldType}) async {
  final response = await http.get('subscriber/info?index=$index&usertype=$userType&like=$like&fieldType=$fieldType');
  return SearchResp.toJson(response);
}

