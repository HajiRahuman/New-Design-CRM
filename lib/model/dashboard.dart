class ExpirySubscriber {
  final int uid;
  final int packid;
  final String profileid;
  final String fullname;
  final String mobile;
  final String packname;
  final String emailpri;
  final String expiration;

  ExpirySubscriber(
      {required this.uid,
      required this.packid,
      required this.profileid,
      required this.fullname,
      required this.mobile,
      required this.emailpri,
      required this.expiration,
      required this.packname});
  factory ExpirySubscriber.toJson(Map<dynamic, dynamic> data) {
    return ExpirySubscriber(
        profileid: data['profileid'],
        fullname: data['fullname'],
        mobile: data['mobile'],
        uid: data['uid'],
        packid: data['packid'],
        emailpri: data['emailpri'],
        expiration: data['expiration'],
        packname: data['packname']);
  }
}

class ExpirySubscribersResp {
  final String msg;
  final bool error;
  final List<ExpirySubscriber>? data;
  ExpirySubscribersResp({required this.msg, required this.error, this.data});

  factory ExpirySubscribersResp.toJson(Map<dynamic, dynamic> data) {
    return ExpirySubscribersResp(
        error: data['error'],
        msg: data['msg'],
        data: data['data'] is List
            ? List<ExpirySubscriber>.from(
                data['data'].map((e) => ExpirySubscriber.toJson(e)))
            : []);
  }
}
