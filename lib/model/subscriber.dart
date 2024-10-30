import 'dart:typed_data';

import 'package:crm/model/addressBook.dart';

class SubscriberSummary {
  final String totalusers;
  final String deactive;
  final String active;
  final String hold;
  final String suspend;
  final String terminate;
  final String mainonline;
  final String offline;
  final String expiredonline;
  final String normalacct;
  final String macacct;

  SubscriberSummary(
      {required this.totalusers,
      required this.deactive,
      required this.active,
      required this.hold,
      required this.suspend,
      required this.terminate,
      required this.mainonline,
      required this.offline,
      required this.expiredonline,
      required this.normalacct,
      required this.macacct});
  factory SubscriberSummary.toJson(Map<dynamic, dynamic> data) {
    return SubscriberSummary(
        totalusers: data['totalusers'] ?? '0',
        deactive: data['deactive'] ?? '0',
        active: data['active'] ?? '0',
        hold: data['hold'] ?? '0',
        suspend: data['suspend'] ?? '0',
        terminate: data['terminate'] ?? '0',
        mainonline: data['mainonline'] ?? '0',
        offline: data['offline'] ?? '0',
        expiredonline: data['expiredonline'] ?? '0',
        normalacct: data['normalacct'] ?? '0',
        macacct: data['macacct'] ?? '0');
  }
}

class SubscriberSummaryResp {
  final String msg;
  final bool error;
  final SubscriberSummary? summary;
  SubscriberSummaryResp({required this.error, required this.msg, this.summary});

  factory SubscriberSummaryResp.toJson(Map<dynamic, dynamic> data) {
    return SubscriberSummaryResp(
        error: data['error'],
        msg: data['msg'],
        summary: data['summary'] != null
            ? SubscriberSummary.toJson(data['summary'])
            : null);
  }
}

class SubscriberDet {
  final int id;
  final int resellerid;
  final int aliceid;
  final int circleid;
  final int acctype;
  final int enablemac;
  final String uacctype;
  final bool usermode;
  final int packid;
  final String conn;
  final String profileid;
  final String fullname;
  final String mobile;
  final String emailpri;
  final String address;
  final String packmode;
  final String packname;
  final int ulspeed;
  final int dlspeed;
  // final int fname;
  // final String fulspeed;
  // final String fdlspeed;
  // final int rpackname;
  final String pricename;
  // final bool acctstarttime;
  final String onlinetime;
  // final String lastlogoff;
  final bool expiry;
  final String expiration;
  final int fupmode;
  // final String dllimit;
  // final String ullimit;
  // final String totallimit;
  final String locality;
  final String conntype;
  final int usersipmode;
  final String ipv4;
  final String ipv6;
  final String alicename;
  final String acctinputoctets;
  final String acctoutputoctets;
  final String accttotaloctets;
  final String acctstatus;
  final String ipmode;

  final int soc;

  SubscriberDet({
    required this.id,
    required this.resellerid,
    required this.aliceid,
    required this.circleid,
    required this.acctype,
    required this.enablemac,
    required this.uacctype,
    required this.usermode,
    required this.packid,
    required this.conn,
    required this.profileid,
    required this.fullname,
    required this.mobile,
    required this.emailpri,
    required this.address,
    required this.packmode,
    required this.packname,
    required this.ulspeed,
    required this.dlspeed,
    // required this.fname,
    // required this.fulspeed,
    // required this.fdlspeed,
    // required this.rpackname,
    required this.pricename,
    // required this.acctstarttime,
    required this.onlinetime,
    // required this.lastlogoff,
    required this.expiry,
    required this.expiration,
    required this.fupmode,
    // required this.dllimit,
    // required this.ullimit,
    // required this.totallimit,
    required this.locality,
    required this.conntype,
    required this.usersipmode,
    required this.ipv4,
    required this.ipv6,
    required this.alicename,
    required this.acctinputoctets,
    required this.acctoutputoctets,
    required this.accttotaloctets,
    required this.acctstatus,
    required this.ipmode,

    required this.soc,
  });
  factory SubscriberDet.toJson(Map<dynamic, dynamic> data) {
    return SubscriberDet(
      id: data['id'],
      resellerid: data['resellerid'],
      aliceid: data['aliceid'],
      circleid: data['circleid'],
      acctype: data['acctype'],
      enablemac: data['enablemac'],
      uacctype: data['uacctype'],
      usermode: data['usermode'],
      packid: data['packid'],
      conn: data['conn'],
      profileid: data['profileid'],
      fullname: data['fullname'],
      mobile: data['mobile'],
      emailpri: data['emailpri'],
      address: data['address'],
      packmode: data['packmode'],
      packname: data['packname'],
      ulspeed: data['ulspeed'],
      dlspeed: data['dlspeed'],
      // fname: data['fname'],
      // fulspeed: data['fulspeed'],
      // fdlspeed: data['fdlspeed'],
      // rpackname: data['rpackname'],
      pricename: data['pricename'],
      // acctstarttime: data['acctstarttime'],
      onlinetime: data['onlinetime'],
      // lastlogoff: data['lastlogoff'],
      expiry: data['expiry'],
      expiration: data['expiration'],
      fupmode: data['fupmode'],
      // dllimit: data['dllimit'],
      // ullimit: data['ullimit'],
      // totallimit: data['totallimit'],
      locality: data['locality'],
      conntype: data['conntype'],
      usersipmode: data['usersipmode'],
      ipv4: data['ipv4'],
      ipv6: data['ipv6'],
      alicename: data['alicename'],
      acctinputoctets: data['acctinputoctets'],
      acctoutputoctets: data['acctoutputoctets'],
      accttotaloctets: data['accttotaloctets'],
      acctstatus: data['acctstatus'],
      ipmode: data['ipmode'],
      soc: data['soc'],
    );
  }
}

