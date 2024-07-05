class ResellerList {
  int id;
  String fullName;
  String profileId;
  String company;
  String mobile;
  // String email;
  // int levelId;
  // int levelRole;
  // Logo logo;
  // int circle;
  // int bbType;
  // int cardType;
  // int voiceType;
  // int ottType;
  // int addonType;
  // int vpnType;
  // int resellerUnder;
  // int wallet;
  // int rStatus;
  // int distId;
  // int subDistId;
  // int nasId;
  // int active;
  // int online;
  // int total;

  ResellerList({
    required this.id,
    required this.fullName,
    required this.profileId,
    required this.company,
    required this.mobile,
    // required this.email,
    // required this.levelId,
    // required this.levelRole,
    // required this.logo,
    // required this.circle,
    // required this.bbType,
    // required this.cardType,
    // required this.voiceType,
    // required this.ottType,
    // required this.addonType,
    // required this.vpnType,
    // required this.resellerUnder,
    // required this.wallet,
    // required this.rStatus,
    // required this.distId,
    // required this.subDistId,
    // required this.nasId,
    // required this.active,
    // required this.online,
    // required this.total,
  });
  factory ResellerList.toJson(Map<dynamic, dynamic> data) {
    return ResellerList(
      id: data['id'] ?? 0,
      fullName: data['full_name'] ?? "",
      profileId: data['profileid'] ?? "",
      company: data['company'] ?? "",
      mobile: data['mobile'] ?? "",
      // email: data['email'] ?? "",
      // levelId: data['levelid'] ?? 0,
      // levelRole: data['level_role'] ?? 0,
      // logo: Logo.toJson(data['logo'] ?? {}),
      // circle: data['circle'] ?? 0,
      // bbType: data['bbtype'] ?? 0,
      // cardType: data['cardtype'] ?? 0,
      // voiceType: data['voicetype'] ?? 0,
      // ottType: data['otttype'] ?? 0,
      // addonType: data['addontype'] ?? 0,
      // vpnType: data['vpntype'] ?? 0,
      // resellerUnder: data['reseller_under'] ?? 0,
      // wallet: data['wallet'] ?? 0,
      // rStatus: data['rstatus'] ?? 0,
      // distId: data['distid'] ?? 0,
      // subDistId: data['subdistid'] ?? 0,
      // nasId: data['nasid'] ?? 0,
      // active: data['active'] ?? 0,
      // online: data['online'] ?? 0,
      // total: data['total'] ?? 0,
    );
  }
}

class ResellerListResp {
  final String msg;
  final bool error;
  final List<ResellerList>? data;

  ResellerListResp({required this.msg, required this.error, this.data});

  factory ResellerListResp.toJson(Map<dynamic, dynamic> data) {
    return ResellerListResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<ResellerList>.from(
            data['data'].map((e) => ResellerList.toJson(e)))
            : []);
  }
}

class Logo {
  String encoding;
  String filename;
  bool limit;
  String mimetype;

  Logo({
    required this.encoding,
    required this.filename,
    required this.limit,
    required this.mimetype,
  });

  factory Logo.toJson(Map<String, dynamic> data) {
    return Logo(
      encoding: data['encoding'] ?? "",
      filename: data['filename'] ?? "",
      limit: data['limit'] ?? false,
      mimetype: data['mimetype'] ?? "",
    );
  }
}




class ResellerDetResp {
  final bool error;
  final String msg;
  final ResellarDet? data;

  ResellerDetResp({required this.error, required this.msg, this.data});

  factory ResellerDetResp.toJson(Map<dynamic, dynamic> resp) {
    return ResellerDetResp(
        error: resp['error'],
        msg: resp['msg'],
        data: ResellarDet.toJson(resp['data']));
  }
}
class ResellarDet {
  final int id;
  final String fullName;
  final String profileId;
  final String company;
  final String mobile;
  final String email;
  final int levelId;
  final int levelRole;
  final String logo;
  final int circle;
  final int bbType;
  final int cardType;
  final int voiceType;
  final int ottType;
  final int addonType;
  final int vpnType;
  // final int resellerUnder;
  final int wallet;
  final int rStatus;
  final int distId;
  final int subdistId;
  final int resellerSub;
  final String email1;
  final int userLimits;
  final int helpLine;
  final String supportEmailId;
  final int resellerMiniAmt;
  final int smsgwid;
  final int paymentgwid;
  final int licenseType;
  final String licenseId;
  final List<int> levelMenu;
  final Agreement agreement;
  final Settings settings;
  final List<Share> share;
  final Nas nas;
  final List<AddressBook> addressBook;

