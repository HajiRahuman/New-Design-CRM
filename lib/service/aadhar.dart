import 'package:crm/model/aadhar.dart';

import './http.dart' as http;



class AadharService {
  Future<GetOPT> getOTP(String aadharNo, int uid, int fileId, bool isUpdate) async {
    final resp = await http.get('/aadhar/$aadharNo/generateOtp/$uid/$fileId/$isUpdate');
    return GetOPT.toJson(resp); // Assuming GetOPT.fromJson converts the response to your model
  }
}


Future<Map<String, dynamic>> submitAadharOPT(uid,int fileid,body) async {
  final response = await http.post('aadhar/$uid/submitOtp/$fileid', body);
  return response;
}