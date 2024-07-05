
class SearchDet {
  int id ;
  final int circleid ;
  final int acctype;
  final String profileid;
  final String fullname;
  final String emailpri;
  final String mobile;
  final int resellerid;
  final String ipv4;

  SearchDet({
    required this.id,
    required this.circleid,
    required this.acctype,
    required this.profileid,
    required this.fullname,
    required this.emailpri,
    required this.mobile,
    required this.resellerid,
    required this.ipv4,
  });

  factory  SearchDet.toJson(Map<dynamic, dynamic> data){
    return  SearchDet(

      id: data['id'] ?? 0 ,
      circleid: data['circleid'] ?? 0,
      acctype: data['acctype'] ?? 0,
      profileid: data['profileid'] ?? '',
      fullname: data['fullname'] ?? '' ,
      emailpri: data['emailpri'] ?? '' ,
      mobile: data['mobile'] ?? '' ,
      resellerid: data['resellerid'] ?? 0 ,
      ipv4: data['ipv4'] ?? '' ,
    );
  }
}
class SearchResp {
  final String msg;
  final bool error;
  final List<SearchDet>? data;

  SearchResp({required this.msg, required this.error, this.data});

  factory SearchResp.toJson(Map<dynamic, dynamic> data) {

    return SearchResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<SearchDet>.from(
            data['data'].map((e) => SearchDet.toJson(e)))
            : []);
  }
}


class SearchPubIpDet {
   int id ;
  final String ipaddr;
  final int ipv4id;

  SearchPubIpDet({
    required this.id,
    required this.ipaddr,
    required this.ipv4id,

  });

  factory  SearchPubIpDet.toJson(Map<dynamic, dynamic> data){
    return  SearchPubIpDet(

      id: data['id'] ?? 0 ,
      ipaddr: data['ipaddr'] ?? '',
      ipv4id: data['ipv4id'] ?? 0,

    );
  }
}
class SearchPubIpResp {
  final String msg;
  final bool error;
  final List<SearchPubIpDet>? data;

  SearchPubIpResp({required this.msg, required this.error, this.data});

  factory SearchPubIpResp.toJson(Map<dynamic, dynamic> data) {

    return SearchPubIpResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<SearchPubIpDet>.from(
            data['data'].map((e) => SearchPubIpDet.toJson(e)))
            : []);
  }
}


class SearchUserMacDet{
  final int uid;
  final int umacid;
  final String usermac;
  SearchUserMacDet({required this.uid,required this.umacid,required this.usermac});
  factory SearchUserMacDet.toJson(Map<dynamic, dynamic> data){
    return SearchUserMacDet(


      uid: data['uid'] ?? 0,
      umacid: data['umacid'] ?? 0 ,
      usermac: data['usermac'] ?? '' ,

    );
  }
}
class SearchUserMacResp{
  final String msg;
  final bool error;
  final List<SearchUserMacDet>? data;

  SearchUserMacResp ({required this.msg, required this.error, this.data});

  factory SearchUserMacResp .toJson(Map<dynamic, dynamic> data) {

    return SearchUserMacResp (
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<SearchUserMacDet>.from(
            data['data'].map((e) => SearchUserMacDet.toJson(e)))
            : []);
  }
}