class ListSubscriberResp {
  final String msg;
  final bool error;
  final List<SubscriberDet>? data;

  ListSubscriberResp({required this.msg, required this.error, this.data});

  factory ListSubscriberResp.toJson(Map<dynamic, dynamic> data) {
    return ListSubscriberResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<SubscriberDet>.from(
                data['data'].map((e) => SubscriberDet.toJson(e)))
            : []);
  }
}

class SubscriberInfo {
  // int id;
  String fullname;
  String emailpri;
  // String emailsec;
  String mobile;

  // String telnum;
  // String company;
  // String? contractfrom;
  // String? contractto;
  // bool gststatus;
  bool addressflag;
  String ugst;
  // String desc;
  // int latitude;
  // int longitude;
  int aliceid;
  int ulmm;
  int locality;
  SubscriberInfo({
    // required this.id,
    required this.fullname,
    required this.emailpri,
    // required this.emailsec,
    required this.mobile,
    // required this.telnum,
    // required this.company,
    // this.contractfrom,
    // this.contractto,
    // required this.gststatus,
    required this.ugst,
    required this.addressflag,
    // required this.desc,
    // required this.latitude,
    // required this.longitude,
    required this.aliceid,
    required this.ulmm,
    required this.locality
  });

  factory SubscriberInfo.toJson(Map<dynamic, dynamic> resp) {
    return SubscriberInfo(
      // id: resp['id'],
      fullname: resp['fullname'],
      emailpri: resp['emailpri'],
      // emailsec: resp['emailsec'],
      mobile: resp['mobile'],
      // telnum: resp['telnum'],
      // company: resp['company'],
      // gststatus: resp['gststatus'],
      ugst: resp['ugst'],
        addressflag: resp['addressflag'],
      // desc: resp['desc'],
      // latitude: resp['latitude'],
      // longitude: resp['longitude'],
      aliceid: resp['aliceid'],
      ulmm: resp['ulmm'],
      locality: resp['locality']
    );
  }
}

class SubscriberFullDet {
  int id;
  // int resellerid;
String mac;
  int circleid;
  int acctype;
  int resellerid;
  int enablemac;
  bool usermode;
  int packid;
  String profileid;
  String conn;
  String expiration;
  String packname;
  String packmode;
  String rpackname;
  String pricename;
  // String dllimit;
  // String totallimit;
  int conntype;
  // String ipv4;
  // String ipv6;
  int simultaneoususe;
  String createdon;
  SubscriberInfo info;
  List<AddressBook> address_book;
  String acctstatus;
  String authpsw;
  String ipmode;
   String callingstationid;
   String framedipaddress;
  String nasipaddress;
  String username;
  int srvusermode;
  int soc;
  int voiceid;
  String authreject;
  String authreject_dt;

  String pon;
  bool onustatus;
  String onutx;
  String onurx;
  String oltname;
  
  // int ip6mode;
  // int ipv4id;
  // int ipv6id;

  SubscriberFullDet({
    required this.id,
    required this.mac,
    // required this.resellerid,
    required this.circleid,
    required this.acctype,
    required this.resellerid,
    required this.enablemac,
    required this.usermode,
    required this.packid,
    required this.profileid,
    required this.conn,
    required this.expiration,
    required this.packname,
    required this.packmode,
    required this.rpackname,
    required this.pricename,
    // required this.dllimit,
    // required this.totallimit,
    required this.conntype,
    // required this.ipv4,
    // required this.ipv6,
    required this.simultaneoususe,
    required this.createdon,
    required this.info,
    required this.address_book,
    required this.acctstatus,
    required this.authpsw,
    required this.ipmode,
    required this.username,
    required this.callingstationid,
    required this.framedipaddress,
    required this.nasipaddress,
    required this.soc,
    required this.srvusermode,
    required this.voiceid,
      required this.authreject,
      required this.authreject_dt,
      required this.oltname,
      required this.onustatus,
      required this.onutx,
      required this.onurx,
      required this.pon,

    // required this.ip6mode,
    // required this.ipv4id,
    // required this.ipv6id
  });

  factory SubscriberFullDet.toJson(Map<dynamic, dynamic> resp) {
  return SubscriberFullDet(
    id: resp['id'] ?? 0,                
    mac: resp['mac'] ?? '',
    circleid: resp['circleid'] ?? 0,
    acctype: resp['acctype'] ?? 0,
    resellerid: resp['resellerid'] ?? 0,
    enablemac: resp['enablemac'] ?? 0,
    usermode: resp['usermode'] ?? false,
    packid: resp['packid'] ?? 0,
    profileid: resp['profileid'] ?? '',  
    conn: resp['conn'] ?? '', 
    expiration: resp['expiration'] ?? '',  
    packname: resp['packname'] ?? '',  
    packmode: resp['packmode'] ?? '',  
    rpackname: resp['rpackname'] ?? '',  
    pricename: resp['pricename'] ?? '',  
    conntype: resp['conntype'] ?? 0,
    simultaneoususe: resp['simultaneoususe'] ?? 0,
    createdon: resp['createdon'] ?? '',  
    info: SubscriberInfo.toJson(resp['info'] ?? {}),
    address_book: List<AddressBook>.from(
        (resp['address_book'] ?? []).map((address) => AddressBook.toJson(address))),
    acctstatus: resp['acctstatus'] ?? '',  
    authpsw: resp['authpsw'] ?? '',  
    ipmode: resp['ipmode'] ?? '', 
    username: resp['username'] ?? '', 
    callingstationid: resp['callingstationid'] ?? '', 
    framedipaddress: resp['framedipaddress'] ?? '',  
    nasipaddress: resp['nasipaddress'] ?? '',  
    srvusermode: resp['srvusermode'] ?? 0,
    soc: resp['soc'] ?? 0,
    voiceid: resp['voiceid'] ?? 0,
    authreject: resp['authreject'] ?? '',  
    authreject_dt: resp['authreject_dt'] ?? '',  
    oltname: resp['oltname'] ?? '',  
    onustatus: resp['onustatus'] ?? false,
    onutx: resp['onutx'] ?? '',  
    onurx: resp['onurx'] ?? '',  
    pon: resp['pon'] ?? '',  
  );
}
}

