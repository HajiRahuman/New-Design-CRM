import 'package:crm/model/BottomNav.dart';
import 'package:crm/model/subscriber.dart';
import './http.dart' as http;
import 'package:dio/dio.dart' as dio;


Future<ListSubscriberResp> listSubscriber() async {
  final resp = await http.get('subscriber');
  return ListSubscriberResp.toJson((resp));
}

Future<SubscriberFullDetResp> fetchSubscriberDetail(int subscriberId) async {
  final response = await http.get('subscriber/view/$subscriberId');
  return SubscriberFullDetResp.toJson(response);
}

Future<CircleResp> circle(String apiUrl) async {
  final resp = await http.get('circle');
  return CircleResp.toJson(resp);
}

Future<BranchResp> resellerAlice(String apiUrl) async {
  final resp = await http.get('resellerAlice');
  return BranchResp.toJson(resp);
}

Future<Map<String, dynamic>> updateProfileID(int subscriberId, body) async {
  final response =
      await http.put('subscriber/updateProfileId/${subscriberId}', body);
  return response;
}

Future<Map<String, dynamic>> updateAuthPwd(int subscriberId, body) async {
  final response =
      await http.put('subscriber/updateAuthPwd/${subscriberId}', body);
  return response;
}

Future<Map<String, dynamic>> updateProfilePwd(int subscriberId, body) async {
  final response =
      await http.put('subscriber/updateProfilePwd/${subscriberId}', body);
  return response;
}

Future<Map<String, dynamic>> updateAcctype(int subscriberId, body) async {
  final response =
      await http.put('subscriber/updateAccountType/${subscriberId}', body);
  return response;
}

Future<Map<String, dynamic>> updatePacAndVal(int subscriberId, body) async {
  final response = await http.put(
      'subscriber/updatePackageAndValidity/${subscriberId}', body);
  return response;
}

Future<ReseelerPackResp> resellerPack(int resellerId) async {
  final response = await http.get('getResellerPack?resellerid=$resellerId');
  return ReseelerPackResp.toJson(response);
}

Future<Map<String, dynamic>> updateMacBinding(int subscriberId, body) async {
  final response =
      await http.put('subscriber/updateMacBind/${subscriberId}', body);
  return response;
}

Future<SessionResp> Session(String username) async {
  final response = await http.get('radacct/onlineSubscriber/${username}');
  return SessionResp.toJson(response);
}

Future<UserMacResp> userMac(int subscriberId) async {
  final response = await http.get('usermac/${subscriberId}');
  return UserMacResp.toJson(response);
}

Future<Map<String, dynamic>> sessionCheckandStop(
    int radacctid, int uid, bool isDisconnect, body) async {
  final response = await http.put(
      'radacct/disconnectOrRefreshSession/$uid/$isDisconnect/$radacctid', body);
  return response;
}

Future<UpdateUserDataResp> getUpdateUserDetail(int subscriberId) async {
  final response = await http.get('subscriber/${subscriberId}');
  return UpdateUserDataResp.toJson(response);
}

Future<Map<String, dynamic>> uploadDocument(
    int id, bool isUpdate, bool isProfile, dio.FormData body) async {
  final response =
      await http.postFile('subscriber/$id/file/$isUpdate/$isProfile', body);
  return response;
}

Future<ViewDocumentResp> viewDocument(int uid) async {
  final resp = await http.get('subscriber/$uid/file');
  return ViewDocumentResp.toJson(resp);
}

Future<GetRenewalPackResp> getRenewPak(
    int resellerid, int uid, int srvusermode) async {
  final resp = await http.get(
      'getRenewalPack?resellerid=$resellerid&uid=$uid&srvusermode=$srvusermode');
  return GetRenewalPackResp.toJson(resp);
}

Future<GetRenewalOttResp> getRenewOtt(int resellerid) async {
  final resp = await http.get('getRenewalOtt?resellerid=$resellerid');
  return GetRenewalOttResp.toJson(resp);
}

Future<GetRenewalPriceResp> getRenewPrice(int resellerid, int packid,String expiration,int expreset) async {
  final resp =
      await http.get('getRenewalPrice?resellerid=$resellerid&packid=$packid&expiration=$expiration&expreset=$expreset');
  return GetRenewalPriceResp.toJson(resp);
}

Future<GetRenewalPriceResp>  getRenewalVoice(int resellerid,String expiration) async{
  final resp = await http.get('getRenewalVoice?resellerid=$resellerid&expiration=$expiration');
  return GetRenewalPriceResp.toJson(resp);
}



Future<Map<String, dynamic>> renewalSubscriber(body) async {
  final response = await http.post('razorpay/subscriber', body);
  return response;
}

Future<Map<String, dynamic>> resellerRenewalSubs(body) async {
  final response = await http.post('renewal', body);
  return response;
}


Future<InvoiceDetResp> getInvoice(int uid) async {
  final resp = await http.get('invoice?uid=$uid');
  return InvoiceDetResp.toJson(resp);
}

Future<ISP_LogoResp> getIsp_logo() async {
  final resp = await http.get('isp_logo');
  return ISP_LogoResp.toJson(resp);
}

Future<RD_GraphResp> getRD_Graph(String Username) async {
  final resp = await http.get('subscriber/$Username/graph');
  return RD_GraphResp.toJson(resp);
}

Future<FileDataResp> getFileData(int fileid) async {
  final resp = await http.get('/subscriber/$fileid/file/blob', true);
  return FileDataResp.toJson(resp);
  // print('respssssssssss--$resp'); return resp;
}


class SubscriberComplaintService {
 Future<ComplaintTypeResp> complaintType(String apiUrl) async {
  final resp = await http.get('complaintsType');
  return ComplaintTypeResp.toJson(resp);
}

}

Future<Map<String, dynamic>> addComplaint(body) async {
  final response = await http.post('complaints',body);
  return response;
}

Future<SubsComplaintResp> subsComplaints(int id) async {
  final resp = await http.get('subscriber/$id/complaints');
  return SubsComplaintResp.toJson(resp);
}


Future<SubsComplaintResp> GetTotComplaints() async {
  final resp = await http.get('complaints');
  return SubsComplaintResp.toJson(resp);
}



Future<SubsComplaintLogResp> GetSubsComplaintLog(int id) async {
  final resp = await http.get('complaints/$id/logs');
  return SubsComplaintLogResp.toJson(resp);
}






class SubscriberInfoComplaint {
 Future<SearchResp> subsInfo(int resellerID) async {
  final response = await http.get('subscriber/info?resellerid=$resellerID');
  return SearchResp.toJson(response);
}


}




Future<Map<String, dynamic>> addResellerComplaint(int id,body) async {
  final response = await http.put('complaints/$id',body);
  return response;
}



Future<EmployeeListResp> GetEmpList() async {
  final resp = await http.get('employee');
  return EmployeeListResp.toJson(resp);
}


Future<Map<String, dynamic>> updatePaySts(int id,body) async {
  final response = await http.put('renewal/$id/invoicePayment',body);
  return response;
}




Future<SessionRptResp> sessionRpt(int Id,int index ,int limit,bool isDayReport,{String startDate = '', String endDate = ''}) async {
  final resp = await http.get('subscriber/$Id/sessionRpt/?index=$index&limit=$limit&isDayReport=$isDayReport&starttime=$startDate&endtime=$endDate');
  return SessionRptResp.toJson((resp));
}