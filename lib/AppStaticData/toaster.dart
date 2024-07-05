import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

alert(BuildContext context, String msg, [bool isError = true]) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final textColor = isError ? Color(0xFFFFF3333) :  Color(0xFFF046A38);
  final bgColor = isError ? Colors.red[50] : Colors.green[50];
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: bgColor,
    textColor: textColor,
    fontSize: 16.0,
  );
}