class SubscriberFullDetResp {
  final bool error;
  final String msg;
  final SubscriberFullDet? data;

  SubscriberFullDetResp({required this.error, required this.msg, this.data});

  factory SubscriberFullDetResp.toJson(Map<dynamic, dynamic> resp) {
    return SubscriberFullDetResp(
        error: resp['error'],
        msg: resp['msg'],
        data: SubscriberFullDet.toJson(resp['data']));
  }
}
class UpdateProId{
  final int acctype;
  final String profileid;

  UpdateProId({required this.acctype,required this.profileid});
}

class UpdateAuthPWD{
  final String authpsw;
  UpdateAuthPWD({required this.authpsw});
}
class UpdateProPWD{
  final String profilepsw;
  UpdateProPWD({required this.profilepsw});
}
class UpdateAccountSts{
  final int id;
  final int acctstatus;
  final String remarks;
  UpdateAccountSts({required this.id,required this.acctstatus,required this.remarks});
}

class CircleDet {
  final int id;
  final String circle_name;

  CircleDet({required this.id,
    required this.circle_name});

  factory CircleDet.toJson(Map<dynamic, dynamic> data){
    return CircleDet(

      id: data['id'] ?? 0 ,
      circle_name: data['circle_name'] ?? '',
    );
  }

}

class CircleResp {
  final String msg;
  final bool error;
  final List<CircleDet>? data;

  CircleResp({required this.msg, required this.error, this.data});

  factory CircleResp.toJson(Map<dynamic, dynamic> data) {


  return CircleResp(
  error: data['error'],
  msg: data['msg'],
  data: data['data'] is List
  ? List<CircleDet>.from(
  data['data'].map((e) => CircleDet.toJson(e)))
      : []);
  }
  }

class BranchDet {
  // String aliceid;
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

  BranchDet({required this.resellerid,
    required this.village});

  factory BranchDet.toJson(Map<dynamic, dynamic> data){
    return BranchDet(

      resellerid: data['resellerid']  ?? 0,
      village: data['village'] ??'',
    );
  }

}

class BranchResp {
  final String msg;
  final bool error;
  final List<BranchDet>? data;

  BranchResp ({required this.msg, required this.error, this.data});

  factory BranchResp .toJson(Map<dynamic, dynamic> data) {


    return BranchResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<BranchDet>.from(
            data['data'].map((e) => BranchDet.toJson(e)))
            : []);
  }
}

class UpdateAccType{
  final int id;
  final int acctype;
  final String username;
  final int enablemac;
  final String mac;
  final String conn;
  UpdateAccType({required this.id,required this.acctype,required this.username,required this.mac,required this.conn,required this.enablemac});
}

class UpdatePacandVal{
  final int packid;
  final String expiration;
  final String simultaneoususe;
  UpdatePacandVal({required this.packid,required this.expiration,required this.simultaneoususe});
}





class ResellerPackDet {
 final int packid;
 final String packname;
 final int packmode;

  ResellerPackDet({required this.packid,
    required this.packname,required this.packmode});

  factory ResellerPackDet.toJson(Map<dynamic, dynamic> data){
    return ResellerPackDet(

      packid: data['packid'] ?? 0 ,
      packname: data['packname'] ?? '',
      packmode: data['packmode'] ?? 0 ,
    );
  }
}
class ReseelerPackResp {
  final String msg;
  final bool error;
  final List<ResellerPackDet>? data;

  ReseelerPackResp({required this.msg, required this.error, this.data});

  factory ReseelerPackResp.toJson(Map<dynamic, dynamic> data) {


    return ReseelerPackResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<ResellerPackDet>.from(
            data['data'].map((e) => ResellerPackDet.toJson(e)))
            : []);
  }
}

class UpdateMacBinding{
  final int id;
  final int enablemac;
  final int acctype;
  final int simultaneoususe;
  final List<String> mac;
  UpdateMacBinding({
    required this.id,
    required this.enablemac,
    required this.acctype,
    required this.simultaneoususe,
    required this.mac});
}



class SessionDet {
 final int radacctid ;
 final int uid ;
 final String username;
 final String acctstarttime;
 final String acctstoptime;
 final String callingstationid;
 final String framedipaddress;

  SessionDet({required this.radacctid,
    required this.uid,
    required this.username,
    required this.acctstarttime,
    required this.acctstoptime,
    required this.callingstationid,
    required this.framedipaddress,});

  factory SessionDet.toJson(Map<dynamic, dynamic> data){
    return SessionDet(

      radacctid: data['radacctid'] ?? 0 ,
      uid: data['uid'] ?? 0,
      username: data['username'] ?? '' ,
      acctstarttime: data['acctstarttime'] ?? '',
      acctstoptime: data['acctstoptime'] ?? '' ,
      callingstationid: data['callingstationid'] ?? '' ,
      framedipaddress: data['framedipaddress'] ?? '' ,
    );
  }
}
class SessionResp {
  final String msg;
  final bool error;
  final List<SessionDet>? data;

  SessionResp({required this.msg, required this.error, this.data});

  factory SessionResp.toJson(Map<dynamic, dynamic> data) {

    return SessionResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<SessionDet>.from(
            data['data'].map((e) =>SessionDet.toJson(e)))
            : []);
  }
}