  ResellarDet({
    required this.id,
    required this.fullName,
    required this.profileId,
    required this.company,
    required this.mobile,
    required this.email,
    required this.levelId,
    required this.levelRole,
    required this.logo,
    required this.circle,
    required this.bbType,
    required this.cardType,
    required this.voiceType,
    required this.ottType,
    required this.addonType,
    required this.vpnType,
    // required this.resellerUnder,
    required this.wallet,
    required this.rStatus,
    required this.distId,
    required this.subdistId,
    required this.resellerSub,
    required this.email1,
    required this.userLimits,
    required this.helpLine,
    required this.supportEmailId,
    required this.resellerMiniAmt,
    required this.smsgwid,
    required this.paymentgwid,
    required this.licenseType,
    required this.licenseId,
    required this.levelMenu,
    required this.agreement,
    required this.settings,
    required this.share,
    required this.nas,
    required this.addressBook,
  });

  factory ResellarDet.toJson(Map<String, dynamic> json) {
    return ResellarDet(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? "",
      profileId: json['profileid'] ?? "",
      company: json['company'] ?? "",
      mobile: json['mobile'] ?? "",
      email: json['email'] ?? "",
      levelId: json['levelid'] ?? 0,
      levelRole: json['level_role'] ?? 0,
      logo: json['logo'] ?? "",
      circle: json['circle'] ?? 0,
      bbType: json['bbtype'] ?? 0,
      cardType: json['cardtype'] ?? 0,
      voiceType: json['voicetype'] ?? 0,
      ottType: json['otttype'] ?? 0,
      addonType: json['addontype'] ?? 0,
      vpnType: json['vpntype'] ?? 0,
      // resellerUnder: json['reseller_under'] ?? 0,
      wallet: json['wallet'] ?? 0,
      rStatus: json['rstatus'] ?? 0,
      distId: json['distid'] ?? 0,
      subdistId: json['subdistid'] ?? 0,
      resellerSub: json['reseller_sub'] ?? 0,
      email1: json['email1'] ?? "",
      userLimits: json['user_limits'] ?? 0,
      helpLine: json['help_line'] ?? 0,
      supportEmailId: json['support_email_id'] ?? "",
      resellerMiniAmt: json['reseller_mini_amt'] ?? 0,
      smsgwid: json['smsgwid'] ?? 0,
      paymentgwid: json['paymentgwid'] ?? 0,
      licenseType: json['licensetype'] ?? 0,
      licenseId: json['licenseid'] ?? "",
      levelMenu: List<int>.from(json['level_menu'] ?? []),
      agreement: Agreement.toJson(json['agreement'] ?? {}),
      settings: Settings.toJson(json['settings'] ?? {}),
      share: (json['share'] as List<dynamic> ?? [])
          .map((share) => Share.toJson(share))
          .toList(),
      nas: Nas.toJson(json['nas'] ?? {}),
      addressBook: (json['address_book'] as List<dynamic> ?? [])
          .map((book) => AddressBook.toJson(book))
          .toList(),
    );
  }
}

class Agreement {
  final int id;
  final String startDate;
  final String endDate;
  final int aggStatus;

  Agreement({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.aggStatus,
  });

  factory Agreement.toJson(Map<String, dynamic> json) {
    return Agreement(
      id: json['id'] ?? 0,
      startDate: json['startdate'] ?? "",
      endDate: json['enddate'] ?? "",
      aggStatus: json['agg_status'] ?? 0,
    );
  }
}

