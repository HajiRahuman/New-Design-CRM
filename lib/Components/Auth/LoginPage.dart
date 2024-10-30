import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/routes.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/DashBoard/DashBoard.dart';
import 'package:crm/Components/DashBoard/SubscriberDashBoard.dart';
import 'package:crm/Components/Subscriber/ViewSubscriber.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/StaticData.dart';
import 'package:crm/service/auth.dart' as auth_service;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool login = false;

// void main() {
//   runApp(MaterialApp(
//     home: LoginPage(),
//   ));
// }
class LoginPage extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  List<MaterialColor> colorizeColors = const [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];
  bool _checkboxListTile = false;
  TextStyle colorizeTextStyle = const TextStyle(
    fontSize: 40.0,
    // fontFamily:Theme.,
  );
  @override
  void initState() {
    super.initState();
    loadSavedLoginInformation();
  }

  int levelid = 0;
  bool isIspAdmin = false;
  int id = 0;
  int selectedAmount = 0;
  bool isSubscriber = false;
  bool isFranchise = true;
  bool _isSubmitted = false;
  String username='';

  getMenuAccess() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    levelid = pref.getInt('level_id') as int;
    isIspAdmin = pref.getBool('isIspAdmin') as bool;
    id = pref.getInt('id') as int;
    isSubscriber = pref.getBool('isSubscriber') as bool;
    username = pref.getString('username') as String;
    
    print('Usernameeeeeeeeeeeee----${username}');
    if (!isIspAdmin && levelid > 4) {}
  }

  Future<void> loadSavedLoginInformation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _checkboxListTile = prefs.getBool("savePassword") ?? false;
      if (_checkboxListTile) {
        usernameController.text = prefs.getString("username") ?? "";
        passwordController.text = prefs.getString("password") ?? "";
      }
    });
  }

  bool _isSubsloginEnabled = false;
  ColorNotifire notifire = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return SafeArea(
        child: Scaffold(
      key: _key,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout
            return Container(
              color: notifire.getprimerycolor,
              height: 900,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildlogin(width: constraints.maxWidth)],
                ),
              ),
            );
          } else if (constraints.maxWidth < 1200) {
            return Container(
              color: constraints.maxWidth < 860
                  ? notifire.getbgcolor
                  : notifire.getprimerycolor,
              height: 1000,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    constraints.maxWidth < 860
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 80),
                            child: _buildlogin(width: constraints.maxWidth),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 19, vertical: 80),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 782,
                                      decoration: BoxDecoration(
                                        color: notifire.getbgcolor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(37)),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: _buildlogin(
                                                width: constraints.maxWidth),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            );
          } else {
            // Website layout
            return SizedBox(
              height: 1000,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 80),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 782,
                                decoration: BoxDecoration(
                                  color: notifire.getbgcolor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(37)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildlogin(
                                          width: constraints.maxWidth),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    ));
  }

  Widget _buildlogin({required double width}) {
     double screenWidth = MediaQuery.of(context).size.width;
    final notifier = Provider.of<ColorNotifire>(context, listen: false);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Container(
          height: 734,
          decoration: BoxDecoration(
            color: notifire.getprimerycolor,
            borderRadius: const BorderRadius.all(Radius.circular(37)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width < 600 ? 20 : 50.0,
                vertical: width < 600 ? 40 : 50.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _isSubmitted
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    // height: 110,
                    child: Column(
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/images/logogsi.png',
                            width: 230, // Set the desired width
                            height: 150, // Set the desired height
                            fit: BoxFit.cover, // Adjust the fit as needed
                          ),
                        ),
                       
                            RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text('Franchise',
                                    style: mediumBlackTextStyle.copyWith(
                                        color: notifire.getMainText,fontSize: screenWidth * 0.04,)),
                                value: true,
                                groupValue: isFranchise,
                                onChanged: (val) {
                                  setState(() {
                                    isFranchise = val as bool;
                                    // Deselect User if Franchise is selected
                                    if (isFranchise) {
                                      _isSubsloginEnabled = false;
                                    }
                                  });
                                },
                              ),
                            
                            RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text('Subscriber',
                                   style: mediumBlackTextStyle.copyWith(
                                        color: notifire.getMainText,fontSize: screenWidth * 0.04,)),
                                value: true,
                                groupValue: _isSubsloginEnabled,
                                onChanged: (val) {
                                  setState(() {
                                    _isSubsloginEnabled = val as bool;
                                    // Deselect Franchise if User is selected
                                    if (_isSubsloginEnabled) {
                                      isFranchise = false;
                                    }
                                  });
                                },
                              ),
                            
                          
                        const SizedBox(
                          height: 21,
                        ),
                        TextFormField(
                          
                          autofocus: true,
                          controller: usernameController,
                           style: TextStyle(color:notifier.getMainText),
                          keyboardType: TextInputType.text,
                         decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: notifire.isDark
                                          ? notifire.geticoncolor
                                          : Colors.grey.shade200)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: notifire.isDark
                                          ? notifire.geticoncolor
                                          : Colors.grey.shade200)),
                              hintText: "Username",
                              hintStyle: mediumGreyTextStyle,
                              prefixIcon: SizedBox(
                                height: 20,
                                width: 50,
                                child: Center(
                                    child: SvgPicture.asset(
                                  "assets/at.svg",
                                  height: 18,
                                  width: 18,
                                  // ignore: deprecated_member_use
                                  color: notifire.geticoncolor,
                                )),
                              ),
                         ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },

                        ),
                        const SizedBox(
                          height: 19.8,
                        ),
                        TextFormField(
                          autofocus: true,
                          obscureText: _obscurePassword,
                          controller: passwordController,
                           style: TextStyle(color:notifier.getMainText),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: notifire.isDark
                                          ? notifire.geticoncolor
                                          : Colors.grey.shade200)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(
                                      color: notifire.isDark
                                          ? notifire.geticoncolor
                                          : Colors.grey.shade200)),
                              hintText: "Password",
                              hintStyle: mediumGreyTextStyle,
                              prefixIcon: SizedBox(
                                height: 20,
                                width: 50,
                                child: Center(
                                    child: SvgPicture.asset(
                                  "assets/lock.svg",
                                  height: 18,
                                  width: 18,
                                  // ignore: deprecated_member_use
                                  color: notifire.geticoncolor,
                                )),
                              ),
                              suffixIcon: IconButton(
                                color:  notifier.geticoncolor,
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 19.8,
                        ),
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text('Remember Me',
                              style: mediumBlackTextStyle.copyWith(
                                  color: notifire.getMainText)),
                          value: _checkboxListTile,
                          onChanged: (value) {
                            setState(() {
                              _checkboxListTile = !_checkboxListTile;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 19.8,
                        ),
                        ElevatedButton(
                            onPressed: () async {
  setState(() {
    _isSubmitted = true;
  });

  if (_formKey.currentState!.validate()) {
    
    final authResp = await (_isSubsloginEnabled
    ? auth_service.Subslogin(
        usernameController.text,
        passwordController.text,
      )
    : isFranchise
        ? auth_service.login(
            usernameController.text,
            passwordController.text,
          )
        : null); // Handle the case where neither condition is true, if needed

    alert(context, authResp!['msg'], authResp['error']);

    if (authResp['error'] == false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("authToken", authResp['token']);
      prefs.setBool("savePassword", _checkboxListTile);
      prefs.setInt("level_id", authResp['level_id'] ?? 111);
      prefs.setInt("id", authResp['id']);
      prefs.setBool('isIspAdmin', authResp['isIspAdmin']);
      prefs.setBool('isSubscriber', authResp['isSubscriber']);
       prefs.setString("username", authResp['username']);
      if (_checkboxListTile) {
        prefs.setString("username", usernameController.text);
        prefs.setString("password", passwordController.text);
      }
   getMenuAccess();
      if (_isSubsloginEnabled) {
        // If Subslogin was called, navigate to ViewSubscriber()
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
          return SubscriberDashBoard(subscriberId: id,);
        }));
      } else if (isFranchise){
        // Otherwise, navigate to Dashboard()
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
          return DashBoard();
        }));
      }
    }
  }
},

                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                                backgroundColor: appMainColor,
                                elevation: 0,
                                fixedSize: const Size.fromHeight(60)),
                            child: Row(
                              children: [
                                const Expanded(
                                    child: SizedBox(
                                  width: 10,
                                )),
                                Text(
                                  "Login",
                                  style: mediumBlackTextStyle.copyWith(
                                      color: Colors.white),
                                ),
                                const Expanded(
                                    child: SizedBox(
                                  width: 10,
                                )),
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Center(
                                      child: SvgPicture.asset(
                                    "assets/arrow-right-small.svg",
                                    width: 12,
                                    height: 12,
                                    color: Colors.white,
                                  )),
                                ),
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