class UserMacDet{
  final int uid;
  final int umacid;
  final String usermac;
  UserMacDet({required this.uid,required this.umacid,required this.usermac});
  factory  UserMacDet.toJson(Map<dynamic, dynamic> data){
    return  UserMacDet(


      uid: data['uid'] ?? 0,
      umacid: data['umacid'] ?? 0 ,
      usermac: data['usermac'] ?? '' ,

    );
  }
}
class UserMacResp {
  final String msg;
  final bool error;
  final List<UserMacDet>? data;

  UserMacResp ({required this.msg, required this.error, this.data});

  factory UserMacResp .toJson(Map<dynamic, dynamic> data) {

    return UserMacResp (
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<UserMacDet>.from(
            data['data'].map((e) => UserMacDet.toJson(e)))
            : []);
  }
}


class SessionCheckandStop{
  final int radacctid;
  final String remarks;
  final bool isDisconnect;
  final int uid;

  SessionCheckandStop({
    required this.radacctid,
    required this.remarks,
    required this.isDisconnect,
    required this.uid,
  });
}



class UpdateUserDataDet {
  int id;
  int resellerid;
  int aliceid;
  int circleid;
  int acctype;
  int enablemac;
  String uacctype;
  bool usermode;
  int packid;
  String conn;
  String profileid;
  String fullname;
  String mobile;
  String emailpri;
  String address;
  String packmode;
  String packname;
  int ulspeed;
  int dlspeed;
  String fname;
  String fulspeed;
  String fdlspeed;
  String rpackname;
  String pricename;
  String acctstarttime;
  String onlinetime;
  String lastlogoff;
  bool expiry;
  String expiration;
  int fupmode;
  String dllimit;
  String ullimit;
  String totallimit;
  String locality;
  int conntype;
  int usersipmode;
  String ipv4;
  String ipv6;
  String alicename;
  String acctinputoctets;
  String acctoutputoctets;
  String accttotaloctets;
  int simultaneoususe;
  String createdon;
  String callingstationid;
  String framedipaddress;
  String nasipaddress;
  String renewaldate;
  String connprotocol;
  UpdateUserDataInfo info;
  List<UpdateUserDataAddressBook> address_book;
  int acctstatus;
  int ipmode;
  int ip6mode;
  int ipv4id;
  int ipv6id;

  UpdateUserDataDet({
    required this.id,
    required this.resellerid,
    required this.aliceid,
    required this.circleid,
    required this.acctype,
    required this.enablemac,
    required this.uacctype,
    required this.usermode,
    required this.packid,
    required this.conn,
    required this.profileid,
    required this.fullname,
    required this.mobile,
    required this.emailpri,
    required this.address,
    required this.packmode,
    required this.packname,
    required this.ulspeed,
    required this.dlspeed,
    required this.fname,
    required this.fulspeed,
    required this.fdlspeed,
    required this.rpackname,
    required this.pricename,
    required this.acctstarttime,
    required this.onlinetime,
    required this.lastlogoff,
    required this.expiry,
    required this.expiration,
    required this.fupmode,
    required this.dllimit,
    required this.ullimit,
    required this.totallimit,
    required this.locality,
    required this.conntype,
    required this.usersipmode,
    required this.ipv4,
    required this.ipv6,
    required this.alicename,
    required this.acctinputoctets,
    required this.acctoutputoctets,
    required this.accttotaloctets,
    required this.simultaneoususe,
    required this.createdon,
    required this.callingstationid,
    required this.framedipaddress,
    required this.nasipaddress,
    required this.renewaldate,
    required this.connprotocol,
    required this.info,
    required this.address_book,
    required this.acctstatus,
    required this.ipmode,
    required this.ip6mode,
    required this.ipv4id,
    required this.ipv6id,
  });

  factory UpdateUserDataDet.toJson(Map<dynamic, dynamic> data) {
    return UpdateUserDataDet(


      id: data['id'] ?? 0,
      resellerid: data['resellerid'] ?? 0,
      aliceid: data['aliceid'] ?? 0,
      circleid: data['circleid'] ?? 0,
      acctype: data['acctype'] ?? 0,
      enablemac: data['enablemac'] ?? 0,
      uacctype: data['uacctype'] ?? "",
      usermode: data['usermode'] ?? false,
      packid: data['packid'] ?? 0,
      conn: data['conn'],
      profileid: data['profileid'],
      fullname: data['fullname'],
      mobile: data['mobile'],
      emailpri: data['emailpri'],
      address: data['address'],
      packmode: data['packmode'],
      packname: data['packname'],
      ulspeed: data['ulspeed'],
      dlspeed: data['dlspeed'],
      fname: data['fname'],
      fulspeed: data['fulspeed'],
      fdlspeed: data['fdlspeed'],
      rpackname: data['rpackname'],
      pricename: data['pricename'],
      acctstarttime: data['acctstarttime'],
      onlinetime: data['onlinetime'],
      lastlogoff: data['lastlogoff'],
      expiry: data['expiry'],
      expiration: data['expiration'],
      fupmode: data['fupmode'],
      dllimit: data['dllimit'],
      ullimit: data['ullimit'],
      totallimit: data['totallimit'],
      locality: data['locality'],
      conntype: data['conntype'],
      usersipmode: data['usersipmode'],
      ipv4: data['ipv4'],
      ipv6: data['ipv6'],
      alicename: data['alicename'],
      acctinputoctets: data['acctinputoctets'],
      acctoutputoctets: data['acctoutputoctets'],
      accttotaloctets: data['accttotaloctets'],
      simultaneoususe: data['simultaneoususe'],
      createdon: data['createdon'],
      callingstationid: data['callingstationid'],
      framedipaddress: data['framedipaddress'],
      nasipaddress: data['nasipaddress'],
      renewaldate: data['renewaldate'],
      connprotocol: data['connprotocol'],
      info: UpdateUserDataInfo.toJson(data['info']),
      address_book: List<UpdateUserDataAddressBook>.from(
          data['address_book'].map((address) => UpdateUserDataAddressBook.toJson(address))),
      // addressBook: List<UpdateUserDataAddressBook>.from(data['address_book']
      //     .map((address) => UpdateUserDataAddressBook.toJson(address))),
      acctstatus: data['acctstatus'],
      ipmode: data['ipmode'],
      ip6mode: data['ip6mode'],
      ipv4id: data['ipv4id'],
      ipv6id: data['ipv6id'],
    );
  }
}