class Settings {
  final int id;
  final int resellerId;
  final String gstNo;
  final String accDet;
  final bool broadbandPrefixStatus;
  final String broadbandPrefixId;
  final bool uniqueMobileStatus;
  final bool uniqueEmailStatus;
  final int smsgwid;
  final int pmgwid;
  final int subpmgw;
  final int overdue;
  final int paydue;
  final bool registerEmail;
  final bool registerSms;
  final bool renewalEmail;
  final bool renewalSms;
  final bool invoiceEmail;
  final bool invoiceSms;
  final bool autoRenewalSms;
  final bool autoRenewalEmail;
  final bool paidEmail;
  final bool paidSms;
  final bool cancelRenewalEmail;
  final bool cancelRenewalSms;
  final bool extraDataEmail;
  final bool extraDataSms;
  final bool topupEmail;
  final bool topupSms;
  final bool suspendEmail;
  final bool suspendSms;
  final bool holdEmail;
  final bool holdSms;
  final bool terminateEmail;
  final bool terminateSms;
  final int expTimeMode;
  final String expTime;
  final bool voiceExpDefer;
  final bool usermac_autoupdate;

  Settings({
    required this.id,
    required this.resellerId,
    required this.gstNo,
    required this.accDet,
    required this.broadbandPrefixStatus,
    required this.broadbandPrefixId,
    required this.uniqueMobileStatus,
    required this.uniqueEmailStatus,
    required this.smsgwid,
    required this.pmgwid,
    required this.subpmgw,
    required this.overdue,
    required this.paydue,
    required this.registerEmail,
    required this.registerSms,
    required this.renewalEmail,
    required this.renewalSms,
    required this.invoiceEmail,
    required this.invoiceSms,
    required this.autoRenewalSms,
    required this.autoRenewalEmail,
    required this.paidEmail,
    required this.paidSms,
    required this.cancelRenewalEmail,
    required this.cancelRenewalSms,
    required this.extraDataEmail,
    required this.extraDataSms,
    required this.topupEmail,
    required this.topupSms,
    required this.suspendEmail,
    required this.suspendSms,
    required this.holdEmail,
    required this.holdSms,
    required this.terminateEmail,
    required this.terminateSms,
    required this.expTimeMode,
    required this.expTime,
    required this.voiceExpDefer,
    required this.usermac_autoupdate
  });

  factory Settings.toJson(Map<String, dynamic> json) {
    return Settings(
      id: json['id'] ?? 0,
      resellerId: json['resellerid'] ?? 0,
      gstNo: json['gst_no'] ?? "",
      accDet: json['accdet'] ?? "",
      broadbandPrefixStatus: json['broadbandprefixstatus'] ?? true,
      broadbandPrefixId: json['broadbandprefixid'] ?? "",
      uniqueMobileStatus: json['uniquemobilestatus'] ?? true,
      uniqueEmailStatus: json['uniqueemailstatus'] ?? true,
      smsgwid: json['smsgwid'] ?? 0,
      pmgwid: json['pmgwid'] ?? 0,
      subpmgw: json['subpmgw'] ?? 0,
      overdue: json['overdue'] ?? 0,
      paydue: json['paydue'] ?? 0,
      registerEmail: json['register_email'] ?? true,
      registerSms: json['register_sms'] ?? true,
      renewalEmail: json['renewal_email'] ?? true,
      renewalSms: json['renewal_sms'] ?? true,
      invoiceEmail: json['invoice_email'] ?? true,
      invoiceSms: json['invoice_sms'] ?? true,
      autoRenewalSms: json['auto_renewal_sms'] ?? true,
      autoRenewalEmail: json['auto_renewal_email'] ?? true,
      paidEmail: json['paid_email'] ?? true,
      paidSms: json['paid_sms'] ?? true,
      cancelRenewalEmail: json['cancel_renewal_email'] ?? true,
      cancelRenewalSms: json['cancel_renewal_sms'] ?? true,
      extraDataEmail: json['extra_data_email'] ?? true,
      extraDataSms: json['extra_data_sms'] ?? true,
      topupEmail: json['topup_email'] ?? true,
      topupSms: json['topup_sms'] ?? true,
      suspendEmail: json['suspend_email'] ?? true,
      suspendSms: json['suspend_sms'] ?? true,
      holdEmail: json['hold_email'] ?? true,
      holdSms: json['hold_sms'] ?? true,
      terminateEmail: json['terminate_email'] ?? true,
      terminateSms: json['terminate_sms'] ?? true,
      expTimeMode: json['exptimemode'] ?? 0,
      expTime: json['exptime'] ?? "",
      voiceExpDefer: json['voice_exp_defer'] ?? true,
       usermac_autoupdate: json['usermac_autoupdate'] ?? true,
      
      
    );
  }
}

