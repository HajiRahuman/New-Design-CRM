
import 'package:crm/model/hotel.dart';
import './http.dart' as http;
Future<HotelResp> listHotel() async {
  final resp = await http.get('hotel');
  return HotelResp.toJson((resp));
}



Future<Map<String, dynamic>> addHoteluser(body) async {
  final response = await http.post('hotel',body);
  return response;
}



Future<HotelResp> ViewlistHotel(int id) async {
  final response = await http.get('hotel?id=$id');
  return HotelResp.toJson(response);
}


Future<Map<String, dynamic>> updateHotelUser(int id,body) async {
  final response = await http.put( 'hotel/${id}',body);
  return response;
}


Future<Map<String, dynamic>> updateAuthPwdHotel(int subscriberId,body) async {
  final response = await http.put( 'subscriber/updateAuthPwd/${subscriberId}',body);
  return response;
}