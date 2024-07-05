class UsersDetail {
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

  UsersDetail({
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
  factory UsersDetail.toJson(Map<dynamic, dynamic> data) {
    return UsersDetail(
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

class UsersDetailResp {
  final String msg;
  final bool error;
  final List<UsersDetail>? data;

  UsersDetailResp({required this.msg, required this.error, this.data});

  factory UsersDetailResp.toJson(Map<dynamic, dynamic> data) {
    return UsersDetailResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<UsersDetail>.from(
                data['data'].map((e) => UsersDetail.toJson(e)))
            : []);
  }
}