class UpdateUserDataInfo {
  int id;
  String fullname;
  String emailpri;
  String emailsec;
  String mobile;
  String telnum;
  bool addressFlag;
  String company;
  String contractfrom;
  String contractto;
  bool gststatus;
  String ugst;
  String desc;
  int latitude;
  int longitude;
  int aliceid;
  int ulmm;
  int locality;

  UpdateUserDataInfo({
    required this.id,
    required this.fullname,
    required this.emailpri,
    required this.emailsec,
    required this.mobile,
    required this.telnum,
    required this.addressFlag,
    required this.company,
    required this.contractfrom,
    required this.contractto,
    required this.gststatus,
    required this.ugst,
    required this.desc,
    required this.latitude,
    required this.longitude,
    required this.aliceid,
    required this.ulmm,
    required this.locality,
  });

  factory UpdateUserDataInfo.toJson(Map<dynamic, dynamic> data) {
    return UpdateUserDataInfo(
      id: data['id'],
      fullname: data['fullname'] ?? "",
      emailpri: data['emailpri'],
      emailsec: data['emailsec'],
      mobile: data['mobile'],
      telnum: data['telnum'],
      addressFlag: data['addressFlag'],
      company: data['company'],
      contractfrom: data['contractfrom'],
      contractto: data['contractto'],
      gststatus: data['gststatus'],
      ugst: data['ugst'],
      desc: data['desc'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      aliceid: data['aliceid'],
      ulmm: data['ulmm'],
      locality: data['locality'],
    );
  }
}

class UpdateUserDataAddressBook {
  int aliceid;
  String alicename;
  int resellerid;
  String address;
  String region;
  int country;
  String state;
  String district;
  String block;
  int pincode;
  String village;

  UpdateUserDataAddressBook({
    required this.aliceid,
    required this.alicename,
    required this.resellerid,
    required this.address,
    required this.region,
    required this.country,
    required this.state,
    required this.district,
    required this.block,
    required this.pincode,
    required this.village,
  });

  factory UpdateUserDataAddressBook.toJson(Map<dynamic, dynamic> data) {
    return UpdateUserDataAddressBook(
      aliceid: data['aliceid'],
      alicename: data['alicename'],
      resellerid: data['resellerid'],
      address: data['address'],
      region: data['region'],
      country: data['country'],
      state: data['state'],
      district: data['district'],
      block: data['block'],
      pincode: data['pincode'],
      village: data['village'],
    );
  }
}

class UpdateUserDataResp {
  final bool error;
  final String msg;
  final UpdateUserDataDet? data;

  UpdateUserDataResp({required this.error, required this.msg, this.data});

  factory UpdateUserDataResp.toJson(Map<dynamic, dynamic> resp) {
    return UpdateUserDataResp(
        error: resp['error'],
        msg: resp['msg'],
        data: UpdateUserDataDet.toJson(resp['data']));
  }
}


class ViewDocument {
  final int id;
  final int doctype;
  final int typeid;
  late  String docid;
  final int verifymode;
  final int fileid;
  final int docstatus;
  final int uid;


  ViewDocument(
      {required this.id,
        required this.doctype,
        required this.typeid,
        required this.docid,
         required this.verifymode,
        required this.fileid,
        required this.docstatus,
         required this.uid,
       });
  factory ViewDocument.toJson(Map<dynamic, dynamic> data) {
    return ViewDocument(
        id: data['id'],
        doctype: data['doctype'],
        typeid: data['typeid'],
        docid: data['docid'],
          verifymode: data['verifymode'],
        fileid: data['fileid'],
        docstatus: data['docstatus'],
        uid: data['uid'],
        
        );
  }
}

class ViewDocumentResp {
  final String msg;
  final bool error;
  final List<ViewDocument>? data;
  ViewDocumentResp({required this.msg, required this.error, this.data});

  factory ViewDocumentResp.toJson(Map<dynamic, dynamic> data) {
    return ViewDocumentResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<ViewDocument>.from(
            data['data'].map((e) => ViewDocument.toJson(e)))
            : []);
  }
}





class GetRenewalPackDet {
  final int packid;
  final String packname;
  final int packmode;
  final int expreset;

  GetRenewalPackDet({required this.packid,
    required this.packname,required this.packmode,required this.expreset});

  factory GetRenewalPackDet.toJson(Map<dynamic, dynamic> data){
    return GetRenewalPackDet(

      packid: data['packid'] ?? 0 ,
      packname: data['packname'] ?? '',
      packmode: data['packmode'] ?? 0 ,
      expreset:data['expreset'] ?? 0
    );
  }
}
class GetRenewalPackResp {
  final String msg;
  final bool error;
  final List<GetRenewalPackDet>? data;

  GetRenewalPackResp({required this.msg, required this.error, this.data});

  factory GetRenewalPackResp.toJson(Map<dynamic, dynamic> data) {


    return GetRenewalPackResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<GetRenewalPackDet>.from(
            data['data'].map((e) => GetRenewalPackDet.toJson(e)))
            : []);
  }
}



