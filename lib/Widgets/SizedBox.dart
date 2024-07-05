import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SizedBoxx extends StatefulWidget {
  const SizedBoxx({super.key});

  @override
  State<SizedBoxx> createState() => _SizeBoxxState();
}

class _SizeBoxxState extends State<SizedBoxx> {
  @override
  Widget build(BuildContext context) {
    return  SizedBox(height: Get.height/25,);
  }
}
