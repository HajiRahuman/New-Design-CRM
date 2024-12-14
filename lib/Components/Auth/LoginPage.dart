
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Components/DashBoard/DashBoard.dart';
import 'package:crm/Components/DashBoard/SubscriberDashBoard.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/service/auth.dart' as auth_service;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool login = false;


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
      //  double screenWidth = MediaQuery.of(context).size.width;
      //     double screenHeight = MediaQuery.of(context).size.width;
    final notifier = Provider.of<ColorNotifire>(context, listen: false);
    return SafeArea(
        child: Scaffold(
          backgroundColor: notifier.getbgcolor,
      key: _key,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: 
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Spacer(),
                              Center(
                                child: Container(
                                            width: 500,
                                            height:600,
                                            decoration: BoxDecoration(
                                          color: notifire.getcontiner,
                                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                                        ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Container(
                                                child: Form(
                                                  key: _formKey,
                                                  autovalidateMode: _isSubmitted
                                                      ? AutovalidateMode.always
                                                      : AutovalidateMode.disabled,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Column(
                                                       mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                      
                                                         Center(
                                      child: Image.asset(
                                        'assets/images/logogsi.png',
                                        width: 230, // Set the desired width
                                        height: 150, // Set the desired height
                                        fit: BoxFit.cover, // Adjust the fit as needed
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                                          Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          isFranchise = true;
                                          _isSubsloginEnabled = false;
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:  isFranchise ? appMainColor : Colors.white,
                                        side: BorderSide(
                                          color: isFranchise ? appMainColor : Colors.grey,
                                        ),
                                      ),
                                      child: Text(
                                        'Franchise',
                                        style: TextStyle(
                                          color: isFranchise ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          isFranchise = false;
                                          _isSubsloginEnabled = true;
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: _isSubsloginEnabled ? appMainColor : Colors.white,
                                        side: BorderSide(
                                          color: _isSubsloginEnabled ? appMainColor : Colors.grey,
                                        ),
                                      ),
                                      child: Text(
                                        'Subscriber',
                                        style: TextStyle(
                                          color: _isSubsloginEnabled ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                                      ),
                                                        // kaka eta
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
    try {
      final authResp = await (_isSubsloginEnabled
          ? auth_service.Subslogin(usernameController.text, passwordController.text)
          : isFranchise
              ? auth_service.login(usernameController.text, passwordController.text)
              : null);

      if (authResp == null) {
        alert(context, "No response from server", true);
        return;
      }

      alert(context, authResp['msg'] ?? "Unexpected error", authResp['error'] ?? true);

      if (authResp['error'] == false) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("authToken", authResp['token'] ?? "");
        prefs.setBool("savePassword", _checkboxListTile);
        prefs.setInt("level_id", authResp['level_id'] ?? 111);
        prefs.setInt("id", authResp['id'] ?? 0);
        prefs.setBool('isIspAdmin', authResp['isIspAdmin'] ?? false);
        prefs.setBool('isSubscriber', authResp['isSubscriber'] ?? false);
        prefs.setString("username", authResp['username'] ?? "");
        prefs.setString("company", authResp['company'] ?? "");

        if (_checkboxListTile) {
          prefs.setString("username", usernameController.text);
          prefs.setString("password", passwordController.text);
        }

        getMenuAccess();
        if (_isSubsloginEnabled) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
            return SubscriberDashBoard(subscriberId: authResp['id'] ?? 0);
          }));
        } else if (isFranchise) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
            return DashBoard();
          }));
        }
      }
    } catch (e) {
      alert(context, "An error occurred: $e", true);
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
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                              ),
                                      
                                    
                                  
                                
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                 
             
        ),
      ),
      
    )
    );
  }

}
