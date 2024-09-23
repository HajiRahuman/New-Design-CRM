import './http.dart' as http;
import 'package:crm/model/CompanyInfo.dart';

Future<CompanyInfoDetResp> getCompanyInfo() async {
  final resp = await http.get('auth/info');
  return CompanyInfoDetResp.toJson(resp);
}