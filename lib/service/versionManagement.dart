
import 'dart:async';

import 'package:crm/model/versionManagement.dart';

import './http.dart' as http;


Future<VersionManagementResp> getVersion(String version) async {
  final resp = await http.get('checkVersion/$version');
  return VersionManagementResp.fromJson(resp);
}
