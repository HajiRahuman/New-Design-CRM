
import 'package:crm/AppStaticData/logger.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/service/auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:synchronized/synchronized.dart';
import 'package:crm/main.dart' show navigatorKey;

BaseOptions options = BaseOptions(
  // baseUrl: 'http://localhost:4000/',
  baseUrl: 'https://bms.gsisp.in/api/',
  contentType: Headers.jsonContentType,
  responseType: ResponseType.json,
);

const Map<String, dynamic> catchResp = {
  'error': true,
  'msg': 'Something went wrong..!'
};

final Dio dio = Dio(options)
  ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString('authToken');
    String? cookie = pref.getString('cookies');
    // print("Token : $token");
    final lock = Lock(); // Create a Lock instance
    await lock.synchronized(() async {
      if (cookie != null) {
        options.headers["cookie"] = cookie;
      }
      if (token is String && token != '') {
        options.headers.addAll({'authorization': 'Bearer ${token}'});
      }
      options.extra["withCredentials"] = true;
    });
    return handler.next(options);
  }));

appendHeader([Map<String, String>? headers]) async {
  Map<String, String> defaultHeader = {};
  if (headers is Map<String, String>) {
    defaultHeader.addAll(headers);
  }
  return defaultHeader;
}

// Map<String, dynamic> handleResponse(Response resp) {
//   // logger.d('handleResponse | Start');
//   final statusCode = resp.statusCode;
//   if (statusCode == HttpStatus.unauthorized) {
//     logout();
//     return {'error': true, 'msg': 'Unauthorized access'};
//   }
//   if (statusCode == HttpStatus.ok) {
//     final data = resp.data;
//     // logger.d('handleResponse | Data: ${data.runtimeType}');
//     if (data.runtimeType != Uint8List && data['error']) {
//       alert(navigatorKey.currentContext as BuildContext, data['msg'],
//           data['error']);
//     } else if (data.runtimeType == Uint8List) {
//       // logger.d('handleResponse | End');
//       return {'error': false, 'file': data};
//     }
//     // logger.d('handleResponse | End');
//     return data;
//   }
//   logger.d('handleResponse | End with Unknown error');
//   return {'error': true, 'msg': 'Something went wrong'};
// }
Map<String, dynamic> handleResponse(Response resp) {
  // logger.d('handleResponse | Start');
  final statusCode = resp.statusCode;
  if (statusCode == HttpStatus.unauthorized) {
    logout();
    return {'error': true, 'msg': 'Unauthorized access'};
  }
  if (statusCode == HttpStatus.ok) {
    final data = resp.data;
    // logger.d('handleResponse | Data: ${data.runtimeType}');
    if (data is Map && data.containsKey('error') && data['error']) {
      alert(navigatorKey.currentContext as BuildContext, data['msg'], data['error']);
    } else if (data is Uint8List) {
      // logger.d('handleResponse | End');
      return {'error': false, 'file': data};
    }
    // logger.d('handleResponse | End');
    return data;
  }
  logger.d('handleResponse | End with Unknown error');
  return {'error': true, 'msg': 'Something went wrong'};
}

Future<Map<String, dynamic>> get(String url,
    [bool isFile = false, Map<String, String>? headers]) async {
  // print('GetHeaders---$headers');
  final httpHeaders = await appendHeader(headers);
  Response resp;
  try {
    resp = await dio.get(url,
        options: Options(
            headers: httpHeaders,
            responseType: isFile ? ResponseType.bytes : ResponseType.json));
  } catch (e) {
    // logger.e(e.toString());
    return catchResp;
  }
  return handleResponse(resp);
}

Future<Map<String, dynamic>> post(String url, Map<String, dynamic> requestBody,
    [Map<String, String>? headers]) async {
  final httpHeaders = await appendHeader(headers);
  Response resp;
  try {
    resp = await dio.post(url,
        data: requestBody, options: Options(headers: httpHeaders));
    final pref = await SharedPreferences.getInstance();
    final cookies = resp.headers.map['set-cookie'];
    if (cookies != null) await pref.setString('cookies', cookies[0]);
  } catch (e) {
    // logger.e(e.toString());
    return catchResp;
  }
  return handleResponse(resp);
}

Future<Map<String, dynamic>> postFile(String url, FormData requestBody,
    [Map<String, String>? headers]) async {
  final httpHeaders = await appendHeader(headers);
  Response resp;
  try {
    resp = await dio.post(url,
        data: requestBody, options: Options(headers: httpHeaders));
  } catch (e) {
    // logger.e(e.toString());
    return catchResp;
  }
  return handleResponse(resp);
}

Future<Map<String, dynamic>> putFile(String url, FormData requestBody,
    [Map<String, String>? headers]) async {
  final httpHeaders = await appendHeader(headers);
  Response resp;
  try {
    resp = await dio.put(url,
        data: requestBody, options: Options(headers: httpHeaders));
  } catch (e) {
    // logger.e(e.toString());
    return catchResp;
  }
  return handleResponse(resp);
}

Future<Map<String, dynamic>> put(String url, Map<String, dynamic> requestBody,
    [Map<String, String>? headers]) async {
  final httpHeaders = await appendHeader(headers);
  Response resp;
  try {
    resp = await dio.put(url,
        data: requestBody, options: Options(headers: httpHeaders));
  } catch (e) {
    // logger.e(e.toString());
    return catchResp;
  }
  return handleResponse(resp);
}
