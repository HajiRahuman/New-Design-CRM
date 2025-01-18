
import 'package:crm/model/addSubscriber.dart';
import 'package:crm/model/hotel.dart';
import './http.dart' as http;



Future<HotelResp> listHotel({
  int? acctstatus,
  int? conn, 
  bool? reselusertype, 
}) async {
  String url = 'hotel?';
if (acctstatus != null) {
    url += 'acctstatus=$acctstatus';
  }

  // If conn is provided, add it to the URL and do not include acctstatus
  if (conn != null) {
    if (acctstatus != null) {
      url += '&';
    }
    url += 'conn=$conn';
  }

  // If reselusertype is provided, add it to the URL
  if (reselusertype != null) {
    if (acctstatus != null || conn != null) {
      url += '&';
    }
    url += 'reselusertype=$reselusertype';
  }
  final resp = await http.get(url);
  return HotelResp.toJson((resp));
}

Future<HotelResp> listHotelSearch(int id) async {
  final resp = await http.get('hotel?id=$id');
  return HotelResp.toJson((resp));
}

Future<Map<String, dynamic>> addHoteluser(body) async {
  final response = await http.post('hotel',body);
  return response;
}

Future<GetPackResp> getPackHotel(String packid) async {
  var resp = await http.get('getpack/$packid');
  return GetPackResp.toJson(resp);
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