class GetRenewalOttDet {
  final int id;
  final int ottId;
  final String planName;
  final List<int> platform;
  final String planCode;
  final int timeUnit;
  final int unit;
  final double mrpPrice;
  final double price;
  final int taxMode;

  GetRenewalOttDet({
    required this.id,
    required this.ottId,
    required this.planName,
    required this.platform,
    required this.planCode,
    required this.timeUnit,
    required this.unit,
    required this.mrpPrice,
    required this.price,
    required this.taxMode,

  });

  factory GetRenewalOttDet.toJson(Map<dynamic, dynamic> data){
    return GetRenewalOttDet(

      id: data['id'],
      ottId: data['ottid'],
      planName: data['planname'],
      platform: List<int>.from(data['platform']),
      planCode: data['plancode'],
      timeUnit: data['timeunit'],
      unit: data['unit'],
      mrpPrice: data['mrpprice'].toDouble(),
      price: data['price'].toDouble(),
      taxMode: data['taxmode'],
    );
  }
}
class GetRenewalOttResp {
  final String msg;
  final bool error;
  final List<GetRenewalOttDet>? data;

  GetRenewalOttResp({required this.msg, required this.error, this.data});

  factory GetRenewalOttResp.toJson(Map<dynamic, dynamic> data) {


    return GetRenewalOttResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<GetRenewalOttDet>.from(
            data['data'].map((e) => GetRenewalOttDet.toJson(e)))
            : []);
  }
}




class GetRenewalPriceDet {
  final int id;
  final String pname;
  final int unittype;
  final int timeunit;
  final int extradays;
  final double price;
  final int taxmode;
  final String validity;

  GetRenewalPriceDet({
    required this.id,
    required this.pname,
    required this.unittype,
    required this.timeunit,
    required this.extradays,
    required this.price,
    required this.taxmode,
    required this.validity,
  });

  factory GetRenewalPriceDet.toJson(Map<dynamic, dynamic> data){
    return GetRenewalPriceDet(

      id: data['id'],
      pname: data['pname'],
      unittype: data['unittype'],
      timeunit: data['timeunit'],
      extradays: data['extradays'],
      price: data['price'].toDouble(),
      taxmode: data['taxmode'],
      validity: data['validity'],
    );
  }
}
class GetRenewalPriceResp {
  final String msg;
  final bool error;
  final List<GetRenewalPriceDet>? data;

  GetRenewalPriceResp({required this.msg, required this.error, this.data});

  factory GetRenewalPriceResp.toJson(Map<dynamic, dynamic> data) {


    return GetRenewalPriceResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<GetRenewalPriceDet>.from(
            data['data'].map((e) => GetRenewalPriceDet.toJson(e)))
            : []);
  }
}

 

 



// your_model.dart

class InvoiceDetResp {
  bool error;
  String msg;
  List<InvoiceDet> data;

  InvoiceDetResp({required this.error, required this.msg, required this.data});

  factory InvoiceDetResp.toJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<InvoiceDet> dataList = list.map((i) => InvoiceDet.toJson(i)).toList();

    return InvoiceDetResp(
      error: json['error'],
      msg: json['msg'],
      data: dataList,
    );
  }
}

class InvoiceDet {
  int invid;
  int uid;
  String invno;
  String packname;
  String pricename;
  String packtype;
  int distid;
  int subdistid;
  int resellerid;
  int igst;
  int cgst;
  int sgst;
  int unittype;
  int timeunit;
  int extradays;
  String expiration;
  int invtype;
  int invmode;
  int invstatus;
  String supplierGst;
  String recipientGst;
  int userpayedamt;
  int payStatus;
  String paydate;
  String comment1;
  // int allispamt;
  // int alldistamt;
  int allsubdistamt;
  // double allreselleramt;
  dynamic allamount;
  dynamic alltaxamt;
  int packmode;
  String createdon;
  String invdate;
  int totalamount;
  String resellercompany;
  String reselleraddress;
  String subname;
  String subprofileid;
  String subaddress;
  String subbilladdress;
  int ocid;
  String couponPrice;

  InvoiceDet({
    required this.invid,
    required this.uid,
    required this.invno,
    required this.packname,
    required this.pricename,
    required this.packtype,
    required this.distid,
    required this.subdistid,
    required this.resellerid,
    required this.igst,
    required this.cgst,
    required this.sgst,
    required this.unittype,
    required this.timeunit,
    required this.extradays,
    required this.expiration,
    required this.invtype,
    required this.invmode,
    required this.invstatus,
    required this.supplierGst,
    required this.recipientGst,
    required this.userpayedamt,
    required this.payStatus,
    required this.paydate,
    required this.comment1,
    // required this.allispamt,
    // required this.alldistamt,
    required this.allsubdistamt,
    // required this.allreselleramt,
    required this.allamount,
    required this.alltaxamt,
    required this.packmode,
    required this.createdon,
    required this.invdate,
    required this.totalamount,
    required this.resellercompany,
    required this.reselleraddress,
    required this.subname,
    required this.subprofileid,
    required this.subaddress,
    required this.subbilladdress,
    required this.ocid,
    required this.couponPrice,
  });

