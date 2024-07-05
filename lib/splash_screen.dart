



import 'package:crm/AppStaticData/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  var selected =0;
  @override
  initState()  {

    super.initState();

     Future.delayed(const Duration(seconds: 3),() {

       Get.offAllNamed(Routes.homepage);

    },);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Image.asset(
                                'assets/images/logogsi.png',
                               
               width: 250, // Set the desired width
                                height: 150, 
                fit: BoxFit.cover,
                              ),  
            
            const SizedBox(
              height: 20,
            ),
            const Text(
              'C R M!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w100,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFFF86C144)),
            ),
          ],
        ),
      ),
    );
  }
}