class Share {
  final int id;
  final int resellerId;
  final int busId;
  final int ispShare;
  final int distShare;
  final int subdistShare;
  final int resellerShare;
  final int hotelShare;

  Share({
    required this.id,
    required this.resellerId,
    required this.busId,
    required this.ispShare,
    required this.distShare,
    required this.subdistShare,
    required this.resellerShare,
    required this.hotelShare,
  });

  factory Share.toJson(Map<String, dynamic> json) {
    return Share(
      id: json['id'] ?? 0,
      resellerId: json['resellerid'] ?? 0,
      busId: json['busid'] ?? 0,
      ispShare: json['ispshare'] ?? 0,
      distShare: json['distshare'] ?? 0,
      subdistShare: json['subdistshare'] ?? 0,
      resellerShare: json['resellershare'] ?? 0,
      hotelShare: json['hotelshare'] ?? 0,
    );
  }

  

  

  
}

class Nas {
  final String nasName;
  final String shortName;
  final String type;
  final int ports;
  final String secret;
  final String server;
  final String description;
  final int vendor;
  final int nasStatus;
  final int nasLinkStatus;
  final String apiUsername;
  final String apiPassword;
  final int circle;
  final bool snmpStatus;
  final int snmpVer;
  final int nasIntGraph;
  final bool usersGraph;
  final int id;
  final int nasMapId;

  Nas({
    required this.nasName,
    required this.shortName,
    required this.type,
    required this.ports,
    required this.secret,
    required this.server,
    required this.description,
    required this.vendor,
    required this.nasStatus,
    required this.nasLinkStatus,
    required this.apiUsername,
    required this.apiPassword,
    required this.circle,
    required this.snmpStatus,
    required this.snmpVer,
    required this.nasIntGraph,
    required this.usersGraph,
    required this.id,
    required this.nasMapId,
  });

  factory Nas.toJson(Map<String, dynamic> json) {
    return Nas(
      nasName: json['nasname'] ?? "",
      shortName: json['shortname'] ?? "",
      type: json['type'] ?? "",
      ports: json['ports'] ?? 0,
      secret: json['secret'] ?? "",
      server: json['server'] ?? "",
      description: json['description'] ?? "",
      vendor: json['vendor'] ?? 0,
      nasStatus: json['nasstatus'] ?? 1,
      nasLinkStatus: json['naslinkstatus'] ?? 1,
      apiUsername: json['apiusername'] ?? "",
      apiPassword: json['apipassword'] ?? "",
      circle: json['circle'] ?? 0,
      snmpStatus: json['snmpstatus'] ?? true,
      snmpVer: json['snmpver'] ?? 0,
      nasIntGraph: json['nasintgraph'] ?? 0,
      usersGraph: json['usersgraph'] ?? true,
      id: json['id'] ?? 0,
      nasMapId: json['nas_map_id'] ?? 0,
    );
  }
}

class AddressBook {
  final int aliceId;
  final String aliceName;
  final int resellerId;
  final String address;
  final String region;
  final int country;
  final String state;
  final String district;
  final String block;
  final int pincode;
  final String village;

  AddressBook({
    required this.aliceId,
    required this.aliceName,
    required this.resellerId,
    required this.address,
    required this.region,
    required this.country,
    required this.state,
    required this.district,
    required this.block,
    required this.pincode,
    required this.village,
  });

  factory AddressBook.toJson(Map<String, dynamic> json) {
    return AddressBook(
      aliceId: json['aliceid'] ?? 0,
      aliceName: json['alicename'] ?? "",
      resellerId: json['resellerid'] ?? 0,
      address: json['address'] ?? "",
      region: json['region'] ?? "",
      country: json['country'] ?? 0,
      state: json['state'] ?? "",
      district: json['district'] ?? "",
      block: json['block'] ?? "",
      pincode: json['pincode'] ?? 0,
      village: json['village'] ?? "",
    );
  }
}




// First, create a model for the top-level JSON structure
class LevelDetResp {
  final bool error;
  final String msg;
  final List<LevelDet> data;

  LevelDetResp({
    required this.error,
    required this.msg,
    required this.data,
  });

  factory LevelDetResp.toJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<LevelDet> levels = dataList.map((e) => LevelDet.toJson(e)).toList();