  factory InvoiceDet.toJson(Map<String, dynamic> json) {
    return InvoiceDet(
      invid: json['invid'],
      uid: json['uid'],
      invno: json['invno'],
      packname: json['packname'],
      pricename: json['pricename'],
      packtype: json['packtype'],
      distid: json['distid'],
      subdistid: json['subdistid'],
      resellerid: json['resellerid'],
      igst: json['igst'],
      cgst: json['cgst'],
      sgst: json['sgst'],
      unittype: json['unittype'],
      timeunit: json['timeunit'],
      extradays: json['extradays'],
      expiration: json['expiration'],
      invtype: json['invtype'],
      invmode: json['invmode'],
      invstatus: json['invstatus'],
      supplierGst: json['supplier_gst'],
      recipientGst: json['recipient_gst'],
      userpayedamt: json['userpayedamt'],
      payStatus: json['pay_status'],
      paydate: json['paydate'],
      comment1: json['comment1'],
      // allispamt: json['allispamt'],
      // alldistamt: json['alldistamt'],
      allsubdistamt: json['allsubdistamt'],
      // allreselleramt: json['allreselleramt'],
      allamount: json['allamount'],
      alltaxamt: json['alltaxamt'],
      packmode: json['packmode'],
      createdon: json['createdon'],
      invdate: json['invdate'],
      totalamount: json['totalamount'],
      resellercompany: json['resellercompany'],
      reselleraddress: json['reselleraddress'],
      subname: json['subname'],
      subprofileid: json['subprofileid'],
      subaddress: json['subaddress'],
      subbilladdress: json['subbilladdress'],
      ocid: json['ocid'],
      couponPrice: json['coupon_price'],
    );
  }
}




// Model class for the JSON data
class ISP_LogoResp {
  final bool error;
  final String msg;
  final ISP_Logo logo;

  ISP_LogoResp({
    required this.error,
    required this.msg,
    required this.logo,
  });

  factory ISP_LogoResp.toJson(Map<String, dynamic> json) {
    return ISP_LogoResp(
      error: json['error'] ?? true,
      msg: json['msg'] ?? "",
      logo: ISP_Logo.toJson(json['logo'] ?? {}),
    );
  }
}

class ISP_Logo {
  final String ispLogo;

  ISP_Logo({
    required this.ispLogo,
  });

  factory ISP_Logo.toJson(Map<String, dynamic> json) {
    return ISP_Logo(
      ispLogo: json['isp_logo'] ?? "",
    );
  }
}


class RD_GraphResp {
  final bool error;
  final String msg;
  final RD_Graph rd_grap;

  RD_GraphResp({
    required this.error,
    required this.msg,
    required this.rd_grap,
  });

  factory RD_GraphResp.toJson(Map<String, dynamic> json) {
    return RD_GraphResp(
      error: json['error'] ?? true,
      msg: json['msg'] ?? "",
      rd_grap: RD_Graph.toJson(json['img'] ?? {}),
    );
  }
}

class RD_Graph {
  final String d;
  final String w;
  final String m;
  final String y;

  RD_Graph({
    required this.d,
    required this.w,
    required this.m,
    required this.y,
  });

  factory RD_Graph.toJson(Map<String, dynamic> json) {
    return RD_Graph(
      d: json['d'] ?? "",
      w: json['w'] ?? "",
      m: json['m'] ?? "",
      y: json['y'] ?? "",
    );
  }
}




class FileDataResp {
  bool error;
  String msg;
  Uint8List file;

  FileDataResp({
    required this.error,
    required this.msg,
    required this.file,
  });

  factory FileDataResp.toJson(Map<String, dynamic> json) {
    return FileDataResp(
      error: json['error'],
      msg: json['msg'] ?? 'Success fully fetched the file',
      file: json['file'],
    );
  }
}

class FileData {
  String encoding;
  String filename;
  bool limit;
  String mimetype;

  FileData({
    required this.encoding,
    required this.filename,
    required this.limit,
    required this.mimetype,
  });

  factory FileData.toJson(Map<String, dynamic> json) {
    return FileData(
      encoding: json['encoding'],
      filename: json['filename'],
      limit: json['limit'],
      mimetype: json['mimetype'],
    );
  }
}




class ComplaintTypeDet {
  final int id;
  final String name;

  ComplaintTypeDet({required this.id,
    required this.name});

  factory ComplaintTypeDet.toJson(Map<dynamic, dynamic> data){
    return ComplaintTypeDet(

      id: data['id'] ?? 0 ,
      name: data['name'] ?? '',
    );
  }

}

class ComplaintTypeResp {
  final String msg;
  final bool error;
  final List<ComplaintTypeDet>? data;

  ComplaintTypeResp({required this.msg, required this.error, this.data});

  factory ComplaintTypeResp.toJson(Map<dynamic, dynamic> data) {


  return ComplaintTypeResp(
  error: data['error'],
  msg: data['msg'],
  data: data['data'] is List
  ? List<ComplaintTypeDet>.from(
  data['data'].map((e) => ComplaintTypeDet.toJson(e)))
      : []);
  }
  }



class SubsComplaintDet {
  final int id;
  final int status;
  final int type;
  final int assignee;
  final int subscriber;
  final int reseller;
  final String comments;
  final String attahment;
  final String profileid;

 
  

  SubsComplaintDet( {
    required this.id,
    required this.status,
    required this.type,
    required this.assignee,
    required this.subscriber,
    required this.reseller,
    required this.comments,
    required this.attahment,
    required this.profileid,
    });

  factory SubsComplaintDet.toJson(Map<dynamic, dynamic> data){
    return SubsComplaintDet(

      id: data['id'] ?? 0 ,
      status: data['status'] ?? 0,
      type: data['type'] ?? 0,
          assignee: data['assignee'] ?? 0,
            subscriber: data['subscriber'] ?? 0,
              reseller: data['reseller'] ?? 0,
                comments: data['comments'] ?? '',
                  attahment: data['attahment'] ?? '',
                    profileid: data['profileid'] ?? '',
    );
  }

}

class SubsComplaintResp {
  final String msg;
  final bool error;
  final List<SubsComplaintDet>? data;

  SubsComplaintResp({required this.msg, required this.error, this.data});

