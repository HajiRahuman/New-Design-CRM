



class PincodeDet {
  final String Name;
  // final String Description;
  // final String BranchType;
  // final String Deliverystatus;
  // final String Circle;
  final String District;
  // final String Division;
  final String Region;
  final String Block;
  final String State;
  // final String Country;
  // final String Pincode;

  PincodeDet({
    required this.Name,
    // required this.Description,
    // required this.BranchType,
    // required this.Deliverystatus,
    // required this.Circle,
    required this.District,
    // required this.Division,
    required this.Region,
    required this.Block,
    required this.State,
    // required this.Country,
    // required this.Pincode,
  });

  factory PincodeDet.toJson(Map<String, dynamic> json) {
    return PincodeDet(
      Name: json['Name'] ?? '',
      // Description: json['Description'] ?? '',
      // BranchType: json['BranchType'] ?? '',
      // Deliverystatus: json['Deliverystatus'] ?? '',
      // Circle: json['Circle'] ?? '',
      District: json['District'] ?? '',
      // Division: json['Division'] ?? '',
      Region: json['Region'] ?? '',
      Block: json['Block'] ?? '',
      State: json['State'] ?? '',
      // Country: json['Country'] ?? '',
      // Pincode: json['Pincode'] ?? '',
    );
  }
}
class PincodeResp {
  final String msg;
  final bool error;
  final List<PincodeDet>? data;

  PincodeResp({required this.msg, required this.error, this.data});

  factory PincodeResp.toJson(Map<dynamic, dynamic> data) {


    return PincodeResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<PincodeDet>.from(
            data['data'].map((e) => PincodeDet.toJson(e)))
            : []);
  }
}


class circleDet {
  final int id;
  final String circle_name;
  circleDet({required this.id,
    required this.circle_name});

  factory circleDet.toJson(Map<dynamic, dynamic> data){
    return circleDet(
      id: data['id'] ?? 0 ,
      circle_name: data['circle_name'] ?? '',
    );
  }

}

class circleResp {
  final String msg;
  final bool error;
  final List<circleDet>? data;

  circleResp({required this.msg, required this.error, this.data});

  factory circleResp.toJson(Map<dynamic, dynamic> data) {


    return circleResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<circleDet>.from(
            data['data'].map((e) => circleDet.toJson(e)))
            : []);
  }
}



class resellerDet {
  final int id;
  final String full_name;
  final String profileid;
  final String company;
  final String mobile;
  final String email;
  final int levelid;
  final int level_role;
  // final String logo;
  final int circle;
  // final int bbtype;
  // final int cardtype;
  // final int voicetype;
  // final int otttype;
  // final int addontype;
  // final int vpntype;
  // final int reseller_under;
  // final double wallet;
  // final int rstatus;
  // final int nasid;
  // final int active;
  // final int online;
  // final int total;
  // final bool broadbandprefixstatus;
  // final String broadbandprefixid;
  // final bool voice_exp_defer;
  // final int exptimemode;
  // final String exptime;




  resellerDet({required this.id,
    required this.full_name,
    required this.profileid,
    required this.company,
    required this.mobile,
    required this.email,
    required this.levelid,
    required this.level_role,
    // required this.logo,
    required this.circle,
    // required this.bbtype,
    // required this.cardtype,
    // required this.voicetype,
    // required this.otttype,
    // required this.addontype,
    // required this.vpntype,
    // required this.reseller_under,
    // required this.wallet,
    // required this.rstatus,
    // required this.nasid,
    // required this.active,
    // required this.online,
    // required this.total,
    // required this.distid,
    // required this.subdistid,
    // required this.broadbandprefixstatus,
    // required this.broadbandprefixid,
    // required this.voice_exp_defer,
    // required this.exptimemode,
    // required this.exptime,

  });

  factory resellerDet.toJson(Map<dynamic, dynamic> data){
    return resellerDet(

      id: data['id'] ?? 0 ,
        full_name: data['full_name'] ?? '',
        profileid: data['profileid'] ?? '',
      company: data['company'] ?? '',
        mobile: data['mobile'] ?? '',
        email: data['email'] ?? '',
        levelid: data['levelid'] ?? 0,
    level_role: data['level_role'] ?? 0,
    // logo: data['logo'] ?? '',
    circle: data['circle'] ?? 0,
    // bbtype: data['bbtype'] ?? 0,
    // cardtype: data['cardtype'] ?? 0,
    // voicetype: data['voicetype'] ?? 0,
    //     otttype: data['otttype'] ?? 0,
    //     addontype: data['addontype'] ?? 0,
    //     vpntype: data['vpntype'] ?? 0,
    //     reseller_under: data['circle_name'] ?? 0,
        // wallet: data['wallet'] ?? 0.0,
      //   rstatus: data['rstatus'] ?? 0,
      // nasid: data['nasid'] ?? 0,
      // active: data['nasid'] ?? 0,
      // online: data['online'] ?? 0,
      // total: data['total'] ?? 0,
      //   distid: data['distid'] ?? 0,
      //   subdistid: data['subdistid'] ?? 0,
      //   broadbandprefixstatus: data['broadbandprefixstatus'] ?? '',
      //   broadbandprefixid: data['broadbandprefixid'] ?? '',
      // voice_exp_defer: data['voice_exp_defer'] ?? '',
      //   exptimemode: data['exptimemode'] ?? 0,
      // exptime: data['exptime'] ?? '',

    );
  }

}

