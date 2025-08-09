import 'dart:async';

import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:crm/AppBar.dart';
import 'package:crm/AppStaticData/AppStaticData.dart';
import 'package:crm/AppStaticData/toaster.dart';
import 'package:crm/Controller/Drawer.dart';
import 'package:crm/Providers/providercolors.dart';
import 'package:crm/model/UpdateSubscriber.dart';
import 'package:crm/model/subscriber.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:crm/service/addSubscribers.dart' as addsubscriberSrv;
import 'package:crm/service/UpdateSubscriber.dart' as updatesubscriberSrv;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/addSubscriber.dart';
import '../../../service/crypto.dart';

class AddSubscriber extends StatefulWidget {
  UpdateSubsDet? updateSubsDet;
  int? subscriberId;
  int? circleid;
  int? resellerid;
  String? mac;
  String? macid;
  int? srvusermode;
  int? aliceid;

  AddSubscriber(
      {super.key,
      this.subscriberId,
      this.circleid,
      this.resellerid,
      this.mac,
      this.macid,
      this.srvusermode,
      this.aliceid});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<AddSubscriber>
    with SingleTickerProviderStateMixin {
  FormGroup? form;

  void createForm() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('M/d/yyyy hh:mm:ss a').format(now);
    form = FormGroup({
      'userinfo': FormGroup({
        'fullname': FormControl<String>(
            value: widget.updateSubsDet != null
                ? widget.updateSubsDet?.info.fullname
                : '',
            validators: [Validators.required]),
        'emailpri': FormControl<String>(
            value: widget.updateSubsDet != null
                ? widget.updateSubsDet?.info.emailpri
                : '',
            validators: [Validators.required, Validators.email]),
        'emailsec': FormControl<String>(),
        'mobile': FormControl<String>(
            value: widget.updateSubsDet != null
                ? widget.updateSubsDet?.info.mobile
                : '',
            validators: [Validators.required, Validators.number]),
        'telnum': FormControl<String>(),
        'desc': FormControl<String>(),
        'ugst': FormControl<String>(
            value: widget.updateSubsDet != null
                ? widget.updateSubsDet?.info.ugst
                : ''),
        'latitude': FormControl<double>(),
        'longitude': FormControl<double>(),
        'aliceid': FormControl<int>(
            value: widget.updateSubsDet?.info.aliceid,
            validators: [Validators.required]),
        'ulmm': FormControl<int>(
            value: widget.updateSubsDet != null
                ? widget.updateSubsDet?.info.ulmm
                : 2),
        'locality': FormControl<int>(
            value: widget.updateSubsDet != null
                ? widget.updateSubsDet?.info.locality
                : 0),
        'gststatus':
            FormControl<bool>(value: widget.updateSubsDet?.info.gststatus),
        'addressflag':
            FormControl<bool>(value: widget.updateSubsDet?.info.addressflag),
        'contractfrom': FormControl<String>(),
        'contractto': FormControl<String>(),
      }),
      'address_book': FormArray([]),
      'profileid': FormControl<String>(
          value: widget.updateSubsDet?.profileid,
          validators: [Validators.required, Validators.minLength(6)]),
      'profilepsw': FormControl<String>(validators: [Validators.required]),
      'authpsw': FormControl<String>(validators: [Validators.required]),
      'macid': FormControl<String>(),
      'mac': FormControl<String>(),
     'simultaneoususe': FormControl<int>(
          value:widget.updateSubsDet != null ? widget.updateSubsDet?.simultaneoususe:1,),
      'expiration': FormControl<String>(
        value: widget.updateSubsDet != null
            ? DateFormat('M/d/yyyy hh:mm:ss a').format(
                DateTime.parse(widget.updateSubsDet!.expiration).toLocal())
            : formattedDate,
      ),
      'ipv4': FormControl<String>(value: widget.updateSubsDet?.ipv4),
      'ipv4id': FormControl<int>(value: widget.updateSubsDet?.ipv4id),
      'ipv6': FormControl<String>(value: widget.updateSubsDet?.ipv6),
      'ipv6id': FormControl<int>(value: widget.updateSubsDet?.ipv6id),
      'circleid': FormControl<int>(
          value: widget.circleid, validators: [Validators.required]),
      'resellerid': FormControl<int>(
          value: widget.resellerid, validators: [Validators.required]),
      'acctype': FormControl<int>(
          value:
              widget.updateSubsDet != null ? widget.updateSubsDet?.acctype : 0),
      'conntype': FormControl<int>(
          value: widget.updateSubsDet != null
              ? widget.updateSubsDet?.conntype
              : 0),
      'usermode': FormControl<bool>(
        value: widget.updateSubsDet?.usermode == 1 ? true : false,
      ),
      'acctstatus': FormControl<int>(
          value: widget.updateSubsDet != null
              ? widget.updateSubsDet?.acctstatus
              : 1),
      'packid': FormControl<int>(
          value: widget.updateSubsDet?.packid,
          validators: [Validators.required]),
      'srvusermode': FormControl<int>(
          value: widget.updateSubsDet != null ? widget.srvusermode : 0),
      'ipmode': FormControl<int>(
          value:
              widget.updateSubsDet != null ? widget.updateSubsDet?.ipmode : 0),
      'PublicIpv4': FormControl<int>(),
      'ip6mode': FormControl<int>(
          value:
              widget.updateSubsDet != null ? widget.updateSubsDet?.ip6mode : 0),
      'dllimit': FormControl<int>(),
      'uplimit': FormControl<int>(),
      'totallimit': FormControl<int>(),
      'timelimit': FormControl<int>(),
      'enablemac': FormControl<bool>(
        value: widget.updateSubsDet != null
            ? widget.updateSubsDet?.enablemac == 1
                ? true
                : false
            : null,
      ),
    });
    form?.control('acctype').valueChanges.listen((value) {
      final macidControl = form?.control('macid') as FormControl<String>;
      if (value == acctypes['Mac']) {
        macidControl.setValidators([
          Validators.required,
          Validators.pattern(r'^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$'),
        ]);
      } else {
        macidControl.clearValidators();
      }
      macidControl.updateValueAndValidity();
    });
  }

  FormArray get addressBook => form?.control('address_book') as FormArray;

  createAddrForm(int index, data) async {
    print('data-------$data');
    addressBook.add(FormGroup({
      'country': FormControl<int>(
          value: widget.updateSubsDet != null
              ? widget.updateSubsDet?.addressBook[index].country
              : 0),
      'alicename': FormControl<String>(
          value: widget.updateSubsDet != null
              ? widget.updateSubsDet?.addressBook[index].alicename
              : data['alicename']),
      'pincode': FormControl<int>(
          value: widget.updateSubsDet != null
              ? widget.updateSubsDet?.addressBook[index].pincode
              : null,
          validators: [Validators.required]),
      'state': FormControl<String>(
        value: widget.updateSubsDet != null
            ? widget.updateSubsDet?.addressBook[index].state
            : null,
      ),
      'district': FormControl<String>(
        value: widget.updateSubsDet != null
            ? widget.updateSubsDet?.addressBook[index].district
            : null,
      ),
      'districtid': FormControl<int>(),
      'stateid': FormControl<int>(),
      'village': FormControl<String>(
          validators: [Validators.required],
          value: widget.updateSubsDet != null
              ? widget.updateSubsDet?.addressBook[index].village
              : null),
      'region': FormControl<String>(
          value: widget.updateSubsDet != null
              ? widget.updateSubsDet?.addressBook[index].region
              : null),
      'block': FormControl<String>(
          value: widget.updateSubsDet != null
              ? widget.updateSubsDet?.addressBook[index].block
              : null),
      'blockid': FormControl<int>(),
      'address': FormControl<String>(
          value: widget.updateSubsDet != null
              ? widget.updateSubsDet?.addressBook[index].address
              : null,
          validators: [Validators.required]),
      'area': FormControl<String>(
          value: widget.updateSubsDet != null
              ? widget.updateSubsDet?.addressBook[index].village
              : null,
          validators: [Validators.required]),
      'areaid': FormControl<int>(),
      'aliceid': FormControl<int>(validators: [Validators.required]),
    }));
    setState(() {});
  }

  // //
  // FormArray get addressBook => form?.control('address_book') as FormArray;

  final GlobalKey<MyAppState> packageAndIpKey = GlobalKey<MyAppState>();
  TextEditingController propswController = TextEditingController();
  TextEditingController authpswController = TextEditingController();
  TextEditingController downLimitController = TextEditingController();
  TextEditingController upLimitController = TextEditingController();
  TextEditingController totLimitController = TextEditingController();
  TextEditingController onlineLimitController = TextEditingController();

  int? reseller;
  int? ResellerAlice;
  int selectedIndex = 0;
  String? pinCodeOpt;
  bool isExpanded = false;
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  bool status = false;

  bool showTextField = false;
  bool showTextField1 = false;
  int selectedDownMbps = 0;
  int selectedUpMbps = 0;
  int selectedTotMbps = 0;
  int selectedOnlTime = 0;

  Map<String, int> ulmms = {
    'Disable': 0,
    'Wireless': 1,
    'Fiber': 2,
    'Hub': 3,
  };

  Map<String, int> locality = {
    'Urban(City)': 0,
    'Rural(Village)': 1,
  };

  Map<String, int> acctypes = {
    'Normal': 0,
    'Mac': 1,
  };

  String? conTypeOpt;
  Map<String, int> contype = {
    'Home': 0,
    'Demo': 1,
    'SME/MSME': 2,
  };

  String? userModeOpt;
  Map<String, bool> usermode = {
    'Prepaid': false,
    'Postpaid': true,
  };

