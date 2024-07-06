
import 'package:crm/AppStaticData/routes.dart';
import 'package:crm/Components/Auth/LoginPage.dart';
import 'package:crm/Components/DashBoard/DashBoard.dart';
import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/HomePage.dart';
import 'package:crm/ListSubscriber.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';



// class AppConst extends GetxController implements GetxService {
//   bool showDrawer = true;

//   updateshowDrawer() {
//     showDrawer = !showDrawer;
//     update();
//   }

//   RxInt pageselecter = 0.obs;

//   RxInt selectColor = 0.obs;
//   RxInt selectedTile = 0.obs;

//   RxInt gridcounter = 4.obs;

//   RxInt newGridCounter = 4.obs;

//   RxDouble size = 550.0.obs;

//   RxDouble size2 = 350.0.obs;

//   int selectCategory = 0;

//   int gridecoumter1 = 4;
//   int grideCount = 4;

//   grideupdate(int value) {
//     gridecoumter1 = value;
//   }

//   grideupdate1(int value) {
//     gridecoumter1 = value;
//     update();
//   }

//   changeCurrentIndex({int? index}) {
//     selectCategory = index ?? 0;
//     update();
//   }

//   //Switch
//   RxBool switchistrue = false.obs;

//   var page = [
//     DashBoard(),
//     const ListSubscriber(),
   

//   ].obs;

//   void changePage(int newIndex) {
//     pageselecter.value = newIndex;
//   }

  
// }

String? token;
bool isSubscriber=false;
int id=0;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppConst extends GetxController implements GetxService {
  bool showDrawer = true;

  @override
  void onInit() {
    super.onInit();
    userLogin();
  }

  userLogin() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('authToken');
    isSubscriber = pref.getBool('isSubscriber') as bool;
    id = pref.getInt('id') as int;
    print("ID--- : $token");
  }

  updateshowDrawer() {
    showDrawer = !showDrawer;
    update();
  }

  RxInt pageselecter = 0.obs;
  RxInt dynamicId = 0.obs;

  RxInt selectColor = 0.obs;
  RxInt selectedTile = 0.obs;

  RxInt gridcounter = 4.obs;

  RxInt newGridCounter = 4.obs;

  RxDouble size = 550.0.obs;

  RxDouble size2 = 350.0.obs;

  int selectCategory = 0;

  int gridecoumter1 = 4;
  int grideCount = 4;

  grideupdate(int value) {
    gridecoumter1 = value;
  }

  grideupdate1(int value) {
    gridecoumter1 = value;
    update();
  }

  changeCurrentIndex({int? index}) {
    selectCategory = index ?? 0;
    update();
  }

  //Switch
  RxBool switchistrue = false.obs;

  // var page = getPage;

  // var page = [
  //   LoginPage(),
  //   DashBoard(),
  //   const ListSubscriber(),
  // ].obs;

  // void changePage(int newIndex) {
  //   pageselecter.value = newIndex;
 
  // }

    void changePage(int newIndex, {int? id}) {
    pageselecter.value = newIndex;
    if(id !=0) dynamicId.value = id!;
    switch (newIndex) {
      case 1:
        Get.toNamed(Routes.homepage);
        break;
      case 2:
        Get.toNamed(Routes.viewsubscriber, parameters: {'id': id.toString()});
        break;
      
      default:
        Get.toNamed(Routes.initial);
    }
}
}