class resellerResp {
  final String msg;
  final bool error;
  final List<resellerDet>? data;

  resellerResp({required this.msg, required this.error, this.data});

  factory resellerResp.toJson(Map<dynamic, dynamic> data) {


    return resellerResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<resellerDet>.from(
            data['data'].map((e) => resellerDet.toJson(e)))
            : []);
  }
}

class resellerAliceDet {
  int aliceid;
  // String circleName;
  int resellerid;
  // String address;
  // String region;
  // String circleid;
  // String state;
  //   String district;
  //   String block;
  //   String pincode;
  String village;

  resellerAliceDet({required this.resellerid,required this.aliceid,
    required this.village});

  factory resellerAliceDet.toJson(Map<dynamic, dynamic> data){
    return resellerAliceDet(

      resellerid: data['resellerid']  ?? 0,
      village: data['village'] ??'',
      aliceid: data ['aliceid']  ?? '',
    );
  }

}

class resellerAliceResp {
  final String msg;
  final bool error;
  final List<resellerAliceDet>? data;

  resellerAliceResp ({required this.msg, required this.error, this.data});

  factory resellerAliceResp .toJson(Map<dynamic, dynamic> data) {


    return resellerAliceResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<resellerAliceDet>.from(
            data['data'].map((e) => resellerAliceDet.toJson(e)))
            : []);
  }
}



class getResellerDet {

  int packid;
  String packname;
  int packmode;

  getResellerDet({required this.packid,
    required this.packname,
  required this.packmode
  });

  factory getResellerDet.toJson(Map<dynamic, dynamic> data){
    return getResellerDet(

      packid: data['packid']  ?? 0,
      packname: data['packname'] ??'',
      packmode: data['packmode']  ?? 0,
    );
  }

}

class getResellerResp {
  final String msg;
  final bool error;
  final List<getResellerDet>? data;

  getResellerResp({required this.msg, required this.error, this.data});

  factory getResellerResp .toJson(Map<dynamic, dynamic> data) {
    return getResellerResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<getResellerDet>.from(
            data['data'].map((e) => getResellerDet.toJson(e)))
            : []);
  }
}


class getAllIpv4Det{
  final int nasid ;
  final int ipv4poolid ;
  final String ipaddr;
  final int uid ;
  final String userassigndate;
  final int resellerid ;
  final int taxtype;
  final int ipprice;
  final int unittype;
  final int totalunit;
  final int ipv4id;

  getAllIpv4Det({required this.nasid,
    required this.ipv4poolid,
    required this.ipaddr,
    required this.uid,
    required this.userassigndate,
    required this.resellerid,
    required this.taxtype,
    required this.ipprice,
    required this.unittype,
    required this.totalunit,
    required this.ipv4id,
  });

  factory getAllIpv4Det.toJson(Map<dynamic, dynamic> data){
    return getAllIpv4Det(

      nasid: data['nasid'] ?? 0 ,
      ipv4poolid: data['ipv4poolid'] ?? 0,
      ipaddr: data['ipaddr'] ?? '' ,
      uid: data['uid'] ?? 0,
      userassigndate: data['userassigndate'] ?? '',
      resellerid: data['resellerid'] ?? 0,
      taxtype: data['taxtype'] ?? 0 ,
      ipprice: data['ipprice'] ?? 0 ,
      unittype: data['unittype'] ?? 0,
      totalunit: data['totalunit'] ?? 0,
      ipv4id: data['ipv4id'] ?? 0,

    );
  }
}
class getAllIpv4Resp {
  final String msg;
  final bool error;
  final List<getAllIpv4Det>? data;

  getAllIpv4Resp({required this.msg, required this.error, this.data});

  factory getAllIpv4Resp.toJson(Map<dynamic, dynamic> data) {
    return getAllIpv4Resp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<getAllIpv4Det>.from(
            data['data'].map((e) =>getAllIpv4Det.toJson(e)))
            : []);
  }
}


class GetPackDet {
  final int packid;
  final int circle;
  final int packtype;
  final int packmode;
  final String packname;
  final String note;
  final String ulspeed;
  final String dlspeed;
  final bool fallback;
  final String fname;
  final int fulspeed;
  final int fdlspeed;
  final int fupmode;
  final int dllimit;
  final int uplimit;
  final int totallimit;
  final bool cof;
  final String ipv4poolname;
  final int expordis;
  final bool expiry;
  final int packUserMode;
  final String packstart;
  final String packend;
  final bool packstatus;
  final String dlpolicy;
  final String ulpolicy;
  final String fdlpolicy;
  final String fulpolicy;
  final int expreset;
  final bool timestatus;
  final int ttime;
  final bool specialtimestatus;
  final String spstime;
  final String spetime;
  final bool burststatus;
  final int dlburstlimit;
  final int ulburstlimit;
  final int dlburstthreshold;
  final int ulburstthreshold;
  final int dlburstthresholdtime;
  final int ulburstthresholdtime;
  final int dlpriority;
  final int ulpriority;
  final int su;
  final int mo;
  final int tu;
  final int we;
  final int th;
  final int fr;
  final int sa;

