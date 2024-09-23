import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:crm/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

alert(BuildContext context, String msg, [bool isError = true]) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  final textColor = isError ? Color(0xFFFFF3333) :  Color(0xFFF046A38);
  final bgColor = isError ? Colors.red[50] : Colors.green[50];

  if(isError==false){
   CherryToast.success(
        enableIconAnimation: false,
      
        animationType: AnimationType.fromRight,
        animationDuration: const Duration(milliseconds: 1000),
        autoDismiss: true,
        title:  Text(msg),
      ).show(navigatorKey.currentContext!); 

  }else{

     CherryToast.error(
        enableIconAnimation: false,
      
        animationType: AnimationType.fromRight,
        animationDuration: const Duration(milliseconds: 1000),
        autoDismiss: true,
        title:  Text(msg),
      ).show(navigatorKey.currentContext!); 
  } 
}