    return LevelDetResp(
      error: json['error'],
      msg: json['msg'],
      data: levels,
    );
  }
}

// Next, create a model for the "level" objects within the "data" list
class LevelDet {
  final int levelId;
  final int levelRole;
  final String levelName;
  final List<int> levelMenu;

  LevelDet({
    required this.levelId,
    required this.levelRole,
    required this.levelName,
    required this.levelMenu,
  });

  factory LevelDet.toJson(Map<String, dynamic> json) {
    var menuList = json['level_menu'] as List;
    List<int> menus = menuList.map((e) => e as int).toList();

    return LevelDet(
      levelId: json['level_id'],
      levelRole: json['level_role'],
      levelName: json['level_name'],
      levelMenu: menus,
    );
  }
}







class viewResellerPackPriceResp {
  final bool error;
  final String msg;
  final List<ResellerPackData> data;

  viewResellerPackPriceResp({required this.error, required this.msg, required this.data});

  factory viewResellerPackPriceResp.toJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<ResellerPackData> data =
    dataList.map((item) => ResellerPackData.toJson(item)).toList();

    return viewResellerPackPriceResp(
      error: json['error'],
      msg: json['msg'],
      data: data,
    );
  }
}

class ResellerPackData {
  final int packid;
  final String packname;
  final int packmode;
  final List<viewResellerPackPriceDet> plan;

  ResellerPackData({
    required this.packid,
    required this.packname,
    required this.packmode,
    required this.plan,
  });

  factory ResellerPackData.toJson(Map<String, dynamic> json) {
    var planList = json['plan'] as List;
    List<viewResellerPackPriceDet> plan = planList.map((item) => viewResellerPackPriceDet.toJson(item)).toList();

    return ResellerPackData(
      packid: json['packid'],
      packname: json['packname'],
      packmode: json['packmode'],
      plan: plan,
    );
  }
}

class viewResellerPackPriceDet {
  final String id;
  final int circle;
  final int resellerid;
  final int packid;
  final String pname;
  final int datasplit;
  final int unittype;
  final int timeunit;
  final int extradays;
  final String price;
  final int taxmode;
  final String ispshare;
  final String distshare;
  final String subdistshare;
  final String resellershare;
  final dynamic validitystart;
  final dynamic validityend;
  final String note;
  final String createdon;
  final dynamic createdid;
  final String createdby;
  final bool pricestatus;
  final bool validitystatus;
  final int daysflag;
  final int ottplanid;
  final String modifiedon;
  final int modifiedby;

  viewResellerPackPriceDet({
    required this.id,
    required this.circle,
    required this.resellerid,
    required this.packid,
    required this.pname,
    required this.datasplit,
    required this.unittype,
    required this.timeunit,
    required this.extradays,
    required this.price,
    required this.taxmode,
    required this.ispshare,
    required this.distshare,
    required this.subdistshare,
    required this.resellershare,
    required this.validitystart,
    required this.validityend,
    required this.note,
    required this.createdon,
    required this.createdid,
    required this.createdby,
    required this.pricestatus,
    required this.validitystatus,
    required this.daysflag,
    required this.ottplanid,
    required this.modifiedon,
    required this.modifiedby,
  });

  factory viewResellerPackPriceDet.toJson(Map<String, dynamic> json) {
    return viewResellerPackPriceDet(
      id: json['id'],
      circle: json['circle'],
      resellerid: json['resellerid'],
      packid: json['packid'],
      pname: json['pname'],
      datasplit: json['datasplit'],
      unittype: json['unittype'],
      timeunit: json['timeunit'],
      extradays: json['extradays'],
      price: json['price'],
      taxmode: json['taxmode'],
      ispshare: json['ispshare'],
      distshare: json['distshare'],
      subdistshare: json['subdistshare'],
      resellershare: json['resellershare'],
      validitystart: json['validitystart'],
      validityend: json['validityend'],
      note: json['note'],
      createdon: json['createdon'],
      createdid: json['createdid'],
      createdby: json['createdby'],
      pricestatus: json['pricestatus'],
      validitystatus: json['validitystatus'],
      daysflag: json['daysflag'],
      ottplanid: json['ottplanid'],
      modifiedon: json['modifiedon'],
      modifiedby: json['modifiedby'],
    );
  }
}