  String? accStsOpt;
  Map<String, int> accstatus = {
    'Disable': 0,
    'Enable': 1,
    'Hold': 2,
    'Suspend': 3,
    'Terminate': 4,
  };

  String? pacusModeOpt;
  Map<String, int> pacusmode = {
    'Disable': 0,
    'Show Old Pack': 1,
    'Show New Pack': 2,
    'Show First Renewal Pack': 3,
  };

  Map<String, int> ipv4 = {
    'DHCP': 0,
    'Local Static Ipv4': 1,
    'Public Static Ipv4': 2,
  };

  String? SelectedIp6Mod;
  Map<String, int> ipv6 = {
    'DHCP': 0,
    'Local Static Ipv6': 1,
    'Public Static Ipv6': 2,
  };
  Map<String, int> Country = {
    'India': 0,
  };
  late TabController _tabController; // Use TabController here.
  // Track the selected tab.

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController.
    super.dispose();
  }

  List<GetLevelDet> level = [];
  Future<void> GetLevel() async {
    GetLevelDetResp resp = (await addsubscriberSrv.getLevel());
    setState(() {
      level = resp.error == true ? [] : resp.data ?? [];
    });
  }

  int levelid = 0;
  bool isIspAdmin = false;
  int id = 0;
  int selectedAmount = 0;
  bool isSubscriber = false;
  bool reselusertype = false;
  getMenuAccess() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    levelid = pref.getInt('level_id') as int;
    isIspAdmin = pref.getBool('isIspAdmin') as bool;
    id = pref.getInt('id') as int;
    isSubscriber = pref.getBool('isSubscriber') as bool;

    resellerAlice(widget.resellerid ?? id);
    getReseller(widget.resellerid ?? id);
    GetLevel();
    circle();
    ResellerList();
  }

  @override
  void initState() {
    print('AliceId-----${widget.aliceid}');
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Listen to changes in the TabController.
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedIndex = _tabController.index;
        });
      }
    });
    bool enableMac = widget.updateSubsDet != null
        ? widget.updateSubsDet?.enablemac == 1
        : false;
    createForm();

    if (widget.subscriberId != null) {
      updateSubDet();
    } else {
      createAddrForm(0, {'alicename': 'Installation'});
    }
    // print('Id----${widget.subscriberId}');

    getMenuAccess();
    // Future.delayed(const Duration(seconds: 20), () {
    //   getLocation();
    // });
  }

  deleteAddrForm() async {
    // Assuming addressBook is a FormArray
    if (addressBook.controls.isNotEmpty) {
      addressBook.removeAt(
          addressBook.controls.length - 1); // Remove the last created form
      setState(() {});
    }
  }

  String? selectedOption;
  List<resellerAliceDet> filteredDetails = [];
  late final List<List<PincodeDet>?> _pincodeDetailsList = [null, null];

  Future<void> fetchPincodeDet(int pincode, int index) async {
    PincodeResp resp = (await addsubscriberSrv.getPincode(pincode));
    setState(() {
      if (resp.error == true) {
        _pincodeDetailsList[index] = [];
      } else {
        _pincodeDetailsList[index] = resp.data ?? [];
      }
    });
  }

  void updateDetails(int index, int selectedIndex) {
    var selectedDetail = _pincodeDetailsList[selectedIndex]?.firstWhere(
      (detail) =>
          detail.areaName == form?.control('address_book.$index.area').value,
    );

    setState(() {
      if (selectedDetail != null) {
        form?.control('address_book.$index.village').value =
            selectedDetail.areaName;
        form?.control('address_book.$index.area').value =
            selectedDetail.areaName;
        form?.control('address_book.$index.state').value =
            selectedDetail.stateName;
        form?.control('address_book.$index.district').value =
            selectedDetail.districtName;
        // form?.control('address_book.$index.region').value = selectedDetail.;
        form?.control('address_book.$index.block').value =
            selectedDetail.blockName;
        form?.control('address_book.$index.areaid').value =
            selectedDetail.pincodeId;
        form?.control('address_book.$index.blockid').value =
            selectedDetail.blockId;
        form?.control('address_book.$index.stateid').value = selectedDetail.sid;
        form?.control('address_book.$index.districtid').value =
            selectedDetail.distId;
      }
    });
  }

  List<resellerAliceDet> reselleralice = [];
  Future<void> resellerAlice(int id) async {
    resellerAliceResp resp = (await addsubscriberSrv.resellerAlice(id));
    setState(() {
      reselleralice = resp.error == true ? [] : resp.data ?? [];
    });
  }

  List<circleDet> idAndNames = [];
  Future<void> circle() async {
    String apiUrl = 'circle';
    circleResp resp = (await addsubscriberSrv.circle(apiUrl));
    setState(() {
      idAndNames = resp.error == true ? [] : resp.data ?? [];
    });
  }

  List<resellerDet> resellerOpt = [];
  Future<void> ResellerList() async {
    resellerResp resp = (await addsubscriberSrv.reseller());
    setState(() {
      resellerOpt = resp.error == true ? [] : resp.data ?? [];
    });
  }

  List<getResellerDet> resellerList = [];
  Future<void> getReseller(int id) async {
    getResellerResp resp = (await addsubscriberSrv.getresellerPack(id));
    setState(() {
      resellerList = resp.error == true ? [] : resp.data ?? [];
    });
  }

//All Ipv4
  int? getIpv4;
  List<getAllIpv4Det> getIpv4Opt = [];
  Future<void> GetAllIpv4(int id) async {
    getAllIpv4Resp resp = (await addsubscriberSrv.getAllIpv4(id));
    setState(() {
      getIpv4Opt = resp.error == true ? [] : resp.data ?? [];
    });
  }

  void updateSubDet() async {
    final resp =
        await updatesubscriberSrv.updateSubscriber(widget.subscriberId!);
    setState(() {
      if (resp.error) {
        alert(context, resp.msg);
        return;
      }

      widget.updateSubsDet = resp.data;
      createForm();
      // print('Id----${widget.subscriberId}');
      // print('Id----${widget.updateSubsDet?.addressBook}');

      widget.updateSubsDet?.addressBook.asMap().forEach((index, e) {
        // print('Address Entry--- $e');
        createAddrForm(index, e);

        // Fetch pincode details for each address entry
        fetchPincodeDet(e.pincode, index);
      });
    });

    if (widget.updateSubsDet?.packid != null) {
      GetPack(widget.updateSubsDet!.packid);
    }
  }

  void updateValidators() {
    // 'dllimit' validator
    final dlLimitControl = form!.control('dllimit');
    if ((getPackOpt?.packmode ?? 0) >= 3 &&
        ((getPackOpt?.fupmode ?? -1) == 0 ||
            (getPackOpt?.fupmode ?? -1) == 2)) {
      dlLimitControl.setValidators([Validators.required]);
    } else {
      dlLimitControl.setValidators([]);
    }
    dlLimitControl.updateValueAndValidity();

    // 'uplimit' validator
    final upLimitControl = form!.control('uplimit');
    if ((getPackOpt?.packmode ?? 0) >= 3 &&
        ((getPackOpt?.fupmode ?? -1) == 1 ||
            (getPackOpt?.fupmode ?? -1) == 2)) {
      upLimitControl.setValidators([Validators.required]);
    } else {
      upLimitControl.setValidators([]);
    }
    upLimitControl.updateValueAndValidity();

    // 'timelimit' validator
    final timeLimitControl = form!.control('timelimit');
    if ((getPackOpt?.packmode == 1 || getPackOpt?.packmode == 4)) {
      timeLimitControl.setValidators([Validators.required]);
    } else {
      timeLimitControl.setValidators([]);
    }
    timeLimitControl.updateValueAndValidity();

    // 'ipv4' validator
    final ipv4Control = form!.control('ipv4');
    if (form?.value['ipmode'] == ipv4['Local Static Ipv4']) {
      ipv4Control.setValidators([Validators.required]);
    } else {
      ipv4Control.setValidators([]);
    }
    ipv4Control.updateValueAndValidity();

    // 'ipv4id' validator
    final ipv4IdControl = form!.control('ipv4id');
    if (form?.value['ipmode'] == ipv4['Public Static Ipv4']) {
      ipv4IdControl.setValidators([Validators.required]);
    } else {
      ipv4IdControl.setValidators([]);
    }
    ipv4IdControl.updateValueAndValidity();

    // 'ipv6' validator
    final ipv6Control = form!.control('ipv6');
    if (form?.value['ip6mode'] == ipv6['Local Static Ipv6']) {
      ipv6Control.setValidators([Validators.required]);
    } else {
      ipv6Control.setValidators([]);
    }
    ipv6Control.updateValueAndValidity();

    // 'ipv6id' validator
    final ipv6IdControl = form!.control('ipv6id');
    if (form?.value['ip6mode'] == ipv6['Public Static Ipv6']) {
      ipv6IdControl.setValidators([Validators.required]);
    } else {
      ipv6IdControl.setValidators([]);
    }
    ipv6IdControl.updateValueAndValidity();
    // final macIdControl = form!.control('macid');
    // if (form?.value['acctype'] == acctypes['Mac']) {
    //   macIdControl.setValidators([
    //     Validators.required,
    //     Validators.pattern(r'^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$') // Validate MAC address format
    //   ]);
    // } else {
    //   macIdControl.setValidators([]);
    // }
    // macIdControl.updateValueAndValidity();
  }

  GetPackDet? getPackOpt;
  Future<void> GetPack(packid) async {
    GetPackResp resp = await addsubscriberSrv.getPack(packid);
    setState(() {
      if (resp.error) alert(context, resp.msg);
      // print('Response Data: ${resp}');
      getPackOpt = resp.error == true ? null : resp.data;
      // debugPrint('Pack----$getPackOpt');
    });
    updateValidators();

    // Add listeners to update validators when relevant conditions change
    // form!.valueChanges.listen((_) {
    //   updateValidators();
    // });
  }