  GetPackDet({
    required this.packid,
    required this.circle,
    required this.packtype,
    required this.packmode,
    required this.packname,
    required this.note,
    required this.ulspeed,
    required this.dlspeed,
    required this.fallback,
    required this.fname,
    required this.fulspeed,
    required this.fdlspeed,
    required this.fupmode,
    required this.dllimit,
    required this.uplimit,
    required this.totallimit,
    required this.cof,
    required this.ipv4poolname,
    required this.expordis,
    required this.expiry,
    required this.packUserMode,
    required this.packstart,
    required this.packend,
    required this.packstatus,
    required this.dlpolicy,
    required this.ulpolicy,
    required this.fdlpolicy,
    required this.fulpolicy,
    required this.expreset,
    required this.timestatus,
    required this.ttime,
    required this.specialtimestatus,
    required this.spstime,
    required this.spetime,
    required this.burststatus,
    required this.dlburstlimit,
    required this.ulburstlimit,
    required this.dlburstthreshold,
    required this.ulburstthreshold,
    required this.dlburstthresholdtime,
    required this.ulburstthresholdtime,
    required this.dlpriority,
    required this.ulpriority,
    required this.su,
    required this.mo,
    required this.tu,
    required this.we,
    required this.th,
    required this.fr,
    required this.sa,
  });

  factory GetPackDet.toJson(Map<dynamic, dynamic> data) {
    return GetPackDet(
      packid: data['packid'] ?? 0,
      circle: data['circle'] ?? 0,
      packtype: data['packtype'] ?? 0,
      packmode: data['packmode'] ?? 0,
      packname: data['packname'] ?? '',
      note: data['note'] ?? '',
      ulspeed: data['ulspeed'] ?? '',
      dlspeed: data['dlspeed'] ?? '',
      fallback: data['fallback'] ?? false,
      fname: data['fname'] ?? '',
      fulspeed: data['fulspeed'] ?? 0,
      fdlspeed: data['fdlspeed'] ?? 0,
      fupmode: data['fupmode'] ?? 0,
      dllimit: data['dllimit'] ?? 0,
      uplimit: data['uplimit'] ?? 0,
      totallimit: data['totallimit'] ?? 0,
      cof: data['cof'] ?? false,
      ipv4poolname: data['ipv4poolname'] ?? '',
      expordis: data['expordis'] ?? 0,
      expiry: data['expiry'] ?? false,
      packUserMode: data['packUserMode'] ?? 0,
      packstart: data['packstart'] ?? '',
      packend: data['packend'] ?? '',
      packstatus: data['packstatus'] ?? false,
      dlpolicy: data['dlpolicy'] ?? '',
      ulpolicy: data['ulpolicy'] ?? '',
      fdlpolicy: data['fdlpolicy'] ?? '',
      fulpolicy: data['fulpolicy'] ?? '',
      expreset: data['expreset'] ?? 0,
      timestatus: data['timestatus'] ?? false,
      ttime: data['ttime'] ?? 0,
      specialtimestatus: data['specialtimestatus'] ?? false,
      spstime: data['spstime'] ?? '',
      spetime: data['spetime'] ?? '',
      burststatus: data['burststatus'] ?? false,
      dlburstlimit: data['dlburstlimit'] ?? 0,
      ulburstlimit: data['ulburstlimit'] ?? 0,
      dlburstthreshold: data['dlburstthreshold'] ?? 0,
      ulburstthreshold: data['ulburstthreshold'] ?? 0,
      dlburstthresholdtime: data['dlburstthresholdtime'] ?? 0,
      ulburstthresholdtime: data['ulburstthresholdtime'] ?? 0,
      dlpriority: data['dlpriority'] ?? 0,
      ulpriority: data['ulpriority'] ?? 0,
      su: data['su'] ?? 0,
      mo: data['mo'] ?? 0,
      tu: data['tu'] ?? 0,
      we: data['we'] ?? 0,
      th: data['th'] ?? 0,
      fr: data['fr'] ?? 0,
      sa: data['sa'] ?? 0,
    );
  }
}

class GetPackResp {
  final String msg;
  final bool error;
  final GetPackDet? data;

  GetPackResp({
    required this.msg,
    required this.error,
    this.data,
  });

  factory GetPackResp.toJson(Map<dynamic, dynamic> data) {
    return GetPackResp(
      error: data['error'] ?? false,
      msg: data['msg'] ?? '',
      // data: data['data'] is List
      //     ? List<GetPackDet>.from(
      //     data['data'].map((e) => GetPackDet.toJson(e)))
      //     : [],
        data: GetPackDet.toJson(data['data'])
    );
  }

}