  factory SubsComplaintResp.toJson(Map<dynamic, dynamic> data) {


  return SubsComplaintResp(
  error: data['error'],
  msg: data['msg'],
  data: data['data'] is List
  ? List<SubsComplaintDet>.from(
  data['data'].map((e) => SubsComplaintDet.toJson(e)))
      : []);
  }
  }





class SubsComplaintLogDet {
  final int status;
  final String comments;

  final int assignee;
  
  final String attahment;
 final int createdon;
 
 
  

  SubsComplaintLogDet( {
   
    required this.status,
    
    required this.assignee,
   
    required this.comments,
    required this.attahment,
       required this.createdon,
    });

  factory SubsComplaintLogDet.toJson(Map<dynamic, dynamic> data){
    return SubsComplaintLogDet(

    
      status: data['status'] ?? 0,
    
          assignee: data['assignee'] ?? 0,
           
                comments: data['comments'] ?? '',
                  attahment: data['attahment'] ?? '',
                  createdon: data['createdon'] ?? 0,
    );
  }

}

class SubsComplaintLogResp {
  final String msg;
  final bool error;
  final List<SubsComplaintLogDet>? data;

  SubsComplaintLogResp({required this.msg, required this.error, this.data});

  factory SubsComplaintLogResp.toJson(Map<dynamic, dynamic> data) {


  return SubsComplaintLogResp(
  error: data['error'],
  msg: data['msg'],
  data: data['data'] is List
  ? List<SubsComplaintLogDet>.from(
  data['data'].map((e) => SubsComplaintLogDet.toJson(e)))
      : []);
  }
  }


class EmployeeList {
   final int id;
  // final int circle;
  // final int levelid;
  // final int resellerSub;
  // final String fullName;
  final String profileId;
  // final String mobile;
  // final int landline;
  // final String email;
  // final String email1;
  // final int rstatus;
  // final List<int> levelMenu;
  // final String password;

 
 
 
  

  EmployeeList( {
   
   required this.id,
    // required this.circle,
    // required this.levelid,
    // required this.resellerSub,
    // required this.fullName,
    required this.profileId,
    // required this.mobile,
    // required this.landline,
    // required this.email,
    // required this.email1,
    // required this.rstatus,
    // required this.levelMenu,
    // required this.password,
    });

  factory EmployeeList.toJson(Map<dynamic, dynamic> json){
    return EmployeeList(

    
     id: json['id'],
      // circle: json['circle'],
      // levelid: json['levelid'],
      // resellerSub: json['reseller_sub'],
      // fullName: json['full_name'],
      profileId: json['profileid'],
      // mobile: json['mobile'],
      // landline: json['landline'],
      // email: json['email'],
      // email1: json['email1'],
      // rstatus: json['rstatus'],
      // levelMenu: List<int>.from(json['level_menu']),
      // password: json['password'],
    );
  }

}

class EmployeeListResp {
  final String msg;
  final bool error;
  final List<EmployeeList>? data;

  EmployeeListResp({required this.msg, required this.error, this.data});

  factory EmployeeListResp.toJson(Map<dynamic, dynamic> data) {


  return EmployeeListResp(
  error: data['error'],
  msg: data['msg'],
  data: data['data'] is List
  ? List<EmployeeList>.from(
  data['data'].map((e) => EmployeeList.toJson(e)))
      : []);
  }
  }



  

class SessionRpt {
  String acctsessionid;
  String acctuniqueid;
  String username;
  String nasipaddress;
  String nasportid;
  String nasporttype;
  String acctstarttime;
  String acctstoptime;
  String callingstationid;
  String acctsessiontime;
  String acctinputoctets;
  String acctoutputoctets;
  String framedipaddress;
  String protocol;
  String connStatus;
  String packid;
  String packname;

  SessionRpt({
    required this.acctsessionid,
    required this.acctuniqueid,
    required this.username,
    required this.nasipaddress,
    required this.nasportid,
    required this.nasporttype,
    required this.acctstarttime,
    required this.acctstoptime,
    required this.callingstationid,
    required this.acctsessiontime,
    required this.acctinputoctets,
    required this.acctoutputoctets,
    required this.framedipaddress,
    required this.protocol,
    required this.connStatus,
    required this.packid,
    required this.packname,
  });

  factory SessionRpt.toJson(Map<String, dynamic> json) {
    return SessionRpt(
      acctsessionid: json['acctsessionid'] ?? '',
      acctuniqueid: json['acctuniqueid'] ?? '',
      username: json['username'] ?? '',
      nasipaddress: json['nasipaddress'] ?? '',
      nasportid: json['nasportid'] ?? '',
      nasporttype: json['nasporttype'] ?? '',
      acctstarttime: json['acctstarttime'] ?? '',
      acctstoptime: json['acctstoptime'] ?? '',
      callingstationid: json['callingstationid'] ?? '',
      acctsessiontime: json['acctsessiontime'] ?? '',
      acctinputoctets: json['acctinputoctets'] ?? '',
      acctoutputoctets: json['acctoutputoctets'] ?? '',
      framedipaddress: json['framedipaddress'] ?? '',
      protocol: json['protocol'] ?? '',
      connStatus: json['conn_status'] ?? '',
      packid: json['packid'] ?? '',
      packname: json['packname'] ?? '',
    );
  }
}

class SessionRptResp {
  bool error;
  String msg;
  List<SessionRpt> data;

  SessionRptResp({
    required this.error,
    required this.msg,
    required this.data,
  });

  
  factory SessionRptResp.toJson(Map<dynamic, dynamic> data) {
    return SessionRptResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<SessionRpt>.from(
                data['data'].map((e) => SessionRpt.toJson(e)))
            : []);
  }
  }