//Add Subscriber
  Future<void> addSubscribers(value) async {
    final resp = await addsubscriberSrv.addSubscriber(value);
    if (resp['error'] == false) {
      alert(context, resp['msg'], resp['error']);
      Navigator.pop(context, true);
    }
  }

  void updateSub(value) async {
    final resp = await updatesubscriberSrv.UpdateSubscribers(
        widget.subscriberId!, value);
    setState(() {
      if (resp['error'] == false) {
        alert(context, resp['msg'], resp['error']);
        Navigator.pop(context, true);
      }
    });
  }

  bool ProAuthPswSame = false;
  String getSecondTextFieldValue() {
    return ProAuthPswSame ? propswController.text : authpswController.text;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHight = MediaQuery.of(context).size.height;
    final notifier = Provider.of<ColorNotifire>(context);
    // final textStyle = Theme.of(context).textTheme.bodyLarge;
    // final selectedTextStyle = textStyle?.copyWith(fontWeight: FontWeight.bold);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DarwerCode(),
        backgroundColor: notifier.getbgcolor,
        resizeToAvoidBottomInset: false,
        body: ReactiveForm(
          formGroup: form!,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        widget.updateSubsDet != null
                            ? 'Update Subscriber'
                            : 'Add Subscriber',
                        style: TextStyle(
                          color: notifier.getMainText,
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                      trailing: CircleAvatar(
                        radius: 20,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: notifier.getMainText,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Visibility(
                      visible: levelid < 4 ||
                          (reselusertype &&
                                  [5, 6, 7, 8, 9, 10].contains(levelid) ||
                              isIspAdmin == true),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ReactiveDropdownField<int>(
                              validationMessages: {
                                'required': (error) => 'Circle required!',
                              },
                              focusColor: Colors.transparent,
                              formControlName:
                                  'circleid', // Provide a unique form control name
                              items: idAndNames.map((item) {
                                return DropdownMenuItem<int>(
                                  value: item.id,
                                  child: Text(item.circle_name),
                                );
                              }).toList(),
                              dropdownColor: notifier.getcontiner,
                              style: TextStyle(color: notifier.getMainText),

                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 15),
                                labelStyle:
                                    mediumGreyTextStyle.copyWith(fontSize: 13),
                                labelText: 'Circle',
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: notifier.isDark
                                            ? notifier.geticoncolor
                                            : Colors.black)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: notifier.isDark
                                            ? notifier.geticoncolor
                                            : Colors.black)),
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  // Reseller();
                                  reseller = null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ReactiveDropdownField<int>(
                              readOnly: widget.subscriberId != null,
                              validationMessages: {
                                'required': (error) => 'Reseller required!',
                              },
                              focusColor: Colors.transparent,
                              formControlName: 'resellerid',
                              isExpanded: true,
                              items: resellerOpt
                                  .where((item) =>
                                      item.circle ==
                                          form?.value[
                                              'circleid'] && // Match selected circle
                                      ([5, 6, 8, 9, 11, 12].contains(
                                          item.levelid))) // Filter by levels
                                  .map((item) {
                                return DropdownMenuItem<int>(
                                  value: item.id,
                                  child: Text(
                                      item.company), // Display the company name
                                );
                              }).toList(),
                              dropdownColor: notifier.getcontiner,
                              style: TextStyle(color: notifier.getMainText),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 15),
                                labelStyle:
                                    mediumGreyTextStyle.copyWith(fontSize: 13),
                                labelText: 'Reseller',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: notifier.isDark
                                          ? notifier.geticoncolor
                                          : Colors.black),
                                ),
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  int selectedResellerId = int.parse(
                                      form?.value['resellerid']?.toString() ??
                                          '0');
                                  resellerAlice(
                                      selectedResellerId); // Fetch Alice data
                                  getReseller(
                                      selectedResellerId); // Update reseller list
                                  GetAllIpv4(
                                      selectedResellerId); // Fetch IPv4 options
                                });
                                ResellerAlice = null;
                                getIpv4 = null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text('Individual',
                                  style: mediumBlackTextStyle.copyWith(
                                      color: notifier.getMainText))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    // if (selectedOption == 'Individual')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SegmentedTabControl(
                        controller: _tabController,
                        tabTextColor: Colors.black,
                        selectedTabTextColor: Colors.white,
                        indicatorPadding: const EdgeInsets.all(4),
                        squeezeIntensity: 2,
                        tabPadding: const EdgeInsets.symmetric(horizontal: 8),
                        textStyle: mediumBlackTextStyle.copyWith(
                            color: notifier.getMainText),
                        selectedTextStyle: mediumBlackTextStyle.copyWith(
                            color: notifier.getMainText),
                        tabs: const [
                          SegmentTab(
                            backgroundColor: Colors.white,
                            selectedTextColor: Colors.white,
                            label: 'BASIC',
                            color: appMainColor,
                          ),
                          SegmentTab(
                            backgroundColor: Colors.white,
                            selectedTextColor: Colors.white,
                            label: 'PROFILE',
                            color: appMainColor,
                          ),
                          SegmentTab(
                            backgroundColor: Colors.white,
                            selectedTextColor: Colors.white,
                            label: 'PACKAGE & IP',
                            color: appMainColor,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height -
                            200, // Adjust as needed
                        child: TabBarView(
                          controller: _tabController,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.3)),
                                    ),
                                    child: ExpansionTile(
                                      collapsedIconColor: notifier.getmaintext,
                                      iconColor: notifier.getmaintext,
                                      trailing: Icon(
                                        isExpanded
                                            ? Icons.arrow_drop_down_circle
                                            : Icons.arrow_drop_down,
                                        color: notifier.getmaintext,
                                      ),
                                      onExpansionChanged: (bool expanding) {
                                        setState(() {
                                          isExpanded = expanding;
                                        });
                                      },
                                      expandedAlignment: Alignment.topLeft,
                                      title: Text(
                                        'Basic',
                                        style: mediumBlackTextStyle.copyWith(
                                            color: notifier.getMainText),
                                      ),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child:
                                                    ReactiveTextField<String>(
                                                  validationMessages: {
                                                    'required': (error) =>
                                                        'FullName required',
                                                  },
                                                  formControlName:
                                                      'userinfo.fullname',
                                                  style: TextStyle(
                                                      color:
                                                          notifier.getMainText),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    labelStyle:
                                                        mediumGreyTextStyle
                                                            .copyWith(
                                                                fontSize: 13),
                                                    labelText: 'Fullname',
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child:
                                                    ReactiveTextField<String>(
                                                  validationMessages: {
                                                    'required': (error) =>
                                                        'E-Mail required!',
                                                    'email': (error) =>
                                                        'The email value must be a valid email'
                                                  },
                                                  formControlName:
                                                      'userinfo.emailpri',
                                                  style: TextStyle(
                                                      color:
                                                          notifier.getMainText),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    labelStyle:
                                                        mediumGreyTextStyle
                                                            .copyWith(
                                                                fontSize: 13),
                                                    labelText: 'Email',
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child:
                                                    ReactiveTextField<String>(
                                                  formControlName:
                                                      'userinfo.emailsec',
                                                  style: TextStyle(
                                                      color:
                                                          notifier.getMainText),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    labelStyle:
                                                        mediumGreyTextStyle
                                                            .copyWith(
                                                                fontSize: 13),
                                                    labelText:
                                                        'Alternate -E-Mail',
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child:
                                                    ReactiveTextField<String>(
                                                  validationMessages: {
                                                    'required': (error) =>
                                                        'Mobile is required',
                                                  },
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9]')),
                                                  ],
                                                  formControlName:
                                                      'userinfo.mobile',
                                                  style: TextStyle(
                                                      color:
                                                          notifier.getMainText),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    labelStyle:
                                                        mediumGreyTextStyle
                                                            .copyWith(
                                                                fontSize: 13),
                                                    labelText: 'Mobile',
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child:
                                                    ReactiveTextField<String>(
                                                  formControlName:
                                                      'userinfo.telnum',
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9]')),
                                                  ],
                                                  style: TextStyle(
                                                      color:
                                                          notifier.getMainText),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    labelStyle:
                                                        mediumGreyTextStyle
                                                            .copyWith(
                                                                fontSize: 13),
                                                    labelText: 'Telephone',
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child:
                                                    ReactiveTextField<String>(
                                                  maxLines: 2,
                                                  formControlName:
                                                      'userinfo.desc',
                                                  style: TextStyle(
                                                      color:
                                                          notifier.getMainText),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    labelStyle:
                                                        mediumGreyTextStyle
                                                            .copyWith(
                                                                fontSize: 13),
                                                    labelText: 'Description',
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                ),
                                                child:
                                                    ReactiveDropdownField<int>(
                                                  focusColor:
                                                      Colors.transparent,
                                                  formControlName:
                                                      'userinfo.aliceid',
                                                  isExpanded: true,
                                                  items:
                                                      reselleralice.map((item) {
                                                    // Check if widget.updateSubsDet is null
                                                    // final isDisabled = widget.updateSubsDet != null;
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: item.aliceid,
                                                      // Set enabled based on the condition
                                                      // enabled: !isDisabled,
                                                      child:
                                                          Text(item.aliceName),
                                                    );
                                                  }).toList(),
                                                  dropdownColor:
                                                      notifier.getcontiner,
                                                  style: TextStyle(
                                                      color:
                                                          notifier.getMainText),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    labelStyle:
                                                        mediumGreyTextStyle
                                                            .copyWith(
                                                                fontSize: 13),
                                                    labelText:
                                                        'Reseller Branch',
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.3)),
                                    ),
                                    child: ExpansionTile(
                                      collapsedIconColor: notifier.getmaintext,
                                      iconColor: notifier.getmaintext,
                                      trailing: Icon(
                                        isExpanded1
                                            ? Icons.arrow_drop_down_circle
                                            : Icons.arrow_drop_down,
                                        color: notifier.getmaintext,
                                      ),
                                      onExpansionChanged: (bool expanding) {
                                        setState(() {
                                          isExpanded1 = expanding;
                                        });
                                      },
                                      expandedAlignment: Alignment.topLeft,
                                      title: Text(
                                        'Additional',
                                        style: mediumBlackTextStyle.copyWith(
                                            color: notifier.getMainText),
                                      ),
                                      children: [
                                        ReactiveSwitchListTile(
                                          title: Text(
                                            "GST Status",
                                            style:
                                                mediumBlackTextStyle.copyWith(
                                                    color:
                                                        notifier.getMainText),
                                          ),
                                          formControlName: 'userinfo.gststatus',
                                          onChanged: (val) {
                                            setState(() {});
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        if (form
                                                ?.control('userinfo.gststatus')
                                                .value ==
                                            true)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0,
                                            ),
                                            child: ReactiveTextField<String>(
                                              validationMessages: {
                                                'required': (error) =>
                                                    'GST Number is required',
                                              },
                                              formControlName: 'userinfo.ugst',
                                              style: TextStyle(
                                                  color: notifier.getMainText),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 15),
                                                labelStyle: mediumGreyTextStyle
                                                    .copyWith(fontSize: 13),
                                                labelText: 'GST Number',
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    borderSide: BorderSide(
                                                        color: notifier.isDark
                                                            ? notifier
                                                                .geticoncolor
                                                            : Colors.black)),
                                              ),
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child:
                                                    ReactiveDropdownField<int>(
                                                  focusColor:
                                                      Colors.transparent,
                                                  formControlName:
                                                      'userinfo.ulmm',
                                                  isExpanded: true,
                                                  items: ulmms.keys.map<
                                                      DropdownMenuItem<int>>(
                                                    (String key) {
                                                      final value = ulmms[key];
                                                      return DropdownMenuItem<
                                                          int>(
                                                        value: value,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          child: Text(key),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                  dropdownColor:
                                                      notifier.getcontiner,
                                                  style: TextStyle(
                                                      color:
                                                          notifier.getMainText),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    labelStyle:
                                                        mediumGreyTextStyle
                                                            .copyWith(
                                                                fontSize: 13),
                                                    labelText:
                                                        'User Last Mile Media',
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child:
                                                    ReactiveDropdownField<int>(
                                                  focusColor:
                                                      Colors.transparent,
                                                  formControlName:
                                                      'userinfo.locality',
                                                  isExpanded: true,
                                                  items: locality.keys.map<
                                                      DropdownMenuItem<int>>(
                                                    (String key) {
                                                      final value =
                                                          locality[key];
                                                      return DropdownMenuItem<
                                                          int>(
                                                        value: value,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          child: Text(key),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                  dropdownColor:
                                                      notifier.getcontiner,
                                                  style: TextStyle(
                                                      color:
                                                          notifier.getMainText),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            left: 15),
                                                    labelStyle:
                                                        mediumGreyTextStyle
                                                            .copyWith(
                                                                fontSize: 13),
                                                    labelText: 'Locality',
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.3)),
                                    ),
                                    child: ExpansionTile(
                                        collapsedIconColor:
                                            notifier.getmaintext,
                                        iconColor: notifier.getmaintext,
                                        trailing: Icon(
                                          isExpanded2
                                              ? Icons.arrow_drop_down_circle
                                              : Icons.arrow_drop_down,
                                          color: notifier.getmaintext,
                                        ),
                                        onExpansionChanged: (bool expanding) {
                                          setState(() {
                                            isExpanded2 = expanding;
                                          });
                                        },
                                        expandedAlignment: Alignment.topLeft,
                                        title: Text(
                                          'Address',
                                          style: mediumBlackTextStyle.copyWith(
                                              color: notifier.getMainText),
                                        ),
                                        children: [
                                          ReactiveSwitchListTile(
                                            title: Text(
                                              "Installation & Billing Address are different",
                                              style:
                                                  mediumBlackTextStyle.copyWith(
                                                      color:
                                                          notifier.getMainText),
                                            ),
                                            formControlName:
                                                'userinfo.addressflag',
                                            onChanged: (val) {
                                              if (form
                                                      ?.control(
                                                          'userinfo.addressflag')
                                                      .value !=
                                                  true) {
                                                deleteAddrForm();
                                              } else {
                                                createAddrForm(0,
                                                    {'alicename': 'Billing'});
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          // const Align(
                                          //   alignment: Alignment.topLeft,
                                          //   child: Text(
                                          //     'Installation Address',
                                          //     style: TextStyle(
                                          //       color: Colors.black,
                                          //       fontWeight:
                                          //           FontWeight.bold,
                                          //       fontSize: 20,
                                          //     ),
                                          //   ),
                                          // ),

                                          const SizedBox(height: 5),
                                          // _buildExtraDisplayed(),
                                          Column(children: [
                                            ReactiveFormArray(
                                                formArrayName: 'address_book',
                                                builder: (context, formArray,
                                                    child) {
                                                  final book = addressBook
                                                      .controls
                                                      .map((control) =>
                                                          control as FormGroup)
                                                      .map((currentform) {
                                                    int index = addressBook
                                                        .controls
                                                        .indexOf(currentform);

                                                    return ReactiveForm(
                                                        formGroup: currentform,
                                                        child: Column(
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Text(
                                                                  index == 0
                                                                      ? 'Installation Address'
                                                                      : 'Billing Address',
                                                                  style: mediumBlackTextStyle
                                                                      .copyWith(
                                                                          color:
                                                                              notifier.getMainText),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),

                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                                child:
                                                                    ReactiveTextField<
                                                                        String>(
                                                                  formControlName:
                                                                      'alicename', // Use dot notation

                                                                  style: TextStyle(
                                                                      color: notifier
                                                                          .getMainText),

                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                15),
                                                                    labelStyle: mediumGreyTextStyle.copyWith(
                                                                        fontSize:
                                                                            13),
                                                                    labelText:
                                                                        'Alice Name',
                                                                    enabledBorder: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                                child:
                                                                    ReactiveDropdownField<
                                                                        int>(
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  formControlName:
                                                                      'country',
                                                                  isExpanded:
                                                                      true,
                                                                  items: Country
                                                                      .keys
                                                                      .map<
                                                                          DropdownMenuItem<
                                                                              int>>(
                                                                    (String
                                                                        key) {
                                                                      final newValue =
                                                                          acctypes[
                                                                              key];
                                                                      return DropdownMenuItem<
                                                                          int>(
                                                                        value:
                                                                            newValue,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 10),
                                                                          child:
                                                                              Text(key),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ).toList(),
                                                                  dropdownColor:
                                                                      notifier
                                                                          .getcontiner,
                                                                  style: TextStyle(
                                                                      color: notifier
                                                                          .getMainText),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                15),
                                                                    labelStyle: mediumGreyTextStyle.copyWith(
                                                                        fontSize:
                                                                            13),
                                                                    labelText:
                                                                        'Country',
                                                                    enabledBorder: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                  ),
                                                                  onChanged:
                                                                      (newValue) {
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              ListTile(
                                                                title: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          0.0),
                                                                  child:
                                                                      ReactiveTextField<
                                                                          int>(
                                                                    validationMessages: {
                                                                      'required':
                                                                          (error) =>
                                                                              'Pincode is required',
                                                                    },
                                                                    formControlName:
                                                                        'pincode',
                                                                    onChanged:
                                                                        (formControl) {
                                                                      final int?
                                                                          pincode =
                                                                          formControl
                                                                              .value;
                                                                      // If user starts editing, reset dependent fields
                                                                      if (pincode ==
                                                                              null ||
                                                                          pincode.toString().length <
                                                                              6) {
                                                                        form?.control('address_book.$index.village').value =
                                                                            null;
                                                                        form?.control('address_book.$index.area').value =
                                                                            null;
                                                                        form?.control('address_book.$index.state').value =
                                                                            null;
                                                                        form?.control('address_book.$index.district').value =
                                                                            null;
                                                                        form?.control('address_book.$index.block').value =
                                                                            null;
                                                                        form?.control('address_book.$index.areaid').value =
                                                                            null;
                                                                        form?.control('address_book.$index.blockid').value =
                                                                            null;
                                                                        form?.control('address_book.$index.stateid').value =
                                                                            null;
                                                                        form?.control('address_book.$index.districtid').value =
                                                                            null;
                                                                      }
                                                                      // Fetch pincode details if pincode is complete
                                                                      if (pincode !=
                                                                              null &&
                                                                          pincode.toString().length ==
                                                                              6) {
                                                                        fetchPincodeDet(
                                                                            pincode,
                                                                            index);
                                                                      }
                                                                    },
                                                                    style: TextStyle(
                                                                        color: notifier
                                                                            .getMainText),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      contentPadding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              15),
                                                                      labelStyle:
                                                                          mediumGreyTextStyle.copyWith(
                                                                              fontSize: 13),
                                                                      labelText:
                                                                          'Pincode',
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: notifier.isDark
                                                                              ? notifier.geticoncolor
                                                                              : Colors.black,
                                                                        ),
                                                                      ),
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                        borderSide:
                                                                            BorderSide(
                                                                          color: notifier.isDark
                                                                              ? notifier.geticoncolor
                                                                              : Colors.black,
                                                                        ),
                                                                      ),
                                                                      hintText:
                                                                          'Enter 6-digit Pincode',
                                                                    ),
                                                                    maxLength:
                                                                        6,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                  ),
                                                                ),
                                                                trailing:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    print(
                                                                        'Index---${form?.control('address_book.$index.pincode').value}');
                                                                    fetchPincodeDet(
                                                                        form
                                                                            ?.control('address_book.$index.pincode')
                                                                            .value,
                                                                        index);
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .search,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        18.0),
                                                                child:
                                                                    ReactiveDropdownField<
                                                                        String>(
                                                                  focusColor: Colors
                                                                      .transparent,
                                                                  formControlName:
                                                                      'area',
                                                                  isExpanded:
                                                                      true,
                                                                  items: _pincodeDetailsList[
                                                                              index]
                                                                          ?.toSet()
                                                                          .map<DropdownMenuItem<String>>(
                                                                              (detail) {
                                                                        return DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              detail.areaName,
                                                                          child:
                                                                              Text(detail.areaName),
                                                                        );
                                                                      }).toList() ??
                                                                      [],
                                                                  onChanged:
                                                                      (newValue) {
                                                                    if (_pincodeDetailsList[
                                                                            index] !=
                                                                        null) {
                                                                      updateDetails(
                                                                          index,
                                                                          index);
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  },
                                                                  dropdownColor:
                                                                      notifier
                                                                          .getcontiner,
                                                                  style: TextStyle(
                                                                      color: notifier
                                                                          .getMainText),
                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                15),
                                                                    labelStyle: mediumGreyTextStyle.copyWith(
                                                                        fontSize:
                                                                            13),
                                                                    labelText:
                                                                        'Select Area',
                                                                    enabledBorder: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                                child:
                                                                    ReactiveTextField<
                                                                        String>(
                                                                  readOnly:
                                                                      true,
                                                                  // validationMessages: {
                                                                  //   'required': (error) =>
                                                                  //       'Block is Required!',
                                                                  // },
                                                                  formControlName:
                                                                      'block',
                                                                  // controller:  blockController,

                                                                  style: TextStyle(
                                                                      color: notifier
                                                                          .getMainText),

                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                15),
                                                                    labelStyle: mediumGreyTextStyle.copyWith(
                                                                        fontSize:
                                                                            13),
                                                                    labelText:
                                                                        'Block',
                                                                    enabledBorder: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                  ),
                                                                ),
                                                              ),
                                                              //                                     Padding(
                                                              //                                       padding: const EdgeInsets
                                                              //                                           .symmetric(
                                                              //                                           horizontal:
                                                              //                                               20.0),
                                                              //                                       child: ReactiveTextField<
                                                              //                                           String>(
                                                              //                                         validationMessages: {
                                                              //                                           'required': (error) =>
                                                              //                                               'Village Name Required!',
                                                              //                                         },
                                                              //                                         formControlName:
                                                              //                                             'village',
                                                              //                                         // controller: cityController,

                                                              //                        style: TextStyle(color: notifier.getMainText),

                                                              //                                          decoration: InputDecoration(
                                                              //                                            contentPadding:const EdgeInsets.only(left: 15),

                                                              //                                             labelStyle: mediumGreyTextStyle.copyWith(
                                                              //           fontSize: 13),
                                                              //                                              labelText: 'City',
                                                              //                                           enabledBorder: OutlineInputBorder(
                                                              // borderRadius:BorderRadius .circular(10.0),
                                                              // borderSide: BorderSide(
                                                              //     color: notifier.isDark
                                                              //         ? notifier.geticoncolor
                                                              //         : Colors.black)),
                                                              //                     border: OutlineInputBorder(
                                                              // borderRadius:BorderRadius .circular(10.0),
                                                              // borderSide: BorderSide(
                                                              //     color: notifier.isDark
                                                              //         ? notifier.geticoncolor
                                                              //         : Colors.black)),
                                                              //                                           ),
                                                              //                                       ),
                                                              //                                     ),
                                                              const SizedBox(
                                                                  height: 10),

                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                                child:
                                                                    ReactiveTextField<
                                                                        String>(
                                                                  readOnly:
                                                                      true,
                                                                  validationMessages: {
                                                                    'required':
                                                                        (error) =>
                                                                            'District Name Required!',
                                                                  },
                                                                  formControlName:
                                                                      'district',
                                                                  // controller: districtController,

                                                                  style: TextStyle(
                                                                      color: notifier
                                                                          .getMainText),

                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                15),
                                                                    labelStyle: mediumGreyTextStyle.copyWith(
                                                                        fontSize:
                                                                            13),
                                                                    labelText:
                                                                        'District',
                                                                    enabledBorder: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                                child:
                                                                    ReactiveTextField<
                                                                        String>(
                                                                  readOnly:
                                                                      true,
                                                                  validationMessages: {
                                                                    'required':
                                                                        (error) =>
                                                                            'State Name Required!',
                                                                  },
                                                                  formControlName:
                                                                      'state',
                                                                  // controller: stateController,

                                                                  style: TextStyle(
                                                                      color: notifier
                                                                          .getMainText),

                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                15),
                                                                    labelStyle: mediumGreyTextStyle.copyWith(
                                                                        fontSize:
                                                                            13),
                                                                    labelText:
                                                                        'State',
                                                                    enabledBorder: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),

                                                              //                                     Padding(
                                                              //                                       padding: const EdgeInsets
                                                              //                                           .symmetric(
                                                              //                                           horizontal:
                                                              //                                               20.0),
                                                              //                                       child: ReactiveTextField<
                                                              //                                           String>(
                                                              //                                         // validationMessages: {
                                                              //                                         //   'required': (error) =>
                                                              //                                         //       'Region is Required!',
                                                              //                                         // },
                                                              //                                         formControlName:
                                                              //                                             'region',
                                                              //                                         // controller:  regionController,

                                                              //                        style: TextStyle(color: notifier.getMainText),

                                                              //                                          decoration: InputDecoration(
                                                              //                                            contentPadding:const EdgeInsets.only(left: 15),

                                                              //                                             labelStyle: mediumGreyTextStyle.copyWith(
                                                              //           fontSize: 13),
                                                              //                                              labelText: 'Region',
                                                              //                                           enabledBorder: OutlineInputBorder(
                                                              // borderRadius:BorderRadius .circular(10.0),
                                                              // borderSide: BorderSide(
                                                              //     color: notifier.isDark
                                                              //         ? notifier.geticoncolor
                                                              //         : Colors.black)),
                                                              //                     border: OutlineInputBorder(
                                                              // borderRadius:BorderRadius .circular(10.0),
                                                              // borderSide: BorderSide(
                                                              //     color: notifier.isDark
                                                              //         ? notifier.geticoncolor
                                                              //         : Colors.black)),
                                                              //                                           ),
                                                              //                                       ),
                                                              //                                     ),
                                                              // const SizedBox(
                                                              //     height:
                                                              //         10),

                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                                child:
                                                                    ReactiveTextField<
                                                                        String>(
                                                                  onChanged:
                                                                      (_) {
                                                                    getLocation();
                                                                  },
                                                                  maxLines: 2,
                                                                  validationMessages: {
                                                                    'required':
                                                                        (error) =>
                                                                            "Address required! (Address Field Excludes Single Quote (') and Double Quote (\")).",
                                                                  },

                                                                  formControlName:
                                                                      'address',
                                                                  // controller:  blockController,

                                                                  style: TextStyle(
                                                                      color: notifier
                                                                          .getMainText),

                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10,
                                                                        top: 8,
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            8),
                                                                    labelStyle: mediumGreyTextStyle.copyWith(
                                                                        fontSize:
                                                                            13),
                                                                    labelText:
                                                                        'Address',
                                                                    enabledBorder: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                    border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0),
                                                                        borderSide:
                                                                            BorderSide(color: notifier.isDark ? notifier.geticoncolor : Colors.black)),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 20),

                                                              // Visibility(
                                                              //    visible: form?.control('userinfo.addressflag').value == true,
                                                              //   child: const Align(alignment: Alignment.topLeft,
                                                              //     child: Text('Billing Address',
                                                              //       style: TextStyle(
                                                              //         color: Colors.black,
                                                              //         fontWeight: FontWeight.bold,
                                                              //         fontSize: 20,
                                                              //       ),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                            ]));
                                                  });
                                                  return Wrap(
                                                    runSpacing: 20,
                                                    children: book.toList(),
                                                  );
                                                }),
                                          ]),
                                          const SizedBox(height: 20),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: ReactiveTextField(
                                              formControlName:
                                                  'userinfo.latitude',
                                              readOnly: true,
                                              style: TextStyle(
                                                  color: notifier.getMainText),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 15),
                                                labelStyle: mediumGreyTextStyle
                                                    .copyWith(fontSize: 13),
                                                labelText: 'Latitude',
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    borderSide: BorderSide(
                                                        color: notifier.isDark
                                                            ? notifier
                                                                .geticoncolor
                                                            : Colors.black)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20.0),
                                                  child: ReactiveTextField(
                                                    formControlName:
                                                        'userinfo.longitude',
                                                    readOnly: true,
                                                    style: TextStyle(
                                                        color: notifier
                                                            .getMainText),
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      labelStyle:
                                                          mediumGreyTextStyle
                                                              .copyWith(
                                                                  fontSize: 13),
                                                      labelText: 'Longitude',
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          borderSide: BorderSide(
                                                              color: notifier
                                                                      .isDark
                                                                  ? notifier
                                                                      .geticoncolor
                                                                  : Colors
                                                                      .black)),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          borderSide: BorderSide(
                                                              color: notifier
                                                                      .isDark
                                                                  ? notifier
                                                                      .geticoncolor
                                                                  : Colors
                                                                      .black)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Align(
                                              //   alignment: Alignment.bottomRight,
                                              //   child: Expanded(child:NeumorphicButton(
                                              //     style: const NeumorphicStyle(
                                              //         intensity: 10,
                                              //         color: AppColors.mainButtonColor
                                              //     ),
                                              //     onPressed: () async {
                                              //       await getLocation();
                                              //     },
                                              //     child: const Text('Get Location',
                                              //       style: TextStyle(color: Colors.white),
                                              //     ),
                                              //   ),),
                                              // )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                        ]),
                                  ),
                                ]),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Profile',
                                      style: mediumBlackTextStyle.copyWith(
                                          color: notifier.getMainText),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: ReactiveTextField<String>(
                                      readOnly: widget.subscriberId != null,
                                      validationMessages: {
                                        'required': (error) =>
                                            'Username required!',
                                        'minLength': (error) =>
                                            'Username must be at least 6 characters!',
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(
                                            r'[a-zA-Z0-9_]')), // Adjust the allowed characters if needed
                                      ],
                                      formControlName: 'profileid',
                                      style: TextStyle(
                                          color: notifier.getMainText),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 15),
                                        labelStyle: mediumGreyTextStyle
                                            .copyWith(fontSize: 13),
                                        labelText: 'Username',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Visibility(
                                    visible: widget.updateSubsDet == null,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: ReactiveTextField<String>(
                                            validationMessages: {
                                              'required': (error) =>
                                                  'Password required!',
                                            },
                                            formControlName: 'profilepsw',
                                            controller: propswController,
                                            style: TextStyle(
                                                color: notifier.getMainText),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15),
                                              labelStyle: mediumGreyTextStyle
                                                  .copyWith(fontSize: 13),
                                              labelText: 'Profile Password',
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: notifier.isDark
                                                          ? notifier
                                                              .geticoncolor
                                                          : Colors.black)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: notifier.isDark
                                                          ? notifier
                                                              .geticoncolor
                                                          : Colors.black)),
                                            ),
                                            onChanged: (_) {
                                              if (ProAuthPswSame) {
                                                form?.control('authpsw').value =
                                                    propswController.text;
                                              }
                                            },
                                          ),
                                        ),
                                        SwitchListTile(
                                          title: const Text(
                                            "Authentication and Profile Password are Same",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          value: ProAuthPswSame,
                                          onChanged: (val) {
                                            setState(() {
                                              ProAuthPswSame = val;
                                              if (ProAuthPswSame) {
                                                // When passwords are the same, copy the profile password to authentication password
                                                authpswController.text =
                                                    propswController.text;
                                              } else {
                                                // If not same, allow authpswController to be cleared, but retain any value
                                                // to avoid null being submitted.
                                                if (authpswController
                                                    .text.isEmpty) {
                                                  authpswController.clear();
                                                }
                                              }
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: ReactiveTextField<String>(
                                            validationMessages: {
                                              'required': (error) =>
                                                  'Password required!',
                                            },
                                            formControlName: 'authpsw',
                                            controller: authpswController,
                                            readOnly: ProAuthPswSame,
                                            style: TextStyle(
                                                color: notifier.getMainText),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15),
                                              labelStyle: mediumGreyTextStyle
                                                  .copyWith(fontSize: 13),
                                              labelText:
                                                  'Authentication Password',
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: notifier.isDark
                                                          ? notifier
                                                              .geticoncolor
                                                          : Colors.black)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: notifier.isDark
                                                          ? notifier
                                                              .geticoncolor
                                                          : Colors.black)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: ReactiveDropdownField<int>(
                                      focusColor: Colors.transparent,
                                      formControlName: 'acctype',
                                      isExpanded: true,
                                      items: acctypes.keys
                                          .map<DropdownMenuItem<int>>(
                                        (String key) {
                                          final newValue = acctypes[key];
                                          return DropdownMenuItem<int>(
                                            value: newValue,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(key),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      dropdownColor: notifier.getcontiner,
                                      style: TextStyle(
                                          color: notifier.getMainText),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 15),
                                        labelStyle: mediumGreyTextStyle
                                            .copyWith(fontSize: 13),
                                        labelText: 'Account Type',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // if (form. == 'Mac')
                                  Visibility(
                                    visible: form?.value['acctype'] ==
                                        acctypes['Mac'],
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ReactiveTextField<String>(
                                        validationMessages: {
                                          'required': (_) =>
                                              'Mac ID is required. MAC Address should be separated by colon (:).',
                                          'pattern': (_) =>
                                              'Invalid MAC address format.',
                                        },
                                        formControlName: 'macid',
                                        style: TextStyle(
                                            color: notifier.getMainText),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.only(left: 15),
                                          labelStyle: mediumGreyTextStyle
                                              .copyWith(fontSize: 13),
                                          hintStyle: mediumGreyTextStyle
                                              .copyWith(fontSize: 13),
                                          hintText: "xx:xx:xx:xx:xx:xx",
                                          labelText: 'Mac ID',
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  color: notifier.isDark
                                                      ? notifier.geticoncolor
                                                      : Colors.black)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  color: notifier.isDark
                                                      ? notifier.geticoncolor
                                                      : Colors.black)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: form?.value['acctype'] ==
                                        acctypes['Normal'],
                                    child: ReactiveSwitchListTile(
                                      title: Text(
                                        "Enable Mac",
                                        style: mediumBlackTextStyle.copyWith(
                                            color: notifier.getMainText),
                                      ),
                                      formControlName: 'enablemac',
                                      onChanged: (val) {
                                        setState(() {
                                          if (widget.updateSubsDet?.enablemac ==
                                              1) {
                                            form?.control('enablemac').value =
                                                true;
                                          } else if (widget
                                                  .updateSubsDet?.enablemac ==
                                              0) {
                                            form?.control('enablemac').value =
                                                false;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // if(widget.subscriberId == null)
                                  if (form?.control('enablemac').value ==
                                          true &&
                                      widget.subscriberId == null)
                                    Visibility(
                                      visible: form?.value['acctype'] ==
                                          acctypes['Normal'],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: ReactiveTextField<String>(
                                            // validationMessages: {
                                            //   'required': (error) =>
                                            //       'Mac Address is Required!',
                                            // },
                                            formControlName: 'mac',
                                            style: TextStyle(
                                                color: notifier.getMainText),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15),
                                              labelStyle: mediumGreyTextStyle
                                                  .copyWith(fontSize: 13),
                                              hintText: "xx:xx:xx:xx:xx:xx",
                                              hintStyle: mediumGreyTextStyle
                                                  .copyWith(fontSize: 13),
                                              labelText: 'Mac Address',
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: notifier.isDark
                                                          ? notifier
                                                              .geticoncolor
                                                          : Colors.black)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: notifier.isDark
                                                          ? notifier
                                                              .geticoncolor
                                                          : Colors.black)),
                                            )),
                                      ),
                                    ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: ReactiveTextField<int>(
                                        readOnly: true,
                                        validationMessages: {
                                          'required': (error) =>
                                              'Simultaneous User is Required!',
                                        },
                                        formControlName: 'simultaneoususe',
                                        style: TextStyle(
                                            color: notifier.getMainText),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.only(left: 15),
                                          labelStyle: mediumGreyTextStyle
                                              .copyWith(fontSize: 13),
                                          labelText: 'Simultaneous User',
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  color: notifier.isDark
                                                      ? notifier.geticoncolor
                                                      : Colors.black)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                  color: notifier.isDark
                                                      ? notifier.geticoncolor
                                                      : Colors.black)),
                                        )),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: ReactiveDropdownField<int>(
                                      focusColor: Colors.transparent,
                                      formControlName: 'conntype',
                                      isExpanded: true,
                                      items: contype.keys
                                          .map<DropdownMenuItem<int>>(
                                        (String key) {
                                          final newValue = contype[key];
                                          return DropdownMenuItem<int>(
                                            value: newValue,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(key),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      dropdownColor: notifier.getcontiner,
                                      style: TextStyle(
                                          color: notifier.getMainText),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 15),
                                        labelStyle: mediumGreyTextStyle
                                            .copyWith(fontSize: 13),
                                        labelText: 'Connection Type',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: ReactiveDropdownField<bool>(
                                      formControlName: 'usermode',
                                      focusColor: Colors.transparent,
                                      isExpanded: true,
                                      items: usermode.keys
                                          .map<DropdownMenuItem<bool>>(
                                        (String key) {
                                          final newValue = usermode[key];
                                          return DropdownMenuItem<bool>(
                                            value: newValue,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(key),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      dropdownColor: notifier.getcontiner,
                                      style: TextStyle(
                                          color: notifier.getMainText),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 15),
                                        labelStyle: mediumGreyTextStyle
                                            .copyWith(fontSize: 13),
                                        labelText: 'User Mode',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: ReactiveDropdownField<int>(
                                        focusColor: Colors.transparent,
                                        formControlName: 'acctstatus',
                                        isExpanded: true,
                                        items: accstatus.keys
                                            .where((key) =>
                                                key !=
                                                'Suspend') // Exclude 'Suspend'
                                            .map<DropdownMenuItem<int>>(
                                                (String key) {
                                          final newValue = accstatus[key];
                                          return DropdownMenuItem<int>(
                                            value: newValue,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(key),
                                            ),
                                          );
                                        }).toList(),
                                        dropdownColor: notifier.getcontiner,
                                        style: TextStyle(
                                            color: notifier.getMainText),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.only(left: 15),
                                          labelStyle: mediumGreyTextStyle
                                              .copyWith(fontSize: 13),
                                          labelText: 'Account Status',
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                              color: notifier.isDark
                                                  ? notifier.geticoncolor
                                                  : Colors.black,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                              color: notifier.isDark
                                                  ? notifier.geticoncolor
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        readOnly:
                                            false, // Make sure it is editable for other options
                                      )),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Package',
                                      style: mediumBlackTextStyle.copyWith(
                                          color: notifier.getMainText),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: ReactiveDropdownField<int>(
                                      focusColor: Colors.transparent,
                                      formControlName: 'packid',
                                      validationMessages: {
                                        'required': (error) => "Pack required!",
                                      },
                                      isExpanded: true,
                                      items: resellerList.map((item) {
                                        // Check if widget.updateSubsDet is null
                                        // final isDisabled = widget.updateSubsDet != null;
                                        return DropdownMenuItem<int>(
                                          value: item.packid,
                                          // Set enabled based on the condition
                                          // enabled: !isDisabled,

                                          child: Text(item.packname),
                                        );
                                      }).toList(),
                                      dropdownColor: notifier.getcontiner,
                                      style: TextStyle(
                                          color: notifier.getMainText),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 15),
                                        labelStyle: mediumGreyTextStyle
                                            .copyWith(fontSize: 13),
                                        labelText: 'Pack Name',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          GetPack(form?.value['packid']);
                                        });
                                      },
                                      readOnly: widget.resellerid != null
                                          ? true
                                          : false,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: ReactiveDropdownField<int>(
                                      formControlName: 'srvusermode',
                                      focusColor: Colors.transparent,
                                      isExpanded: true,
                                      items: pacusmode.keys
                                          .map<DropdownMenuItem<int>>(
                                        (String key) {
                                          final Value = pacusmode[key];
                                          return DropdownMenuItem<int>(
                                            value: Value,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(key),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      dropdownColor: notifier.getcontiner,
                                      style: TextStyle(
                                          color: notifier.getMainText),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 15),
                                        labelStyle: mediumGreyTextStyle
                                            .copyWith(fontSize: 13),
                                        labelText: 'Pack User Mode',
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: ReactiveTextField<String>(
                                      validationMessages: {
                                        'required': (error) =>
                                            'Expiration required!',
                                      },
                                      formControlName: 'expiration',
                                      readOnly: true,
                                      style: TextStyle(
                                          color: notifier.getMainText),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 15),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: notifier.isDark
                                                    ? notifier.geticoncolor
                                                    : Colors.black)),
                                        suffixIcon: Visibility(
                                          visible: !(widget.resellerid !=
                                                  null ||
                                              levelid > 4 &&
                                                  isIspAdmin !=
                                                      true), // The icon will be visible if the condition is false
                                          child: GestureDetector(
                                            onTap: () => _selectDate(context),
                                            child: Icon(
                                              Icons
                                                  .calendar_today, // Use any icon you prefer
                                              color: notifier.getMainText,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: (getPackOpt?.packmode ?? 0) >= 3 &&
                                        ((getPackOpt?.fupmode ?? -1) == 0 ||
                                            (getPackOpt?.fupmode ?? -1) == 2),
                                    // visible:
                                    //  getPackOpt?.packmode == 3 &&
                                    //     (getPackOpt?.fupmode == 0 ||
                                    //         getPackOpt?.fupmode == 2),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ReactiveTextField(
                                          validationMessages: {
                                            'required': (error) =>
                                                'Inavlid Download Limit..!',
                                          },
                                          formControlName: 'dllimit',
                                          controller: downLimitController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          style: TextStyle(
                                              color: notifier.getMainText),
                                          decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.only(
                                                  left: 15),
                                              labelStyle: mediumGreyTextStyle
                                                  .copyWith(fontSize: 13),
                                              labelText:
                                                  'Download Limit(in Mbps)',
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: notifier.isDark
                                                          ? notifier
                                                              .geticoncolor
                                                          : Colors.black)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: notifier.isDark
                                                          ? notifier
                                                              .geticoncolor
                                                          : Colors.black)),
                                              suffixIcon: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedDownMbps++;
                                                          downLimitController
                                                                  .text =
                                                              selectedDownMbps
                                                                  .toString();
                                                        });
                                                      },
                                                      child: Icon(
                                                          Icons.arrow_drop_up,
                                                          color: notifier
                                                              .getMainText),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (selectedDownMbps >
                                                            0) {
                                                          setState(() {
                                                            selectedDownMbps--;
                                                            downLimitController
                                                                    .text =
                                                                selectedDownMbps
                                                                    .toString();
                                                          });
                                                        }
                                                      },
                                                      child: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: notifier
                                                              .getMainText),
                                                    ),
                                                  ]))),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: (getPackOpt?.packmode ?? 0) >= 3 &&
                                        ((getPackOpt?.fupmode ?? -1) == 1 ||
                                            (getPackOpt?.fupmode ?? -1) == 2),

                                    //               visible:
                                    //                 getPackOpt!.packmode >= 3 &&
                                    // (getPackOpt!.fupmode == 1 || getPackOpt!.fupmode == 2),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ReactiveTextField(
                                          validationMessages: {
                                            'required': (error) =>
                                                'Inavlid Download Limit..!',
                                          },
                                          formControlName: 'uplimit',
                                          controller: upLimitController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          style: TextStyle(
                                              color: notifier.getMainText),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.only(left: 15),
                                            labelStyle: mediumGreyTextStyle
                                                .copyWith(fontSize: 13),
                                            labelText: 'Upload Limit(in Mbps)',
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                    color: notifier.isDark
                                                        ? notifier.geticoncolor
                                                        : Colors.black)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                    color: notifier.isDark
                                                        ? notifier.geticoncolor
                                                        : Colors.black)),
                                            suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedUpMbps++;
                                                      upLimitController.text =
                                                          selectedUpMbps
                                                              .toString();
                                                    });
                                                  },
                                                  child: Icon(
                                                      Icons.arrow_drop_up,
                                                      color:
                                                          notifier.getMainText),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (selectedUpMbps > 0) {
                                                      setState(() {
                                                        selectedUpMbps--;
                                                        upLimitController.text =
                                                            selectedUpMbps
                                                                .toString();
                                                      });
                                                    }
                                                  },
                                                  child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color:
                                                          notifier.getMainText),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: (getPackOpt?.packmode ?? 0) >= 3 &&
                                        (getPackOpt?.fupmode ?? -1) == 3,

                                    // visible:getPackOpt!.packmode >= 3 &&getPackOpt!.fupmode == 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ReactiveTextField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          formControlName: 'totallimit',
                                          controller: totLimitController,
                                          style: TextStyle(
                                              color: notifier.getMainText),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.only(left: 15),
                                            labelStyle: mediumGreyTextStyle
                                                .copyWith(fontSize: 13),
                                            labelText: 'Total Limit(in Mbps)',
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                    color: notifier.isDark
                                                        ? notifier.geticoncolor
                                                        : Colors.black)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                    color: notifier.isDark
                                                        ? notifier.geticoncolor
                                                        : Colors.black)),
                                            suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedTotMbps++;
                                                      totLimitController.text =
                                                          selectedTotMbps
                                                              .toString();
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.arrow_drop_up,
                                                    color: notifier.getMainText,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (selectedUpMbps > 0) {
                                                      setState(() {
                                                        selectedTotMbps--;
                                                        totLimitController
                                                                .text =
                                                            selectedTotMbps
                                                                .toString();
                                                      });
                                                    }
                                                  },
                                                  child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color:
                                                          notifier.getMainText),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                  // timelimit
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: (getPackOpt?.packmode == 1 ||
                                        getPackOpt?.packmode == 4),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: ReactiveTextField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          formControlName: 'timelimit',
                                          controller: onlineLimitController,
                                          style: TextStyle(
                                              color: notifier.getMainText),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.only(left: 15),
                                            labelStyle: mediumGreyTextStyle
                                                .copyWith(fontSize: 13),
                                            labelText: 'Online Time(Seconds))',
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                    color: notifier.isDark
                                                        ? notifier.geticoncolor
                                                        : Colors.black)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: BorderSide(
                                                    color: notifier.isDark
                                                        ? notifier.geticoncolor
                                                        : Colors.black)),
                                            suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedOnlTime++;
                                                      onlineLimitController
                                                              .text =
                                                          selectedOnlTime
                                                              .toString();
                                                    });
                                                  },
                                                  child: Icon(
                                                      Icons.arrow_drop_up,
                                                      color:
                                                          notifier.getMainText),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (selectedOnlTime > 0) {
                                                      setState(() {
                                                        selectedOnlTime--;
                                                        onlineLimitController
                                                                .text =
                                                            selectedOnlTime
                                                                .toString();
                                                      });
                                                    }
                                                  },
                                                  child: Icon(
                                                      Icons.arrow_drop_down,
                                                      color:
                                                          notifier.getMainText),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: levelid < 4 || isIspAdmin == true,
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'IP-V4',
                                            style:
                                                mediumBlackTextStyle.copyWith(
                                                    color:
                                                        notifier.getMainText),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: ReactiveDropdownField<int>(
                                            formControlName: 'ipmode',
                                            focusColor: Colors.transparent,
                                            isExpanded: true,
                                            items: ipv4.keys
                                                .map<DropdownMenuItem<int>>(
                                              (String key) {
                                                final value = ipv4[key];
                                                return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(key),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            dropdownColor: notifier.getcontiner,
                                            style: TextStyle(
                                                color: notifier.getMainText),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15),
                                              labelStyle: mediumGreyTextStyle
                                                  .copyWith(fontSize: 13),
                                              labelText: 'IP Mode',
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: notifier.isDark
                                                          ? notifier
                                                              .geticoncolor
                                                          : Colors.black)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: notifier.isDark
                                                          ? notifier
                                                              .geticoncolor
                                                          : Colors.black)),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                GetAllIpv4(int.parse(form
                                                        ?.value['resellerid']
                                                        ?.toString() ??
                                                    '0'));
                                                getIpv4 = null;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Visibility(
                                          // visible : SelectedIpMode== 'Local Static Ipv4',
                                          visible: form?.value['ipmode'] ==
                                              ipv4['Local Static Ipv4'],
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: ReactiveTextField<String>(
                                              validationMessages: {
                                                'required': (error) =>
                                                    'Ipv4 required!',
                                              },
                                              formControlName: 'ipv4',
                                              style: TextStyle(
                                                  color: notifier.getMainText),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 15),
                                                labelStyle: mediumGreyTextStyle
                                                    .copyWith(fontSize: 13),
                                                labelText: 'Local Ipv4',
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    borderSide: BorderSide(
                                                        color: notifier.isDark
                                                            ? notifier
                                                                .geticoncolor
                                                            : Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Visibility(
                                          visible: form?.value['ipmode'] ==
                                              ipv4['Public Static Ipv4'],
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18.0),
                                            child: ReactiveDropdownField<int>(
                                              focusColor: Colors.transparent,
                                              formControlName: 'ipv4id',
                                              validationMessages: {
                                                'required': (error) =>
                                                    'Ipv4 required!',
                                              },
                                              isExpanded: true,
                                              items: getIpv4Opt.map((item) {
                                                return DropdownMenuItem<int>(
                                                  value: item.resellerid,
                                                  child: Text(item.ipaddr),
                                                );
                                              }).toList(),
                                              dropdownColor:
                                                  notifier.getcontiner,
                                              style: TextStyle(
                                                  color: notifier.getMainText),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 15),
                                                labelStyle: mediumGreyTextStyle
                                                    .copyWith(fontSize: 13),
                                                labelText: 'Public Ipv4',
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    borderSide: BorderSide(
                                                        color: notifier.isDark
                                                            ? notifier
                                                                .geticoncolor
                                                            : Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'IP-V6',
                                            style:
                                                mediumBlackTextStyle.copyWith(
                                                    color:
                                                        notifier.getMainText),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: ReactiveDropdownField<int>(
                                            formControlName: 'ip6mode',
                                            focusColor: Colors.transparent,
                                            isExpanded: true,
                                            items: ipv6.keys
                                                .map<DropdownMenuItem<int>>(
                                              (String key) {
                                                final value = ipv6[key];
                                                return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(key),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            dropdownColor: notifier.getcontiner,
                                            style: TextStyle(
                                                color: notifier.getMainText),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 15),
                                              labelStyle: mediumGreyTextStyle
                                                  .copyWith(fontSize: 13),
                                              labelText: 'IP-V6-Mode',
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: notifier.isDark
                                                          ? notifier
                                                              .geticoncolor
                                                          : Colors.black)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: BorderSide(
                                                      color: notifier.isDark
                                                          ? notifier
                                                              .geticoncolor
                                                          : Colors.black)),
                                            ),
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Visibility(
                                          visible: form?.value['ip6mode'] ==
                                              ipv6['Local Static Ipv6'],
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: ReactiveTextField<String>(
                                              validationMessages: {
                                                'required': (error) =>
                                                    'Ipv6 required!',
                                              },
                                              formControlName: 'ipv6',
                                              // controller:  blockController,

                                              style: TextStyle(
                                                  color: notifier.getMainText),

                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 15),
                                                labelStyle: mediumGreyTextStyle
                                                    .copyWith(fontSize: 13),
                                                labelText: 'Local Ipv6',
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    borderSide: BorderSide(
                                                        color: notifier.isDark
                                                            ? notifier
                                                                .geticoncolor
                                                            : Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Visibility(
                                          visible: form?.value['ip6mode'] ==
                                              ipv6['Public Static Ipv6'],
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: ReactiveTextField<int>(
                                              validationMessages: {
                                                'required': (error) =>
                                                    'Ipv6 required!',
                                              },
                                              formControlName: 'ipv6id',
                                              // controller:  blockController,

                                              style: TextStyle(
                                                  color: notifier.getMainText),

                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 15),
                                                labelStyle: mediumGreyTextStyle
                                                    .copyWith(fontSize: 13),
                                                labelText: 'Public Ipv6',
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        borderSide: BorderSide(
                                                            color: notifier
                                                                    .isDark
                                                                ? notifier
                                                                    .geticoncolor
                                                                : Colors
                                                                    .black)),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    borderSide: BorderSide(
                                                        color: notifier.isDark
                                                            ? notifier
                                                                .geticoncolor
                                                            : Colors.black)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // // if (selectedOption == 'Individual')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (selectedIndex > 0)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: appMainColor),
                            onPressed: () {
                              setState(() {
                                selectedIndex--;
                              });
                              _tabController.animateTo(
                                  selectedIndex); // Use TabController.
                            },
                            child: const Text('Previous',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appMainColor,
                          ),
                          onPressed: () async {
                            if (selectedIndex < 2) {
                              setState(() {
                                selectedIndex++;
                              });
                              _tabController.animateTo(
                                  selectedIndex); // Use TabController.
                            } else {
                              // Trigger validation for all form fields
                              // form?.markAllAsTouched();

                              // Check form validity before submission
                              // if (form?.valid ?? false) {
                              // Call the submit function when on the last tab and form is valid
                              await _handleSubmit();
                            }
                          },
                          child: Text(
                            selectedIndex < 2 ? 'Next' : 'Submit',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shadowColor: notifier.getprimerycolor,
          color: notifier.getprimerycolor,
          surfaceTintColor: notifier.getprimerycolor,
          child: BottomNavBar(scaffoldKey: _scaffoldKey),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    // Mark all form fields as touched to trigger validation messages
    form?.markAllAsTouched();

    // Access other form values
    final village = form?.control('address_book.0.village').value;
    final state = form?.control('address_book.0.state').value;
    final district = form?.control('address_book.0.district').value;
    final region = form?.control('address_book.0.region').value;
    final block = form?.control('address_book.0.block').value;
    final macid = form!.control('macid').value;
    final authpsw =
        ProAuthPswSame ? propswController.text : authpswController.text;

    // Patching values to form controls
    form?.control('authpsw').patchValue(authpsw);

    // Patching values to form controls

    final expiration = form?.control('expiration').value;

    final int? upLimitValue = int.tryParse(upLimitController.text);
    form?.control('uplimit').patchValue(upLimitValue);

    final int? downLimitValue = int.tryParse(downLimitController.text);
    form?.control('dllimit').patchValue(downLimitValue);

    final int? totalLimitValue = int.tryParse(totLimitController.text);
    form?.control('totallimit').patchValue(totalLimitValue);

    // ignore: non_constant_identifier_names
    final int? OnlineLimitValue = int.tryParse(onlineLimitController.text);
    form?.control('timelimit').patchValue(OnlineLimitValue);

    final latitude = form?.control('userinfo.latitude').value;
    final longitude = form?.control('userinfo.longitude').value;

    if (selectedIndex == 2) {
      // Extract form data and submit
      final value = {
        ...?form?.value, // Copy of form values
      };

      if (widget.subscriberId == null) {
        // Encrypt password if subscriber ID is null
        final encryptPwd = await encryptPasswordAndSubmit(value);
        print('encrypt-- $encryptPwd');
        value['profilepsw'] = encryptPwd;
      }

      print('value--$value');

      // Update or Add subscribers based on condition
      if (widget.subscriberId != null) {
        updateSub(value);
      } else {
        await addSubscribers(value);
      }
    }
  }

  String formattedDate =
      DateFormat('M/d/yyyy hh:mm:ss a').format(DateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    // Show the date picker first
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Show the time picker after a date is selected
      TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine the picked date and time
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          // Format the combined date and time with AM/PM and seconds
          formattedDate =
              DateFormat('yyyy-MM-dd hh:mm:ss a').format(pickedDateTime);
          form?.control('expiration').value = formattedDate;
        });
      }
    }
  }

  Future<String> encryptPasswordAndSubmit(value) async {
    final encryptedPwdResp = await getEncryptPassword(value['profilepsw']);
    final encryptedPwd = encryptedPwdResp['password'];
    return encryptedPwd;
    // form.control('profilepsw').value = encryptedPwd;
  }

  String latitude = 'Latitude: N/A';
  String longitude = 'Longitude: N/A';

  Future<void> getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      setState(() {
        form?.control('userinfo.latitude').value =
            position.latitude; // Assign double
        form?.control('userinfo.longitude').value =
            position.longitude; // Assign double

        latitude = 'Latitude: ${position.latitude}';
        longitude = 'Longitude: ${position.longitude}';
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}
