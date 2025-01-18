
class HotelDet {
  final int id;
  final int resellerId;
  final String profileId;
  final String expiration;
  final String packId;
  final int dlLimit;
  final int ulLimit;
  final int totalLimit;
  final int timeLimit;
  final int simultaneousUse;
  final String authPassword;
  final String packMode;
  final String packName;
  final String conn;
  final int soc;
  final String acctStatus;
  final String username;
  final String authReject;
  final String authRejectDate;

  HotelDet( {
      required this.id,
    required this.resellerId,
    required this.profileId,
    required this.expiration,
    required this.packId,
    required this.dlLimit,
    required this.ulLimit,
    required this.totalLimit,
    required this.timeLimit,
    required this.simultaneousUse,
    required this.authPassword,
    required this.packMode,
    required this.packName,
    required this.conn,
    required this.soc,
    required this.acctStatus,
    required this.username,
   required this.authReject,
   required this.authRejectDate,
  });
  factory HotelDet.toJson(Map<dynamic, dynamic> json) {
    return HotelDet(
       id: json['id'] ?? 0,
    resellerId: json['resellerid'] ?? 0,
    profileId: json['profileid'] ?? "",
    expiration: json['expiration'] ?? "", // Default to current date-time
    packId: json['packid'] ?? "",
    dlLimit: json['dllimit'] ?? 0,
    ulLimit: json['uplimit'] ?? 0,
    totalLimit: json['totallimit'] ?? 0,
    timeLimit: json['timelimit'] ?? 0,
    simultaneousUse: json['simultaneoususe'] ?? 0,
    authPassword: json['authpsw'] ?? "",
    packMode: json['packmode'] ?? "",
    packName: json['packname'] ?? "",
    conn: json['conn'] ?? "",
    soc: json['soc'] ?? 0,
    acctStatus: json['acctstatus'] ?? "",
    username: json['username'] ?? "",
    authReject: json['authreject'] ?? "",
    authRejectDate: json['authreject_dt'] ?? "",
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


class HotelSummary {
    
  final int totalusers;
  final int deactive;
  final int active;
  final int mainonline;
  final int offline;
  final int duplicate_session;
 

  HotelSummary (
      {required this.totalusers,
      required this.deactive,
      required this.active,
    
      required this.mainonline,
      required this.offline,
      required this.duplicate_session,
     });
  factory HotelSummary .toJson(Map<dynamic, dynamic> data) {
    return HotelSummary (
        totalusers: data['totalusers'] ?? '0',
        deactive: data['deactive'] ?? '0',
        active: data['active'] ?? '0',
      
        mainonline: data['mainonline'] ?? '0',
        offline: data['offline'] ?? '0',
        duplicate_session: data['duplicate_session'] ?? '0',
     
        );
  }
}
class HotelSummaryResp {
  final String msg;
  final bool error;
  final HotelSummary ? summary;
  HotelSummaryResp({required this.error, required this.msg, this.summary});

  factory HotelSummaryResp.toJson(Map<dynamic, dynamic> data) {
    return HotelSummaryResp(
        error: data['error'],
        msg: data['msg'],
        summary: data['summary'] != null
            ? HotelSummary .toJson(data['summary'])
            : null);
  }
}
