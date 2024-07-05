
import 'package:crm/Components/Auth/LoginPage.dart';
import 'package:crm/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './http.dart' show post;
import 'crypto.dart' show getEncryptPassword;


Future<Map<String, dynamic>> login(String username, String password) async {
  final encryptedPwdResp = await getEncryptPassword(password);
  if (encryptedPwdResp['error'] == true) {
    return encryptedPwdResp;
  }
  final encryptedPwd = encryptedPwdResp['password'];
  final resp = await post(
      'auth/login', {'username': username, 'password': encryptedPwd});
  return resp;
}

Future<Map<String, dynamic>> Subslogin(String username, String password) async {
  final encryptedPwdResp = await getEncryptPassword(password);
  if (encryptedPwdResp['error'] == true) {
    return encryptedPwdResp;
  }
  final encryptedPwd = encryptedPwdResp['password'];
  final resp = await post(
      'auth/login/subscriber?loginBy=subscriber', {'username': username, 'password': encryptedPwd});
  return resp;
}

Future<void> logout() async {
  final pref = await SharedPreferences.getInstance();
  pref.remove('authToken');
  pref.remove('cookies');
  pref.setBool('login', true);
  Navigator.pushReplacement(
      navigatorKey.currentContext as BuildContext,
      MaterialPageRoute(
          builder: (context) =>
              LoginPage()));
  
}
