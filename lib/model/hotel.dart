
class HotelDet {
  final int id;
  final int resellerid;
  final String conn;
  final String profileid;
  // final int packid;
  // final String packmode;
  // final String packname;
  final String expiration;
  // final int dllimit;
  // final int ullimit;
  // final int totallimit;
  // final int timelimit;
  final int simultaneoususe;
  final String authpsw;
  final String acctstatus;
  // final int soc;
  HotelDet( {
    required this.id,
    required this.resellerid,
    required this.conn,
    required this.profileid,
    // required this.packid,
    // required this.packmode,
    // required this.packname,
    required this.expiration,
    // required this.dllimit,
    // required this.ullimit,
    // required this.totallimit,
    // required this.timelimit,
    required this.simultaneoususe,
    required this.acctstatus,
    required this.authpsw,
    // required this.soc,
  });
  factory HotelDet.toJson(Map<dynamic, dynamic> data) {
    return HotelDet(
      id: data['id'],
      resellerid: data['resellerid'],
      conn: data['conn'],
      profileid: data['profileid'] ?? "",
      // packid: data['packid'],
      // packmode: data['packmode'],
      // packname: data['packname'],
      expiration: data['expiration'],
      // dllimit: data['dllimit'],
      // ullimit: data['ullimit'],
      // totallimit: data['totallimit'],
      // timelimit: data['timelimit'],
      simultaneoususe: data['simultaneoususe'],
      // soc: data['soc'],
      acctstatus: data['acctstatus'],
      authpsw: data['authpsw'],
    );
  }
}

class HotelResp {
  final String msg;
  final bool error;
  final List<HotelDet>? data;

  HotelResp({required this.msg, required this.error, this.data});

  factory HotelResp.toJson(Map<dynamic, dynamic> data) {
    return HotelResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<HotelDet>.from(
            data['data'].map((e) => HotelDet.toJson(e)))
            : []);
  }
}